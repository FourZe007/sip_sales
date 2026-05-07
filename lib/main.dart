import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales_clean/core/constant/state_manager.dart';
import 'package:sip_sales_clean/core/dependencies/face_recognition_dependencies.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/providers/filter_state_provider.dart';
import 'package:sip_sales_clean/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upgrader/upgrader.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Future.wait([
    FaceRecognitionDependencies.initialize(),
    _initSupabase(),
    _initAndroidStorage(),
  ]);

  // final String deviceOS = await Functions.readDeviceOS();
  //
  // await FaceRecognitionDependencies.initialize();
  //
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //
  // if (deviceOS.isNotEmpty && Platform.isAndroid) {
  //   if (int.parse(deviceOS.split('.')[0]) >= 10) {
  //     log('Device OS $deviceOS is above OS 10.');
  //     await Functions.initStorageConfig(false);
  //   } else {
  //     log('Device OS $deviceOS is below OS 10.');
  //     await Functions.initStorageConfig(true);
  //   }
  // }
  //
  // try {
  //   await dotenv.load(fileName: '.env');
  //   final url = dotenv.env['SUPABASE_URL'];
  //   final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
  //   if (url != null && anonKey != null) {
  //     await Supabase.initialize(url: url, anonKey: anonKey);
  //   } else {
  //     log('Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env');
  //   }
  // } catch (e) {
  //   log('Supabase init error: $e');
  // }

  runApp(const MyApp());
}

Future<void> _initSupabase() async {
  try {
    // final url = 'https://kfgfbaitkcbfuifzpgpq.supabase.co';
    // final anonKey =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtmd2ZiYWl0a2NiZnVpZnpwZ3BxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0NzY0MjYsImV4cCI6MjA3NTA1MjQyNn0.28009330032201203300';
    // await Supabase.initialize(
    //   url: url,
    //   anonKey: anonKey,
    //   authOptions: FlutterAuthClientOptions(),
    // );

    await dotenv.load(fileName: '.env');
    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (url != null && anonKey != null) {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
        authOptions: FlutterAuthClientOptions(),
      );
    } else {
      log('Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env');
    }
  } on TypeError catch (e) {
    log('Supabase init error: $e');
  } on ArgumentError catch (e) {
    log('Supabase init error: $e');
  } on Exception catch (e) {
    log('Supabase init error: $e');
  } on Error catch (e) {
    log('Supabase init error: $e');
  } catch (e) {
    log('Supabase Init Error: $e');
    // if (e is FormatException) {
    //   log('Supabase init error: $e');
    // } else if (e is TypeError) {
    //   log('Supabase init error: $e');
    // } else if (e is ArgumentError) {
    //   log('Supabase init error: $e');
    // } else if (e is Error) {
    //   log('Supabase init error: $e');
    // } else if (e is Exception) {
    //   log('Supabase init error: $e');
    // } else {
    //   log('Supabase init error: $e');
    // }
  }
}

Future<void> _initAndroidStorage() async {
  if (!Platform.isAndroid) return;
  final String deviceOS = await Functions.readDeviceOS();
  if (deviceOS.isEmpty) return;
  final int major = int.parse(deviceOS.split('.')[0]);
  if (major >= 10) {
    log('Device OS $deviceOS is above OS 10.');
    await Functions.initStorageConfig(false);
  } else {
    log('Device OS $deviceOS is below OS 10.');
    await Functions.initStorageConfig(true);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      barrierDismissible: false,
      showIgnore: false,
      showLater: false,
      upgrader: Upgrader(
        durationUntilAlertAgain: const Duration(days: 1),
      ),
      child: MediaQuery(
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
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch};
}
