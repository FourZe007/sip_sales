// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/dropdown/custom_dropdown.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:info_popup/info_popup.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ManagerNewActivityPage extends StatefulWidget {
  const ManagerNewActivityPage({super.key});

  @override
  State<ManagerNewActivityPage> createState() => _ManagerNewActivityPageState();
}

class _ManagerNewActivityPageState extends State<ManagerNewActivityPage> {
  // Panel Controller
  // PanelController panelController = PanelController();
  // bool isOpen = false;

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
    setState(() {
      activityType = value;
      activityDescription = value2;
    });
  }

  void setActivityDescription(
    String value,
    SipSalesState state,
  ) {
    activityDescription = value;
    state.setDescriptionCache(value);
  }

  // void onTap() {
  //   isOpen = !isOpen;
  //   if (isOpen == true) {
  //     panelController.open();
  //   } else {
  //     panelController.close();
  //   }
  // }

  void imageRemovalProcessing(SipSalesState state) {
    // print('pressed');
    if (Platform.isIOS) {
      GlobalDialog.showCrossPlatformCustomOption(
        context,
        'Peringatan!',
        'Apakah anda ingin menghapus gambar ini?',
        'Hapus',
        () {
          Navigator.pop(context);
          removeImage(state, 0);
        },
        'Batal',
        () => Navigator.pop(context),
        isIOS: true,
      );
    } else {
      GlobalDialog.showCrossPlatformCustomOption(
        context,
        'Peringatan!',
        'Apakah anda ingin menghapus gambar ini?',
        'Hapus',
        () {
          Navigator.pop(context);
          removeImage(state, 0);
        },
        'Batal',
        () => Navigator.pop(context),
      );
    }
  }

  void removeImage(SipSalesState state, int index) async {
    // print('delete');
    state.setIsDisable(true);
    state.removeImage(index);
    // onTap();

    if (Platform.isIOS) {
      GlobalDialog.showCrossPlatformDialog(
        context,
        'Berhasil!',
        'Gambar berhasil dihapus.',
        () => Navigator.pop(context),
        'Tutup',
        isIOS: true,
      );
    } else {
      GlobalDialog.showCrossPlatformDialog(
        context,
        'Berhasil!',
        'Gambar berhasil dihapus.',
        () => Navigator.pop(context),
        'Tutup',
      );
    }
  }

  void assetHandler(SipSalesState state) async {
    if (state.fetchFilteredList.isEmpty) {
      if (activityType == state.fetchManagerActivityTypeList[2].activityName) {
        uploadImageFromGallery(
          context,
          state,
        );
      } else {
        uploadImageFromCamera(
          context,
          state,
        );
      }
    } else {
      if (Platform.isIOS) {
        await GlobalDialog.showCrossPlatformDialog(
          context,
          'Peringatan!',
          'Anda hanya diizinkan mengunggah 1 gambar, harap hapus gambar Anda terlebih dahulu.',
          () => Navigator.pop(context),
          'Tutup',
          isIOS: true,
        );
      } else {
        await GlobalDialog.showCrossPlatformDialog(
          context,
          'Oh no!',
          'Anda hanya diizinkan mengunggah 1 gambar, harap hapus gambar Anda terlebih dahulu.',
          () => Navigator.pop(context),
          'Tutup',
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
        // print('Android 12 or below');
        var storageStatus = await handler.Permission.storage.status;
        // print(storageStatus);
        if (storageStatus.isGranted) {
          // print('Camera Permission granted');
          if (!await state.uploadImageFromGallery(context)) {
            await GlobalDialog.showCrossPlatformDialog(
              context,
              'Gagal!',
              'Pengunggahan gambar dibatalkan.',
              () => Navigator.pop(context),
              'Tutup',
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
              'Peringatan!',
              'Silakan ubah izin Foto dan Video Anda.',
              () => Navigator.pop(context),
              'Tutup',
            );
          } else {
            uploadImageFromGallery(context, state);
          }
        }
      }
      // Note -> above Android 13
      else {
        // print('Android 13 or above');
        var galleryStatus = await handler.Permission.photos.status;
        // print(galleryStatus);
        if (galleryStatus.isGranted || galleryStatus.isLimited) {
          // print('Camera Permission granted');
          if (!await state.uploadImageFromGallery(context)) {
            await GlobalDialog.showCrossPlatformDialog(
              context,
              'Gagal!',
              'Pengunggahan gambar dibatalkan.',
              () => Navigator.pop(context),
              'Tutup',
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
              'Peringatan!',
              'Silakan ubah izin Foto dan Video Anda.',
              () => Navigator.pop(context),
              'Tutup',
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
            'Gagal!',
            'Pengunggahan gambar dibatalkan.',
            () => Navigator.pop(context),
            'Tutup',
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
            'Peringatan!',
            'Silakan ubah izin Foto dan Video Anda.',
            () => Navigator.pop(context),
            'Tutup',
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
    // print('Camera Permission Status: $cameraStatus');
    if (cameraStatus.isGranted) {
      // print('Camera Permission granted');
      if (!await state.uploadImageFromCamera(context)) {
        if (Platform.isIOS) {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Gagal!',
            'Pengunggahan gambar dibatalkan.',
            () => Navigator.pop(context),
            'Tutup',
            isIOS: true,
          );
        } else {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Gagal!',
            'Pengunggahan gambar dibatalkan.',
            () => Navigator.pop(context),
            'Tutup',
          );
        }
      } else {
        // do nothing
      }
    } else {
      // print('Camera Permission denied');
      cameraStatus = await handler.Permission.camera.request();
      // print('Camera Permission Request: $cameraStatus');
      if (cameraStatus != handler.PermissionStatus.granted) {
        if (Platform.isIOS) {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Peringatan!',
            'Silakan ubah izin Kamera Anda.',
            () => Navigator.pop(context),
            'Tutup',
            isIOS: true,
          );
        } else {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Warning!',
            'Silakan ubah izin Kamera Anda.',
            () => Navigator.pop(context),
            'Tutup',
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
  }

  void createActivity(
    SipSalesState state,
    List<ModelActivities> list,
    String type,
    String desc,
  ) async {
    if (state.getIsLocationGranted) {
      if (await state.createShopManagerActivity(
        context,
        list,
        activityType,
        activityDescription,
      )) {
        print('Activity Created');
        Navigator.pop(context, true);
      }
    } else {
      await requestPermission(state).then((isGranted) async {
        if (isGranted) {
          if (await state.createShopManagerActivity(
            context,
            list,
            activityType,
            activityDescription,
          )) {
            print('Activity Created');
            Navigator.pop(context, true);
          }
        } else {
          if (Platform.isIOS) {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Peringatan!',
              'Mohon izinkan lokasi Anda dan coba lagi.',
              () => Navigator.pop(context),
              'Tutup',
              isIOS: true,
            );
          } else {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Peringatan!',
              'Mohon izinkan lokasi Anda dan coba lagi.',
              () => Navigator.pop(context),
              'Tutup',
            );
          }
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<SipSalesState>(context, listen: false).clearState();
  }

  @override
  Widget build(BuildContext context) {
    // State Management
    final managerActivityState = Provider.of<SipSalesState>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        toolbarHeight: (MediaQuery.of(context).size.width < 800)
            ? MediaQuery.of(context).size.height * 0.075
            : MediaQuery.of(context).size.height * 0.075,
        title: (MediaQuery.of(context).size.width < 800)
            ? Text(
                'Buat Aktivitas',
                style: GlobalFont.giantfontRBold,
              )
            : Text(
                'Buat Aktivitas',
                style: GlobalFont.terafontRBold,
              ),
        leading: ValueListenableBuilder(
          valueListenable: managerActivityState.isLoading,
          builder: (context, value, child) {
            return IconButton(
              onPressed: () async {
                managerActivityState.setIsDisable(true);
                managerActivityState.removeImage(0);

                if (value == true) {
                  if (Platform.isIOS) {
                    await GlobalDialog.showCrossPlatformDialog(
                      context,
                      'Peringatan!',
                      'Silakan periksa inputan Anda kembali.',
                      () => Navigator.pop(context),
                      'Tutup',
                      isIOS: true,
                    );
                  } else {
                    await GlobalDialog.showCrossPlatformDialog(
                      context,
                      'Peringatan!',
                      'Silakan periksa kembali inputan Anda.',
                      () => Navigator.pop(context),
                      'Tutup',
                    );
                  }
                } else {
                  Navigator.pop(context, false);
                }
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                color: Colors.black,
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ========================= Sections ==========================
                  SizedBox(
                    child: Column(
                      children: [
                        // =============== Activity Details Section ==============
                        Row(
                          children: [
                            Text(
                              'Detail Aktivitas',
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
                              contentTitle:
                                  'Masukkan jenis dan deskripsi aktivitas.',
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
                                  'Tipe',
                                  style: GlobalFont.mediumgiantfontR,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.black, width: 1.5),
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.005,
                                  ),
                                  child: CustomDropDown(
                                    listData: managerActivityState
                                        .fetchManagerActivityTypeList,
                                    inputan: activityType,
                                    hint: 'Tipe Aktivitas Manajer',
                                    handle: setActivityType,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                          ),
                          child: Text(
                            'Deskripsi',
                            style: GlobalFont.mediumgiantfontR,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom * 0.65,
                          ),
                          child: TextField(
                            maxLines: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9./@\s:()%+-?]*'),
                              ),
                            ],
                            controller: TextEditingController(
                              text: activityType == 'DAILY REPORT'
                                  ? activityDescription
                                  : activityDescription == ''
                                      ? managerActivityState
                                          .managerActivityTypeList[0]
                                          .activityTemplate
                                      : activityDescription,
                            ),
                            enabled: true,
                            style: GlobalFont.mediumgiantfontR,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[400],
                              contentPadding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.04,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              hintStyle: GlobalFont.mediumbigfontM,
                              hintText: activityType == 'DAILY REPORT'
                                  ? 'Masukkan Report Sore Anda.'
                                  : 'Masukkan deskripsi Anda.',
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
                                    'Foto',
                                    style: GlobalFont.giantfontRBold,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  const InfoPopupWidget(
                                    arrowTheme: InfoPopupArrowTheme(
                                      color: Colors.grey,
                                    ),
                                    dismissTriggerBehavior:
                                        PopupDismissTriggerBehavior.onTapArea,
                                    contentTitle:
                                        'Unggah foto menggunakan kamera atau galeri.',
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo_rounded,
                                    size: 25.0,
                                  ),
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable:
                                    managerActivityState.getIsUploading,
                                builder: (context, value, child) {
                                  if (value == true) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Platform.isIOS
                                            ? const CupertinoActivityIndicator(
                                                radius: 12.5,
                                              )
                                            : const CircleLoading(),
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
                                          itemCount: managerActivityState
                                              .filteredList.length,
                                          itemBuilder: (context, index) {
                                            final imageData = base64Decode(
                                              managerActivityState
                                                  .filteredList[0],
                                            );
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    imageRemovalProcessing(
                                                      managerActivityState,
                                                    );
                                                  },
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.topRight,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25.0),
                                                        child: Image.memory(
                                                          imageData,
                                                          fit: BoxFit.contain,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.215,
                                                          height: MediaQuery.of(
                                                                      context)
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
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
                      ],
                    ),
                  ),

                  // ======================= Create Button =======================
                  SizedBox(
                    child: ValueListenableBuilder(
                      valueListenable: managerActivityState.isDisable,
                      builder: (context, value, child) {
                        if (value == true) {
                          return InkWell(
                            onTap: () {
                              if (Platform.isIOS) {
                                GlobalDialog.showCrossPlatformDialog(
                                  context,
                                  'Peringatan!',
                                  'Silakan periksa inputan Anda kembali.',
                                  () => Navigator.pop(context),
                                  'Tutup',
                                  isIOS: true,
                                );
                              } else {
                                GlobalDialog.showCrossPlatformDialog(
                                  context,
                                  'Peringatan!',
                                  'Silakan periksa kembali inputan Anda.',
                                  () => Navigator.pop(context),
                                  'Tutup',
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
                                vertical:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              child: ValueListenableBuilder(
                                valueListenable: managerActivityState.isLoading,
                                builder: (context, value, child) {
                                  if (value == true) {
                                    if (Platform.isIOS) {
                                      return const CupertinoActivityIndicator(
                                        radius: 12.5,
                                        color: Colors.white,
                                      );
                                    }
                                    return const CircleLoading(
                                      warna: Colors.white,
                                    );
                                  } else {
                                    return Text(
                                      'Buat',
                                      style: GlobalFont.giantfontRBold,
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              if (!managerActivityState.isLoading.value) {
                                createActivity(
                                  managerActivityState,
                                  managerActivityState
                                      .fetchManagerActivityTypeList,
                                  activityType,
                                  activityDescription,
                                );
                              } else {
                                if (Platform.isIOS) {
                                  GlobalDialog.showCrossPlatformDialog(
                                    context,
                                    'Peringatan!',
                                    'Mohon tunggu hingga proses selesai.',
                                    () => Navigator.pop(context),
                                    'Tutup',
                                    isIOS: true,
                                  );
                                } else {
                                  GlobalDialog.showCrossPlatformDialog(
                                    context,
                                    'Peringatan!',
                                    'Mohon tunggu hingga proses selesai.',
                                    () => Navigator.pop(context),
                                    'Tutup',
                                  );
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
                                vertical:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              child: ValueListenableBuilder(
                                valueListenable: managerActivityState.isLoading,
                                builder: (context, value, child) {
                                  if (value == true) {
                                    if (Platform.isIOS) {
                                      return const CupertinoActivityIndicator(
                                        radius: 12.5,
                                        color: Colors.white,
                                      );
                                    }
                                    return const CircleLoading(
                                      warna: Colors.white,
                                    );
                                  } else {
                                    return Text(
                                      'Buat',
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
                  ),
                ],
              ),
            ),
          ),
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
