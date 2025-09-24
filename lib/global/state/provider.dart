// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:developer';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as images;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
// import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/dialog.dart';
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
    log('isLoadingProgress: $isLoadingProgress');
  }

  // =================================================================
  // ===================== Login Configuration =======================
  // =================================================================
  Future<void> getUserAttendanceHistory({
    String startDate = '',
    String endDate = '',
  }) async {
    try {
      List<ModelAttendanceHistory> temp = [];
      temp.clear();
      temp.addAll(await GlobalAPI.fetchAttendanceHistory(
        await readAndWriteUserId(),
        startDate,
        endDate,
      ));

      log('Absent History list length: ${temp.length}');

      absentHistoryList = temp;
      notifyListeners();
    } catch (e) {
      log('Fetch Attendance History failed: ${e.toString()}');
    }
  }

  Future<void> getSalesDashboard() async {
    log('Get Sales Dashboard');
    try {
      log('Employee ID: ${getUserAccountList[0].employeeID}');
      log('Branch: ${getUserAccountList[0].branch}');
      log('Shop: ${getUserAccountList[0].shop}');
      await GlobalAPI.fetchSalesDashboard(
        getUserAccountList[0].employeeID,
        getUserAccountList[0].branch,
        getUserAccountList[0].shop,
      ).then((res) {
        log('Absent history: ${res.length}');
        setSalesDashboardList(res);
      });
    } catch (e) {
      log('Error: ${e.toString()}');
    }
  }

  bool isAccLocked = false;
  bool get getIsAccLocked => isAccLocked;

  void setIsAccLocked(bool value) {
    isAccLocked = value;
    notifyListeners();
  }

  List<ModelUser> userAccountList = [];
  List<ModelUser> get getUserAccountList => userAccountList;

  void setUserAccountList(List<ModelUser> value) {
    userAccountList = value;
    notifyListeners();
  }

  String employeeId = '';
  String get getEmployeeId => employeeId;

  void setEmployeeId(String value) {
    employeeId = value;
    notifyListeners();
  }

  String deviceConfiguration = '';
  String get getDeviceConfiguration => deviceConfiguration;

  void setDeviceConfiguration(String value) {
    deviceConfiguration = value;
    notifyListeners();
  }

  Future<String> readAndWriteDeviceConfig() async {
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

        // Notify listeners as the state changed
        notifyListeners();
      } else {
        // Use the existing ID
        deviceConfiguration = deviceConfig;
        log("Device Configuration: $deviceConfiguration");
      }
    } catch (e) {
      log('Error retrieving device info: $e');
      deviceConfiguration = 'error';
      notifyListeners();
    }

    return deviceConfiguration;
  }

  Future<String> readAndWriteUserId({
    String id = '',
    bool isLogin = false,
  }) async {
    try {
      // Read the existing ID only once
      String? existingId = await storage.read(key: 'employeeId');

      if (existingId == null || existingId.isEmpty || isLogin) {
        // Generate a new ID if none exists
        employeeId = id;
        await storage.write(key: 'employeeId', value: id);

        // Log the action for debugging
        log("Employee Id: $employeeId");

        // Notify listeners as the state changed
        notifyListeners();
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

      // Notify listeners as the state changed
      notifyListeners();
    }

    return employeeId;
  }

  String password = '';
  String get getPassword => password;

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<String> readAndWriteUserPass({
    String pass = '',
    bool isLogin = false,
  }) async {
    try {
      // Read the existing Password only once
      String? existingPass = await storage.read(key: 'pass');

      if (existingPass == null || existingPass.isEmpty || isLogin) {
        // Generate a new Password if none exists
        password = pass;
        await storage.write(key: 'pass', value: pass);

        // Log the action for debugging
        log("Input and saved Password: $password");

        // Notify listeners as the state changed
        notifyListeners();
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

      // Notify listeners as the state changed
      notifyListeners();
    }

    return password;
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

  void setUUID(String value) {
    uuid = value;
    notifyListeners();
  }

  Future<String> generateUuid() async {
    try {
      // Read the existing UUID only once
      String? existingUuid = await storage.read(key: 'uuid');

      if (existingUuid == null || existingUuid.isEmpty) {
        // Generate a new UUID if none exists
        uuid = Uuid().v4();
        await storage.write(key: 'uuid', value: uuid);

        // Log the action for debugging
        log("Generated and saved new UUID: $uuid");

        // Notify listeners as the state changed
        notifyListeners();
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
        log('Unbind Request: ${unbindRequestList[0].resultMessage}');
        if (unbindRequestList[0].resultMessage.split(':')[0] == 'https') {
          // if (unbindRequestList[0].resultMessage == 'SUKSES') {
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

  List<ModelResultMessage2> employeeIdRequestList = [];
  List<ModelResultMessage2> get getEmployeeIdRequest => employeeIdRequestList;

  Future<String> employeeIdRequestProcess(String phoneNumber) async {
    try {
      employeeIdRequestList.clear();
      employeeIdRequestList.addAll(
        await GlobalAPI.fetchReqEmployeeId(phoneNumber),
      );

      if (employeeIdRequestList.isNotEmpty) {
        log('Unbind Request: ${employeeIdRequestList[0].resultMessage}');
        if (employeeIdRequestList[0].resultMessage == 'https: ') {
          displayDescription =
              'Permintaan NIP berhasil dikirim. Mohon cek Whatsapp secara berkala.';
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
      return 'error';
    }
  }

  List<ModelResultMessage2> passwordResetList = [];
  List<ModelResultMessage2> get getPasswordReset => passwordResetList;

  Future<String> passwordResetProcess(String id) async {
    try {
      passwordResetList.clear();
      passwordResetList.addAll(await GlobalAPI.fetchResetPassword(id));

      if (passwordResetList.isNotEmpty) {
        log('Unbind Request: ${passwordResetList[0].resultMessage}');
        if (passwordResetList[0].resultMessage == 'https: ') {
          displayDescription =
              'Permintaan reset berhasil dikirim. Mohon cek Whatsapp secara berkala untuk mendapatkan link reset.';
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
      return 'error';
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
        log('Picked image is empty');
      } else {
        log('Read picked image as bytes');
        // Read image bytes
        if (pickedPpList.isNotEmpty) {
          ppBytesList.add(await pickedPpList[0]!.readAsBytes());
        } else {
          return false;
        }

        if (ppBytesList.isNotEmpty) {
          log('Profile picture is not empty');
          ppList.addAll(
              ppBytesList.map((imageByte) => images.decodeImage(imageByte)!));

          // Encode image to base64
          log('Encode image to base64');
          base64PpList.addAll(
              ppList.map((image) => base64Encode(images.encodePng(image))));
          log('Base 64 Image: ${base64PpList.length}');
        }
      }

      notifyListeners();

      if (base64PpList.isNotEmpty) {
        log('Image available');
        return true;
      }
      log('Image not available');
      return false;
    } catch (e) {
      log('Error taking profile picture: $e');
      return false;
    }
  }

  List<ModelResultMessage> uploadProfileState = [];
  List<ModelResultMessage> get getUploadProfileState => uploadProfileState;

  Future<String> uploadProfilePicture(BuildContext context) async {
    uploadProfileState.clear();
    uploadProfileState.addAll(await GlobalAPI.fetchUploadImage(
      getUserAccountList[0].employeeID,
      getBase64PpList[0],
    ));

    if (uploadProfileState.isNotEmpty) {
      log('result message: ${uploadProfileState[0].resultMessage}');
      if (uploadProfileState[0].resultMessage == 'SUKSES') {
        await GlobalAPI.fetchUserAccount(
          await readAndWriteUserId(),
          await readAndWriteUserPass(),
          await generateUuid(),
          await readAndWriteDeviceConfig(),
        ).then((user) async {
          setProfilePicturePreview(user[0].profilePicture);
          try {
            await GlobalAPI.fetchShowImage(user[0].employeeID).then(
              (String highResImg) async {
                if (highResImg == 'not available') {
                  setProfilePicture(highResImg);
                  log('High Res Image is not available.');
                } else if (highResImg == 'failed') {
                  setProfilePicture(highResImg);
                  log('High Res Image failed to load.');
                } else if (highResImg == 'error') {
                  setProfilePicture(highResImg);
                  log('An error occured, please try again.');
                } else {
                  setProfilePicture(highResImg);
                  log('High Res Image successfully loaded.');
                  log('High Res Image: $highResImg');
                }
              },
            );
          } catch (e) {
            log('Show HD Image Error: $e');
          }
        });

        displayDescription = 'Foto profil berhasil diunggah.';

        return 'success';
      } else {
        displayDescription = 'Foto profil gagal diunggah.';

        return 'failed';
      }
    } else {
      log('Profile image is empty');
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
      log('Error: ${e.toString()}');
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
  // String employeeID = '';
  List<ModelActivityRoute> activityRouteList = [];
  int locationIndex = 0;

  // String get getEmployeeID => employeeID;

  List<ModelActivityRoute> get getActivityRoute => activityRouteList;

  int get getLocationIndex => locationIndex;

  void setLocationIndex(int i) {
    locationIndex = i;
    // notifyListeners();
  }

  Future<List<ModelActivityRoute>> fetchActivityRouteList(String date) async {
    activityRouteList.clear();
    activityRouteList.addAll(await GlobalAPI.fetchActivityRoute(
      await readAndWriteUserId(),
      date,
    ));

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

  Future<String> eventCheckIn() async {
    log('Event Check In');
    try {
      Position coordinate = await Geolocator.getCurrentPosition();

      if (getEventPhoto.isEmpty || getEventTextController.text.isEmpty) {
        displayDescription = 'Mohon periksa input anda lagi.';
        log(displayDescription);
        return 'warn';
      } else {
        List<ModelResultMessage> res = [];
        res.addAll(await GlobalAPI.fetchModifyEventAttendance(
          '1',
          await readAndWriteUserId(),
          getUserAccountList[0].branch,
          getUserAccountList[0].shop,
          DateTime.now().toString().split(' ')[0],
          DateTime.now().toString().split(' ')[1].replaceAll(RegExp(r':'), '.'),
          coordinate.latitude,
          coordinate.longitude,
          getEventTextController.text,
          getEventPhoto,
        ));

        // ~:Check In List is not empty:~
        if (res.isNotEmpty) {
          log('Check In Event: ${res[0].resultMessage}');
          // ~:Check Out Success:~
          if (res[0].resultMessage == 'SUKSES') {
            absentHistoryList.clear();
            absentHistoryList.addAll(
              await GlobalAPI.fetchAttendanceHistory(
                await readAndWriteUserId(),
                '',
                '',
              ),
            );
            notifyListeners();

            displayDescription = 'Clock In Event berhasil.';
            log('Success: $displayDescription');
            return 'success';
          }
          // ~:Check In Failed:~
          else {
            displayDescription = res[0].resultMessage;
            log('Warning: $displayDescription');
            return 'warn';
          }
        }
        // ~:Check In List is empty:~
        else {
          log('Event Check In is empty');
          displayDescription = 'Clock In gagal.';
          log('Failed: $displayDescription');
          return 'failed';
        }
      }
    } catch (e) {
      displayDescription = '${e.toString()}.';
      log('Failed: $displayDescription');
      return 'failed';
    }
  }

  // Location
  List<ModelCoordinate> coordinateList = [];
  // Location location = Location();
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
  //   log('CheckInStatus: $checkInStatus');
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
    log('Open Map function');
    try {
      await Geolocator.getCurrentPosition().then((coordinate) {
        log('get user coordinate');
        log('Latitude: ${coordinate.latitude}');
        log('Longitude: ${coordinate.longitude}');
        setLngDisplay(coordinate.longitude);
        setLatDisplay(coordinate.latitude);
      });
    } catch (e) {
      log('Error: $e');
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
      log('Android device');
      Position position = await Geolocator.getCurrentPosition();

      if (position.isMocked) {
        log("Fake GPS detected!");
        return true;
        // Show an alert or restrict functionality
      } else {
        log("Real GPS location.");
        return false;
      }
    } else {
      log('iOS device');
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

    log('isJailbroken: $isJailBroken, isDeveloperMode: $isDeveloperMode');
    if (isJailBroken || isDeveloperMode) {
      log("Device integrity compromised: Jailbroken.");
      // Handle compromised device (e.g., restrict functionality or show alert)
      return true;
    } else {
      log("Device integrity is intact.");
      return false;
    }
    // return false;
  }

  Future<bool> checkDeviceModification() async {
    bool isMocked = await checkMockGPS();
    bool isCompromised = await checkDeviceIntegrity();
    log('isMocked: $isMocked, isCompromised: $isCompromised');

    if (isMocked && isCompromised) {
      displayDescription =
          'Perangkat anda terdeteksi menggunakan Fake GPS & Jailbreak.';
      log('Perangkat anda terdeteksi menggunakan Fake GPS & Jailbreak.');
      return true;
    } else if (isMocked) {
      displayDescription = 'Perangkat anda terdeteksi menggunakan Fake GPS.';
      log('Perangkat anda terdeteksi menggunakan Fake GPS.');
      return true;
    } else if (isCompromised) {
      displayDescription = 'Perangkat anda terdeteksi Jailbreak.';
      log('Perangkat anda terdeteksi Jailbroken.');
      return true;
    } else {
      return false;
    }
  }

  // Function -> run 'Check In' button
  Future<String> checkIn(
    BuildContext context,
  ) async {
    // ~:Profile Picture is uploaded:~
    if (profilePicturePreview.isNotEmpty) {
      log('Profile Picture is uploaded');
      // ~:Location Service activated:~
      if (await Geolocator.isLocationServiceEnabled()) {
        log('Location Service is activated');
        // ~:Mock Location & Device Integrity Detection:~
        bool isDeviceModified = await checkDeviceModification();

        if (isDeviceModified) {
          await GlobalAPI.fetchInsertViolation(
            getUserAccountList[0].employeeID,
            'FAKE GPS',
          ).then((value) {
            if (value[0].resultMessage == 'SUKSES') {
              log('Insert Violation succeed');
            } else {
              log('Insert Violation failed');
            }
          });

          log('Device Modification detected');
          return 'warn';
        } else {
          log('Device Modification passed');
          // ~:Check if User within branch radius or not:~
          try {
            await Geolocator.getCurrentPosition().then((coordinate) async {
              await GlobalAPI.fetchIsWithinRadius(
                getUserAccountList[0].latitude,
                getUserAccountList[0].longitude,
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
                // log('IsWithinRadius: $isWithinRadius');
              });
            });
          } catch (e) {
            log('Error: $e');
          }

          // ~:User is not within branch radius:~
          if (!isWithinRadius) {
            log('User is not within branch radius');
            displayDescription = 'Lokasi Tidak Valid';
            return 'warn';
          }
          // ~:User is within branch radius:~
          else {
            log('User is within branch radius');
            // ~:Check In Process via API:~
            checkInList.clear();
            await Geolocator.getCurrentPosition().then((coordinate) async {
              checkInList.addAll(await GlobalAPI.fetchModifyAttendance(
                '1',
                await readAndWriteUserId(),
                getUserAccountList[0].branch,
                getUserAccountList[0].shop,
                getUserAccountList[0].locationID,
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
              log('Check In List is not empty');
              // ~:Check In Success:~
              if (checkInList[0].resultMessage == 'SUKSES') {
                absentHistoryList.clear();
                absentHistoryList.addAll(
                  await GlobalAPI.fetchAttendanceHistory(
                    await readAndWriteUserId(),
                    '',
                    '',
                  ),
                );
                notifyListeners();

                log('Check In Success');
                displayDescription = 'Clock In berhasil';
                return 'success';
              }
              // ~:Check In Failed:~
              else {
                log('Check In Failed');
                displayDescription = checkInList[0].resultMessage;
                return 'warn';
              }
            }
            // ~:Check In List is empty:~
            else {
              log('Check In List is empty');
              displayDescription = 'Clock In gagal';
              return 'failed';
            }
          }
        }
      }
      // ~:Location Service deactivated:~
      else {
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever ||
            permission == LocationPermission.unableToDetermine) {
          log('Location Permission is denied or unable to determine');
          displayDescription = 'Mohon ubah layanan izin lokasi.';
          return 'warn';
        } else {
          log('Location Service is deactivated');
          displayDescription = 'Mohon aktifkan layanan lokasi.';
          return 'warn';
        }
      }
    }
    // ~:Profile Picture is not uploaded yet:~
    else {
      log('Profile Picture is not uploaded yet');
      displayDescription = 'Mohon upload foto profil terlebih dahulu.';
      return 'warn';
    }
  }

  // Function -> run 'Check Out' button
  Future<String> checkOut(
    BuildContext context,
  ) async {
    // ~:Profile Picture is uploaded:~
    if (profilePicturePreview.isNotEmpty) {
      // ~:Location Service activated:~
      if (await Geolocator.isLocationServiceEnabled()) {
        // ~:Check if User within branch radius or not:~
        await Geolocator.getCurrentPosition().then((coordinate) async {
          await GlobalAPI.fetchIsWithinRadius(
            getUserAccountList[0].latitude,
            getUserAccountList[0].longitude,
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
            // log('IsWithinRadius: $isWithinRadius');
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
              await readAndWriteUserId(),
              getUserAccountList[0].branch,
              getUserAccountList[0].shop,
              getUserAccountList[0].locationID,
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
            log('Check Out: ${checkOutList[0].resultMessage}');
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
            log('Check Out is empty');
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

  void setManagerActivityTypeList(List<ModelActivities> list) {
    managerActivityTypeList = list;
    notifyListeners();
  }

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
    setManagerActivityTypeList(await GlobalAPI.fetchManagerActivityTypes());

    log(
      'Manager Activity Type List length: ${managerActivityTypeList.length}',
    );
    // for (var data in managerActivityTypeList) {
    //   log(data.activityName);
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
    var i = (math.log(bytes) / math.log(1024)).floor();
    return ((bytes / math.pow(1024, i)).toStringAsFixed(decimals)) +
        suffixes[i];
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
    //     log('Image Size: ${getFileSizeString((imageFile.lengthSync()))}');
    //   } else {
    //     log('No image selected.');
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
      await Geolocator.getCurrentPosition().then((coordinate) async {
        newActivitiesList.clear();
        newActivitiesList = await GlobalAPI.fetchNewSalesActivity(
          eId,
          date,
          TimeOfDay.now().toString().substring(10, 15),
          coordinate.latitude,
          coordinate.longitude,
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

    if (filteredList.isNotEmpty) {
      log('Image List is not empty');
    } else {
      log('Image List is empty');
    }

    bool isSuccess = false;
    if (type != '' && desc != '' && filteredList.isNotEmpty) {
      log('User Input is not empty');
      try {
        await Geolocator.getCurrentPosition().then(
          (coordinate) async {
            // log('Employee Id: $eId');
            // log('Date: ${DateTime.now().toString().split(' ')[0]}');
            // log('Time: ${DateFormat('HH:mm').format(DateTime.now())}');
            // log('branch: $branchId');
            // log('shop: $shopId');
            // log('Current lat: ${coordinate.latitude}');
            // log('Current lng: ${coordinate.longitude}');
            // log('Activity Id: $aId');
            // log('Desc: $desc');
            // log('${filteredList.length}');
            newActivitiesList.clear();
            try {
              newActivitiesList.addAll(await GlobalAPI.fetchNewManagerActivity(
                '1',
                getUserAccountList[0].employeeID,
                DateTime.now().toIso8601String().split('T')[0],
                DateFormat('HH:mm').format(DateTime.now()),
                getUserAccountList[0].branch,
                getUserAccountList[0].shop,
                coordinate.latitude,
                coordinate.longitude,
                aId,
                desc,
                filteredList,
              ));
            } catch (e) {
              log('Error: $e');
            }

            // setIsLoading(false);
            if (newActivitiesList.isNotEmpty) {
              log('New Activities List is not empty');
            } else {
              log('New Activities List: ${newActivitiesList[0].resultMessage}');
            }

            if (newActivitiesList.isNotEmpty) {
              if (newActivitiesList[0].resultMessage == 'SUKSES') {
                log('Activity created successfully');
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
                log('Activity failed to create');
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
              log(newActivitiesList[0].resultMessage);
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
        log('Error: $e');
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
      log('User Input is not empty');
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

    log('isSuccess: $isSuccess');
    return isSuccess;
  }

  // ============================================================
  // ===================== User Permission ======================
  // ============================================================
  bool isManager = false;

  bool get getIsManager => isManager;

  void setIsManager(bool value) {
    isManager = value;
    notifyListeners();
  }

  Future<bool> readAndWriteIsUserManager({
    bool state = false,
    bool isLogin = false,
  }) async {
    log('Is user manager state: $state');
    try {
      // Read the existing ID only once
      String? existingStatus = await storage.read(key: 'isManager');
      log('Existing Status: $existingStatus');

      if (existingStatus == null || existingStatus.isEmpty || isLogin) {
        // Generate a new ID if none exists
        isManager = state;
        await storage.write(key: 'isManager', value: state ? '0' : '1');

        // Log the action for debugging
        log("Is User Manager status: $isManager");

        // Notify listeners as the state changed
        notifyListeners();
      } else {
        // Use the existing Password
        isManager = existingStatus == '0' ? true : false;
        log("Is User Manager status: $isManager");
      }
    } catch (e) {
      // Handle decryption or secure storage errors
      log("Error reading or writing secure storage: $e");
      isManager = await storage.read(key: 'isManager') == '0' ? true : false;
      await storage.write(key: 'isManager', value: state ? '0' : '1');
      log("Is User Manager status due to error: $isManager");

      // Notify listeners as the state changed
      notifyListeners();
    }

    return isManager;
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

  void setManagerActivities(List<ModelManagerActivities> value) {
    managerActivitiesList = value;
    notifyListeners();
  }

  Future<List<ModelManagerActivities>> fetchManagerActivities({
    String date = '',
  }) async {
    if (date == '') {
      date = DateTime.now().toString().split(' ')[0];
    }
    log('Manager Activities Date: $date');

    List<ModelManagerActivities> temp = [];
    await GlobalAPI.fetchManagerActivity(
      await readAndWriteUserId(),
      date,
    ).then((res) {
      temp = res;
      notifyListeners();
    });

    log('Manager Activities List length: ${temp.length}');

    return temp;
  }

  ModelManagerActivityDetails managerActivityDetails =
      ModelManagerActivityDetails(
    time: '',
    lat: 0,
    lng: 0,
    actId: '',
    actDesc: '',
    pic1: '',
  );

  ModelManagerActivityDetails get getManagerActivityDetails =>
      managerActivityDetails;

  Future<ModelManagerActivityDetails> fetchManagerActivityDetails(
    String date,
    String actId,
  ) async {
    if (date == '') {
      date = DateTime.now().toString().split(' ')[0];
    }

    managerActivityDetails = ModelManagerActivityDetails(
      time: '',
      lat: 0,
      lng: 0,
      actId: '',
      actDesc: '',
      pic1: '',
    );

    await GlobalAPI.fetchManagerActivityDetails(
      getUserAccountList[0].employeeID,
      date,
      actId,
    ).then((value) {
      managerActivityDetails = value[0];
    });

    log(managerActivityDetails.pic1);

    return managerActivityDetails;
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
