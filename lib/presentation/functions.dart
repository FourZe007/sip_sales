import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store.event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/counter_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/head_acts_master.dart';
import 'package:sip_sales_clean/presentation/cubit/image_cubit.dart';
import 'package:sip_sales_clean/presentation/screens/login_screen.dart';
import 'package:sip_sales_clean/presentation/screens/request_id_screen.dart';
import 'package:sip_sales_clean/presentation/screens/reset_password_screen.dart';
import 'package:sip_sales_clean/presentation/screens/tnc_screen.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:geolocator/geolocator.dart';

class Functions {
  static AndroidOptions getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static IOSOptions getIOSOptions() => const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  static FlutterSecureStorage? storage;
  //  = FlutterSecureStorage(
  //   aOptions: getAndroidOptions(),
  //   iOptions: getIOSOptions(),
  // );

  static SharedPreferences? prefs;

  static Future<void> clearAllData() async {
    await storage?.deleteAll(
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );
  }

  static Future<void> initStorageConfig(
    final bool isOldAndroid,
  ) async {
    if (isOldAndroid) {
      prefs = await SharedPreferences.getInstance();
    } else {
      storage = FlutterSecureStorage(
        aOptions: getAndroidOptions(),
        iOptions: getIOSOptions(),
      );
    }
  }

  // employeeId, branch & shop -> loginstate
  // activityId -> decide from which type the user chose
  // date & time -> auto generate
  // lat & lng -> auto generate
  // desc -> user input
  // image -> user input
  static Future<void> manageNewHeadStoreAct(
    final BuildContext context,
    final String actTypeId, {
    final String desc = '',
    // HeadBriefingCreationModel? briefing,
  }) async {
    log('Activity Code: $actTypeId');

    switch (actTypeId) {
      case '00':
        log('Morning Briefing');
        final headMasterCubit = context.read<HeadActsMasterCubit>().state;
        if (headMasterCubit is HeadActsMasterLoaded) {
          log('Location: ${headMasterCubit.briefingMaster[0].bsName}');
        } else {
          log(
            'Location: ${(context.read<LoginBloc>().state as LoginSuccess).user.bsName}',
          );
        }
        // ~:Description user input should be break down into several fields!:~
        final counterCubit = context.read<CounterCubit>();
        log('Shop Manager: ${counterCubit.getValueWithKey('shop_manager')}');
        log('Shop Counter: ${counterCubit.getValueWithKey('sales_counter')}');
        log('Salesman: ${counterCubit.getValueWithKey('salesman')}');
        log('Others: ${counterCubit.getValueWithKey('others')}');
        log(
          'Number of Participants: ${counterCubit.getKeysTotalValue(['shop_manager', 'sales_counter', 'salesman', 'others'])}',
        );
        log(
          'Morning Briefing values: ${counterCubit.getBriefingValues(['shop_manager', 'sales_counter', 'salesman', 'others'])}',
        );
        log('Description: $desc');
        log('Image state: ${context.read<ImageCubit>().state}');
        context.read<HeadStoreBloc>().add(
          InsertMorningBriefing(
            context: context,
            actId: actTypeId,
            desc: desc,
          ),
        );
        break;
      case '01':
        log('Visit Market');
        // context.read<HeadStoreBloc>().add(
        //   InsertVisitMarket(
        //     employee: employee,
        //     actId: actId,
        //     desc: desc,
        //     img: img,
        //     locationName: locationName,
        //     values: values,
        //   ),
        // );
        break;
      case '02':
        log('Recruitment');
        // context.read<HeadStoreBloc>().add(
        //   InsertRecruitment(
        //     employee: employee,
        //     actId: actId,
        //     desc: desc,
        //     img: img,
        //     locationName: locationName,
        //     values: values,
        //   ),
        // );
        break;
      case '03':
        log('Interview');
        // context.read<HeadStoreBloc>().add(
        //   InsertInterview(
        //     employee: employee,
        //     actId: actId,
        //     desc: desc,
        //     img: img,
        //     locationName: locationName,
        //     values: values,
        //   ),
        // );
        break;
      case '04':
        log('Daily Report');
        // context.read<HeadStoreBloc>().add(
        //   InsertDailyReport(
        //     employee: employee,
        //     actId: actId,
        //     desc: desc,
        //     img: img,
        //     locationName: locationName,
        //     values: values,
        //   ),
        // );
        break;
      default:
    }
  }

