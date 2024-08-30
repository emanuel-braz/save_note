import 'package:flutter_test/flutter_test.dart';
import 'package:save_note/src/models/gitlab_extras.dart';

void main() {
  test('GitlabExtras toMap should return a valid map', () {
    // arrange
    final extras = GitlabExtras(
      assignee_id: 1,
      assignee_ids: [1, 2, 3],
      confidential: true,
      created_at: '2022-01-01',
      description: 'Sample description',
      discussion_to_resolve: 'Sample discussion',
      due_date: '2022-02-01',
      epic_id: 123,
      epic_iid: 456,
      iid: 'ABC123',
      issue_type: 'Bug',
      labels: 'label1,label2',
      merge_request_to_resolve_discussions_of: 789,
      milestone_id: 987,
      weight: 10,
    );

    // act
    final map = extras.toMap();

    // assert
    expect(map, {
      'assignee_id': 1,
      'assignee_ids': [1, 2, 3],
      'confidential': true,
      'created_at': '2022-01-01',
      'description': 'Sample description',
      'discussion_to_resolve': 'Sample discussion',
      'due_date': '2022-02-01',
      'epic_id': 123,
      'epic_iid': 456,
      'iid': 'ABC123',
      'issue_type': 'Bug',
      'labels': 'label1,label2',
      'merge_request_to_resolve_discussions_of': 789,
      'milestone_id': 987,
      'weight': 10,
    });
  });

  test('GitlabExtras fromMap should return a valid instance', () {
    // arrange
    final map = {
      'assignee_id': 1,
      'assignee_ids': [1, 2, 3],
      'confidential': true,
      'created_at': '2022-01-01',
      'description': 'Sample description',
      'discussion_to_resolve': 'Sample discussion',
      'due_date': '2022-02-01',
      'epic_id': 123,
      'epic_iid': 456,
      'iid': 'ABC123',
      'issue_type': 'Bug',
      'labels': 'label1,label2',
      'merge_request_to_resolve_discussions_of': 789,
      'milestone_id': 987,
      'weight': 10,
    };

    // act
    final extras = GitlabExtras.fromMap(map);

    // assert
    expect(extras.assignee_id, 1);
    expect(extras.assignee_ids, [1, 2, 3]);
    expect(extras.confidential, true);
    expect(extras.created_at, '2022-01-01');
    expect(extras.description, 'Sample description');
    expect(extras.discussion_to_resolve, 'Sample discussion');
    expect(extras.due_date, '2022-02-01');
    expect(extras.epic_id, 123);
    expect(extras.epic_iid, 456);
    expect(extras.iid, 'ABC123');
    expect(extras.issue_type, 'Bug');
    expect(extras.labels, 'label1,label2');
    expect(extras.merge_request_to_resolve_discussions_of, 789);
    expect(extras.milestone_id, 987);
    expect(extras.weight, 10);
  });

  test('GitlabExtras toJson should return a valid JSON string', () {
    // arrange
    final extras = GitlabExtras(
      assignee_id: 1,
      assignee_ids: [1, 2, 3],
      confidential: true,
      created_at: '2022-01-01',
      description: 'Sample description',
      discussion_to_resolve: 'Sample discussion',
      due_date: '2022-02-01',
      epic_id: 123,
      epic_iid: 456,
      iid: 'ABC123',
      issue_type: 'Bug',
      labels: 'label1,label2',
      merge_request_to_resolve_discussions_of: 789,
      milestone_id: 987,
      weight: 10,
    );

    // act
    final json = extras.toJson();

    // assert
    expect(json,
        '{"assignee_id":1,"assignee_ids":[1,2,3],"confidential":true,"created_at":"2022-01-01","description":"Sample description","discussion_to_resolve":"Sample discussion","due_date":"2022-02-01","epic_id":123,"epic_iid":456,"iid":"ABC123","issue_type":"Bug","labels":"label1,label2","merge_request_to_resolve_discussions_of":789,"milestone_id":987,"weight":10}');
  });

  test('GitlabExtras fromJson should return a valid instance', () {
    // arrange
    const json =
        '{"assignee_id":1,"assignee_ids":[1,2,3],"confidential":true,"created_at":"2022-01-01","description":"Sample description","discussion_to_resolve":"Sample discussion","due_date":"2022-02-01","epic_id":123,"epic_iid":456,"iid":"ABC123","issue_type":"Bug","labels":"label1,label2","merge_request_to_resolve_discussions_of":789,"milestone_id":987,"weight":10}';

    // act
    final extras = GitlabExtras.fromJson(json);

    // assert
    expect(extras.assignee_id, 1);
    expect(extras.assignee_ids, [1, 2, 3]);
    expect(extras.confidential, true);
    expect(extras.created_at, '2022-01-01');
    expect(extras.description, 'Sample description');
    expect(extras.discussion_to_resolve, 'Sample discussion');
    expect(extras.due_date, '2022-02-01');
    expect(extras.epic_id, 123);
    expect(extras.epic_iid, 456);
    expect(extras.iid, 'ABC123');
    expect(extras.issue_type, 'Bug');
    expect(extras.labels, 'label1,label2');
    expect(extras.merge_request_to_resolve_discussions_of, 789);
    expect(extras.milestone_id, 987);
    expect(extras.weight, 10);
  });
}
