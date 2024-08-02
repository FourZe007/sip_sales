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
      // theme: ThemeData(
      //   // This is the theme of your application.
      //   //
      //   // TRY THIS: Try running your application with "flutter run". You'll see
      //   // the application has a blue toolbar. Then, without quitting the app,
      //   // try changing the seedColor in the colorScheme below to Colors.green
      //   // and then invoke "hot reload" (save your changes or press the "hot
      //   // reload" button in a Flutter-supported IDE, or press "r" if you used
      //   // the command line to start the app).
      //   //
      //   // Notice that the counter didn't reset back to zero; the application
      //   // state is not lost during the reload. To reset the state, use hot
      //   // restart instead.
      //   //
      //   // This works for code too, not just values: Most code changes can be
      //   // tested with just a hot reload.
      //   // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   // useMaterial3: true,
      //   // primarySwatch: Colors.blueGrey,
      //   dividerColor: Colors.transparent,
      // ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/location': (context) => const LocationPage(),
        '/menu': (context) => const MenuPage(),
        '/profile': (context) => const ProfilePage(),
        // '/setting': (context) => const SettingsPage(),
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
