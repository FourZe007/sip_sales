// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as images;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:background_location/background_location.dart'
    as background_location;
import 'package:sip_sales/pages/location/image_view.dart';
import 'package:sip_sales/pages/map/map.dart';
import 'dart:math' as math;
import 'package:sip_sales/widget/popup/kotak_pesan.dart';

class SipSalesState with ChangeNotifier {
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
  bool? attendanceStatus = false;
  bool isWithinRadius = false;
  bool onProgress = false;

  // Loading
  bool isPressed = false;

  // Checked In
  List<ModelResultMessage> checkInList = [];
  bool isCheckedIn = false;

  // Checked Out
  List<ModelResultMessage> checkOutList = [];
  List<ModelResultMessage2> activityTimestampList = [];

  List<ModelCoordinate> get fetchCoordinateList => coordinateList;

  bool? get fetchAttendanceStatus => attendanceStatus;

  double get fetchLngDisplay => lngDisplay;
  double get fetchLatDisplay => latDisplay;

  void pressTrigger() {
    isPressed = !isPressed;
    notifyListeners();
  }

  void setLngDisplay(double value) {
    lngDisplay = value;
    notifyListeners();
  }

  void setLatDisplay(double value) {
    latDisplay = value;
    notifyListeners();
  }

  void setAttendanceStatus(bool state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('attendanceStatus', state);
    notifyListeners();
  }

