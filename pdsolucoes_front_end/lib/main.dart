import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pdsolucoes_front_end/core/theme/app_theme.dart';
import 'package:pdsolucoes_front_end/core/utils/app_initializer.dart';
import 'package:pdsolucoes_front_end/presentation/pages/login/login_page.dart';
import 'package:pdsolucoes_front_end/presentation/pages/home/home_page.dart';
import 'package:pdsolucoes_front_end/core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carrega as variáveis de ambiente do arquivo .env
  await dotenv.load(fileName: ".env");
  
  await AppInitializer.initialize();
  runApp(const PDSolucoesApp());
}

class PDSolucoesApp extends StatelessWidget {
  const PDSolucoesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDSoluções',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
