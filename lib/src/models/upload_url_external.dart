import 'dart:convert';

class UploadURLExternal {
  final String url;
  final String fileId;

  UploadURLExternal({required this.url, required this.fileId});

  Map<String, dynamic> toMap() {
    return {
      'upload_url': url,
      'file_id': fileId,
    };
  }

  factory UploadURLExternal.fromMap(Map<String, dynamic> map) {
    return UploadURLExternal(
      url: map['upload_url'],
      fileId: map['file_id'],
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UploadURLExternal.fromJson(String source) => UploadURLExternal.fromMap(jsonDecode(source));
}
