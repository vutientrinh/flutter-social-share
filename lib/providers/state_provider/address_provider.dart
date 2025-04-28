import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/ecommerce/address_service.dart';

import '../../services/api_client.dart';

final addressServiceProvider = Provider<AddressService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return AddressService(dio);
});
