import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../../../save_note.dart';

class SlackNoteSender extends NoteSender {
  final String token;
  final String channelId;
  final String? userName;
  final String? slackUsername;
  final String? userIconUrl;
  final String? userIconEmoji;

  SlackNoteSender({
    required super.channelName,
    required this.token,
    required this.channelId,
    this.userName,
    this.slackUsername,
    this.userIconUrl,
    this.userIconEmoji = ':robot:',
    super.onSuccess,
    super.onError,
  }) : super(icon: 'assets/slack_icon.png');

  @override
  Future<bool> sendNote({required Uint8List imageData, required BuildContext context, String message = ''}) async {
    return _postImage(
      imageData: imageData,
      context: context,
      message: userName == null ? message : '[$userName]: $message',
    );
  }

  // ignore: unused_element
  _postMessage(String message, String channel) async {
    const url = 'https://slack.com/api/chat.postMessage';
    final response = await Client().post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'channel': channel,
          'text': userName?.isNotEmpty == true ? '$userName: $message' : message,
          'username': slackUsername,
          'icon_url': userIconUrl,
          'icon_emoji': userIconEmoji,
        }));

    final responseBody = SlackResponse.fromJson(response.body);

    if (!responseBody.ok) {
      throw Exception('Failed to send feedback to Slack\n${responseBody.error}');
    }
  }

  Future<bool> _postImage({
    required Uint8List imageData,
    required BuildContext context,
    String message = '',
  }) async {
    final completer = Completer<bool>();

    try {
      final urlExternal = await getUploadURLExternal(imageData: imageData, channel: channelId, message: message);
      late StreamedResponse response;

      final request = MultipartRequest('POST', Uri.parse(urlExternal.url))
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['channels'] = channelId
        ..fields['initial_comment'] = message
        ..files.add(MultipartFile.fromBytes(
          'file',
          imageData,
          filename: '${DateTime.now().toIso8601String()}-${Random().nextInt(1000)}.png',
          contentType: MediaType('image', 'png'),
        ));

      request.send().asStream().listen((event) {
        response = event;
      }).onDone(() async {
        debugPrint('Response status: ${response.statusCode}');

        final result = await response.stream.bytesToString();
        debugPrint('Response body: $result');

        if (response.statusCode != 200) {
          onError?.call('Failed to send feedback to Slack\n$result');
          completer.completeError('Failed to send feedback to Slack\n$result');
        } else {
          await completeUploadExternal(fileId: urlExternal.fileId, channel: channelId, message: message);
          onSuccess?.call();
          completer.complete(true);
        }
      });

      return completer.future;
    } catch (e) {
      onError?.call('Error sending image to Slack: $e');
      completer.completeError('Error sending image to Slack: $e');
      return completer.future;
    }
  }

  Future<UploadURLExternal> getUploadURLExternal({
    required Uint8List imageData,
    required String channel,
    String? message,
  }) async {
    const String url = 'https://slack.com/api/files.getUploadURLExternal';
    final queryParams = {
      'filename': '${DateTime.now().toIso8601String()}-${Random().nextInt(1000)}.png',
      'length': '${imageData.length}',
    };
    final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    final response = await Client().get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['ok']) {
        return UploadURLExternal.fromMap(responseData);
      } else {
        throw Exception('Failed to get upload URL: ${responseData['error']}');
      }
    } else {
      throw Exception('Failed to get upload URL: ${response.body}');
    }
  }

  Future<void> completeUploadExternal({
    required String fileId,
    required String channel,
    required String message,
  }) async {
    const String url = 'https://slack.com/api/files.completeUploadExternal';

    final response = await Client().post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'channel_id': channel,
        'initial_comment': message,
        'files': [
          {"id": fileId, "title": '${DateTime.now().toIso8601String()}-${Random().nextInt(1000)}.png'}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['ok']) {
        debugPrint('File upload completed successfully!');
      } else {
        throw Exception('Failed to complete file upload: ${responseData['error']}');
      }
    } else {
      throw Exception('Failed to complete file upload: ${response.statusCode}');
    }
  }
}
