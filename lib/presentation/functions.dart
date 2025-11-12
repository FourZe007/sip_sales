import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales_clean/presentation/screens/login_screen.dart';
import 'package:sip_sales_clean/presentation/screens/reset_password_screen.dart';
import 'package:sip_sales_clean/presentation/screens/tnc_screen.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:geolocator/geolocator.dart';

class Functions {
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  static void viewPhoto(BuildContext context, String img) {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return CircleAvatar(foregroundImage: MemoryImage(base64Decode(img)));
        },
      );
    } catch (e) {
      log('Error: $e');
    }
  }

  static void openLink(
    BuildContext context,
    String url,
  ) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      log('Tidak dapat membuka tautan.');
      if (context.mounted) {
        Functions.customFlutterToast('Tidak dapat membuka tautan.');
      }
    }
  }

  static void customFlutterToast(String text, {double fontSize = 16.0}) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[300],
      textColor: Colors.black,
      fontSize: fontSize,
    );
  }

  static void customSnackBar(
    BuildContext context,
    String text,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey,
        content: Text(
          text,
          style: TextThemes.normalTextButton,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.all(8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void openUserGuideline(
    BuildContext context,
    String uri,
  ) async {
    Uri url = Uri.parse(uri);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        customSnackBar(
          context,
          'Tidak dapat membuka tautan. Silakan periksa URL dan coba lagi.',
        );
      }
    }
  }

  static void displayProminentDisclosure(BuildContext context) async {
    final FlutterSecureStorage storage = const FlutterSecureStorage();

    final result = await Navigator.push(
      (context.mounted) ? context : context,
      MaterialPageRoute(
        builder: (context) => const TermsConditionScreen(),
      ),
    );

    if (result) {
      await storage.write(key: 'isUserAgree', value: '1');

      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context.mounted ? context : context,
          '/location',
        );
      }
    } else {
      await storage.write(key: 'isUserAgree', value: '0');
    }
  }

  static void loginUtilization(
    BuildContext context,
    // 0 -> request unbind, 1 -> request NIP, 2 -> reset password
    String option,
  ) {
    try {
      switch (option) {
        case '0':
          Navigator.push(
            context,
            MaterialPageRoute(
              // builder: (context) => UnbindRequestPage(),
              builder: (context) => LoginScreen(),
            ),
          );
          break;
        case '1':
          Navigator.push(
            context,
            MaterialPageRoute(
              // builder: (context) => IdRequestPage(),
              builder: (context) => LoginScreen(),
            ),
          );
          break;
        case '2':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(),
            ),
          );
          break;
        default:
          if (context.mounted) {
            customSnackBar(
              context,
              'Halaman tujuan tidak ditemukan. Mohon coba lagi.',
            );
          }
          break;
      }
    } catch (e) {
      log('Login Utilization Error: $e');
      // GlobalDialog.showCrossPlatformDialog(
      //   context,
      //   'Peringatan!',
      //   'Terjadi kesalahan. Mohon coba lagi.',
      //   () => Navigator.pop(context),
      //   'Tutup',
      //   isIOS: Platform.isIOS ? true : false,
      // );
      if (context.mounted) {
        customSnackBar(
          context,
          'Terjadi kesalahan. Mohon coba lagi.',
        );
      }
    }
  }

  static Future<String> generateUuid() async {
    String uuid = '';

    try {
      // Read the existing UUID only once
      String? existingUuid = await storage.read(key: 'uuid');

      if (existingUuid == null || existingUuid.isEmpty) {
        // Generate a new UUID if none exists
        uuid = Uuid().v4();
        await storage.write(key: 'uuid', value: uuid);

        // Log the action for debugging
        log("Generated and saved new UUID: $uuid");
      } else {
        // Use the existing UUID
        uuid = existingUuid;
        log("Using existing UUID: $uuid");
      }
    } catch (e) {
      // Handle decryption or secure storage errors
      log("Error reading or writing secure storage: $e");
      uuid = Uuid().v4();
      await storage.write(key: 'uuid', value: uuid);
      log("Generated and saved new UUID due to error: $uuid");
    }

    return uuid;
  }

  static Future<String> readAndWriteEmployeeId({
    String id = '',
    bool isLogin = false,
  }) async {
    String employeeId = '';

    try {
      // Read the existing ID only once
      String? existingId = await storage.read(key: 'employeeId');

      if (existingId == null || existingId.isEmpty || isLogin) {
        // Generate a new ID if none exists
        employeeId = id;
        await storage.write(key: 'employeeId', value: id);

        // Log the action for debugging
        log("Employee Id: $employeeId");
      } else {
        // Use the existing ID
        employeeId = existingId;
        log("Employee Id: $employeeId");
      }
    } catch (e) {
      // Handle decryption or secure storage errors
      log("Error reading or writing secure storage: $e");
      employeeId = id;
      await storage.write(key: 'employeeId', value: id);
      log("Input and saved new ID due to error: $employeeId");
    }

    return employeeId;
  }

  static Future<String> readAndWriteUserPass({
    String pass = '',
    bool isLogin = false,
  }) async {
    String password = '';

    try {
      // Read the existing Password only once
      String? existingPass = await storage.read(key: 'pass');

      if (existingPass == null || existingPass.isEmpty || isLogin) {
        // Generate a new Password if none exists
        password = pass;
        await storage.write(key: 'pass', value: pass);

        // Log the action for debugging
        log("Input and saved Password: $password");
      } else {
        // Use the existing Password
        password = existingPass;
        log("Input and saved Password: $password");
      }
    } catch (e) {
      // Handle decryption or secure storage errors
      log("Error reading or writing secure storage: $e");

      password = pass;
      await storage.write(key: 'pass', value: pass);
      log("Input and saved new Password due to error: $password");
    }

    return password;
  }

  static Future<String> readAndWriteDeviceConfig() async {
    String deviceConfiguration = '';
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      // Read the existing ID only once
      String? deviceConfig = await storage.read(key: 'deviceConfig');

      if (deviceConfig == null || deviceConfig.isEmpty) {
        if (Platform.isAndroid) {
          // For Android devices
          final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

          // Generate a new ID if none exists
          deviceConfiguration =
              '${androidInfo.model}, Android ${androidInfo.version.release}';
          await storage.write(key: 'deviceConfig', value: deviceConfiguration);

          // Log the action for debugging
          log("Device Configuration: $deviceConfiguration");
        } else if (Platform.isIOS) {
          // For iOS devices
          final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

          // Generate a new ID if none exists
          deviceConfiguration =
              '${iosInfo.model}, iOS ${iosInfo.systemVersion}';
          await storage.write(key: 'deviceConfig', value: deviceConfiguration);

          // Log the action for debugging
          log("Device Configuration: $deviceConfiguration");
        } else {
          // add handler for non-Android and non-iOS devices (upcoming v1.1.11)
        }
      } else {
        // Use the existing ID
        deviceConfiguration = deviceConfig;
        log("Device Configuration: $deviceConfiguration");
      }
    } catch (e) {
      log('Error retrieving device info: $e');
      deviceConfiguration = 'error';
    }

    return deviceConfiguration;
  }

  static Future<bool> requestPermission() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLocationGranted', false);

    try {
      handler.PermissionStatus permissionStatus;
      permissionStatus = await handler.Permission.locationWhenInUse.status;
      if (permissionStatus == handler.PermissionStatus.denied ||
          permissionStatus == handler.PermissionStatus.permanentlyDenied) {
        permissionStatus = await handler.Permission.locationWhenInUse.request();
        if (permissionStatus == handler.PermissionStatus.denied ||
            permissionStatus == handler.PermissionStatus.permanentlyDenied) {
          await storage.write(key: 'isLocationGranted', value: 'false');
          return false;
        }
      }

      await storage.write(key: 'isLocationGranted', value: 'true');
      return true;
    } catch (e) {
      await storage.write(key: 'isLocationGranted', value: 'false');
      return false;
    }
  }

  // static Future<bool> serviceRequest() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   log('Is Location Service enabled? $serviceEnabled');
  //   if (!serviceEnabled) {
  //     log('Service disabled');
  //     final permission = await Geolocator.requestPermission();
  //     log('Permission: $permission');
  //     if (permission != LocationPermission.always &&
  //         permission != LocationPermission.whileInUse) {
  //       return false;
  //     }
  //   } else {
  //     log('Service enabled');
  //   }

  //   return true;
  // }

  static Future<bool> serviceRequest() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      log('Location service enabled: $serviceEnabled');

      // If service is disabled, try to enable it
      if (!serviceEnabled) {
        Position? position = await Geolocator.getCurrentPosition();
        log('Position: $position');

        if (position != null) {
          log('Location service enabled');
          return true;
        }
      }

      // Check and request location permissions
      final permissionStatus = await handler.Permission.location.request();
      log('Location permission status: ${permissionStatus.name}');

      if (permissionStatus.isDenied) {
        // Request permission
        final requestedStatus = await handler.Permission.location.request();
        if (requestedStatus.isDenied || requestedStatus.isPermanentlyDenied) {
          log('Location permission denied');
          return false;
        }
      }

      // Verify location services are still enabled after permission check
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('Location services were disabled during permission check');
        return false;
      }

      return true;
    } catch (e) {
      log('Error in serviceRequest: $e');
      return false;
    }
  }
}
