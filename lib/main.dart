import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/account/login.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/location/location.dart';
import 'package:sip_sales/global/menu.dart';
import 'package:sip_sales/pages/profile/profile.dart';

final navigatorKey = GlobalKey<NavigatorState>();

//091188
void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    // Adjust for icon visibility
    statusBarBrightness: Brightness.light,
  ));

  runApp(
    ChangeNotifierProvider(
      create: (context) => SipSalesState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIP Sales',
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/location': (context) => const LocationPage(),
        '/menu': (context) => const MenuPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        // PointerDeviceKind.mouse,
      };
}
