import 'package:flutter/material.dart';
import 'package:sip_sales_clean/presentation/screens/about_screen.dart';
import 'package:sip_sales_clean/presentation/screens/home_screen.dart';
import 'package:sip_sales_clean/presentation/screens/location_screen.dart';
import 'package:sip_sales_clean/presentation/screens/login_screen.dart';
import 'package:sip_sales_clean/presentation/screens/profile_screen.dart';
import 'package:sip_sales_clean/presentation/screens/register_screen.dart';
import 'package:sip_sales_clean/presentation/screens/sales_report_screen.dart';
import 'package:sip_sales_clean/presentation/screens/splash_screen.dart';
import 'package:sip_sales_clean/presentation/screens/tnc_screen.dart';

class ConstantRoutes {
  static const String init = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String tnc = '/tnc';
  static const String location = '/location';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String about = '/about';
  static const String salesReport = '/salesReport';

  static Map<String, Widget Function(BuildContext)> maps = {
    ConstantRoutes.init: (context) => const SplashScreen(),
    ConstantRoutes.login: (context) => const LoginScreen(),
    ConstantRoutes.register: (context) => const RegisterScreen(),
    ConstantRoutes.tnc: (context) => const TermsConditionScreen(),
    ConstantRoutes.location: (context) => const LocationScreen(),
    ConstantRoutes.home: (context) => const HomeScreen(),
    ConstantRoutes.profile: (context) => const ProfileScreen(),
    ConstantRoutes.about: (context) => const AboutScreen(),
    ConstantRoutes.salesReport: (context) => const SalesReportScreen(),
  };
}
