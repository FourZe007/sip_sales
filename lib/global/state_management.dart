// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as images;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/pages/location/image_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sip_sales/widget/status/failure_animation.dart';
import 'package:sip_sales/widget/status/success_animation.dart';
import 'package:sip_sales/widget/status/warning_animation.dart';
import 'package:uuid/uuid.dart';

class SipSalesState with ChangeNotifier {
  // =================================================================
  // ============================ App Flow ===========================
  // =================================================================
  bool isAppFlowLoading = false;
  bool get getIsAppFlowLoading => false;

  void setIsAppFlowLoading() {
    isAppFlowLoading = !isAppFlowLoading;
    notifyListeners();
  }

  String displayDescription = '';
  String get getdDisplayDescription => displayDescription;

  void setDisplayDescription(String value) {
    displayDescription = value;
  }

  // String returnPage = '';
  // String get getReturnPage => returnPage;

  final profileShowcaseKey = GlobalKey(debugLabel: 'profile');
  final dateTimeShowcaseKey = GlobalKey(debugLabel: 'datetime');
  final absentShowcaseKey = GlobalKey(debugLabel: 'absent');
  final logShowcaseKey = GlobalKey(debugLabel: 'log');
  final latestLogShowcaseKey = GlobalKey(debugLabel: 'latestlog');

  bool isShowCaseCompleted = false;

  bool get getIsShowCaseCompleted => isShowCaseCompleted;

  void setIsShowCaseCompleted(bool value) {
    isShowCaseCompleted = value;
    notifyListeners();
  }

  bool isLoadingProgress = false;

  bool get getIsLoadingProgress => isLoadingProgress;

  Future<void> setIsLoadingProgress() async {
    isLoadingProgress = !isLoadingProgress;
    notifyListeners();
    print('isLoadingProgress: $isLoadingProgress');
  }

  // =================================================================
  // ===================== Login Configuration =======================
  // =================================================================
  List<ModelUser> userAccountList = [];
  List<ModelUser> get getUserAccountList => userAccountList;

  void setUserAccountList(List<ModelUser> value) {
    userAccountList = value;
    notifyListeners();
  }

  String profilePicture = '';
  String get getProfilePicture => profilePicture;

  void setProfilePicture(String value) {
    profilePicture = value;
    notifyListeners();
  }

  String profilePicturePreview = '';
  String get getProfilePicturePreview => profilePicturePreview;

  void setProfilePicturePreview(String value) {
    profilePicturePreview = value;
    notifyListeners();
  }

  FlutterSecureStorage storage = const FlutterSecureStorage();

  String uuid = '';

  String get getUUID => uuid;

  Future<String> generateUuid() async {
    try {
      // Read the existing UUID only once
      String? existingUuid = await storage.read(key: 'uuid');

      if (existingUuid == null || existingUuid.isEmpty) {
        // Generate a new UUID if none exists
        uuid = Uuid().v4();
        await storage.write(key: 'uuid', value: uuid);

        // Log the action for debugging
        print("Generated and saved new UUID: $uuid");

        // Notify listeners as the state changed
        notifyListeners();
      } else {
        // Use the existing UUID
        uuid = existingUuid;
        print("Using existing UUID: $uuid");
      }
    } catch (e) {
      // Handle decryption or secure storage errors
      print("Error reading or writing secure storage: $e");
      uuid = Uuid().v4();
      await storage.write(key: 'uuid', value: uuid);
      print("Generated and saved new UUID due to error: $uuid");

      // Notify listeners as the state changed
      notifyListeners();
    }

    return uuid;
  }

  TextEditingController unbindReqTextController = TextEditingController();
  TextEditingController get getUnbindReqTextController =>
      unbindReqTextController;

  void setUnbindReqTextController(String value) {
    unbindReqTextController.text = value;
    notifyListeners();
  }

  List<ModelResultMessage2> unbindRequestList = [];
  List<ModelResultMessage2> get getUnbindRequestList => unbindRequestList;

  Future<String> processUnbindRequest(String eId) async {
    try {
      unbindRequestList.clear();
      unbindRequestList.addAll(await GlobalAPI.fetchReqUnbindAcc(
        eId,
        getUnbindReqTextController.text,
      ));

      if (unbindRequestList.isNotEmpty) {
        print('Unbind Request: ${unbindRequestList[0].resultMessage}');
        if (unbindRequestList[0].resultMessage.split(':')[0] == 'https') {
          displayDescription =
              'Permintaan unbind berhasil dikirim. Mohon tunggu informasi lebih lanjut.';
          return 'success';
        } else {
          displayDescription = 'Permintaan unbind gagal dikirim.';
          return 'warn';
        }
      } else {
        displayDescription = 'Terjadi kesalahan, mohon coba lagi.';
        return 'failed';
      }
    } catch (e) {
      displayDescription = e.toString();
      return 'failed';
    }
  }

  // =================================================================
  // =========================== Profile =============================
  // =================================================================
  List<XFile?> pickedPpList = [];
  List<Uint8List> ppBytesList = [];
  List<images.Image> ppList = [];
  List<String> base64PpList = [];
  List<String> get getBase64PpList => base64PpList;

  Future<bool> takeProfilePictureFromCamera(BuildContext context) async {
    pickedPpList = [];
    ppBytesList = [];
    ppList = [];
    base64PpList = [];

    try {
      pickedPpList.add(await ImagePicker().pickImage(
        source: ImageSource.camera,
      ));

      // Check if image was picked
      if (pickedPpList.isEmpty) {
        // do something
        print('Picked image is empty');
      } else {
        print('Read picked image as bytes');
        // Read image bytes
        if (pickedPpList.isNotEmpty) {
          ppBytesList.add(await pickedPpList[0]!.readAsBytes());
        } else {
          return false;
        }

        if (ppBytesList.isNotEmpty) {
          print('Profile picture is not empty');
          ppList.addAll(
              ppBytesList.map((imageByte) => images.decodeImage(imageByte)!));

          // Encode image to base64
          print('Encode image to base64');
          base64PpList.addAll(
              ppList.map((image) => base64Encode(images.encodePng(image))));
          print('Base 64 Image: ${base64PpList.length}');
        }
      }

      notifyListeners();

      if (base64PpList.isNotEmpty) {
        print('Image available');
        return true;
      }
      print('Image not available');
      return false;
    } catch (e) {
      print('Error taking profile picture: $e');
      return false;
    }
  }

