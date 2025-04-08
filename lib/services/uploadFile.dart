import 'dart:io';
import 'package:dio/dio.dart';
import 'api_client.dart';

class UploadFileService {
  final Dio _dio = ApiClient.dio;

  Future<Response> uploadFile(File file, String bucketName) async {
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
        '/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }
}
