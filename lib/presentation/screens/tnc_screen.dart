import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/switch/text.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  bool isLocationGranted = false;
  bool isPhotoGranted = false;
  bool isCameraGranted = false;
  bool isPolicyGranted = false;

  ValueNotifier<List<bool>> userPermissionNotifier = ValueNotifier<List<bool>>([
    false,
    false,
    false,
    false,
  ]);

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
    Uri url = Uri.parse(
      'https://yamaha-jatim.co.id/PrivacyPolicySIPSales.html',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Custom Alert Dialog for Android and iOS
      if (Platform.isIOS) {
        Functions.customFlutterToast(
          'Unable to open the link. Please check the URL and try again.',
        );
      } else {
        Functions.customFlutterToast(
          'Unable to open the link. Please check the URL and try again.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          centerTitle: true,
          // toolbarHeight: 60,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          title: Text(
            'Syarat & Ketentuan',
            style: TextThemes.normalTextButton.copyWith(fontSize: 18),
          ),
          leading: Builder(
            builder: (context) {
              if (Platform.isIOS) {
                return IconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: (MediaQuery.of(context).size.width < 800)
                        ? 20.0
                        : 35.0,
                    color: Colors.black,
                  ),
                );
              } else {
                return IconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size: (MediaQuery.of(context).size.width < 800)
                        ? 20.0
                        : 35.0,
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                spacing: 12,
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

              // Return Button
              ValueListenableBuilder(
                valueListenable: userPermissionNotifier,
                builder: (context, value, child) {
                  if (value[0] || value[1] || value[2] || value[3]) {
                    return InkWell(
                      onTap: () => Navigator.pop(context, true),
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.055,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Text(
                          'Return',
                          style: TextThemes.normalTextButton.copyWith(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () => Navigator.pop(context, false),
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.055,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Text(
                          'Return',
                          style: TextThemes.normalTextButton,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
