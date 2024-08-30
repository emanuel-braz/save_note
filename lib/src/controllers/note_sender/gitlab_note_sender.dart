import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../../../save_note.dart';

/// Create an API Access Token, with the following scopes:
///   - api
///   - write_repository
///
/// Get the project ID from the project settings page - [General] section
///
/// See docs https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html#limiting-scopes-of-a-project-access-token
///
/// Optional parameters: [GitlabNoteSender.defaultExtras]
/// assignee_id: 	                           integer          No	The ID of the user to assign the issue to. Only appears on GitLab Free.
/// assignee_ids: 	                         integer/array    No	The IDs of the users to assign the issue to. Premium and Ultimate only.
/// confidential: 	                         boolean          No	Set an issue to be confidential. Default is false.
/// created_at: 	                           string           No	When the issue was created. Date time string, ISO 8601 formatted, for example 2016-03-11T03:45:40Z. Requires administrator or project/group owner rights.
/// description: 	                           string           No	The description of an issue. Limited to 1,048,576 characters.
/// discussion_to_resolve: 	                 string           No	The ID of a discussion to resolve. This fills out the issue with a default description and mark the discussion as resolved. Use in combination with merge_request_to_resolve_discussions_of.
/// due_date: 	                             string           No	The due date. Date time string in the format YYYY-MM-DD, for example 2016-03-11.
/// epic_id: 	                               integer          No	ID of the epic to add the issue to. Valid values are greater than or equal to 0. Premium and Ultimate only.
/// epic_iid: 	                             integer          No	IID of the epic to add the issue to. Valid values are greater than or equal to 0. (deprecated, scheduled for removal in API version 5). Premium and Ultimate only.
/// iid: 	                                   integer/string   No	The internal ID of the project’s issue (requires administrator or project owner rights).
/// issue_type: 	                           string           No	The type of issue. One of issue, incident, test_case or task. Default is issue.
/// labels: 	                               string           No	Comma-separated label names to assign to the new issue. If a label does not already exist, this creates a new project label and assigns it to the issue.
/// merge_request_to_resolve_discussions_of: integer	        No	The IID of a merge request in which to resolve all issues. This fills out the issue with a default description and mark all discussions as resolved. When passing a description or title, these values take precedence over the default values.
/// milestone_id: 	                         integer          No	The global ID of a milestone to assign issue. To find the milestone_id associated with a milestone, view an issue with the milestone assigned and use the API to retrieve the issue’s details.
/// weight: 	                               integer          No	The weight of the issue. Valid values are greater than or equal to 0. Premium and Ultimate only.

class GitlabNoteSender extends NoteSender {
  final String projectId;
  final String token;
  final String? baseUrl;
  final Client? client;
  final GitlabExtras? gitlabExtras;

  GitlabNoteSender({
    required this.projectId,
    required this.token,
    required super.name,
    this.baseUrl,
    this.client,
    super.onSuccess,
    super.onError,
    this.gitlabExtras,
  }) : super(icon: 'assets/gitlab_icon.png');

  @override
  Future<bool> sendNote({
    required Uint8List imageData,
    required BuildContext context,
    String message = '',
    Map<String, dynamic>? extras,
  }) async {
    try {
      final client = this.client ?? Client();
      final baseUrl = this.baseUrl ?? 'gitlab.com';

      final extrasMixed = <String, dynamic>{};

      if (gitlabExtras != null) {
        Map<String, dynamic> gitlabExtrasMap = (gitlabExtras?.toMap() ?? {})
          ..removeWhere((key, value) => value == null);

        extrasMixed.addAll(gitlabExtrasMap);
      }

      // Overwrite default extras with the new values
      extrasMixed.addAll(extras ?? {});

      final uri = Uri.https(baseUrl, '/api/v4/projects/$projectId/uploads');
      final fileName =
          '${DateTime.now().toIso8601String()}-${Random().nextInt(1000)}.png';

      final uploadRequest = MultipartRequest('POST', uri)
        ..headers['PRIVATE-TOKEN'] = token
        ..files.add(MultipartFile.fromBytes(
          'file',
          imageData,
          filename: fileName,
          contentType: MediaType('image', 'png'),
        ));

      final streamedResponse = await uploadRequest.send();
      final uploadResponse = await Response.fromStream(streamedResponse);

      if (uploadResponse.statusCode != 201) {
        // 201 for created
        onError?.call('Failed to upload image\n\n${uploadResponse.body}');
        return false;
      }

      final responseBody = jsonDecode(uploadResponse.body);
      final markdownImage = responseBody['markdown'];
      final imageInDescription =
          'Image: ${markdownImage ?? '[Error]: Missing image!'}';

      final description = extrasMixed['description'] ?? '';
      extrasMixed['description'] = '$description\n\n$imageInDescription';

      final issueResponse = await client.post(
        Uri.https(baseUrl, '/api/v4/projects/$projectId/issues'),
        headers: {
          'PRIVATE-TOKEN': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'title': message, ...extrasMixed}),
      );

      if (issueResponse.statusCode != 201) {
        onError?.call('Failed to create issue\n\n${issueResponse.body}');
        return false;
      }

      onSuccess?.call();
      return true;
    } catch (e) {
      onError?.call('Error sending image to Gitlab: $e');
      return false;
    }
  }
}
