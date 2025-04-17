class FileResponse {
  final String filename;
  final String contentType;
  final int fileSize;
  final DateTime createdAt;

  FileResponse({
    required this.filename,
    required this.contentType,
    required this.fileSize,
    required this.createdAt,
  });

  factory FileResponse.fromJson(Map<String, dynamic> json) {
    return FileResponse(
      filename: json['filename'],
      contentType: json['contentType'],
      fileSize: json['fileSize'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}