// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/account/register.dart';
import 'package:sip_sales/account/user_consent.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
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

  void displayProminentDisclosure(
    bool isAccept,
    SipSalesState state,
  ) async {
    if (isAccept) {
      Navigator.of(context).pop();

      await Future.delayed(const Duration(seconds: 1)).then((_) async {
        isUserGranted = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserConsentPage(),
          ),
        );

        if (isUserGranted) {
          state.setIsUserAgree(true);
          Navigator.pushReplacementNamed(context, '/location');
        } else {
          state.setIsUserAgree(false);
          GlobalFunction.tampilkanDialog(
            context,
            true,
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SIP Care',
                    style: GlobalFont.giantfontRBold,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Please enable at least one permission inside SIP User Consent page in order to continue.',
                    style: GlobalFont.mediumgiantfontR,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Tap anywhere to dismiss.',
                    style: GlobalFont.mediumbigfontR,
                  ),
                ],
              ),
            ),
          );
        }
      });
    } else {
      state.setIsUserAgree(false);
      Navigator.of(context).pop();

      GlobalFunction.tampilkanDialog(
        context,
        true,
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SIP Care',
                style: GlobalFont.giantfontRBold,
              ),
              const SizedBox(height: 20),
              Text(
                'Please make sure you accept the SIP Care in order to maximize the App Performance.',
                style: GlobalFont.mediumgiantfontR,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                'Tap anywhere to dismiss.',
                style: GlobalFont.mediumbigfontR,
              ),
            ],
          ),
        ),
      );
    }
  }

  void login(SipSalesState state) async {
    // S2207/009097
    // 932518
    if (nip != '' && password != '') {
      toggleIsLoading();
      userLogin = await GlobalAPI.fetchUserAccount(nip, password);
      if (userLogin.isNotEmpty) {
        if (userLogin[0].flag == 1) {
          setState(() {
            loginStatus = 'Login berhasil.';
          });

          Future.delayed(const Duration(seconds: 2)).then((value) async {
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
            toggleIsLoading();

            if (state.getIsUserAgree == true) {
              Navigator.pushReplacementNamed(context, '/location');
            } else {
              GlobalFunction.displayProminentDisclosure(
                context,
                Container(
                  height: MediaQuery.of(context).size.height * 0.275,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.025,
                    vertical: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'SIP Care',
                          style: GlobalFont.giantfontRBold,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'SIP Sales collects location data for location service to enable an activity insertation when the app is in use.',
                          style: GlobalFont.mediumgiantfontR,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  displayProminentDisclosure(false, state),
                              style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.blue,
                                  width: 2.5,
                                ),
                              ),
                              child: Text(
                                'Deny',
                                style: GlobalFont.bigfontR,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  displayProminentDisclosure(true, state),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: Text(
                                'Accept',
                                style: GlobalFont.bigfontRWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          });
        } else if (userLogin[0].flag == 2) {
          toggleIsLoading();
          setState(() {
            loginStatus = userLogin[0].memo;
          });
        } else {
          toggleIsLoading();
          setState(() {
            loginStatus = 'Wrong username or password.';
          });

          Future.delayed(const Duration(seconds: 2)).then((value) async {
            setState(() {
              loginStatus = '';
            });
          });
        }
      } else {
        setState(() {
          loginStatus = 'Try again.';
        });
      }
    } else {
      setState(() {
        loginStatus = 'Please check your input again.';
      });

      Future.delayed(const Duration(seconds: 2)).then((value) async {
        setState(() {
          loginStatus = '';
        });
      });
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
                  child: Text(
                    'LOGIN',
                    style: GlobalFont.petafontRBold,
                  ),
                ),
                CustomUserInput2(
                  setNIP,
                  nip,
                  mode: 0,
                  isIcon: true,
                  icon: Icons.person,
                  hint: 'NIP Karyawan',
                  isCapital: true,
                ),
                CustomUserInput2(
                  setPassword,
                  password,
                  mode: 0,
                  isPass: true,
                  isIcon: true,
                  icon: Icons.lock,
                  hint: 'Password',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loginStatus,
                      style: GlobalFont.mediumbigfontM,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Create Account',
                        style: GlobalFont.mediumBigfontRTextButtonBlue,
                      ),
                    ),
                  ],
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
                    height: 50,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: isLoading
                        ? const CircleLoading(
                            warna: Colors.white,
                          )
                        : Text(
                            'SIGN IN',
                            style: (MediaQuery.of(context).size.width < 800)
                                ? GlobalFont.mediumgiantfontRBoldWhite
                                : GlobalFont.mediumgigafontMBoldWhite,
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
