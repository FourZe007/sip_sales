import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, SystemUiOverlay, SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales_clean/core/constant/state_manager.dart';
import 'package:sip_sales_clean/presentation/providers/filter_state_provider.dart';
import 'package:sip_sales_clean/routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );

  // Optional: customize status bar look (transparent background, dark icons)
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: MultiBlocProvider(
        providers: StateManager.getBlocProviders(),
        child: ChangeNotifierProvider(
          create: (context) => FilterStateProvider(),
          child: MaterialApp(
            title: 'SIP Sales',
            scrollBehavior: MyCustomScrollBehavior(),
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            initialRoute: ConstantRoutes.init,
            routes: ConstantRoutes.maps,
          ),
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch};
}