  static void viewPhoto(
    BuildContext context,
    String img, {
    bool isCircular = false,
  }) {
    try {
      if (isCircular) {
        showDialog(
          context: context,
          builder: (context) {
            return CircleAvatar(
              foregroundImage: MemoryImage(base64Decode(img)),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(
                  base64Decode(img),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  static void openMap(
    double lat,
    double lng,
  ) async {
    Uri url = Uri.parse('https://maps.google.com/?q=$lat,$lng');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Functions.customFlutterToast(
        'Tidak dapat membuka tautan. Silakan periksa URL dan coba lagi.',
      );
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
    String text, {
    Color defaultTextColor = Colors.black,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey.shade300,
        content: Text(
          text,
          style: TextThemes.normalTextButton.copyWith(
            color: defaultTextColor,
          ),
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
    final result = await Navigator.push(
      (context.mounted) ? context : context,
      MaterialPageRoute(
        builder: (context) => const TermsConditionScreen(),
      ),
    );

    if (result) {
      // await storage.write(key: 'isUserAgree', value: '1');

      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context.mounted ? context : context,
          '/location',
        );
      }
    } else {
      // await storage.write(key: 'isUserAgree', value: '0');
    }
  }

  static void loginUtilization(
    BuildContext context,
    // 0 -> request unbind, 1 -> request NIP, 2 -> reset password
    String option,
  ) {
    try {
      switch (option) {
        // ~:Disabled:~
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
              builder: (context) => RequestIdScreen(),
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
      if ((int.parse(await readDeviceOS())) >= 10) {
        // Read the existing UUID only once
        String? existingUuid = await storage?.read(key: 'uuid');

        if (existingUuid == null || existingUuid.isEmpty) {
          // Generate a new UUID if none exists
          uuid = Uuid().v4();
          await storage?.write(key: 'uuid', value: uuid);

          // Log the action for debugging
          log("Generated and saved new UUID: $uuid");
        } else {
          // Use the existing UUID
          uuid = existingUuid;
          log("Using existing UUID: $uuid");
        }
      } else {
        // Read the existing UUID only once
        String? existingUuid = prefs?.getString('uuid');

        if (existingUuid == null || existingUuid.isEmpty) {
          // Generate a new UUID if none exists
          uuid = Uuid().v4();
          prefs?.setString('uuid', uuid);

          // Log the action for debugging
          log("Generated and saved new UUID: $uuid");
        } else {
          // Use the existing UUID
          uuid = existingUuid;
          log("Using existing UUID: $uuid");
        }
      }
    } catch (e) {
      // Handle decryption or secure storage errors
      log("Error reading or writing secure storage: $e");
      // uuid = Uuid().v4();
      if (int.parse(await readDeviceOS()) >= 10) {
        await storage?.delete(key: 'uuid');
      } else {
        await prefs?.remove('uuid');
      }
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
      if (int.parse(await readDeviceOS()) >= 10) {
        // Read the existing ID only once
        String? existingId = await storage?.read(key: 'employeeId');
        log('Existing ID: $existingId');

        if (existingId == null || existingId.isEmpty || isLogin) {
          // Generate a new ID if none exists
          employeeId = id;
          await storage?.write(key: 'employeeId', value: id);

          // Log the action for debugging
          log("Employee Id: $employeeId");
        } else {
          // Use the existing ID
          employeeId = existingId;
          log("Employee Id: $employeeId");
        }
      } else {
        // Read the existing ID only once
        String? existingId = prefs?.getString('employeeId');
        log('Existing ID: $existingId');

        if (existingId == null || existingId.isEmpty || isLogin) {
          // Generate a new ID if none exists
          employeeId = id;
          await prefs?.setString('employeeId', id);

          // Log the action for debugging
          log("Employee Id: $employeeId");
        } else {
          // Use the existing ID
          employeeId = existingId;
          log("Employee Id: $employeeId");
        }
      }
    } catch (e) {
      // Handle decryption or secure storage errors
      log("Error reading or writing secure storage: $e");
      employeeId = id;

      if (int.parse(await readDeviceOS()) >= 10) {
        await storage?.delete(key: 'employeeId');
      } else {
        await prefs?.remove('employeeId');
      }
      // await storage.write(key: 'employeeId', value: id);
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
      if (int.parse(await readDeviceOS()) >= 10) {
        // Read the existing Password only once
        String? existingPass = await storage?.read(key: 'pass');
        log('Existing Password: $existingPass');

        if (existingPass == null || existingPass.isEmpty || isLogin) {
          // Generate a new Password if none exists
          password = pass;
          await storage?.write(key: 'pass', value: pass);

          // Log the action for debugging
          log("Input and saved Password: $password");
        } else {
          // Use the existing Password
          password = existingPass;
          log("Input and saved Password: $password");
        }
      } else {
        // Read the existing Password only once
        String? existingPass = prefs?.getString('pass');
        log('Existing Password: $existingPass');

        if (existingPass == null || existingPass.isEmpty || isLogin) {
          // Generate a new Password if none exists
          password = pass;
          await prefs?.setString('pass', pass);

          // Log the action for debugging
          log("Input and saved Password: $password");
        } else {
          // Use the existing Password
          password = existingPass;
          log("Input and saved Password: $password");
        }
      }
    } catch (e) {
      // Handle decryption or secure storage errors
      log("Error reading or writing secure storage: $e");
      password = pass;
      // await storage.write(key: 'pass', value: pass);
      if (int.parse(await readDeviceOS()) >= 10) {
        await storage?.delete(key: 'pass');
      } else {
        await prefs?.remove('pass');
      }
      log("Input and saved new Password due to error: $password");
    }

    return password;
  }

  static Future<String> readAndWriteDeviceConfig() async {
    String deviceConfiguration = '';
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (int.parse(await readDeviceOS()) >= 10) {
        // Read the existing ID only once
        String? deviceConfig = await storage?.read(key: 'deviceConfig');
        log('Read Device Config: $deviceConfig');

        if (deviceConfig == null || deviceConfig.isEmpty) {
          log('Device Config is either null or empty!');
          if (Platform.isIOS) {
            // storage = FlutterSecureStorage(iOptions: getIOSOptions());

            // For iOS devices
            final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
            log('iOS Info: $iosInfo');
            log('iOS System Version: ${iosInfo.systemVersion}');

            // Generate a new ID if none exists
            deviceConfiguration =
                '${iosInfo.model}, iOS ${iosInfo.systemVersion}';
            await storage?.write(
              key: 'deviceConfig',
              value: deviceConfiguration,
            );

            // Log the action for debugging
            log("Wrote New iOS Device Config: $deviceConfiguration");
          } else {
            // storage = FlutterSecureStorage(aOptions: getAndroidOptions());

            // For Non-iOS devices
            final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
            log('Android Info: $androidInfo');
            log('Android Version: ${androidInfo.version.release}');

            // Generate a new ID if none exists
            deviceConfiguration =
                '${androidInfo.model}, Android ${androidInfo.version.release}';
            log('New Android Device Config: $deviceConfiguration');
            await storage?.write(
              key: 'deviceConfig',
              value: deviceConfiguration,
            );

            // Log the action for debugging
            log(
              "Read Saved Android Device Config: ${await storage?.read(key: 'deviceConfig')}",
            );
          }
        } else {
          log('Device Config is not null or empty!');
          // Use the existing ID
          deviceConfiguration = deviceConfig;
          log("Existing Device Config: $deviceConfiguration");
        }
      } else {
        // Read the existing ID only once
        String? deviceConfig = prefs?.getString('deviceConfig');
        log('Read Device Config: $deviceConfig');

        if (deviceConfig == null || deviceConfig.isEmpty) {
          log('Device Config is either null or empty!');
          if (Platform.isIOS) {
            // storage = FlutterSecureStorage(iOptions: getIOSOptions());

            // For iOS devices
            final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
            log('iOS Info: $iosInfo');
            log('iOS System Version: ${iosInfo.systemVersion}');

            // Generate a new ID if none exists
            deviceConfiguration =
                '${iosInfo.model}, iOS ${iosInfo.systemVersion}';
            await prefs?.setString('deviceConfig', deviceConfiguration);

            // Log the action for debugging
            log("Wrote New iOS Device Config: $deviceConfiguration");
          } else {
            // storage = FlutterSecureStorage(aOptions: getAndroidOptions());

            // For Non-iOS devices
            final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
            log('Android Info: $androidInfo');
            log('Android Version: ${androidInfo.version.release}');

            // Generate a new ID if none exists
            deviceConfiguration =
                '${androidInfo.model}, Android ${androidInfo.version.release}';
            log('New Android Device Config: $deviceConfiguration');
            await prefs?.setString('deviceConfig', deviceConfiguration);

            // Log the action for debugging
            log("Read Saved Android Device Config: $deviceConfiguration");
          }
        } else {
          log('Device Config is not null or empty!');
          // Use the existing ID
          deviceConfiguration = deviceConfig;
          log("Existing Device Config: $deviceConfiguration");
        }
      }
    } on PlatformException catch (e) {
      log(e.toString());
      deviceConfiguration = '';
      if (int.parse(await readDeviceOS()) >= 10) {
        await storage?.delete(key: 'deviceConfig');
      } else {
        await prefs?.remove('deviceConfig');
      }
    } catch (e) {
      log('Error retrieving device config: $e');
      deviceConfiguration = '';
      if (int.parse(await readDeviceOS()) >= 10) {
        await storage?.delete(key: 'deviceConfig');
      } else {
        await prefs?.remove('deviceConfig');
      }
    }

    return deviceConfiguration;
  }

  static Future<String> readDeviceOS() async {
    String deviceOS = '';
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      log('Device OS is either null or empty!');
      if (Platform.isIOS) {
        // storage = FlutterSecureStorage(iOptions: getIOSOptions());

        // For iOS devices
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        log('iOS Info: $iosInfo');
        log('iOS System Version: ${iosInfo.systemVersion}');

        // Generate a new ID if none exists
        // deviceOS = iosInfo.systemVersion;
        deviceOS = '';

        // Log the action for debugging
        log("Wrote New iOS Device OS: $deviceOS");
      } else {
        // storage = FlutterSecureStorage(aOptions: getAndroidOptions());

        // For Non-iOS devices
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        // log('Android Info: $androidInfo');
        log('Android Version: ${androidInfo.version.release}');

        // Generate a new ID if none exists
        deviceOS = androidInfo.version.release.split('.')[0];
        log('New Android Device OS: $deviceOS');

        // Log the action for debugging
        log('Read Saved Android Device OS: $deviceOS');
      }
    } on PlatformException catch (e) {
      log(e.toString());
      deviceOS = '';
    } catch (e) {
      log('Error retrieving device OS: $e');
      deviceOS = '';
    }

    return deviceOS;
  }

  static Future<bool> requestPermission() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setBool('isLocationGranted', false);

    try {
      handler.PermissionStatus permissionStatus;
      permissionStatus = await handler.Permission.locationWhenInUse.status;
      if (permissionStatus == handler.PermissionStatus.denied ||
          permissionStatus == handler.PermissionStatus.permanentlyDenied) {
        permissionStatus = await handler.Permission.locationWhenInUse.request();
        if (permissionStatus == handler.PermissionStatus.denied ||
            permissionStatus == handler.PermissionStatus.permanentlyDenied) {
          // await storage.write(key: 'isLocationGranted', value: 'false');
          return false;
        }
      }

      // await storage.write(key: 'isLocationGranted', value: 'true');
      return true;
    } catch (e) {
      // await storage.write(key: 'isLocationGranted', value: 'false');
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
  //
  //   return true;
  // }

  static Future<Map<String, dynamic>> serviceRequest() async {
    try {
      // ~:New Version:~
      bool serviceEnabled;
      LocationPermission permission;

      // 1. Check if Location Services are enabled (The Simulator GPS switch)
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // This usually means the Simulator "Features -> Location" is set to "None"
        // return Future.error('Location services are disabled.');
        return {
          'isServiceEnabled': false,
          'message': 'Location services are disabled.',
        };
      }

      // 2. Check current permission status
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // 3. FORCE THE REQUEST
        // If you don't call this, the popup never shows, and the app isn't in Settings
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          // return Future.error('Location permissions are denied');
          return {
            'isServiceEnabled': false,
            'message': 'Location permissions are denied.',
          };
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        // return Future.error('Location permissions are permanently denied.');
        return {
          'isServiceEnabled': false,
          'message': 'Location permissions are permanently denied.',
        };
      }

      // 4. If we get here, we can get the location
      Position position = await Geolocator.getCurrentPosition();
      log("Clock In Success at: ${position.latitude}, ${position.longitude}");
      return {
        'isServiceEnabled': true,
        'message': 'Location services are enabled.',
      };

      // ~:Old Version:~
      // Check if location services are enabled
      // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // log('Location service enabled: $serviceEnabled');
      //
      // final reqLoc = await Geolocator.requestPermission();
      // log('Location permission status after request: $reqLoc');

      // // If service is disabled, try to enable it
      // if (!serviceEnabled) {
      //   Position? position = await Geolocator.getCurrentPosition();
      //   log('Position: $position');
      //
      //   if (position != null) {
      //     log('Location service enabled');
      //     return true;
      //   }
      // }
      //
      // // Check and request location permissions
      // final permissionStatus = await handler.Permission.location.request();
      // log('Location permission status: ${permissionStatus.name}');
      //
      // if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      //   // Request permission
      //   final requestedStatus = await handler.Permission.location.request();
      //   if (requestedStatus.isDenied || requestedStatus.isPermanentlyDenied) {
      //     log('Location permission denied');
      //     return false;
      //   }
      // }
      //
      // // Verify location services are still enabled after permission check
      // serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // if (!serviceEnabled) {
      //   log('Location services were disabled during permission check');
      //   return false;
      // }
      //
      // return true;
    } catch (e) {
      log('Error in serviceRequest: $e');
      return {
        'isServiceEnabled': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
}
