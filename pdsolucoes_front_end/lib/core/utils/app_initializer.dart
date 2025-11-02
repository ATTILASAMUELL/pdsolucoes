import 'package:pdsolucoes_front_end/core/network/dio_client.dart';
import 'package:pdsolucoes_front_end/core/utils/storage_service.dart';

class AppInitializer {
  static Future<void> initialize() async {
    final token = await StorageService.getToken();
    
    if (token != null && token.isNotEmpty) {
      DioClient.instance.setAuthToken(token);
    }
  }
}


