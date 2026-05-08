import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';  // Replaced by Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales_clean/core/constant/state_manager.dart';
import 'package:sip_sales_clean/core/dependencies/face_recognition_dependencies.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/providers/filter_state_provider.dart';
import 'package:sip_sales_clean/routes.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';  // Replaced by Firebase
import 'package:sip_sales_clean/firebase_options.dart';
import 'package:upgrader/upgrader.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Fast inits first — neither spawns a Dart isolate.
  await Future.wait([_initFirebase(), _initAndroidStorage()]);

  // Yield so the debug adapter can finish applying pauseIsolatesOnStart:false
  // before the Regula SDK (FaceSDK.initialize) spawns its background isolate.
  await Future.delayed(Duration.zero);

  // Heavy init last — Regula SDK spawns a background isolate here.
  await FaceRecognitionDependencies.initialize();

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

// Replaced by Firebase — kept for reference
// Future<void> _initSupabase() async {
//   try {
//     await dotenv.load(fileName: '.env');
//     final url = dotenv.env['SUPABASE_URL'];
//     final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
//     if (url != null && anonKey != null) {
//       await Supabase.initialize(
//         url: url,
//         anonKey: anonKey,
//       );
//     } else {
//       log('Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env');
//     }
//   } on TypeError catch (e) {
//     log('Supabase init error: $e');
//   } on ArgumentError catch (e) {
//     log('Supabase init error: $e');
//   } on Exception catch (e) {
//     log('Supabase init error: $e');
//   } on Error catch (e) {
//     log('Supabase init error: $e');
//   } catch (e) {
//     log('Supabase Init Error: $e');
//   }
// }

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
    );
    log('Firebase initialized successfully');
  } catch (e) {
    log('Firebase init error: $e');
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
