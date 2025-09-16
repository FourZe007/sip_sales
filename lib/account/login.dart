// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/account/id_request.dart';
import 'package:sip_sales/account/password_reset.dart';
import 'package:sip_sales/account/unbind_request.dart';
import 'package:sip_sales/account/user_consent.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/enum.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/coordinatordashboard/coord_dashboard_bloc.dart';
import 'package:sip_sales/global/state/coordinatordashboard/coord_dashboard_event.dart';
import 'package:sip_sales/global/state/dashboardtype_cubit.dart';
import 'package:sip_sales/global/state/login/login_bloc.dart';
import 'package:sip_sales/global/state/login/login_event.dart';
import 'package:sip_sales/global/state/login/login_state.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/widget/button/static_button.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:sip_sales/widget/text/custom_text.dart';
import 'package:sip_sales/widget/textfield/customuserinput2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

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
  // List<ModelUser> userLogin = [];
  bool? isLocationGranted = false;
  bool isLoading = false;
  bool isUserGranted = false;

  void setNIP(String value) {
    nip = value.toUpperCase();
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

  void oldLogin(SipSalesState state) async {
    // S2207/009097
    // 932518
    if (nip != '' && password != '') {
      toggleIsLoading();

      await state.readAndWriteUserId(id: nip, isLogin: true);
      await state.readAndWriteUserPass(pass: password, isLogin: true);
      await state.readAndWriteDeviceConfig();

      log('Device Configuration: ${state.getDeviceConfiguration}');

      await state.generateUuid().then((String uuid) async {
        log('UUID: $uuid');
        try {
          await GlobalAPI.fetchUserAccount(
            nip,
            password,
            uuid,
            state.getDeviceConfiguration,
          ).then((res) {
            state.setUserAccountList(res);
          });
        } catch (e) {
          log('Error fetchUserAccount: $e');
          state.setUserAccountList([]);
        }
      });

      if (state.getUserAccountList.isNotEmpty) {
        log(state.getUserAccountList[0].employeeName);
        if (state.getUserAccountList[0].flag == 1) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await state
              .readAndWriteIsUserManager(
                  state: state.getUserAccountList[0].code == 0 ? true : false,
                  isLogin: true)
              .then((value) {
            if (value) {
              log('User is manager');
            } else {
              log('User is sales');
            }
          });

          // ~:NEW:~
          if (await state.readAndWriteIsUserManager() ||
              state.getManagerActivityTypeList.isEmpty) {
            log('Manager');
            // Note -> get Activity Insertation dropdown for Manager
            await state.fetchManagerActivityData();
            await state.fetchManagerActivities().then((res) {
              state.setManagerActivities(res);
            });
          } else {
            log('Sales');
            // ~:Sales Old Activity Insertation:~
            // Note -> get Activity Insertation dropdown for Sales
            // await Provider.of<SipSalesState>(context, listen: false)
            //     .fetchSalesActivityData();

            // ~:Sales New Activity Insertation:~
            await state.getUserAttendanceHistory();
            await state.getSalesDashboard();

            // ~:Reset dropdown default value to User's placement:~
            // state.setAbsentType(state.getUserAccountList[0].locationName);

            if (state.getUserAccountList.isNotEmpty &&
                state.getProfilePicture.isEmpty &&
                state.getProfilePicturePreview.isEmpty) {
              state.setProfilePicture(
                state.getUserAccountList[0].profilePicture,
              );

              try {
                await GlobalAPI.fetchShowImage(
                  state.getUserAccountList[0].employeeID,
                ).then((String highResImg) async {
                  if (highResImg == 'not available' ||
                      highResImg == 'failed' ||
                      highResImg == 'error') {
                    state.setProfilePicturePreview('');
                    await prefs.setString('highResImage', '');
                    log('High Res Image is not available.');
                  } else {
                    state.setProfilePicturePreview(highResImg);
                    await prefs.setString('highResImage', highResImg);
                    log('High Res Image successfully loaded.');
                    log('High Res Image: $highResImg');
                  }
                });
              } catch (e) {
                log('Show HD Image Error: $e');
                state.setProfilePicturePreview('');
                await prefs.setString('highResImage', '');
              }
            }
          }

          // Load and save HD image to cache memory
          try {
            state.setProfilePicture(state.getUserAccountList[0].profilePicture);
            await GlobalAPI.fetchShowImage(
              state.getUserAccountList[0].employeeID,
            ).then((String highResImg) async {
              if (highResImg == 'not available' ||
                  highResImg == 'failed' ||
                  highResImg == 'error') {
                state.setProfilePicturePreview('');
                await prefs.setString('highResImage', '');
                log('High Res Image is not available.');
              } else {
                state.setProfilePicturePreview(highResImg);
                await prefs.setString('highResImage', highResImg);
                log('High Res Image successfully loaded.');
                log('High Res Image: $highResImg');
              }
            });
          } catch (e) {
            log('Show HD Image Error: $e');
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
        } else if (state.getUserAccountList[0].flag == 2) {
          toggleIsLoading();
          // Login by new device, please contact admin to unbind the old device
          if (state.getUserAccountList[0].memo ==
              'Login by new device, please contact admin to unbind the old device') {
            state.setIsAccLocked(true);
          } else {
            state.setIsAccLocked(false);
          }

          GlobalDialog.showCrossPlatformDialog(
            context,
            'Peringatan!',
            state.getUserAccountList[0].memo,
            () => Navigator.pop(context),
            'Tutup',
            isIOS: Platform.isIOS ? true : false,
          );
        } else {
          toggleIsLoading();
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Peringatan!',
            'Username atau password salah.',
            () => Navigator.pop(context),
            'Tutup',
            isIOS: Platform.isIOS ? true : false,
          );
        }
      } else {
        toggleIsLoading();
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Peringatan!',
          'Coba lagi.',
          () => Navigator.pop(context),
          'Tutup',
          isIOS: Platform.isIOS ? true : false,
        );
      }
    } else {
      toggleIsLoading();
      GlobalDialog.showCrossPlatformDialog(
        context,
        'Peringatan!',
        'Mohon periksi input anda kembali.',
        () => Navigator.pop(context),
        'Tutup',
        isIOS: Platform.isIOS ? true : false,
      );
    }
  }

  void loginUtilization(
    SipSalesState state,
    // 0 -> request unbind, 1 -> request NIP, 2 -> reset password
    String option,
  ) {
    try {
      switch (option) {
        case '0':
          if (state.getIsAccLocked) {
            state.setUnbindReqTextController('');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UnbindRequestPage(),
              ),
            );
          } else {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Peringatan!',
              'Akun anda tidak terkunci. Silahkan coba login kembali.',
              () => Navigator.pop(context),
              'Tutup',
              isIOS: Platform.isIOS ? true : false,
            );
          }
          break;
        case '1':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IdRequestPage(),
            ),
          );
          break;
        case '2':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordResetPage(),
            ),
          );
          break;
        default:
          GlobalDialog.showCrossPlatformDialog(
            context,
            'Peringatan!',
            'Halaman tujuan tidak ditemukan. Mohon coba lagi.',
            () => Navigator.pop(context),
            'Tutup',
            isIOS: Platform.isIOS ? true : false,
          );
          break;
      }
    } catch (e) {
      log('Login Utilization Error: $e');
      GlobalDialog.showCrossPlatformDialog(
        context,
        'Peringatan!',
        'Terjadi kesalahan. Mohon coba lagi.',
        () => Navigator.pop(context),
        'Tutup',
        isIOS: Platform.isIOS ? true : false,
      );
    }
  }

  void openUserGuideline() async {
    Uri url = Uri.parse(
      'https://www.canva.com/design/DAGfnPUa7_Q/nE2tAQYp5NGFOTKE_SrzvQ/edit?utm_content=DAGfnPUa7_Q&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Custom Alert Dialog for Android and iOS
      GlobalDialog.showCrossPlatformDialog(
        context,
        'Oh no!',
        'Unable to open the link. Please check the URL and try again.',
        () => Navigator.pop(context),
        'Dismiss',
        isIOS: (Platform.isIOS) ? true : false,
      );
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
    // Provider.of<SipSalesState>(context, listen: false).userAccountList.clear();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<SipSalesState>(context);

    return UpgradeAlert(
      showIgnore: false,
      showLater: false,
      dialogStyle: (Platform.isIOS)
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      child: SafeArea(
        top: false,
        bottom: false,
        maintainBottomViewPadding: true,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            toolbarHeight: 0.0,
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            automaticallyImplyLeading: false,
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            color: Colors.grey[300],
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                // ~:Header & Body:~
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.83,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ~:Logo:~
                      Image(
                        image: const AssetImage('assets/SIP.png'),
                        width: MediaQuery.of(context).size.width * 0.55,
                      ),

                      // ~:Title:~
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.025,
                        ),
                        child: CustomText(
                          'LOGIN',
                          fontSize: MediaQuery.of(context).size.width * 0.075,
                          isBold: true,
                        ),
                      ),

                      // ~:User Input:~
                      Column(
                        spacing: 8,
                        children: [
                          Column(
                            children: [
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
                            ],
                          ),

                          // ~:Submit Button:~
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              shadowColor: Colors.black,
                              elevation: 7.5,
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                            ),
                            // onPressed: () => oldLogin(state),
                            onPressed: () async {
                              if (nip.isNotEmpty && password.isNotEmpty) {
                                await appState.readAndWriteUserId(
                                    id: nip, isLogin: true);
                                await appState.readAndWriteUserPass(
                                    pass: password, isLogin: true);
                                await appState.readAndWriteDeviceConfig();
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'NIP dan Password tidak boleh kosong',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey[300],
                                  textColor: Colors.black,
                                  fontSize: 16.0,
                                );
                              }

                              context.read<LoginBloc>().add(
                                    LoginEvent(
                                      context: context,
                                      appState: context.read<SipSalesState>(),
                                      id: nip,
                                      pass: password,
                                    ),
                                  );
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: BlocConsumer<LoginBloc, LoginState>(
                                listener: (context, state) async {
                                  if (state is LoginFailed) {
                                    Fluttertoast.showToast(
                                      msg: state.message,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey[300],
                                      textColor: Colors.black,
                                      fontSize: 16.0,
                                    );
                                  } else if (state is LoginSuccess) {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setInt(
                                        'accessCode', state.user[0].code);
                                    prefs.setBool('isLoggedIn', true);

                                    if (state.user[0].code == 2) {
                                      context
                                          .read<CoordinatorDashboardBloc>()
                                          .add(
                                            LoadCoordinatorDashboard(
                                              state.user[0].employeeID,
                                              DateTime.now()
                                                  .toIso8601String()
                                                  .split('T')[0],
                                            ),
                                          );

                                      context
                                          .read<DashboardTypeCubit>()
                                          .changeType(DashboardType.salesman);

                                      Navigator.pushNamed(context, '/menu');
                                    } else {
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (prefs.getBool('isUserAgree') ??
                                          false) {
                                        Navigator.pushReplacementNamed(
                                            context, '/location');
                                      } else {
                                        displayProminentDisclosure(appState);
                                      }
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  if (state is LoginLoading) {
                                    if (Platform.isIOS) {
                                      return const CupertinoActivityIndicator(
                                        radius: 12.5,
                                        color: Colors.white,
                                      );
                                    } else {
                                      return const CircleLoading(
                                        warna: Colors.white,
                                        customizedHeight: 20,
                                        customizedWidth: 20,
                                        strokeWidth: 3,
                                      );
                                    }
                                  } else {
                                    return CustomText(
                                      'SIGN IN',
                                      color: Colors.white,
                                      fontSize: 16,
                                      isBold: true,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ~:Footer:~
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 84,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ~:App Version:~
                      Text(
                        'v1.1.12',
                        style: GlobalFont.mediumbigfontR,
                      ),

                      // ~:More Button:~
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        physics: BouncingScrollPhysics(),
                        child: Wrap(
                          spacing: 10,
                          children: [
                            // ~:Manual Book:~
                            StaticButton(
                              () => openUserGuideline(),
                              Icons.menu_book_rounded,
                              'Manual Book',
                            ),

                            // ~:Unbind Button:~
                            StaticButton(
                              () => loginUtilization(appState, '0'),
                              Icons.person_off_rounded,
                              'Request Unbind',
                            ),

                            // ~:NIP Button:~
                            StaticButton(
                              () => loginUtilization(appState, '1'),
                              Icons.badge,
                              'Request NIP',
                            ),

                            // ~:Reset Button:~
                            StaticButton(
                              () => loginUtilization(appState, '2'),
                              Icons.lock_reset,
                              'Reset Password',
                            ),
                          ],
                        ),
                      ),
                    ],
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
