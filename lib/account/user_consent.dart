// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:url_launcher/url_launcher.dart';

class UserConsentPage extends StatefulWidget {
  const UserConsentPage({super.key});

  @override
  State<UserConsentPage> createState() => _UserConsentPageState();
}

class _UserConsentPageState extends State<UserConsentPage> {
  bool isLocationGranted = false;
  bool isPhotoGranted = false;
  bool isCameraGranted = false;
  bool isPolicyGranted = false;

  ValueNotifier<List<bool>> userPermissionNotifier =
      ValueNotifier<List<bool>>([false, false, false, false]);

  void toggleLocationSwitch(bool value) {
    setState(() {
      isLocationGranted = !isLocationGranted;
    });

    userPermissionNotifier.value[0] = isLocationGranted;
  }

  void togglePhotoSwitch(bool value) {
    setState(() {
      isPhotoGranted = !isPhotoGranted;
    });

    userPermissionNotifier.value[1] = isPhotoGranted;
  }

  void toggleCameraSwitch(bool value) {
    setState(() {
      isCameraGranted = !isCameraGranted;
    });

    userPermissionNotifier.value[2] = isCameraGranted;
  }

  void togglePolicySwitch(bool value) {
    setState(() {
      isPolicyGranted = !isPolicyGranted;
    });

    userPermissionNotifier.value[3] = isPolicyGranted;
  }

  void launchLink(BuildContext context) async {
    Uri url =
        Uri.parse('https://yamaha-jatim.co.id/PrivacyPolicySIPSales.html');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Custom Alert Dialog for Android and iOS
      if (Platform.isIOS) {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oh no!',
          'Unable to open the link. Please check the URL and try again.',
          () => Navigator.pop(context),
          'Dismiss',
          isIOS: true,
        );
      } else {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Oops!',
          'Unable to open the link. Please check the URL and try again.',
          () => Navigator.pop(context),
          'Dismiss',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        centerTitle: true,
        toolbarHeight: (MediaQuery.of(context).size.width < 800)
            ? MediaQuery.of(context).size.height * 0.075
            : MediaQuery.of(context).size.height * 0.075,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(false),
          icon: Icon(
            Icons.arrow_back_ios,
            size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[300],
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.005,
                    bottom: MediaQuery.of(context).size.height * 0.0375,
                  ),
                  child: Text(
                    'SIP User Consent',
                    style: GlobalFont.petafontRBold,
                  ),
                ),

                // User Location Permission
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '1. ',
                                style: GlobalFont.mediumgiantfontR,
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                "SIP Sales would like to use device's location service in order to make the main feature, which are activity insertation works.",
                                style: GlobalFont.mediumgiantfontR,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Switch(
                          value: isLocationGranted,
                          onChanged: toggleLocationSwitch,
                          activeColor: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                ),

                // User Photo Permission
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '2. ',
                                style: GlobalFont.mediumgiantfontR,
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                "SIP Sales would like to use device's photo or gallery in order to take image directly from your device.",
                                style: GlobalFont.mediumgiantfontR,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Switch(
                          value: isPhotoGranted,
                          onChanged: togglePhotoSwitch,
                          activeColor: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                ),

                // User Camera Permission
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '3. ',
                                style: GlobalFont.mediumgiantfontR,
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                "SIP Sales would like to use device's camera in order to take photo directly from your device.",
                                style: GlobalFont.mediumgiantfontR,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Switch(
                          value: isCameraGranted,
                          onChanged: toggleCameraSwitch,
                          activeColor: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                ),

                // App Privacy Policy
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '4. ',
                                style: GlobalFont.mediumgiantfontR,
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                children: [
                                  Text(
                                    "SIP Sales would like to ask User's agreement regarding SIP Privacy Policy.",
                                    style: GlobalFont.mediumgiantfontR,
                                  ),
                                  InkWell(
                                    onTap: () => launchLink(context),
                                    child: Text(
                                      "https://yamaha-jatim.co.id/PrivacyPolicySIPSales.html",
                                      style: GlobalFont
                                          .mediumgiantfontRBlueUnderlined,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Switch(
                          value: isPolicyGranted,
                          onChanged: togglePolicySwitch,
                          activeColor: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Return Button
            ValueListenableBuilder(
              valueListenable: userPermissionNotifier,
              builder: (context, value, child) {
                if (value[0] || value[1] || value[2] || value[3]) {
                  return InkWell(
                    onTap: () => Navigator.of(context).pop(true),
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.055,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Text(
                        'Return',
                        style: GlobalFont.mediumgiantfontRBoldWhite,
                      ),
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: () => Navigator.of(context).pop(false),
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.055,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Text(
                        'Return',
                        style: GlobalFont.mediumgiantfontRBold,
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
