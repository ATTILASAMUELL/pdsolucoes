import 'package:flutter/material.dart';
import 'package:pdsolucoes_front_end/presentation/pages/login/login_page.dart';
import 'package:pdsolucoes_front_end/presentation/pages/home/home_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String hours = '/horas';
  static const String employees = '/funcionarios';
  static const String squads = '/squads';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginPage(),
        home: (context) => const HomePage(initialPage: HomePage.pageDashboard),
        dashboard: (context) => const HomePage(initialPage: HomePage.pageDashboard),
        hours: (context) => const HomePage(initialPage: HomePage.pageHours),
        employees: (context) => const HomePage(initialPage: HomePage.pageEmployees),
        squads: (context) => const HomePage(initialPage: HomePage.pageSquads),
      };
}

