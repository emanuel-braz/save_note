import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class GitlabExtras {
  final int? assignee_id;
  final List<int>? assignee_ids;
  final bool? confidential;
  final String? created_at;
  final String? description;
  final String? discussion_to_resolve;
  final String? due_date;
  final int? epic_id;
  final int? epic_iid;
  final String? iid;
  final String? issue_type;
  final String? labels;
  final int? merge_request_to_resolve_discussions_of;
  final int? milestone_id;
  final int? weight;

  GitlabExtras({
    this.assignee_id,
    this.assignee_ids,
    this.confidential,
    this.created_at,
    this.description,
    this.discussion_to_resolve,
    this.due_date,
    this.epic_id,
    this.epic_iid,
    this.iid,
    this.issue_type,
    this.labels,
    this.merge_request_to_resolve_discussions_of,
    this.milestone_id,
    this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'assignee_id': assignee_id,
      'assignee_ids': assignee_ids?.map((x) => x).toList(),
      'confidential': confidential,
      'created_at': created_at,
      'description': description,
      'discussion_to_resolve': discussion_to_resolve,
      'due_date': due_date,
      'epic_id': epic_id,
      'epic_iid': epic_iid,
      'iid': iid,
      'issue_type': issue_type,
      'labels': labels,
      'merge_request_to_resolve_discussions_of': merge_request_to_resolve_discussions_of,
      'milestone_id': milestone_id,
      'weight': weight,
    };
  }

  factory GitlabExtras.fromMap(Map<String, dynamic> map) {
    return GitlabExtras(
      assignee_id: map['assignee_id'],
      assignee_ids: List<int>.from(map['assignee_ids']),
      confidential: map['confidential'],
      created_at: map['created_at'],
      description: map['description'],
      discussion_to_resolve: map['discussion_to_resolve'],
      due_date: map['due_date'],
      epic_id: map['epic_id'],
      epic_iid: map['epic_iid'],
      iid: map['iid'],
      issue_type: map['issue_type'],
      labels: map['labels'],
      merge_request_to_resolve_discussions_of: map['merge_request_to_resolve_discussions_of'],
      milestone_id: map['milestone_id'],
      weight: map['weight'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GitlabExtras.fromJson(String source) => GitlabExtras.fromMap(json.decode(source));
}
