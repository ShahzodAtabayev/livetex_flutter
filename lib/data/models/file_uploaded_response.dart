class FileUploadedResponse {
  String? url;
  String? name;

  FileUploadedResponse({required this.url, required this.name});

  factory FileUploadedResponse.fromMap(Map<String, dynamic> map) {
    return FileUploadedResponse(
      url: map['url'] as String?,
      name: map['name'] as String?,
    );
  }
}
