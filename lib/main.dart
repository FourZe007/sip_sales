import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales_clean/core/constant/state_manager.dart';
import 'package:sip_sales_clean/presentation/providers/filter_state_provider.dart';
import 'package:sip_sales_clean/routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Set up system UI
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.black,
  //     statusBarBrightness: Brightness.light,
  //     systemNavigationBarColor: Colors.white,
  //     systemNavigationBarDividerColor: Colors.transparent,
  //   ),
  // );

  // Only show the top overlay (the status bar)."
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.,
  // );

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
