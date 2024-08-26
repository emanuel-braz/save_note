import 'dart:convert';

class SlackResponse {
  final bool ok;
  final String? error;

  SlackResponse({required this.ok, this.error});

  /// Returns a map
  Map<String, dynamic> toMap() {
    return {
      'ok': ok,
      'error': error,
    };
  }

  /// Returns a SlackResponse from a map
  factory SlackResponse.fromMap(Map<String, dynamic> map) {
    return SlackResponse(
      ok: map['ok'],
      error: map['error'],
    );
  }

  /// Returns a JSON string
  String toJson() => jsonEncode(toMap());

  /// Returns a SlackResponse from a JSON string
  factory SlackResponse.fromJson(String source) =>
      SlackResponse.fromMap(json.decode(source));
}
