// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/dropdown/custom_dropdown.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:info_popup/info_popup.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ManagerNewActivityPage extends StatefulWidget {
  const ManagerNewActivityPage({super.key});

  @override
  State<ManagerNewActivityPage> createState() => _ManagerNewActivityPageState();
}

class _ManagerNewActivityPageState extends State<ManagerNewActivityPage> {
  // Panel Controller
  PanelController panelController = PanelController();
  bool isOpen = false;

  // Profile
  String? name = '';
  String? number = '';

  // Date
  String? date = DateTime.now().toString().substring(0, 10);

  // Activity Details
  String activityType = 'MORNING BRIEFING';
  String activityDescription = '';
  String activityTemplate = '';

  // Loading
  bool isLoading = false;

  Location location = Location();
  bool isUserGranted = false;

  void setActivityType(String value, String value2) {
    activityType = value;
    activityDescription = value2;
  }

  void setActivityDescription(
    String value,
    SipSalesState state,
  ) {
    activityDescription = value;
    state.setDescriptionCache(value);
  }

  void onTap() {
    isOpen = !isOpen;
    if (isOpen == true) {
      panelController.open();
    } else {
      panelController.close();
    }
  }

  void removeImage(SipSalesState state, int index) async {
    state.setIsDisable(true);
    state.removeImage(index);
    onTap();

    if (Platform.isIOS) {
      GlobalDialog.showCrossPlatformDialog(
        context,
        'Success!',
        'The image has been deleted successfully.',
        () => Navigator.pop(context),
        'Dismiss',
        isIOS: true,
      );
    } else {
      GlobalDialog.showCrossPlatformDialog(
        context,
        'Success!',
        'The image has been deleted successfully.',
        () => Navigator.pop(context),
        'Dismiss',
      );
    }
  }

  void assetHandler(SipSalesState state) async {
    if (Platform.isIOS) {
      if (state.fetchFilteredList.isEmpty) {
        if (activityType ==
            state.fetchManagerActivityTypeList[2].activityName) {
          await GlobalDialog.showIOSPermissionGranted(
            context,
            'Photo Permission',
            // 'This app needs access to your photo to image asset. Would you like to allow photo access?',
            'SIP Sales accesses your photo library to let you choose. This allows you to personalize your activity in form of an image. For example, you can select photos from your library to create a new activity.',
          ).then(
            (isPermissionGranted) async {
              if (isPermissionGranted) {
                uploadImageFromGallery(
                  context,
                  state,
                );
              } else {
                await GlobalDialog.showCustomIOSDialog(
                  context,
                  'Oh no!',
                  'Upload image cancelled.',
                  () => Navigator.pop(context),
                  'Dismiss',
                  isDismissible: true,
                );
              }
            },
          );
        } else {
          await GlobalDialog.showIOSPermissionGranted(
            context,
            'Camera Permission',
            // 'This app needs access to your photo to image asset. Would you like to allow photo access?',
            'SIP Sales uses your camera to capture photos. This allows you personalize your activity in form of an image. For example, you can take a picture for create a new activity.',
          ).then(
            (isPermissionGranted) async {
              if (isPermissionGranted) {
                uploadImageFromCamera(
                  context,
                  state,
                );
              } else {
                await GlobalDialog.showCustomIOSDialog(
                  context,
                  'Oh no!',
                  'You need to allow camera access to upload image.',
                  () => Navigator.pop(context),
                  'Dismiss',
                  isDismissible: true,
                );
              }
            },
          );
        }
      } else {
        await GlobalDialog.showCrossPlatformDialog(
          context,
          'Oh no!',
          'You only allowed to upload 1 image, please delete your image first.',
          () => Navigator.pop(context),
          'Dismiss',
          isIOS: true,
        );
      }
    } else {
      if (state.fetchFilteredList.isEmpty) {
        if (activityType ==
            state.fetchManagerActivityTypeList[2].activityName) {
          await GlobalDialog.showAndroidPermissionGranted(
            context,
            'Photo Permission',
            // 'This app needs access to your photo to image asset. Would you like to allow photo access?',
            'SIP Sales accesses your photo library to let you choose. This allows you to personalize your activity in form of an image. For example, you can select photos from your library to create a new activity.',
          ).then(
            (isPermissionGranted) async {
              if (isPermissionGranted) {
                uploadImageFromGallery(
                  context,
                  state,
                );
              } else {
                await GlobalDialog.showCustomAndroidDialog(
                  context,
                  'Oh no!',
                  'Upload image cancelled.',
                  () => Navigator.pop(context),
                  'Dismiss',
                  isDismissible: true,
                );
              }
            },
          );
        } else {
          await GlobalDialog.showAndroidPermissionGranted(
            context,
            'Camera Permission',
            // 'This app needs access to your photo to image asset. Would you like to allow photo access?',
            'SIP Sales uses your camera to capture photos. This allows you personalize your activity in form of an image. For example, you can take a picture for create a new activity.',
          ).then(
            (isPermissionGranted) async {
              if (isPermissionGranted) {
                uploadImageFromCamera(
                  context,
                  state,
                );
              } else {
                await GlobalDialog.showCustomAndroidDialog(
                  context,
                  'Oh no!',
                  'You need to allow camera access to upload image.',
                  () => Navigator.pop(context),
                  'Dismiss',
                  isDismissible: true,
                );
              }
            },
          );
        }
        // await GlobalDialog.showAndroidPermissionGranted(
        //   context,
        //   'Photo Permission',
        //   // 'This app needs access to your photo to image asset. Would you like to allow photo access?',
        //   'SIP Sales accesses your photo library to let you choose. This allows you to personalize your activity in form of an image. For example, you can select photos from your library to create a new activity.',
        // ).then(
        //   (isPermissionGranted) async {
        //     if (isPermissionGranted) {
        //       uploadImageFromGallery(
        //         context,
        //         state,
        //       );
        //     } else {
        //       await GlobalDialog.showCustomAndroidDialog(
        //         context,
        //         'Oh no!',
        //         'You need to allow camera access to upload image.',
        //         () => Navigator.pop(context),
        //         'Dismiss',
        //         isDismissible: true,
        //       );
        //     }
        //   },
        // );
      } else {
        await GlobalDialog.showCrossPlatformDialog(
          context,
          'Oh no!',
          'You only allowed to upload 1 image, please delete your image first.',
          () => Navigator.pop(context),
          'Dismiss',
        );
      }
    }
  }

