// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/account/register.dart';
import 'package:sip_sales/account/user_consent.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:sip_sales/widget/text/custom_text.dart';
import 'package:sip_sales/widget/textfield/customuserinput2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String nip = '';
  String password = '';
  int? userState = 0;
  String loginStatus = '';
  List<ModelUser> userLogin = [];
  bool? isLocationGranted = false;
  bool isLoading = false;
  bool isUserGranted = false;

  void setNIP(String value) {
    nip = value;
  }

  void setPassword(String value) {
    password = value;
  }

  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  // Note -> move this checking function inside Splash Screen
  void loginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userState = prefs.getInt('flag');
    isLocationGranted = prefs.getBool('isLocationGranted');

    setState(() {
      loginStatus = '';
    });

    if (userState == 1 && isLocationGranted == true) {
      Navigator.pushReplacementNamed(context, '/location');
    }
  }

  // Note -> This function is not used in the current codebase
  // void displayProminentDisclosure(
  //   bool isAccept,
  //   SipSalesState state,
  // ) async {
  //   Navigator.pop(context);
  //
  //   if (isAccept) {
  //     await Future.delayed(const Duration(seconds: 1)).then((_) async {
  //       isUserGranted = await Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const UserConsentPage(),
  //         ),
  //       );
  //
  //       if (isUserGranted) {
  //         state.setIsUserAgree(true);
  //         Navigator.pushReplacementNamed(context, '/location');
  //       } else {
  //         state.setIsUserAgree(false);
  //
  //         if (Platform.isIOS) {
  //           GlobalDialog.showCustomIOSDialog(
  //             context,
  //             'SIP Care',
  //             'Please enable at least one permission inside SIP User Consent page in order to continue.',
  //             () => Navigator.pop(context),
  //             'Dismiss',
  //           );
  //         } else {
  //           GlobalDialog.showCustomAndroidDialog(
  //             context,
  //             'SIP Care',
  //             'Please enable at least one permission inside SIP User Consent page in order to continue.',
  //             () => Navigator.pop(context),
  //             'Dismiss',
  //           );
  //         }
  //       }
  //     });
  //   } else {
  //     state.setIsUserAgree(false);
  //   }
  // }

  void displayProminentDisclosure(SipSalesState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isUserGranted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserConsentPage(),
      ),
    );

    if (isUserGranted) {
      await prefs.setBool('isUserAgree', true);
      state.setIsUserAgree(true);
      Navigator.pushReplacementNamed(context, '/location');
    } else {
      await prefs.setBool('isUserAgree', false);
      state.setIsUserAgree(false);
      setState(() {
        loginStatus = 'Login Cancelled.';
      });
    }
  }

  void login(SipSalesState state) async {
    // S2207/009097
    // 932518
    if (nip != '' && password != '') {
      toggleIsLoading();

      await state.generateUuid().then(
        (String uuid) async {
          try {
            userLogin.clear();
            userLogin.addAll(await GlobalAPI.fetchUserAccount(
              nip,
              password,
              uuid,
            ));
          } catch (e) {
            print('Error: $e');
          }
        },
      );

      if (userLogin.isNotEmpty) {
        print(userLogin[0].employeeName);
        if (userLogin[0].flag == 1) {
          // setState(() {
          //   loginStatus = 'Login Success.';
          // });

          Future.delayed(const Duration(seconds: 2)).then(
            (value) async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setInt('flag', 1);
              await prefs.setString('nip', nip);
              await prefs.setString('password', password);
              await prefs.setBool('attendanceStatus', false);
              await prefs.setString('branch', userLogin[0].branch);
              await prefs.setString('shop', userLogin[0].shop);
              await prefs.setInt('isManager', userLogin[0].code);
              await prefs.setBool('isLocationGranted', false);
              await prefs.setBool('checkInStatus', true);
              await prefs.setBool('checkOutStatus', false);
              await prefs.setBool('isShowCaseCompleted', true);

              // ~:NEW:~
              if (userLogin[0].code == 1 ||
                  state.getManagerActivityTypeList.isEmpty) {
                // Note -> get Activity Insertation dropdown for Manager
                await Provider.of<SipSalesState>(context, listen: false)
                    .fetchManagerActivityData();
              } else {
                // Note -> get Activity Insertation dropdown for Sales
                await Provider.of<SipSalesState>(context, listen: false)
                    .fetchSalesActivityData();
              }

              // Load and save HD image to cache memory
              try {
                state.setProfilePicture(userLogin[0].profilePicture);
                await GlobalAPI.fetchShowImage(userLogin[0].employeeID)
                    .then((String highResImg) async {
                  if (highResImg == 'not available' ||
                      highResImg == 'failed' ||
                      highResImg == 'error') {
                    state.setProfilePicturePreview('');
                    await prefs.setString('highResImage', '');
                    print('High Res Image is not available.');
                  } else {
                    state.setProfilePicturePreview(highResImg);
                    await prefs.setString('highResImage', highResImg);
                    print('High Res Image successfully loaded.');
                    print('High Res Image: $highResImg');
                  }
                });
              } catch (e) {
                print('Show HD Image Error: $e');
                state.setProfilePicturePreview('');
                await prefs.setString('highResImage', '');
              }
              // ~:NEW:~

              toggleIsLoading();

              if (prefs.getBool('isUserAgree') ?? false) {
                Navigator.pushReplacementNamed(context, '/location');
              } else {
                displayProminentDisclosure(state);
              }
            },
          );
        } else if (userLogin[0].flag == 2) {
          toggleIsLoading();
          if (Platform.isIOS) {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Peringatan!',
              userLogin[0].memo,
              () => Navigator.pop(context),
              'Tutup',
              isIOS: true,
            );
          } else {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Peringatan!',
              userLogin[0].memo,
              () => Navigator.pop(context),
              'Tutup',
            );
          }
        } else {
          toggleIsLoading();
          if (Platform.isIOS) {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Peringatan!',
              'Username atau password salah.',
              () => Navigator.pop(context),
              'Tutup',
              isIOS: true,
            );
          } else {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Peringatan!',
              'Username atau password salah.',
              () => Navigator.pop(context),
              'Tutup',
            );
          }
        }
      } else {
        toggleIsLoading();
        if (Platform.isIOS) {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Peringatan!',
            'Coba lagi.',
            () => Navigator.pop(context),
            'Tutup',
            isIOS: true,
          );
        } else {
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Peringatan!',
            'Coba lagi.',
            () => Navigator.pop(context),
            'Tutup',
          );
        }
      }
    } else {
      toggleIsLoading();
      if (Platform.isIOS) {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Peringatan!',
          'Mohon periksi input anda kembali.',
          () => Navigator.pop(context),
          'Tutup',
          isIOS: true,
        );
      } else {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Peringatan!',
          'Mohon periksi input anda kembali.',
          () => Navigator.pop(context),
          'Tutup',
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loginState();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    nip = '';
    password = '';
    userState = 0;
    loginStatus = '';
    userLogin.clear();
  }

  @override
  Widget build(BuildContext context) {
    final signInState = Provider.of<SipSalesState>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.grey[300],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.1,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage('assets/SIP.png'),
                  width: MediaQuery.of(context).size.width * 0.55,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.025,
                  ),
                  child: CustomText(
                    'LOGIN',
                    fontSize: MediaQuery.of(context).size.width * 0.075,
                    isBold: true,
                  ),
                ),
                CustomUserInput2(
                  setNIP,
                  nip,
                  mode: 0,
                  isIcon: true,
                  icon: Icons.person,
                  label: 'NIP Karyawan',
                  isCapital: true,
                ),
                CustomUserInput2(
                  setPassword,
                  password,
                  mode: 0,
                  isPass: true,
                  isIcon: true,
                  icon: Icons.lock,
                  label: 'Password',
                ),
                // CustomText(
                //   loginStatus,
                //   fontFamily: GlobalFontFamily.fontMontserrat,
                //   fontSize: MediaQuery.of(context).size.width * 0.03,
                // ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: CustomText(
                      'Create Account',
                      color: Colors.blue,
                      fontSize: MediaQuery.of(context).size.width * 0.0325,
                      decor: TextDecoration.underline,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    shadowColor: Colors.black,
                    elevation: 7.5,
                  ),
                  onPressed: () => login(signInState),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: Builder(
                      builder: (context) {
                        if (isLoading) {
                          return Builder(
                            builder: (context) {
                              if (Platform.isIOS) {
                                return const CupertinoActivityIndicator(
                                  radius: 12.5,
                                  color: Colors.white,
                                );
                              } else {
                                return const CircleLoading(
                                  warna: Colors.white,
                                );
                              }
                            },
                          );
                        } else {
                          return CustomText(
                            'SIGN IN',
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            isBold: true,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
