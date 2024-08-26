import 'dart:convert';

class UploadURLExternal {
  final String url;
  final String fileId;

  UploadURLExternal({required this.url, required this.fileId});

  /// Returns a map
  Map<String, dynamic> toMap() {
    return {
      'upload_url': url,
      'file_id': fileId,
    };
  }

  /// Returns a UploadURLExternal from a map
  factory UploadURLExternal.fromMap(Map<String, dynamic> map) {
    return UploadURLExternal(
      url: map['upload_url'],
      fileId: map['file_id'],
    );
  }

  /// Returns a JSON string
  String toJson() => jsonEncode(toMap());

  /// Returns a UploadURLExternal from a JSON string
  factory UploadURLExternal.fromJson(String source) =>
      UploadURLExternal.fromMap(jsonDecode(source));
}
