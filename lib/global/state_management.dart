// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
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
              'WARNING!',
              'Location service is disabled',
              detail2: 'Please enable for more advanced features',
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
              'Oh noo!',
              'Invalid Location',
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
                'YOU DID IT!',
                'Check In success',
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
                'Oh noo!!',
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
            'Oh noo!!',
            'Please check out first',
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
          'WARNING!',
          'Location service is disabled',
          detail2: 'Please enable for more advanced features',
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
            'Invalid Location',
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

        print('Insert all coordinate to database');
        print('NIP: ${GlobalVar.nip}');
        print('Date: ${DateTime.now().toString().split(' ')[0]}');
        print('List: $coordinateList');
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
                'YOU DID IT!',
                'Check out success',
                tinggi: MediaQuery.of(context).size.height * 0.2,
              ),
            );
          } else {
            // Check Out Failed
            GlobalFunction.tampilkanDialog(
              context,
              false,
              KotakPesan(
                'FAILED',
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
              'Oh noo!!',
              'Check Out fail',
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
          'Oh noo!!',
          'Please check in first',
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
      imageQuality: 100,
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

  Future<bool> uploadImageFromCamera(BuildContext context) async {
    setIsUploading(true);
    setIsDisable(true);

    pickedFileList.clear();
    imageBytesList.clear();
    imgList.clear();
    base64ImageList.clear();

    pickedFileList
        .add(await ImagePicker().pickImage(source: ImageSource.camera));

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
                'Yey!',
                'Activity inserted succedfully!',
                () => Navigator.pop(context),
                'Dismiss',
                isIOS: true,
              );
            } else {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Yey!',
                'Activity inserted succedfully!',
                () => Navigator.pop(context),
                'Dismiss',
              );
            }
          } else {
            setIsLoading(false);

            // Custom Alert Dialog for Android and iOS
            if (Platform.isIOS) {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Oh no!',
                'Failed to insert activity.',
                () => Navigator.pop(context),
                'Dismiss',
                isIOS: true,
              );
            } else {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Oh no!',
                'Failed to insert activity.',
                () => Navigator.pop(context),
                'Dismiss',
              );
            }
          }
        } else {
          setIsLoading(false);

          // Custom Alert Dialog for Android and iOS
          if (Platform.isIOS) {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Oh no!',
              'You have already submitted today\'s activity. Please try again tomorrow.',
              () => Navigator.pop(context),
              'Dismiss',
              isIOS: true,
            );
          } else {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Oh no!',
              'You have already submitted today\'s activity. Please try again tomorrow.',
              () => Navigator.pop(context),
              'Dismiss',
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
          'Oh no!',
          'Please check your input and try again.',
          () => Navigator.pop(context),
          'Dismiss',
          isIOS: true,
        );
      } else {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oh no!',
          'Please check your input and try again.',
          () => Navigator.pop(context),
          'Dismiss',
        );
      }
    }
  }

  void createShopManagerActivity(
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
        newActivitiesList = await GlobalAPI.fetchNewManagerActivity(
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
        );

        if (newActivitiesList.isNotEmpty) {
          if (newActivitiesList[0].resultMessage == 'SUKSES') {
            setIsLoading(false);

            if (Platform.isIOS) {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Yey!',
                'Activity inserted succedfully!',
                () => Navigator.pop(context),
                'Dismiss',
                isIOS: true,
              );
            } else {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Yey!',
                'Activity inserted succedfully!',
                () => Navigator.pop(context),
                'Dismiss',
              );
            }
          } else {
            setIsLoading(false);

            if (Platform.isIOS) {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Oh no!',
                'Failed to insert activity.',
                () => Navigator.pop(context),
                'Dismiss',
                isIOS: true,
              );
            } else {
              GlobalDialog.showCrossPlatformDialog(
                context,
                'Oh no!',
                'Failed to insert activity.',
                () => Navigator.pop(context),
                'Dismiss',
              );
            }
          }
        } else {
          setIsLoading(false);

          if (Platform.isIOS) {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Oh no!',
              'You have already submitted today\'s activity. Please try again tomorrow.',
              () => Navigator.pop(context),
              'Dismiss',
              isIOS: true,
            );
          } else {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Oh no!',
              'You have already submitted today\'s activity. Please try again tomorrow.',
              () => Navigator.pop(context),
              'Dismiss',
            );
          }
        }
      });
    } else {
      setIsLoading(false);

      if (Platform.isIOS) {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oh no!',
          'Please check your input and try again.',
          () => Navigator.pop(context),
          'Dismiss',
          isIOS: true,
        );
      } else {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oh no!',
          'Please check your input and try again.',
          () => Navigator.pop(context),
          'Dismiss',
        );
      }
    }
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

  bool get getIsLocationGranted => isLocationEnable;

  void setIsLocationGranted(bool value) {
    isLocationEnable = value;
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

  Stream<List<ModelManagerActivities>> fetchManagerActivities(
    String date,
  ) async* {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    eId = prefs.getString('nip')!;

    managerActivitiesList.clear();
    managerActivitiesList = await GlobalAPI.fetchManagerActivity(
      eId,
      date,
    );

    yield managerActivitiesList;
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