  // Note -> temporary not used, but I'll keep it just in case I need it in the future
  Future showOptions(
    BuildContext context,
    SipSalesState state,
  ) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Gallery'),
            onPressed: () {
              // get image from gallery
              uploadImageFromGallery(context, state);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              // get image from camera
              uploadImageFromCamera(context, state);
            },
          ),
        ],
      ),
    );
  }

  void uploadImageFromGallery(
    BuildContext context,
    SipSalesState state,
  ) async {
    // print('Gallery Permission');
    AndroidDeviceInfo androidInfo;
    if (Platform.isAndroid) {
      androidInfo = await DeviceInfoPlugin().androidInfo;
      // Note -> below Android 12
      if (androidInfo.version.sdkInt <= 32) {
        var storageStatus = await handler.Permission.storage.status;
        // print(storageStatus);
        if (storageStatus.isGranted) {
          // print('Camera Permission granted');
          if (!await state.uploadImageFromGallery(context)) {
            await GlobalDialog.showCrossPlatformDialog(
              context,
              'Failed!',
              'Upload image cancelled.',
              () => Navigator.pop(context),
              'Dismiss',
            );
          } else {
            // do nothing
          }
        } else {
          // print('Gallery Permission denied');
          storageStatus = await handler.Permission.storage.request();
          // print(storageStatus);
          if (storageStatus != handler.PermissionStatus.granted) {
            await GlobalDialog.showCrossPlatformDialog(
              context,
              'Warning!',
              'Please change your Photo and Video permission.',
              () => Navigator.pop(context),
              'Dismiss',
            );
          } else {
            uploadImageFromGallery(context, state);
          }
        }
      }
      // Note -> above Android 13
      else {
        var galleryStatus = await handler.Permission.photos.status;
        // print(galleryStatus);
        if (galleryStatus.isGranted || galleryStatus.isLimited) {
          // print('Camera Permission granted');
          if (!await state.uploadImageFromGallery(context)) {
            await GlobalDialog.showCrossPlatformDialog(
              context,
              'Failed!',
              'Upload image cancelled.',
              () => Navigator.pop(context),
              'Dismiss',
            );
          } else {
            // do nothing
          }
        } else {
          // print('Gallery Permission denied');
          galleryStatus = await handler.Permission.photos.request();
          // print(galleryStatus);
          if (galleryStatus != handler.PermissionStatus.granted ||
              galleryStatus.isLimited) {
            await GlobalDialog.showCrossPlatformDialog(
              context,
              'Warning!',
              'Please change your Photo and Video permission.',
              () => Navigator.pop(context),
              'Dismiss',
            );
          } else {
            uploadImageFromGallery(context, state);
          }
        }
      }
    } else if (Platform.isIOS) {
      var storageStatus = await handler.Permission.storage.status;
      // print(storageStatus);
      if (storageStatus.isGranted) {
        // print('Camera Permission granted');
        if (!await state.uploadImageFromGallery(context)) {
          await GlobalDialog.showCrossPlatformDialog(
            context,
            'Failed!',
            'Upload image cancelled.',
            () => Navigator.pop(context),
            'Dismiss',
            isIOS: true,
          );
        }
      } else {
        // print('Gallery Permission denied');
        storageStatus = await handler.Permission.storage.request();
        // print(storageStatus);
        if (storageStatus != handler.PermissionStatus.granted) {
          await GlobalDialog.showCrossPlatformDialog(
            context,
            'Warning!',
            'Please change your Photo and Video permission.',
            () => Navigator.pop(context),
            'Dismiss',
            isIOS: true,
          );
        } else {
          uploadImageFromGallery(context, state);
        }
      }
    }
  }

  void uploadImageFromCamera(
    BuildContext context,
    SipSalesState state, {
    bool isRecruitment = false,
  }) async {
    var cameraStatus = await handler.Permission.camera.status;
    // print('Camera Permission');
    if (cameraStatus.isGranted) {
      // print('Camera Permission granted');
      if (!await state.uploadImageFromCamera(context)) {
        if (Platform.isIOS) {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Failed!',
            'Upload image cancelled.',
            () => Navigator.pop(context),
            'Dismiss',
            isIOS: true,
          );
        } else {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Failed!',
            'Upload image cancelled.',
            () => Navigator.pop(context),
            'Dismiss',
          );
        }
      } else {
        // do nothing
      }
    } else {
      // print('Camera Permission denied');
      cameraStatus = await handler.Permission.camera.request();
      if (cameraStatus != handler.PermissionStatus.granted) {
        if (Platform.isIOS) {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Warning!',
            'Please change your Camera permission.',
            () => Navigator.pop(context),
            'Dismiss',
            isIOS: true,
          );
        } else {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Warning!',
            'Please change your Camera permission.',
            () => Navigator.pop(context),
            'Dismiss',
          );
        }
      } else {
        uploadImageFromCamera(context, state);
      }
    }
  }

  Future<bool> requestPermission(SipSalesState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    state.setIsLocationGranted(prefs.getBool('isLocationGranted')!);

    // Alert Dialog for iOS
    if (Platform.isIOS) {
      bool isDialogGranted = prefs.getBool('isDialogGranted') ?? false;
      if (!isDialogGranted) {
        if (await GlobalDialog.showIOSPermissionGranted(
          context,
          'Location Permission',
          // 'This app needs access to your location to provide accurate services. Would you like to allow location access?',
          'SIP Sales uses your location to find your precise location and grant access of all app feature. For example, you can create an activity for keep and access your data online.',
        )) {
          prefs.setBool('isDialogGranted', true);
          isDialogGranted = prefs.getBool('isDialogGranted')!;
        } else {
          prefs.setBool('isDialogGranted', false);
          isDialogGranted = prefs.getBool('isDialogGranted')!;
        }
      }

      // print('isDialogGranted: $isDialogGranted');
      if (isDialogGranted) {
        if (!state.getIsLocationGranted) {
          PermissionStatus permissionStatus;

          permissionStatus = await location.hasPermission();
          if (permissionStatus == PermissionStatus.denied ||
              permissionStatus == PermissionStatus.deniedForever) {
            permissionStatus = await location.requestPermission();
            if (permissionStatus == PermissionStatus.denied ||
                permissionStatus == PermissionStatus.deniedForever) {
              await prefs.setBool('isLocationGranted', false);
              return false;
            }
          }

          await prefs.setBool('isLocationGranted', true);
          return true;
        } else {
          await prefs.setBool('isLocationGranted', true);
          return true;
        }
      } else {
        // do nothing
      }
    }
    // Alert Dialog for Android
    else {
      bool isDialogGranted = prefs.getBool('isDialogGranted') ?? false;
      if (!isDialogGranted) {
        if (await GlobalDialog.showAndroidPermissionGranted(
          context,
          'Location Permission',
          // 'This app needs access to your location to provide accurate services. Would you like to allow location access?',
          'SIP Sales uses your location to find your precise location and grant access of all app feature. For example, you can create an activity for keep and access your data online.',
        )) {
          prefs.setBool('isDialogGranted', true);
        } else {
          prefs.setBool('isDialogGranted', false);
        }
        isDialogGranted = prefs.getBool('isDialogGranted') ?? false;
      }

      if (isDialogGranted) {
        if (!state.getIsLocationGranted) {
          PermissionStatus permissionStatus;

          permissionStatus = await location.hasPermission();
          if (permissionStatus == PermissionStatus.denied ||
              permissionStatus == PermissionStatus.deniedForever) {
            permissionStatus = await location.requestPermission();
            if (permissionStatus == PermissionStatus.denied ||
                permissionStatus == PermissionStatus.deniedForever) {
              await prefs.setBool('isLocationGranted', false);
              return false;
            }
          }

          await prefs.setBool('isLocationGranted', true);
          return true;
        } else {
          await prefs.setBool('isLocationGranted', true);
          return true;
        }
      } else {
        await GlobalDialog.showCustomAndroidDialog(
          context,
          'WARNING',
          'App location permission denied, you can change your permission in App Settings.',
          () => Navigator.pop(context),
          'Dismiss',
          isDismissible: true,
        );
      }
    }

    await prefs.setBool('isLocationGranted', false);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // State Management
    final managerActivityState = Provider.of<SipSalesState>(context);

    return SlidingUpPanel(
      renderPanelSheet: false,
      backdropEnabled: true,
      minHeight: 0.0,
      maxHeight: (MediaQuery.of(context).size.width < 800)
          ? MediaQuery.of(context).size.height * 0.25
          : MediaQuery.of(context).size.height * 0.225,
      controller: panelController,
      panel: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025,
          vertical: MediaQuery.of(context).size.height * 0.015,
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              alignment: Alignment.center,
              child: Text(
                'Do you want to delete this image?',
                style: GlobalFont.bigfontRBold,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.045,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: onTap,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.04,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Cancel',
                        style: GlobalFont.bigfontR,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => removeImage(managerActivityState, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.04,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Delete',
                        style: GlobalFont.bigfontRWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Colors.white,
        ),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.1,
          left: MediaQuery.of(context).size.height * 0.05,
          right: MediaQuery.of(context).size.height * 0.05,
        ),
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.12,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            // ======================= Activity Details ========================
            Row(
              children: [
                Text(
                  'Activity Details',
                  style: GlobalFont.giantfontRBold,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                const InfoPopupWidget(
                  arrowTheme: InfoPopupArrowTheme(
                    color: Colors.grey,
                  ),
                  dismissTriggerBehavior: PopupDismissTriggerBehavior.onTapArea,
                  contentTitle: 'Type activity type and description.',
                  child: Icon(
                    Icons.info_outlined,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Type',
                      style: GlobalFont.mediumgiantfontR,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.04,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.black, width: 1.5),
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04,
                        vertical: MediaQuery.of(context).size.height * 0.005,
                      ),
                      child: CustomDropDown(
                        listData:
                            managerActivityState.fetchManagerActivityTypeList,
                        inputan: activityType,
                        hint: 'Manager Activity Type',
                        handle: setActivityType,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Text(
                'Descriptions',
                style: GlobalFont.mediumgiantfontR,
              ),
            ),
            Container(
              height: 175,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
              ),
              child: TextField(
                maxLines: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9./@\s:()%+-?]*'),
                  ),
                ],
                controller: TextEditingController(
                  text: activityDescription == ''
                      ? managerActivityState
                          .managerActivityTypeList[0].activityTemplate
                      : activityDescription,
                ),
                enabled: true,
                style: GlobalFont.mediumgiantfontR,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[400],
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                    vertical: MediaQuery.of(context).size.height * 0.005,
                  ),
                  hintStyle: GlobalFont.mediumbigfontM,
                  hintText: 'Masukkan deskripsi',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onChanged: (newValues) => setActivityDescription(
                  newValues,
                  managerActivityState,
                ),
              ),
            ),

            // ========================= Photo Section =========================
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Photos',
                        style: GlobalFont.giantfontRBold,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      const InfoPopupWidget(
                        arrowTheme: InfoPopupArrowTheme(
                          color: Colors.grey,
                        ),
                        dismissTriggerBehavior:
                            PopupDismissTriggerBehavior.onTapArea,
                        contentTitle: 'Upload a photo using camera or gallery.',
                        child: Icon(
                          Icons.info_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1125,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => assetHandler(managerActivityState),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.01,
                      ),
                      child: const Icon(
                        Icons.add_a_photo_rounded,
                        size: 25.0,
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: managerActivityState.getIsUploading,
                    builder: (context, value, child) {
                      if (value == true) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleLoading(),
                            const SizedBox(height: 7.5),
                            Text(
                              'Loading...',
                              style: GlobalFont.bigfontR,
                            ),
                          ],
                        );
                      } else {
                        return Expanded(
                          child: SizedBox(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  managerActivityState.filteredList.length,
                              itemBuilder: (context, index) {
                                final imageData = base64Decode(
                                  managerActivityState.filteredList[0],
                                );
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: onTap,
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            child: Image.memory(
                                              imageData,
                                              fit: BoxFit.contain,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.215,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.delete_rounded,
                                            size: 30.0,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.015,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // ========================= Create Button =========================
            ValueListenableBuilder(
              valueListenable: managerActivityState.isDisable,
              builder: (context, value, child) {
                if (value == true) {
                  return InkWell(
                    onTap: () {
                      if (Platform.isIOS) {
                        GlobalDialog.showCrossPlatformDialog(
                          context,
                          'Warning',
                          'Please check your input again.',
                          () => Navigator.pop(context),
                          'Dismiss',
                          isIOS: true,
                        );
                      } else {
                        GlobalDialog.showCrossPlatformDialog(
                          context,
                          'Warning',
                          'Please check your input again.',
                          () => Navigator.pop(context),
                          'Dismiss',
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height * 0.04,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.025,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: managerActivityState.isLoading,
                        builder: (context, value, child) {
                          if (value == true) {
                            return const CircleLoading(
                              warna: Colors.white,
                            );
                          } else {
                            return Text(
                              'Create',
                              style: GlobalFont.giantfontRBold,
                            );
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      bool locPermission =
                          prefs.getBool('isLocationGranted') ?? false;
                      if (locPermission) {
                        // Note -> request permission inside the app
                        // await requestPermission(
                        //     Provider.of<SipSalesState>(context, listen: false));
                        managerActivityState.createShopManagerActivity(
                          context,
                          managerActivityState.fetchManagerActivityTypeList,
                          activityType,
                          activityDescription,
                        );
                      } else {
                        if (await requestPermission(Provider.of<SipSalesState>(
                            context,
                            listen: false))) {
                          managerActivityState.createShopManagerActivity(
                            context,
                            managerActivityState.fetchManagerActivityTypeList,
                            activityType,
                            activityDescription,
                          );
                        } else {
                          if (Platform.isIOS) {
                            GlobalDialog.showCrossPlatformDialog(
                              context,
                              'Warning',
                              'Your location permission is denied, please try again or allow it in App Settings.',
                              () async {
                                await AppSettings.openAppSettings();
                              },
                              'Open Settings',
                              isIOS: true,
                              isDismissable: true,
                            );
                          } else {
                            GlobalDialog.showCrossPlatformDialog(
                              context,
                              'Warning',
                              'Your location permission is denied, please try again or allow it in App Settings.',
                              () async {
                                await AppSettings.openAppSettings();
                              },
                              'Open Settings',
                              isDismissable: true,
                            );
                          }
                        }
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.025,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: managerActivityState.isLoading,
                        builder: (context, value, child) {
                          if (value == true) {
                            return const CircleLoading(
                              warna: Colors.white,
                            );
                          } else {
                            return Text(
                              'Create',
                              style: GlobalFont.giantfontRBoldWhite,
                            );
                          }
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UpperCaseText extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
