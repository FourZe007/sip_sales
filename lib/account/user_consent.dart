// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/widget/button/text_switch.dart';
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
        leading: Builder(
          builder: (context) {
            if (Platform.isIOS) {
              return IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            } else {
              return IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            }
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[300],
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // SIP User Consent Title
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.005,
                    bottom: MediaQuery.of(context).size.height * 0.025,
                  ),
                  child: Text(
                    'SIP User Consent',
                    style: GlobalFont.petafontRBold,
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.675,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // User Location Permission
                      TextSwitch(
                        '1. ',
                        'SIP Sales ingin menggunakan layanan lokasi perangkat untuk menggunakan fitur utama, yaitu penambahan aktivitas berfungsi.',
                        isLocationGranted,
                        toggleLocationSwitch,
                      ),

                      // User Photo Permission
                      TextSwitch(
                        '2. ',
                        'SIP Sales ingin menggunakan foto dari perangkat untuk mengambil gambar langsung dari perangkat Anda.',
                        isPhotoGranted,
                        togglePhotoSwitch,
                      ),

                      // User Camera Permission
                      TextSwitch(
                        '3. ',
                        'SIP Sales ingin menggunakan kamera dari perangkat untuk mengambil gambar langsung dari perangkat Anda.',
                        isCameraGranted,
                        toggleCameraSwitch,
                      ),

                      // App Privacy Policy
                      TextSwitch(
                        '4. ',
                        'SIP Sales ingin meminta persetujuan Pengguna mengenai Kebijakan Privasi SIP.',
                        isPolicyGranted,
                        togglePolicySwitch,
                        isLinkAvailable: true,
                        link:
                            'https://yamaha-jatim.co.id/PrivacyPolicySIPSales.html',
                        linkFunction: (dynamic) => launchLink(context),
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
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.025,
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
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.025,
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