  void getAttendanceStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    attendanceStatus = prefs.getBool('attendanceStatus');
    notifyListeners();
  }

  void setIsCheckedIn(bool state) {
    isCheckedIn = state;
  }

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
    await location.getLocation().then((coordinate) {
      setLngDisplay(coordinate.longitude!);
      setLatDisplay(coordinate.latitude!);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(
          fetchLngDisplay,
          fetchLatDisplay,
        ),
      ),
    );
  }

  void backToLocation(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/location');
  }

  // Function -> Convert Longitude and Latitude coordinate, from degree to radians
  double radiansConverter(double degrees) => degrees * math.pi / 180;

  // Function -> Check 2nd coordinate is within 1st coordinate radius
  bool getIsWithinRadius(double lat1, double lon1, double lat2, double lon2,
      double radiusInMeters) {
    // Function -> Convert coordinates to radians
    double radiansLat1 = radiansConverter(lat1);
    double radiansLon1 = radiansConverter(lon1);
    double radiansLat2 = radiansConverter(lat2);
    double radiansLon2 = radiansConverter(lon2);

    // Function -> Earth's radius (in meters)
    const double earthRadius = 6371e3;

    // Function -> Calculate the difference in latitude and longitude
    double dLat = radiansLat2 - radiansLat1;
    double dLon = radiansLon2 - radiansLon1;

    // Function -> Haversine formula for distance calculation
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(radiansLat1) *
            math.cos(radiansLat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    // Function -> Calculate distance in meters
    double distance = earthRadius * c;

    // Function -> Check if distance is less than or equal to radius
    return distance <= radiusInMeters;
  }

  void trackUserLocation(BuildContext context) async {
    while (isCheckedIn) {
      if (onProgress) {
        if (await location.serviceEnabled()) {
          await Future.delayed(const Duration(seconds: 5)).then(
            (_) async {
              // background_location library
              await background_location.BackgroundLocation.getLocationUpdates(
                  (location) {
                setCoordinateList(
                  location.latitude,
                  location.longitude,
                );
              });

              addCoordinateList(ModelCoordinate(
                longitude: longitude!,
                latitude: latitude!,
                time: time,
              ));
            },
          );
        } else {
          setIsCheckedIn(false);
          // Function -> declare 'attendanceStatus' value to true and user have access to 'Check In' safely
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('attendanceStatus', false);
          attendanceStatus = prefs.getBool('attendanceStatus')!;

          GlobalFunction.tampilkanDialog(
            context,
            false,
            KotakPesan(
              'Peringatan!',
              'Layanan lokasi dinonaktifkan.',
              detail2: 'Silakan aktifkan untuk fitur yang lebih advanced.',
              function: () => backToLocation(context),
            ),
          );
        }
      }
    }
  }

  // Function -> run 'Check In' button
  void checkIn(BuildContext context) async {
    getAttendanceStatus();

    if (await location.serviceEnabled()) {
      if (attendanceStatus == false) {
        pressTrigger();

        // Enable -> uncommand if all requirement fulfilled
        // await location.getLocation().then((coordinate) {
        //   isWithinRadius = getIsWithinRadius(
        //     coordinate.latitude!,
        //     coordinate.longitude!,
        //     GlobalVar.userAccountList[0].latitude,
        //     GlobalVar.userAccountList[0].longitude,
        //     10.0,
        //   );
        //
        //   if (isWithinRadius == true) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(
        //         content: Text('User is within Radius'),
        //       ),
        //     );
        //   } else {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(
        //         content: Text('User is out of Radius'),
        //       ),
        //     );
        //   }
        // });

        // Delete -> remove later, used to bypass variable for trial
        isWithinRadius = true;

        onProgress = true;
        coordinateList.clear();

        pressTrigger();

        if (isWithinRadius == false) {
          setIsCheckedIn(false);
          // Function -> declare 'attendanceStatus' value to false and user need to try 'Check In' again
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('attendanceStatus', false);
          attendanceStatus = prefs.getBool('attendanceStatus')!;

          GlobalFunction.tampilkanDialog(
            context,
            true,
            KotakPesan(
              'Peringatan!',
              'Lokasi Tidak Valid',
              tinggi: MediaQuery.of(context).size.height * 0.3,
              detail2:
                  'User: (${GlobalVar.userAccountList[0].latitude}, ${GlobalVar.userAccountList[0].longitude}); Current: ($latitude, $longitude)',
            ),
          );
        } else {
          // Temp -> temporary variable for accessing all app feature
          bool byPass = true;
          // Enable -> uncommand if all requirement fulfilled
          // checkInList = await GlobalAPI.fetchModifyAttendance(
          //   '1',
          //   GlobalVar.nip!,
          //   GlobalVar.userAccountList[0].branch,
          //   GlobalVar.userAccountList[0].shop,
          //   GlobalVar.userAccountList[0].locationID,
          //   DateTime.now().toString().split(' ')[1],
          //   '${DateTime.now().hour}.${DateTime.now().minute}.${DateTime.now().second}',
          //   '',
          // );
          //
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Check In ${checkInList[0].resultMessage}'),
          //   ),
          // );

          // Temp -> uncommand if all requirement fulfilled
          // if (checkInList[0].resultMessage == 'SUKSES') {
          if (byPass == true) {
            // Function -> set isCheckedIn to true whenever the user press the 'Check In' Button
            setIsCheckedIn(true);
            // Function -> declare 'attendanceStatus' value to true and user have access to 'Check In' safely
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setBool('attendanceStatus', true);
            attendanceStatus = prefs.getBool('attendanceStatus')!;

            GlobalFunction.tampilkanDialog(
              context,
              false,
              KotakPesan(
                'Sukses!',
                'Check In berhasil.',
                tinggi: MediaQuery.of(context).size.height * 0.2,
              ),
            );

            await background_location.BackgroundLocation.startLocationService();

            await location.getLocation().then((coordinate) {
              setCoordinateList(
                coordinate.latitude,
                coordinate.longitude,
              );
            });

            addCoordinateList(ModelCoordinate(
              longitude: longitude!,
              latitude: latitude!,
              time: time,
            ));

            // Delete -> remove later
            // print('First Coordinate');
            // print('Longitude, Latitude: $longitude, $latitude');
            // print('Time: $time');
            // print('Coordinate list length: ${coordinateList.length}');

            trackUserLocation(context);
          } else {
            // Note -> error dari pak Har
            // Function -> declare 'attendanceStatus' value to false and user need to try 'Check In' again
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setBool('attendanceStatus', false);
            attendanceStatus = prefs.getBool('attendanceStatus')!;

            GlobalFunction.tampilkanDialog(
              context,
              false,
              KotakPesan(
                'Peringatan!!',
                checkInList[0].resultMessage,
                tinggi: MediaQuery.of(context).size.height * 0.2,
              ),
            );
          }
        }
      } else {
        // Function -> do nothing if User already pressed 'Check In' button
        GlobalFunction.tampilkanDialog(
          context,
          false,
          KotakPesan(
            'Peringatan!',
            'Tolong check out terlebih dahulu.',
            tinggi: MediaQuery.of(context).size.height * 0.2,
            detail2: attendanceStatus.toString(),
          ),
        );
      }
    } else {
      setIsCheckedIn(false);
      // Function -> declare 'attendanceStatus' value to true and user have access to 'Check In' safely
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('attendanceStatus', false);
      attendanceStatus = prefs.getBool('attendanceStatus')!;

      GlobalFunction.tampilkanDialog(
        context,
        false,
        KotakPesan(
          'Peringatan!',
          'Layanan Lokasi dinonaktifkan.',
          detail2: 'Silakan aktifkan untuk fitur yang lebih advanced.',
          function: () => backToLocation(context),
        ),
      );
    }
  }

  // Function -> run 'Check Out' button
  void checkOut(BuildContext context) async {
    await background_location.BackgroundLocation.stopLocationService();
    getAttendanceStatus();

    if (attendanceStatus == true) {
      pressTrigger();

      setIsCheckedIn(false);
      onProgress = false;

      // await location.getLocation().then((coordinate) {
      //   isWithinRadius = getIsWithinRadius(
      //     coordinate.latitude!,
      //     coordinate.longitude!,
      //     GlobalVar.userAccountList[0].latitude,
      //     GlobalVar.userAccountList[0].longitude,
      //     10.0,
      //   );
      //
      //   if (isWithinRadius == true) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text('User is within Radius'),
      //       ),
      //     );
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text('User is out of Radius'),
      //       ),
      //     );
      //   }
      // });

      // Delete -> remove later
      isWithinRadius = true;

      if (isWithinRadius == false) {
        // Function -> declare 'attendanceStatus' value to true and user need to try 'Check Out' again
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('attendanceStatus', true);
        attendanceStatus = prefs.getBool('attendanceStatus')!;

        GlobalFunction.tampilkanDialog(
          context,
          true,
          KotakPesan(
            'WARNING!',
            'Lokasi Tidak Valid',
            tinggi: MediaQuery.of(context).size.height * 0.3,
            detail2:
                'User: (${GlobalVar.userAccountList[0].latitude}, ${GlobalVar.userAccountList[0].longitude}); Current: ($latitude, $longitude)',
          ),
        );
      } else {
        // Function -> declare 'attendanceStatus' value to false and user have access to 'Check Out' safely
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('attendanceStatus', false);
        attendanceStatus = prefs.getBool('attendanceStatus')!;

        coordinateList.clear();
        coordinateList.addAll(await readListFromCache('cached_coordinates'));

        // Enable -> uncommand if all requirement fulfilled
        // checkOutList = await GlobalAPI.fetchModifyAttendance(
        //   '2',
        //   GlobalVar.nip!,
        //   GlobalVar.userAccountList[0].branch,
        //   GlobalVar.userAccountList[0].shop,
        //   GlobalVar.userAccountList[0].locationID,
        //   DateTime.now().toString().split(' ')[1],
        //   '',
        //   '${DateTime.now().hour}.${DateTime.now().minute}.${DateTime.now().second}',
        // );
        //
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Check Out ${checkOutList[0].resultMessage}'),
        //   ),
        // );

        // print('Last Coordinate');
        // print('Longitude, Latitude: $longitude, $latitude');
        // print('Time: $time');
        // print('Coordinate list length: ${coordinateList.length}');
        // print('Insert all coordinate to database');
        // print('NIP: ${GlobalVar.nip}');
        // print('Date: ${DateTime.now().toString().split(' ')[0]}');
        // print('List: $coordinateList');
        activityTimestampList = await GlobalAPI.fetchActivityTimestamp(
          '1',
          GlobalVar.nip!,
          DateTime.now().toString().split(' ')[0],
          coordinateList,
        );

        // Delete -> remove later
        bool byPass = true;

        // Delete -> remove later
        // ~:NEW:~
        List<dynamic> latList = [];
        List<dynamic> lngList = [];
        List<dynamic> timeList = [];

        latList.addAll(fetchCoordinateList.map((map) {
          return map.latitude;
        }));

        await GlobalAPI.fetchSendMessage(
          '6281338518880',
          'Latitude Coordinate: $latList',
          'realme-tab',
          'text',
        );

        lngList.addAll(fetchCoordinateList.map((map) {
          return map.longitude;
        }));

        await GlobalAPI.fetchSendMessage(
          '6281338518880',
          'Longitude Coordinate: $lngList',
          'realme-tab',
          'text',
        );

        timeList.addAll(fetchCoordinateList.map((map) {
          return map.time;
        }));

        await GlobalAPI.fetchSendMessage(
          '6281338518880',
          'Time: $timeList',
          'realme-tab',
          'text',
        );

        latList.clear();
        lngList.clear();
        timeList.clear();
        // ~:NEW:~

        if (activityTimestampList.isNotEmpty) {
          // Activity Timestamp is not empty
          if (byPass == true &&
              activityTimestampList[0].resultMessage == 'SUKSES') {
            GlobalFunction.tampilkanDialog(
              context,
              false,
              KotakPesan(
                'Sukses!',
                'Check out berhasil.',
                tinggi: MediaQuery.of(context).size.height * 0.2,
              ),
            );
          } else {
            // Check Out Failed
            GlobalFunction.tampilkanDialog(
              context,
              false,
              KotakPesan(
                'Gagal',
                checkOutList[0].resultMessage,
                tinggi: MediaQuery.of(context).size.height * 0.2,
              ),
            );
          }
        } else {
          // Activity Timestamp is empty
          GlobalFunction.tampilkanDialog(
            context,
            false,
            KotakPesan(
              'Gagal!',
              'Check Out gagal.',
              tinggi: MediaQuery.of(context).size.height * 0.2,
            ),
          );
        }
      }
      pressTrigger();
    } else {
      // print('Not Checked In yet');
      GlobalFunction.tampilkanDialog(
        context,
        false,
        KotakPesan(
          'Gagal!',
          'Tolong check in terlebih dahulu.',
          detail2: attendanceStatus.toString(),
        ),
      );
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

  List<ModelActivities> get fetchManagerActivityTypeList =>
      managerActivityTypeList;

  List<XFile?> pickedFileList = [];
  List<Uint8List> imageBytesList = [];
  List<images.Image> imgList = [];
  List<String> base64ImageList = [];
  List<String> filteredList = [];

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

  ValueNotifier<bool> isUploading = ValueNotifier(false);

  ValueNotifier<bool> get getIsUploading => isUploading;

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

    setIsDisable(true);
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

    // print(
    //     'Manager Activity Type List length: ${managerActivityTypeList.length}');
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
    setIsUploading(true);
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

    setIsUploading(false);

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
    setIsUploading(true);
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

      // notifyListeners();
    }

    setIsUploading(false);

    if (filteredList.isNotEmpty) {
      setIsDisable(false);
      return true;
    }
    return false;
  }

  void removeImage(int index) async {
    filteredList.clear();
    notifyListeners();
  }

  void removeImages() async {
    filteredList.clear();
    notifyListeners();
  }

  void setIsLoading(bool value) {
    isLoading.value = value;
    notifyListeners();
  }

  void setIsDisable(bool value) {
    isDisable.value = value;
    notifyListeners();
  }

  void setIsUploading(bool value) {
    isUploading.value = value;
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
              'Anda sudah mengirimkan aktivitas hari ini. Silakan coba lagi besok.',
              () => Navigator.pop(context),
              'Tutup',
              isIOS: true,
            );
          } else {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Peringatan!',
              'Anda sudah mengirimkan aktivitas hari ini. Silakan coba lagi besok.',
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

    // print('Employee ID: $eId');
    // print('Branch ID: $branchId');
    // print('Shop ID: $shopId');

    if (type != '' && desc != '' && filteredList.isNotEmpty) {
      await location.getLocation().then((coordinate) async {
        newActivitiesList.clear();
        newActivitiesList.addAll(await GlobalAPI.fetchNewManagerActivity(
          eId,
          DateTime.now().toString().split(' ')[0],
          TimeOfDay.now().toString().substring(10, 15),
          branchId,
          shopId,
          coordinate.latitude!,
          coordinate.longitude!,
          aId,
          desc,
          filteredList,
        ));

        // setIsLoading(false);
        // if (newActivitiesList.isNotEmpty) {
        //   print('New Activities List is not empty');
        // } else {
        //   print('New Activities List: ${newActivitiesList[0].resultMessage}');
        // }

        if (newActivitiesList.isNotEmpty) {
          if (newActivitiesList[0].resultMessage == 'SUKSES') {
            setIsLoading(false);

            if (Platform.isIOS) {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Sukses!',
                'Aktivitas berhasil dibuat.',
                () => Navigator.pop(context),
                'Tutup',
                isIOS: true,
              );
            } else {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Sukses!',
                'Aktivitas berhasil dibuat.',
                () => Navigator.pop(context),
                'Tutup',
              );
            }

            return true;
          } else {
            setIsLoading(false);

            if (Platform.isIOS) {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Gagal!',
                'Aktivitas gagal dibuat.',
                () => Navigator.pop(context),
                'Tutup',
                isIOS: true,
              );
            } else {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Gagal!',
                'Aktivitas gagal dibuat.',
                () => Navigator.pop(context),
                'Tutup',
              );
            }

            return false;
          }
        } else {
          setIsLoading(false);

          if (Platform.isIOS) {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Gagal!',
              'Anda sudah mengirimkan aktivitas hari ini. Silakan coba lagi besok.',
              () => Navigator.pop(context),
              'Tutup',
              isIOS: true,
            );
          } else {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Gagal!',
              'Anda sudah mengirimkan aktivitas hari ini. Silakan coba lagi besok.',
              () => Navigator.pop(context),
              'Tutup',
            );
          }

          return false;
        }
      });
    } else {
      setIsLoading(false);

      if (Platform.isIOS) {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Gagal!',
          'Silakan periksa input Anda dan coba lagi.',
          () => Navigator.pop(context),
          'Tutup',
          isIOS: true,
        );
      } else {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Gagal!',
          'Silakan periksa input Anda dan coba lagi.',
          () => Navigator.pop(context),
          'Tutup',
        );
      }

      return false;
    }

    return false;
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

    // print('Manager Activities List length: ${managerActivitiesList.length}');å

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
