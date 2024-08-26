import 'dart:convert';

class SlackResponse {
  final bool ok;
  final String? error;

  SlackResponse({required this.ok, this.error});

  Map<String, dynamic> toMap() {
    return {
      'ok': ok,
      'error': error,
    };
  }

  factory SlackResponse.fromMap(Map<String, dynamic> map) {
    return SlackResponse(
      ok: map['ok'],
      error: map['error'],
    );
  }

  String toJson() => jsonEncode(toMap());

  factory SlackResponse.fromJson(String source) => SlackResponse.fromMap(json.decode(source));
}
