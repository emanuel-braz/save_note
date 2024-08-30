import 'package:flutter/material.dart';

import '../../../save_note.dart';
import 'note_form_input.dart';

class GitlabFormFieldFactory {
  static List<NoteFormField> getNoteFormFieldFromGilabExtras(GitlabExtras? extras) {
    if (extras == null) return [];

    final List<NoteFormField> formFields = [];

    formFields.add(NoteFormField(
      name: 'description',
      type: String,
      controller: TextEditingController(text: extras.description ?? ''),
      hint: 'The description of an issue. Limited to 1,048,576 characters.',
    ));

    formFields.add(NoteFormField(
      name: 'labels',
      type: String,
      controller: TextEditingController(text: extras.labels ?? ''),
      hint:
          'Comma-separated label names to assign to the new issue. If a label does not already exist, this creates a new project label and assigns it to the issue.',
    ));

    formFields.add(NoteFormField(
      name: 'weight',
      type: int,
      controller: TextEditingController(text: extras.weight?.toString() ?? ''),
      hint: 'The weight of the issue. Valid values are greater than or equal to 0. Premium and Ultimate only.',
    ));

    formFields.add(NoteFormField(
      name: 'issue_type',
      type: String,
      controller: TextEditingController(text: extras.issue_type ?? ''),
      hint: 'The type of issue. One of issue, incident, test_case or task. Default is issue.',
      customBuilder: (context, TextEditingController controller) {
        final issueTypes = List<String>.from(['issue', 'incident', 'test_case', 'task']);
        final initialText = issueTypes.contains(controller.text) ? controller.text : null;

        return DropdownButtonFormField<String>(
          hint: const Text('Select issue type (default is "issue")'),
          value: initialText,
          items: issueTypes.toSet().map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            controller.text = value!;
          },
        );
      },
    ));

    // formFields.add(NoteFormField(
    //   name: 'due_date',
    //   type: String,
    //   controller: TextEditingController(text: extras.due_date ?? ''),
    //   hint: 'The due date. Date time string in the format YYYY-MM-DD, for example 2016-03-11.',
    // ));

    // formFields.add(NoteFormField(
    //   name: 'created_at',
    //   type: String,
    //   controller: TextEditingController(text: extras.created_at ?? ''),
    //   hint:
    //       'When the issue was created. Date time string, ISO 8601 formatted, for example 2016-03-11T03:45:40Z. Requires administrator or project/group owner rights.',
    // ));

    // formFields.add(NoteFormField(
    //   name: 'discussion_to_resolve',
    //   type: String,
    //   controller: TextEditingController(text: extras.discussion_to_resolve ?? ''),
    //   hint:
    //       'The ID of a discussion to resolve. This fills out the issue with a default description and mark the discussion as resolved. Use in combination with merge_request_to_resolve_discussions_of.',
    // ));

    // formFields.add(NoteFormField(
    //   name: 'epic_id',
    //   type: int,
    //   controller: TextEditingController(text: extras.epic_id?.toString() ?? ''),
    //   hint:
    //       'ID of the epic to add the issue to. Valid values are greater than or equal to 0. Premium and Ultimate only.',
    // ));

    // formFields.add(NoteFormField(
    //   name: 'epic_iid',
    //   type: int,
    //   controller: TextEditingController(text: extras.epic_iid?.toString() ?? ''),
    //   hint:
    //       'IID of the epic to add the issue to. Valid values are greater than or equal to 0. (deprecated, scheduled for removal in API version 5). Premium and Ultimate only.',
    // ));

    // formFields.add(NoteFormField(
    //   name: 'iid',
    //   type: String,
    //   controller: TextEditingController(text: extras.iid ?? ''),
    //   hint: 'The internal ID of the project’s issue (requires administrator or project owner rights).',
    // ));

    // formFields.add(NoteFormField(
    //   name: 'merge_request_to_resolve_discussions_of',
    //   type: int,
    //   controller: TextEditingController(text: extras.merge_request_to_resolve_discussions_of?.toString() ?? ''),
    //   hint:
    //       'The IID of a merge request in which to resolve all issues. This fills out the issue with a default description and mark all discussions as resolved. When passing a description or title, these values take precedence over the default values.',
    // ));

    // formFields.add(NoteFormField(
    //   name: 'milestone_id',
    //   type: int,
    //   controller: TextEditingController(text: extras.milestone_id?.toString() ?? ''),
    //   hint:
    //       'The global ID of a milestone to assign issue. To find the milestone_id associated with a milestone, view an issue with the milestone assigned and use the API to retrieve the issue’s details.',
    // ));

    return formFields;
  }
}
