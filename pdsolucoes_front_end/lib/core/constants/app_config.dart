import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static String get apiBaseUrl => dotenv.get('API_BASE_URL', fallback: 'http://localhost:3000');
  
  static String get appName => dotenv.get('APP_NAME', fallback: 'PDSoluções');
  
  static String get appVersion => dotenv.get('APP_VERSION', fallback: '1.0.0');
  
  static bool get enableDebugMode => dotenv.get('ENABLE_DEBUG_MODE', fallback: 'false') == 'true';

  static const int apiTimeout = 30;
}