  List<ModelResultMessage> uploadProfileState = [];
  List<ModelResultMessage> get getUploadProfileState => uploadProfileState;

  Future<String> uploadProfilePicture(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String nip = prefs.getString('nip')!;

    uploadProfileState.clear();
    uploadProfileState.addAll(await GlobalAPI.fetchUploadImage(
      nip,
      getBase64PpList[0],
    ));

    if (uploadProfileState.isNotEmpty) {
      print('result message: ${uploadProfileState[0].resultMessage}');
      if (uploadProfileState[0].resultMessage == 'SUKSES') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await GlobalAPI.fetchUserAccount(
          prefs.getString('nip')!,
          prefs.getString('password')!,
          await generateUuid(),
        ).then((user) async {
          setProfilePicturePreview(user[0].profilePicture);
          try {
            await GlobalAPI.fetchShowImage(user[0].employeeID).then(
              (String highResImg) async {
                if (highResImg == 'not available') {
                  setProfilePicture(highResImg);
                  print('High Res Image is not available.');
                } else if (highResImg == 'failed') {
                  setProfilePicture(highResImg);
                  print('High Res Image failed to load.');
                } else if (highResImg == 'error') {
                  setProfilePicture(highResImg);
                  print('An error occured, please try again.');
                } else {
                  setProfilePicture(highResImg);
                  print('High Res Image successfully loaded.');
                  print('High Res Image: $highResImg');
                }
              },
            );
          } catch (e) {
            print('Show HD Image Error: $e');
          }
        });

        displayDescription = 'Foto profil berhasil diunggah.';

        return 'success';
      } else {
        displayDescription = 'Foto profil gagal diunggah.';

        return 'failed';
      }
    } else {
      print('Profile image is empty');
      displayDescription =
          'Terjadi kesalahan saat mengunggah, silakan coba lagi.';

      return 'error';
    }
  }

  Future<String> showProfilePicture(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String nip = prefs.getString('nip')!;

    uploadProfileState.clear();
    uploadProfileState.addAll(await GlobalAPI.fetchUploadImage(
      nip,
      getBase64PpList[0],
    ));

    if (uploadProfileState.isNotEmpty) {
      if (uploadProfileState[0].resultMessage == 'SUKSES') {
        displayDescription = 'Profil berhasil diunggah.';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessAnimationPage(),
          ),
        );
      } else {
        displayDescription = 'Profil gagal diunggah.';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const FailureAnimationPage(),
          ),
        );
      }
    } else {
      displayDescription =
          'Terjadi kesalahan saat mengunggah, silakan coba lagi.';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WarningAnimationPage(),
        ),
      );
    }

    return profilePicture;
  }

  String currentPassword = '';
  String get getCurrentPassword => currentPassword;

  void setCurrentPassword(String value) {
    currentPassword = value;
  }

  String newPassword = '';
  String get getNewPassword => newPassword;

  void setNewPassword(String value) {
    newPassword = value;
  }

  List<ModelResultMessage2> changePasswordList = [];
  List<ModelResultMessage2> get getChangePasswordList => changePasswordList;

  Future<Map<String, dynamic>> fetchChangeUserPassword(
    String currentPass,
    String newPass,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String id = prefs.getString('nip') ?? '';

      changePasswordList.clear();
      changePasswordList.addAll(
        await GlobalAPI.fetchChangeUserPassword(id, currentPass, newPass),
      );

      if (changePasswordList.isNotEmpty) {
        if (changePasswordList[0].resultMessage == 'SUKSES') {
          displayDescription = 'Kata sandi berhasil diubah!';
          return {
            'status': 'success',
            'data': changePasswordList,
          };
        } else {
          displayDescription = '${changePasswordList[0].resultMessage}.';
          return {
            'status': 'warn',
            'data': [],
          };
        }
      } else {
        displayDescription = 'Terjadi kesalahan, mohon coba lagi.';
        return {
          'status': 'failed',
          'data': [],
        };
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      displayDescription = e.toString();

      return {
        'status': 'error',
        'data': [],
      };
    }
  }

  // ================================================================
  // ======================= Activity Route =========================
  // ================================================================
  String employeeID = '';
  List<ModelActivityRoute> activityRouteList = [];
  int locationIndex = 0;

  String get getEmployeeID => employeeID;

  List<ModelActivityRoute> get getActivityRoute => activityRouteList;

  int get getLocationIndex => locationIndex;

  void setLocationIndex(int i) {
    locationIndex = i;
    // notifyListeners();
  }

  Future<List<ModelActivityRoute>> fetchActivityRouteList(String date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    employeeID = prefs.getString('nip')!;

    activityRouteList.clear();
    activityRouteList = await GlobalAPI.fetchActivityRoute(
      employeeID,
      date,
    );

    return activityRouteList;
  }

  // ================================================================
  // ============= Default & Carousel Route Details =================
  // ================================================================
  String absentType = '';
  String get getAbsentType => absentType;

  void setAbsentType(String value) {
    absentType = value;
  }

  List<SalesDashboardModel> salesDashboardList = [];
  List<SalesDashboardModel> get getSalesDashboardList => salesDashboardList;

  void setSalesDashboardList(List<SalesDashboardModel> list) {
    salesDashboardList = list;
    notifyListeners();
  }

  List<ModelAttendanceHistory> absentHistoryList = [];
  List<ModelAttendanceHistory> get getAbsentHistoryList => absentHistoryList;

  void setAbsentHistoryList(List<ModelAttendanceHistory> values) {
    absentHistoryList = values;
    notifyListeners();
  }

  ModelAttendanceHistory absentHistoryDetail = ModelAttendanceHistory(
    employeeID: '',
    employeeName: '',
    branch: '',
    shop: '',
    branchName: '',
    shopName: '',
    locationID: '',
    locationName: '',
    latitude: 0,
    longitude: 0,
    date: '',
    checkIn: '',
    checkOut: '',
    absentLocation: '',
    userLat: 0,
    userLng: 0,
    eventName: '',
    eventPhoto: '',
    eventThumbnail: '',
  );
  ModelAttendanceHistory get getAbsentHistoryDetail => absentHistoryDetail;

  List<ModelActivityRouteDetails> activityRouteDetailsList = [];

  List<ModelActivityRouteDetails> get fetchActivityRouteDetails =>
      activityRouteDetailsList;

  List<List<ModelImage>> imageList = [[]];

  List<List<ModelImage>> get fetchImageList => imageList;

  Future<ModelDetailsProcessing> fetchDetailsProcessing(int index) async {
    activityRouteDetailsList.clear();
    for (int i = 0; i < activityRouteList[index].detail.length; i++) {
      activityRouteDetailsList.add(activityRouteList[index].detail[i]);
    }

    imageList.clear();
    for (int i = 0; i < activityRouteList[index].detail.length; i++) {
      ModelActivityRouteDetails detail = activityRouteList[index].detail[i];

      List<ModelImage> temp = [];
      if (detail.pic1 != '') {
        temp.add(ModelImage(imageDir: detail.pic1, isSelected: true));

        if (detail.pic2 != '') {
          temp.add(ModelImage(imageDir: detail.pic2));
        }
        if (detail.pic3 != '') {
          temp.add(ModelImage(imageDir: detail.pic3));
        }
        if (detail.pic4 != '') {
          temp.add(ModelImage(imageDir: detail.pic4));
        }
        if (detail.pic5 != '') {
          temp.add(ModelImage(imageDir: detail.pic5));
        }
      } else {
        // do nothing if the first photo is not available
      }

      imageList.add(temp);
    }

    return ModelDetailsProcessing(
      routeDetails: activityRouteDetailsList,
      images: imageList,
    );
  }

  int selectedImage = 0;

  int get getSelectedImage => selectedImage;

  void setSelectImage(int onPageChangeIndex, int onImageChangeIindex) {
    selectedImage = onImageChangeIindex;
    imageList[onPageChangeIndex][selectedImage].isSelected = true;
    for (int i = 0; i < imageList[onPageChangeIndex].length; i++) {
      if (i != onImageChangeIindex) {
        imageList[onPageChangeIndex][i].isSelected = false;
      }
    }
    notifyListeners();
  }

  void resetSelectImage() {
    selectedImage = 0;
    notifyListeners();
  }

  int isActive = 0;

  int get getIsActive => isActive;

  void resetIsActive() {
    isActive = 0;
  }

  void onCarouselChanged(int index) {
    isActive = index;
  }

  void openImageView(BuildContext context, String imageDir) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageView(imageDir),
      ),
    );
  }

  // ================================================================
  // ========================= Attendances ==========================
  // ================================================================
  // Event
  TextEditingController eventTextController = TextEditingController();
  TextEditingController get getEventTextController => eventTextController;

  String eventPhoto = '';
  String get getEventPhoto => eventPhoto;

  void setEventPhoto(String value) {
    eventPhoto = value;
    notifyListeners();
  }

  Future<String> eventCheckIn(SipSalesState state) async {
    print('Event Check In');
    try {
      Position coordinate = await Geolocator.getCurrentPosition();

      if (getEventPhoto.isEmpty || getEventTextController.text.isEmpty) {
        displayDescription = 'Mohon periksa input anda lagi.';
        print(displayDescription);
        return 'warn';
      } else {
        List<ModelResultMessage> res = [];
        res.addAll(await GlobalAPI.fetchModifyEventAttendance(
          '1',
          GlobalVar.nip!,
          state.getUserAccountList[0].branch,
          state.getUserAccountList[0].shop,
          DateTime.now().toString().split(' ')[0],
          DateTime.now().toString().split(' ')[1].replaceAll(RegExp(r':'), '.'),
          coordinate.latitude,
          coordinate.longitude,
          getEventTextController.text,
          getEventPhoto,
        ));

        // ~:Check In List is not empty:~
        if (res.isNotEmpty) {
          print('Check In Event: ${res[0].resultMessage}');
          // ~:Check Out Success:~
          if (res[0].resultMessage == 'SUKSES') {
            absentHistoryList.clear();
            absentHistoryList.addAll(
              await GlobalAPI.fetchAttendanceHistory(GlobalVar.nip!, '', ''),
            );
            notifyListeners();

            displayDescription = 'Clock In Event berhasil.';
            print('Success: $displayDescription');
            return 'success';
          }
          // ~:Check In Failed:~
          else {
            displayDescription = res[0].resultMessage;
            print('Warning: $displayDescription');
            return 'warn';
          }
        }
        // ~:Check In List is empty:~
        else {
          print('Event Check In is empty');
          displayDescription = 'Clock In gagal.';
          print('Failed: $displayDescription');
          return 'failed';
        }
      }
    } catch (e) {
      displayDescription = '${e.toString()}.';
      print('Failed: $displayDescription');
      return 'failed';
    }
  }

  // Location
  List<ModelCoordinate> coordinateList = [];
  Location location = Location();
  bool locationPermission = false;
  bool isLocationEnable = false;
  // Note -> database usage
  double? longitude = 0;
  double? latitude = 0;
  // Note -> display usage
  double lngDisplay = 0.0;
  double latDisplay = 0.0;
  String time = '';
  // bool attendanceStatus = false;
  // bool get getAttendanceStatus => attendanceStatus

  // Delete -> remove later, bcs these features already checked in the API
  // bool checkInStatus = true;
  // bool get getCheckInStatus => checkInStatus;
  //
  // Future<bool> fetchCheckInStatus() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool('checkInStatus') ?? false;
  // }
  //
  // void saveCheckInStatus(bool state) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('checkInStatus', state);
  //
  //   checkInStatus = state;
  //   notifyListeners();
  //   print('CheckInStatus: $checkInStatus');
  // }
  //
  // bool checkOutStatus = false;
  // bool get getCheckOutStatus => checkOutStatus;
  //
  // Future<bool> fetchCheckOutStatus() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool('checkOutStatus') ?? false;
  // }
  //
  // void saveCheckOutStatus(bool state) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('checkOutStatus', state);
  //
  //   checkOutStatus = state;
  //   notifyListeners();
  // }

  bool isWithinRadius = false;

  // Checked In
  List<ModelResultMessage> checkInList = [];
  // bool isCheckedIn = false;

  // Checked Out
  List<ModelResultMessage> checkOutList = [];
  List<ModelResultMessage2> activityTimestampList = [];

  List<ModelCoordinate> get fetchCoordinateList => coordinateList;

  double get getLngDisplay => lngDisplay;
  double get getLatDisplay => latDisplay;

  void setLngDisplay(double value) {
    lngDisplay = value;
    notifyListeners();
  }

  void setLatDisplay(double value) {
    latDisplay = value;
    notifyListeners();
  }

  // void setAttendanceStatus(bool state) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('attendanceStatus', state);
  //   notifyListeners();
  // }
  //
  // void fetchAttendanceStatus() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   attendanceStatus = prefs.getBool('attendanceStatus') ?? false;
  //   notifyListeners();
  // }
  //
  // void setIsCheckedIn(bool state) {
  //   isCheckedIn = state;
  // }

  static Future<void> writeListToCache(
      String key, List<ModelCoordinate> data) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData =
        jsonEncode(data.map((coordinate) => coordinate.toJson()).toList());
    await prefs.setString(key, encodedData);
  }

  static Future<List<ModelCoordinate>> readListFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final decodedData = jsonDecode(prefs.getString(key)!);
    await prefs.remove(key);
    if (decodedData != null) {
      return decodedData
          .map<ModelCoordinate>((list) => ModelCoordinate.fromJson(list))
          .toList();
    } else {
      return [];
    }
  }

  void addCoordinateList(ModelCoordinate data) async {
    coordinateList.add(
      ModelCoordinate(
        longitude: data.longitude,
        latitude: data.latitude,
        time: data.time,
      ),
    );

    await writeListToCache('cached_coordinates', coordinateList);
  }

  void setCoordinateList(double? lat, double? lng) {
    latitude = lat;
    longitude = lng;
    time = DateTime.now().toString().split(' ')[1];
  }

  void openMap(BuildContext context) async {
    print('Open Map function');
    try {
      await Geolocator.getCurrentPosition().then((coordinate) {
        print('get user coordinate');
        print('Latitude: ${coordinate.latitude}');
        print('Longitude: ${coordinate.longitude}');
        setLngDisplay(coordinate.longitude);
        setLatDisplay(coordinate.latitude);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void backToLocation(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/location');
  }

  // Note --> Haversine Formula, calculate distance between 2 coordinates
  // Function -> Convert Longitude and Latitude coordinate, from degree to radians
  // double radiansConverter(double degrees) => degrees * math.pi / 180;
  //
  // Function -> Check 2nd coordinate is within 1st coordinate radius
  // bool getIsWithinRadius(double lat1, double lon1, double lat2, double lon2,
  //     double radiusInMeters) {
  //   // Function -> Convert coordinates to radians
  //   double radiansLat1 = radiansConverter(lat1);
  //   double radiansLon1 = radiansConverter(lon1);
  //   double radiansLat2 = radiansConverter(lat2);
  //   double radiansLon2 = radiansConverter(lon2);
  //
  //   // Function -> Earth's radius (in meters)
  //   const double earthRadius = 6371e3;
  //
  //   // Function -> Calculate the difference in latitude and longitude
  //   double dLat = radiansLat2 - radiansLat1;
  //   double dLon = radiansLon2 - radiansLon1;
  //
  //   // Function -> Haversine formula for distance calculation
  //   double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
  //       math.cos(radiansLat1) *
  //           math.cos(radiansLat2) *
  //           math.sin(dLon / 2) *
  //           math.sin(dLon / 2);
  //   double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  //
  //   // Function -> Calculate distance in meters
  //   double distance = earthRadius * c;
  //
  //   // Function -> Check if distance is less than or equal to radius
  //   return distance <= radiusInMeters;
  // }

  // Note --> Live-tracking not used for a while
  // void trackUserLocation(BuildContext context) async {
  //   while (isCheckedIn) {
  //     if (onProgress) {
  //       if (await location.serviceEnabled()) {
  //         await Future.delayed(const Duration(seconds: 5)).then(
  //           (_) async {
  //             // background_location library
  //             await background_location.BackgroundLocation.getLocationUpdates(
  //                 (location) {
  //               setCoordinateList(
  //                 location.latitude,
  //                 location.longitude,
  //               );
  //             });
  //
  //             addCoordinateList(ModelCoordinate(
  //               longitude: longitude!,
  //               latitude: latitude!,
  //               time: time,
  //             ));
  //           },
  //         );
  //       } else {
  //         setIsCheckedIn(false);
  //         // Function -> declare 'attendanceStatus' value to true and user have access to 'Check In' safely
  //         final SharedPreferences prefs = await SharedPreferences.getInstance();
  //         prefs.setBool('attendanceStatus', false);
  //         attendanceStatus = prefs.getBool('attendanceStatus')!;
  //
  //         GlobalFunction.tampilkanDialog(
  //           context,
  //           false,
  //           KotakPesan(
  //             'Peringatan!',
  //             'Layanan lokasi dinonaktifkan.',
  //             detail2: 'Silakan aktifkan untuk fitur yang lebih advanced.',
  //             function: () => backToLocation(context),
  //           ),
  //         );
  //       }
  //     }
  //   }
  // }

  Future<bool> checkMockGPS() async {
    if (Platform.isAndroid) {
      print('Android device');
      Position position = await Geolocator.getCurrentPosition();

      if (position.isMocked) {
        print("Fake GPS detected!");
        return true;
        // Show an alert or restrict functionality
      } else {
        print("Real GPS location.");
        return false;
      }
    } else {
      print('iOS device');
      return false;
    }
  }

  Future<bool> checkDeviceIntegrity() async {
    // bool isJailBroken = false;
    bool isJailBroken = await JailbreakRootDetection.instance.isJailBroken;
    // Android only
    bool isDeveloperMode = false;
    // if (Platform.isAndroid) {
    //   isDeveloperMode = await JailbreakRootDetection.instance.isDevMode;
    // }

    print('isJailbroken: $isJailBroken, isDeveloperMode: $isDeveloperMode');
    if (isJailBroken || isDeveloperMode) {
      print("Device integrity compromised: Jailbroken.");
      // Handle compromised device (e.g., restrict functionality or show alert)
      return true;
    } else {
      print("Device integrity is intact.");
      return false;
    }
    // return false;
  }

  Future<bool> checkDeviceModification() async {
    bool isMocked = await checkMockGPS();
    bool isCompromised = await checkDeviceIntegrity();
    print('isMocked: $isMocked, isCompromised: $isCompromised');

    if (isMocked && isCompromised) {
      displayDescription =
          'Perangkat anda terdeteksi menggunakan Fake GPS & Jailbreak.';
      print('Perangkat anda terdeteksi menggunakan Fake GPS & Jailbreak.');
      return true;
    } else if (isMocked) {
      displayDescription = 'Perangkat anda terdeteksi menggunakan Fake GPS.';
      print('Perangkat anda terdeteksi menggunakan Fake GPS.');
      return true;
    } else if (isCompromised) {
      displayDescription = 'Perangkat anda terdeteksi Jailbreak.';
      print('Perangkat anda terdeteksi Jailbroken.');
      return true;
    } else {
      return false;
    }
  }

  // Function -> run 'Check In' button
  Future<String> checkIn(
    BuildContext context,
    SipSalesState state,
  ) async {
    // ~:Profile Picture is uploaded:~
    if (profilePicturePreview.isNotEmpty) {
      debugPrint('Profile Picture is uploaded');
      // ~:Location Service activated:~
      if (await Geolocator.isLocationServiceEnabled()) {
        debugPrint('Location Service is activated');
        // ~:Mock Location & Device Integrity Detection:~
        bool isDeviceModified = await checkDeviceModification();

        if (isDeviceModified) {
          await GlobalAPI.fetchInsertViolation(
            state.getUserAccountList[0].employeeID,
            'FAKE GPS',
          ).then((value) {
            if (value[0].resultMessage == 'SUKSES') {
              print('Insert Violation succeed');
            } else {
              print('Insert Violation failed');
            }
          });

          print('Device Modification detected');
          return 'warn';
        } else {
          print('Device Modification passed');
          // ~:Check if User within branch radius or not:~
          try {
            await Geolocator.getCurrentPosition().then((coordinate) async {
              await GlobalAPI.fetchIsWithinRadius(
                state.getUserAccountList[0].latitude,
                state.getUserAccountList[0].longitude,
                coordinate.latitude,
                coordinate.longitude,
              ).then((status) {
                // ~:User is not within branch radius:~
                if (status == 'NOT OK') {
                  isWithinRadius = false;
                }
                // ~:User is within branch radius:~
                else {
                  isWithinRadius = true;
                }
                // print('IsWithinRadius: $isWithinRadius');
              });
            });
          } catch (e) {
            print('Error: $e');
          }

          // ~:User is not within branch radius:~
          if (!isWithinRadius) {
            debugPrint('User is not within branch radius');
            displayDescription = 'Lokasi Tidak Valid';
            return 'warn';
          }
          // ~:User is within branch radius:~
          else {
            debugPrint('User is within branch radius');
            // ~:Check In Process via API:~
            checkInList.clear();
            await Geolocator.getCurrentPosition().then((coordinate) async {
              checkInList.addAll(await GlobalAPI.fetchModifyAttendance(
                '1',
                GlobalVar.nip!,
                state.getUserAccountList[0].branch,
                state.getUserAccountList[0].shop,
                state.getUserAccountList[0].locationID,
                DateTime.now().toString().split(' ')[0],
                DateTime.now()
                    .toString()
                    .split(' ')[1]
                    .replaceAll(RegExp(r':'), '.'),
                '',
                coordinate.latitude,
                coordinate.longitude,
              ));
            });

            // ~:Check In List is not empty:~
            if (checkInList.isNotEmpty) {
              debugPrint('Check In List is not empty');
              // ~:Check In Success:~
              if (checkInList[0].resultMessage == 'SUKSES') {
                absentHistoryList.clear();
                absentHistoryList.addAll(
                  await GlobalAPI.fetchAttendanceHistory(
                      GlobalVar.nip!, '', ''),
                );
                notifyListeners();

                debugPrint('Check In Success');
                displayDescription = 'Clock In berhasil';
                return 'success';
              }
              // ~:Check In Failed:~
              else {
                debugPrint('Check In Failed');
                displayDescription = checkInList[0].resultMessage;
                return 'warn';
              }
            }
            // ~:Check In List is empty:~
            else {
              debugPrint('Check In List is empty');
              displayDescription = 'Clock In gagal';
              return 'failed';
            }
          }
        }
      }
      // ~:Location Service deactivated:~
      else {
        debugPrint('Location Service is deactivated');
        displayDescription = 'Mohon aktifkan layanan lokasi.';
        return 'warn';
      }
    }
    // ~:Profile Picture is not uploaded yet:~
    else {
      debugPrint('Profile Picture is not uploaded yet');
      displayDescription = 'Mohon upload foto profil terlebih dahulu.';
      return 'warn';
    }
  }

  // Function -> run 'Check Out' button
  Future<String> checkOut(
    BuildContext context,
    SipSalesState state,
  ) async {
    // ~:Profile Picture is uploaded:~
    if (profilePicturePreview.isNotEmpty) {
      // ~:Location Service activated:~
      if (await Geolocator.isLocationServiceEnabled()) {
        // ~:Check if User within branch radius or not:~
        await Geolocator.getCurrentPosition().then((coordinate) async {
          await GlobalAPI.fetchIsWithinRadius(
            state.getUserAccountList[0].latitude,
            state.getUserAccountList[0].longitude,
            coordinate.latitude,
            coordinate.longitude,
          ).then((status) {
            // ~:User is not within branch radius:~
            if (status == 'NOT OK') {
              isWithinRadius = false;
            }
            // ~:User is within branch radius:~
            else {
              isWithinRadius = true;
            }
            // print('IsWithinRadius: $isWithinRadius');
          });
        });

        // ~:User is not within branch radius:~
        if (!isWithinRadius) {
          displayDescription = 'Lokasi Tidak Valid.';
          return 'warn';
        }
        // ~:User is within branch radius:~
        else {
          // ~:Check Out Process via API:~
          checkOutList.clear();
          await Geolocator.getCurrentPosition().then((coordinate) async {
            checkOutList.addAll(await GlobalAPI.fetchModifyAttendance(
              '2',
              GlobalVar.nip!,
              state.getUserAccountList[0].branch,
              state.getUserAccountList[0].shop,
              state.getUserAccountList[0].locationID,
              DateTime.now().toString().split(' ')[0],
              '',
              DateTime.now()
                  .toString()
                  .split(' ')[1]
                  .replaceAll(RegExp(r':'), '.'),
              coordinate.latitude, // Lat
              coordinate.longitude, // Lng
            ));
          });

          // ~:Check Out List is not empty:~
          if (checkOutList.isNotEmpty) {
            print('Check Out: ${checkOutList[0].resultMessage}');
            // ~:Check Out Success:~
            if (checkOutList[0].resultMessage == 'SUKSES') {
              displayDescription = 'Clock Out berhasil.';
              return 'success';
            }
            // ~:Check Out Failed:~
            else {
              displayDescription = checkOutList[0].resultMessage;
              return 'warn';
            }
          }
          // ~:Check Out List is empty:~
          else {
            print('Check Out is empty');
            displayDescription = 'Clock Out gagal.';
            return 'failed';
          }
        }
      }
      // ~:Location Service deactivated:~
      else {
        displayDescription = 'Mohon aktifkan layanan lokasi.';
        return 'warn';
      }
    }
    // ~:Profile Picture is not uploaded yet:~
    else {
      displayDescription = 'Mohon upload foto profil terlebih dahulu.';
      return 'warn';
    }
  }

  // ============================================================
  // ===================== New Activities =======================
  // ============================================================
  ModelNewActivityDetails newActivity = ModelNewActivityDetails(
    activities: [],
    image: [],
  );

  List<ModelActivities> salesActivityTypeList = [];

  List<ModelActivities> get fetchsalesActivityTypeList => salesActivityTypeList;

  List<ModelActivities> managerActivityTypeList = [];

  List<ModelActivities> get getManagerActivityTypeList =>
      managerActivityTypeList;

  List<XFile?> pickedFileList = [];
  List<Uint8List> imageBytesList = [];
  List<images.Image> imgList = [];
  List<String> base64ImageList = [];
  List<String> filteredList = [];
  List<String> get getFilteredList => filteredList;

  List<ModelResultMessage2> newActivitiesList = [];

  List<ModelResultMessage2> get fetchNewActivitiesList => newActivitiesList;

  String eId = ''; // Employee ID
  String branchId = '';
  String shopId = '';
  String aId = ''; // Activity ID

  List<ModelActivities> get fetchSalesActivityTypes => salesActivityTypeList;

  List<String> get fetchFilteredList => filteredList;

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueNotifier<bool> isDisable = ValueNotifier(false);

  ValueNotifier<bool> isUploadingNotifier = ValueNotifier(false);

  ValueNotifier<bool> get getIsUploadingNotifier => isUploadingNotifier;

  ValueNotifier<String> salesListener = ValueNotifier('PROSPEK');

  ValueNotifier<String> managerListener = ValueNotifier('MORNING BRIEFING');

  String descriptionCache = '';

  String get fetchDescriptionCache => descriptionCache;

  void setDescriptionCache(String value) {
    descriptionCache = value;
  }

  void clearState() {
    pickedFileList.clear();
    imageBytesList.clear();
    imgList.clear();
    base64ImageList.clear();
    filteredList.clear();
    salesListener = ValueNotifier('PROSPEK');
    managerListener = ValueNotifier('MORNING BRIEFING');
    isDisable = ValueNotifier(true);
  }

  void setTypeListener(String value, bool isManager) async {
    if (isManager) {
      managerListener.value = value;
    } else {
      salesListener.value = value;
    }
    notifyListeners();
  }

  Future<ModelNewActivityDetails> fetchSalesActivityData() async {
    salesActivityTypeList.clear();
    salesActivityTypeList.addAll(await GlobalAPI.fetchSalesActivityTypes());

    return newActivity;
  }

  Future<List<ModelActivities>> fetchManagerActivityData() async {
    managerActivityTypeList.clear();
    managerActivityTypeList.addAll(await GlobalAPI.fetchManagerActivityTypes());

    print(
        'Manager Activity Type List length: ${managerActivityTypeList.length}');
    // for (var data in managerActivityTypeList) {
    //   print(data.activityName);
    // }

    for (var data in managerActivityTypeList) {
      if (data.activityName == 'DAILY REPORT') {
        data.activityTemplate = '';
        break;
      }
    }

    return managerActivityTypeList;
  }

  Future<bool> uploadImageFromGallery(BuildContext context) async {
    setIsUploadingNotifier(true);
    setIsDisable(true);

    pickedFileList.clear();
    imageBytesList.clear();
    imgList.clear();
    base64ImageList.clear();

    pickedFileList.add(await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxHeight: 1000,
      maxWidth: 1000,
    ));

    // Check if image was picked
    if (pickedFileList.isEmpty) {
      // do something
    } else {
      // Read image bytes
      for (var file in pickedFileList) {
        if (file != null) {
          imageBytesList.add(await file.readAsBytes());
        } else {
          break;
        }
      }

      // Resize image (optional)
      imgList.addAll(
          imageBytesList.map((imageByte) => images.decodeImage(imageByte)!));

      // Encode image to base64
      base64ImageList.addAll(
          imgList.map((image) => base64Encode(images.encodePng(image))));

      filteredList.clear();
      if (base64ImageList.length > 5) {
        filteredList.addAll(base64ImageList.take(5));
      } else {
        filteredList.addAll(base64ImageList);
      }
    }

    notifyListeners();
    setIsUploadingNotifier(false);

    if (filteredList.isNotEmpty) {
      setIsDisable(false);
      return true;
    }
    return false;
  }

  // Format File Size
  static String getFileSizeString(int bytes, {int decimals = 0}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  Future<bool> uploadImageFromCamera(BuildContext context) async {
    setIsUploadingNotifier(true);
    setIsDisable(true);

    pickedFileList.clear();
    imageBytesList.clear();
    imgList.clear();
    base64ImageList.clear();

    // Note -> Displaying Image Size
    // pickedFileList.add(await ImagePicker()
    //     .pickImage(
    //   source: ImageSource.camera,
    //   imageQuality: 70,
    // )
    //     .then((image) {
    //   File imageFile = File('');
    //   if (image != null) {
    //     imageFile = File(image.path);
    //     print('Image Size: ${getFileSizeString((imageFile.lengthSync()))}');
    //   } else {
    //     print('No image selected.');
    //   }
    //   return image;
    // }));

    pickedFileList.add(await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    ));

    // Check if image was picked
    if (pickedFileList.isEmpty) {
      // do something
      displayDescription =
          'Izin kamera ditolak. Silakan aktifkan di pengaturan aplikasi.';
      return false;
    } else {
      // Read image bytes
      for (var file in pickedFileList) {
        if (file != null) {
          imageBytesList.add(await file.readAsBytes());
        } else {
          break;
        }
      }

      if (imageBytesList.isNotEmpty) {
        // Resize image (optional)
        imgList.addAll(
            imageBytesList.map((imageByte) => images.decodeImage(imageByte)!));

        // Encode image to base64
        base64ImageList.addAll(
            imgList.map((image) => base64Encode(images.encodePng(image))));

        filteredList.clear();
        if (base64ImageList.length > 5) {
          filteredList.addAll(base64ImageList.take(5));
        } else {
          filteredList.addAll(base64ImageList);
        }
      }
    }

    notifyListeners();
    setIsUploadingNotifier(false);

    if (filteredList.isNotEmpty) {
      setIsDisable(false);
      displayDescription = 'Foto berhasil diunggah.';
      return true;
    }
    displayDescription = 'Foto gagal diunggah.';
    return false;
  }

  void removeImage(int index) async {
    filteredList.clear();
    // notifyListeners();
  }

  void setIsLoading(bool value) {
    isLoading.value = value;
    notifyListeners();
  }

  void setIsDisable(bool value) {
    isDisable.value = value;
    notifyListeners();
  }

  void setIsUploadingNotifier(bool value) {
    isUploadingNotifier.value = value;
    notifyListeners();
  }

  void createSalesActivity(
    BuildContext context,
    String name,
    String number,
    String date,
    List<ModelActivities> activities,
    String type,
    String desc,
    // List<String> images,
  ) async {
    setIsLoading(true);

    for (var list in activities) {
      if (list.activityName == type) {
        aId = list.activityID;
        break;
      }
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    eId = prefs.getString('nip')!;

    if (type != '' && desc != '' && filteredList.isNotEmpty && date != '') {
      await location.getLocation().then((coordinate) async {
        newActivitiesList.clear();
        newActivitiesList = await GlobalAPI.fetchNewSalesActivity(
          eId,
          date,
          TimeOfDay.now().toString().substring(10, 15),
          coordinate.latitude!,
          coordinate.longitude!,
          aId,
          desc,
          name,
          number,
          filteredList,
        );

        if (newActivitiesList.isNotEmpty) {
          if (newActivitiesList[0].resultMessage == 'SUKSES') {
            setIsLoading(false);

            // Custom Alert Dialog for Android and iOS
            if (Platform.isIOS) {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Sukses!',
                'Aktivitas berhasil dimasukkan.',
                () => Navigator.pop(context),
                'Tutup',
                isIOS: true,
              );
            } else {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Sukses!',
                'Aktivitas berhasil dimasukkan.',
                () => Navigator.pop(context),
                'Tutup',
              );
            }
          } else {
            setIsLoading(false);

            // Custom Alert Dialog for Android and iOS
            if (Platform.isIOS) {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Gagal!',
                'Aktivitas gagal dimasukkan.',
                () => Navigator.pop(context),
                'Tutup',
                isIOS: true,
              );
            } else {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Oh no!',
                'Aktivitas gagal dimasukkan.',
                () => Navigator.pop(context),
                'Tutup',
              );
            }
          }
        } else {
          setIsLoading(false);

          // Custom Alert Dialog for Android and iOS
          if (Platform.isIOS) {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Peringatan!',
              newActivitiesList[0].resultMessage,
              () => Navigator.pop(context),
              'Tutup',
              isIOS: true,
            );
          } else {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Peringatan!',
              newActivitiesList[0].resultMessage,
              () => Navigator.pop(context),
              'Tutup',
            );
          }
        }
      });
    } else {
      setIsLoading(false);

      // Custom Alert Dialog for Android and iOS
      if (Platform.isIOS) {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Peringatan!',
          'Silakan periksa input Anda dan coba lagi.',
          () => Navigator.pop(context),
          'Tutup',
          isIOS: true,
        );
      } else {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Peringatan!',
          'Silakan periksa input Anda dan coba lagi.',
          () => Navigator.pop(context),
          'Tutup',
        );
      }
    }
  }

  Future<bool> createShopManagerActivity(
    BuildContext context,
    List<ModelActivities> activities,
    String type,
    String desc,
    // List<String> images,
  ) async {
    setIsLoading(true);

    for (var list in activities) {
      if (list.activityName == type) {
        aId = list.activityID;
        break;
      }
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    eId = prefs.getString('nip')!;
    branchId = prefs.getString('branch')!;
    shopId = prefs.getString('shop')!;

    print('Employee ID: $eId');
    print('Branch ID: $branchId');
    print('Shop ID: $shopId');
    if (filteredList.isNotEmpty) {
      print('Image List is not empty');
    } else {
      print('Image List is empty');
    }

    bool isSuccess = false;
    if (type != '' && desc != '' && filteredList.isNotEmpty) {
      print('User Input is not empty');
      try {
        await location.getLocation().then(
          (coordinate) async {
            print('Employee Id: $eId');
            print('Date: ${DateTime.now().toString().split(' ')[0]}');
            print('Time: ${DateFormat('HH:mm').format(DateTime.now())}');
            print('branch: $branchId');
            print('shop: $shopId');
            print('Current lat: ${coordinate.latitude}');
            print('Current lng: ${coordinate.longitude}');
            print('Activity Id: $aId');
            print('Desc: $desc');
            print('${filteredList.length}');
            newActivitiesList.clear();
            try {
              newActivitiesList.addAll(await GlobalAPI.fetchNewManagerActivity(
                eId,
                DateTime.now().toString().split(' ')[0],
                DateFormat('HH:mm').format(DateTime.now()),
                branchId,
                shopId,
                coordinate.latitude!,
                coordinate.longitude!,
                aId,
                desc,
                filteredList,
              ));
            } catch (e) {
              print('Error: $e');
            }

            // setIsLoading(false);
            if (newActivitiesList.isNotEmpty) {
              print('New Activities List is not empty');
            } else {
              print(
                  'New Activities List: ${newActivitiesList[0].resultMessage}');
            }

            if (newActivitiesList.isNotEmpty) {
              if (newActivitiesList[0].resultMessage == 'SUKSES') {
                print('Activity created successfully');
                setIsLoading(false);

                if (Platform.isIOS) {
                  await GlobalDialog.showCrossPlatformDialog(
                    context,
                    'Sukses!',
                    'Aktivitas berhasil dibuat.',
                    () => Navigator.pop(context),
                    'Tutup',
                    isIOS: true,
                  );
                } else {
                  await GlobalDialog.showCrossPlatformDialog(
                    context,
                    'Sukses!',
                    'Aktivitas berhasil dibuat.',
                    () => Navigator.pop(context),
                    'Tutup',
                  );
                }

                isSuccess = true;
              } else {
                print('Activity failed to create');
                setIsLoading(false);

                if (Platform.isIOS) {
                  await GlobalDialog.showCrossPlatformDialog(
                    context,
                    'Gagal!',
                    'Aktivitas gagal dibuat.',
                    () => Navigator.pop(context),
                    'Tutup',
                    isIOS: true,
                  );
                } else {
                  await GlobalDialog.showCrossPlatformDialog(
                    context,
                    'Gagal!',
                    'Aktivitas gagal dibuat.',
                    () => Navigator.pop(context),
                    'Tutup',
                  );
                }

                isSuccess = false;
              }
            } else {
              print(newActivitiesList[0].resultMessage);
              setIsLoading(false);

              if (Platform.isIOS) {
                await GlobalDialog.showCrossPlatformDialog(
                  context,
                  'Gagal!',
                  newActivitiesList[0].resultMessage,
                  () => Navigator.pop(context),
                  'Tutup',
                  isIOS: true,
                );
              } else {
                await GlobalDialog.showCrossPlatformDialog(
                  context,
                  'Gagal!',
                  newActivitiesList[0].resultMessage,
                  () => Navigator.pop(context),
                  'Tutup',
                );
              }

              isSuccess = false;
            }
          },
        );
      } catch (e) {
        print('Error: $e');
        setIsLoading(false);

        if (Platform.isIOS) {
          await GlobalDialog.showCrossPlatformDialog(
            context,
            'Gagal!',
            'Terjadi kesalahan, silakan coba lagi.',
            () => Navigator.pop(context),
            'Tutup',
            isIOS: true,
          );
        } else {
          await GlobalDialog.showCrossPlatformDialog(
            context,
            'Gagal!',
            'Terjadi kesalahan, silakan coba lagi.',
            () => Navigator.pop(context),
            'Tutup',
          );
        }

        isSuccess = false;
      }
    } else {
      print('User Input is not empty');
      setIsLoading(false);

      if (Platform.isIOS) {
        await GlobalDialog.showCrossPlatformDialog(
          context,
          'Gagal!',
          'Silakan periksa input Anda dan coba lagi.',
          () => Navigator.pop(context),
          'Tutup',
          isIOS: true,
        );
      } else {
        await GlobalDialog.showCrossPlatformDialog(
          context,
          'Gagal!',
          'Silakan periksa input Anda dan coba lagi.',
          () => Navigator.pop(context),
          'Tutup',
        );
      }

      isSuccess = false;
    }

    print('isSuccess: $isSuccess');
    return isSuccess;
  }

  // ============================================================
  // ===================== User Permission ======================
  // ============================================================
  int isManager = 0;

  int get getIsManager => isManager;

  void setIsManager(int? value) {
    isManager = value!;
  }

  bool isLocationGranted = false;

  bool get getIsLocationGranted => isLocationGranted;

  void setIsLocationGranted(bool value) {
    isLocationGranted = value;
  }

  // =============================================================
  // =================== Salesman Activities =====================
  // =============================================================
  List<ModelSalesActivities> salesActivitiesList = [];

  List<ModelSalesActivities> get fetchSalesActivitiesList =>
      salesActivitiesList;

  Stream<List<ModelSalesActivities>> fetchSalesActivities(
    String date,
  ) async* {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    eId = prefs.getString('nip')!;

    salesActivitiesList.clear();
    salesActivitiesList = await GlobalAPI.fetchSalesActivity(
      eId,
      date,
    );

    yield salesActivitiesList;
  }

  // =============================================================
  // =================== Manager Activities =====================
  // =============================================================
  List<ModelManagerActivities> managerActivitiesList = [];

  List<ModelManagerActivities> get getManagerActivitiesList =>
      managerActivitiesList;

  Future<List<ModelManagerActivities>> fetchManagerActivities(
    String date,
  ) async {
    if (date == '') {
      date = DateTime.now().toString().split(' ')[0];
    }
    // print('Manager Activities Date: $date');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    eId = prefs.getString('nip')!;

    managerActivitiesList.clear();
    managerActivitiesList.addAll(await GlobalAPI.fetchManagerActivity(
      eId,
      date,
    ));

    print('Manager Activities List length: ${managerActivitiesList.length}');

    return managerActivitiesList;
  }

  ModelManagerActivityDetails managerActivityDetailsList =
      ModelManagerActivityDetails(
    time: '',
    lat: 0,
    lng: 0,
    actId: '',
    actDesc: '',
    pic1: '',
  );

  ModelManagerActivityDetails get getManagerActivityDetailsList =>
      managerActivityDetailsList;

  Future<ModelManagerActivityDetails> fetchManagerActivityDetails(
    String date,
    String actId,
  ) async {
    if (date == '') {
      date = DateTime.now().toString().split(' ')[0];
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    eId = prefs.getString('nip')!;

    // print('State Management');
    // print('Employee ID: $eId');
    // print('Date: $date');
    // print('Activity ID: $actId');

    managerActivityDetailsList = ModelManagerActivityDetails(
      time: '',
      lat: 0,
      lng: 0,
      actId: '',
      actDesc: '',
      pic1: '',
    );

    await GlobalAPI.fetchManagerActivityDetails(
      eId,
      date,
      actId,
    ).then((value) {
      managerActivityDetailsList = value[0];
    });

    // print(managerActivityDetailsList.length);

    return managerActivityDetailsList;
  }

  // =============================================================
  // =================== App Rule Agreement ======================
  // =============================================================
  bool isUserAgree = false;

  bool get getIsUserAgree => isUserAgree;

  void setIsUserAgree(bool value) {
    isUserAgree = value;
  }
}
