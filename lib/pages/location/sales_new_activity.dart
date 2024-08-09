// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/dropdown/custom_dropdown.dart';
import 'package:sip_sales/widget/format.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:info_popup/info_popup.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SalesNewActivityPage extends StatefulWidget {
  const SalesNewActivityPage({super.key});

  @override
  State<SalesNewActivityPage> createState() => _SalesNewActivityPageState();
}

class _SalesNewActivityPageState extends State<SalesNewActivityPage> {
  // Camera Controller
  late Permission cameraPermission;

  // Panel Controller
  PanelController panelController = PanelController();
  bool isOpen = false;

  // Profile
  String name = '';
  String number = '';

  // Date
  String date = DateTime.now().toString().substring(0, 10);
  String time = TimeOfDay.now().toString().substring(10, 15);

  // Activity Details
  String activityType = 'PROSPEK';
  String activityDescription = '';
  String activityTemplate = '';

  // Loading
  bool isLoading = false;

  void setName(String value) {
    name = value;
  }

  void setNumber(String value) {
    number = value;
  }

  void setDate(String value) {
    date = value;
  }

  void setTime(String value) {
    time = value;
  }

  void setActivityType(String value) {
    activityType = value;
  }

  void setActivityDescription(String value) {
    activityDescription = value;
  }

  void setInsertationDate(
    BuildContext context,
    String tgl,
    Function handle,
  ) async {
    tgl = tgl == '' ? DateTime.now().toString().substring(0, 10) : tgl;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl == '' ? DateTime.now() : DateTime.parse(tgl),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    // print('Selected Date: $picked');

    if (picked != null && picked != DateTime.parse(tgl)) {
      setState(() {
        tgl = picked.toString().substring(0, 10);
      });
      handle(tgl);
    }
  }

  void setInsertationTime(
    BuildContext context,
    String time,
    Function handle,
  ) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        time = picked.toString().substring(10, 15);
      });
    }
    handle(time);
  }

  Future showPopUpInformation(String value) async {
    print('pressed');
    InfoPopupWidget(
      arrowTheme: const InfoPopupArrowTheme(
        color: Colors.pink,
      ),
      contentTitle: 'INFORMATION',
      child: Text(value),
    );
  }

  void onTap() {
    isOpen = !isOpen;
    if (isOpen == true) {
      panelController.open();
    } else {
      panelController.close();
    }
  }

  void assetHandler(SipSalesState state) async {
    if (state.fetchFilteredList.isEmpty) {
      uploadImage(
        context,
        state,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 5),
          content: Text(
            'You only allowed to upload 1 image, please delete your image first',
          ),
        ),
      );
    }
  }

  void removeImage(SipSalesState state, int index) async {
    state.setIsDisable(true);
    state.removeImage(index);
    onTap();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image successfully deleted'),
      ),
    );
  }

  void uploadImage(
    BuildContext context,
    SipSalesState state,
  ) async {
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isGranted) {
      // print('Camera Permission granted');
      if (!await state.uploadImageFromCamera(context)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              'Upload image cancelled.',
            ),
          ),
        );
      }
    } else {
      // print('Camera Permission denied');
      cameraStatus = await Permission.camera.request();
      if (cameraStatus != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              'Please change your camera permission in app settings.',
            ),
          ),
        );
      } else {
        uploadImage(context, state);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // State Management
    final salesActivityState = Provider.of<SipSalesState>(context);

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
                    onTap: () => removeImage(salesActivityState, 0),
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
        height: MediaQuery.of(context).size.height,
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
          children: [
            Row(
              children: [
                Text(
                  'Activity Details *',
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
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04,
                        vertical: MediaQuery.of(context).size.height * 0.005,
                      ),
                      child: CustomDropDown(
                        listData: salesActivityState.fetchsalesActivityTypeList,
                        inputan: activityType,
                        hint: 'Sales Activity Type',
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
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
              ),
              child: TextField(
                maxLines: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9./@\s]*'),
                  ),
                  UpperCaseText(),
                ],
                controller: TextEditingController(
                  text: activityDescription,
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
                onChanged: (newValues) => setActivityDescription(newValues),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Row(
                children: [
                  Text(
                    'Timeline *',
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
                    contentTitle: 'Type current date and time.',
                    child: Icon(
                      Icons.info_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date',
                      style: GlobalFont.mediumgiantfontR,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () => setInsertationDate(
                        context,
                        date,
                        setDate,
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                          vertical: MediaQuery.of(context).size.height * 0.005,
                        ),
                        child: Text(
                          Format.tanggalFormat(date),
                          style: GlobalFont.mediumgiantfontR,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Row(
                children: [
                  Text(
                    'Profile',
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
                        "Type customer's name and phone number. Phone number must be start without 0!",
                    child: Icon(
                      Icons.info_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Name',
                      style: GlobalFont.mediumgiantfontR,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.045,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9./@\s]*'),
                          ),
                          UpperCaseText(),
                        ],
                        controller: TextEditingController(
                          text: name,
                        ),
                        enabled: true,
                        style: GlobalFont.mediumgiantfontR,
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
                          hintText: 'Masukkan nama',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onChanged: (newValues) => setName(newValues),
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
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Number',
                      style: GlobalFont.mediumgiantfontR,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.045,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp(r'^0'), // Deny leading 0
                            replacementString: '', // Replace with nothing
                          ),
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^-?[0-9.]*'),
                          ),
                          UpperCaseText(),
                        ],
                        controller: TextEditingController(
                          text: number,
                        ),
                        enabled: true,
                        style: GlobalFont.mediumgiantfontR,
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
                          hintText: 'Masukkan nomor telepon',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onChanged: (newValues) => setNumber(newValues),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                        'Photos *',
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
                        contentTitle: 'Upload a photo using camera.',
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
                    onTap: () => assetHandler(salesActivityState),
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
                  // Note -> remove later, if it's not being used
                  ValueListenableBuilder(
                    valueListenable: salesActivityState.getIsUploading,
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
                              itemCount: salesActivityState.filteredList.length,
                              itemBuilder: (context, index) {
                                final imageData = base64Decode(
                                    salesActivityState.filteredList[index]);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: onTap,
                                      onLongPress: null,
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
            ValueListenableBuilder(
              valueListenable: salesActivityState.isDisable,
              builder: (context, value, child) {
                if (value == true) {
                  return InkWell(
                    onTap: null,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      width: MediaQuery.of(context).size.width,
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
                        valueListenable: salesActivityState.isLoading,
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
                    onTap: () => salesActivityState.createSalesActivity(
                      context,
                      name,
                      number,
                      date,
                      salesActivityState.fetchsalesActivityTypeList,
                      activityType,
                      activityDescription,
                    ),
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
                        valueListenable: salesActivityState.isLoading,
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
