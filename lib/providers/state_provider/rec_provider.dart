import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/social/rec_service.dart';

import '../../services/api_client.dart';

final addressServiceProvider = Provider<RecService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return RecService(dio);
});
