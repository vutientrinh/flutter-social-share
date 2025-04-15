import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/uploadFile_service.dart';


import '../../services/api_client.dart';

final uploadServiceProvider = Provider<UploadFileService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return UploadFileService(dio);
});
