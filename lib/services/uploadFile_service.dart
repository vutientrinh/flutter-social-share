import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/file_response.dart';

class UploadFileService {
  final Dio _dio;

  UploadFileService(this._dio);

  Future<FileResponse> uploadFile(File file, {String bucketName = "commons"}) async {
    try {
      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        'bucketName': bucketName,
      });

      final response = await _dio.post(
        '/minio/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      final fileResponse = response.data['data'];
      return FileResponse.fromJson(fileResponse);
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }
}
