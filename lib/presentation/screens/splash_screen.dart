import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Functions.runSecurityCheck(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) async {
            log('Login State: $state');
            // if (state is LoginBlocked) {
            //   // Full-screen blocked UI is shown in builder — do nothing here
            // } else
            if (state is LoginUnauthenticated || state is LoginFailed) {
              if (state is LoginFailed &&
                  state.message.toLowerCase().contains('failed host lookup')) {
                log('No internet connection');
                Functions.customFlutterToast(
                  'No internet connection',
                );
              } else {
                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    ConstantRoutes.login,
                  );
                }
              }
            } else if (state is LoginSuccess) {
              log('Enroll Face');
              await Functions.enrollFaceIfNeeded(context, state.user);
              // On auto-login success, continue to next screen (e.g., location)
              if (context.mounted) {
                if (state.user.code == 2) {
                  Navigator.pushReplacementNamed(
                    context,
                    ConstantRoutes.home,
                  );
                } else {
                  Navigator.pushReplacementNamed(
                    context,
                    ConstantRoutes.location,
                  );
                }
              }
            }
          },
          builder: (context, state) {
            if (state is LoginBlocked) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.security_outlined,
                      size: 80,
                      color: Color(0xFFD32F2F),
                    ),
                    const Text(
                      'Perangkat Tidak Diizinkan',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A2340),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const Divider(),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          MediaQuery.of(context).size.width / 2,
                          52,
                        ),
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => SystemNavigator.pop(),
                      child: const Text(
                        'Tutup Aplikasi',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ~:Logo:~
                    Image(
                      image: const AssetImage('assets/SIP.png'),
                      width: MediaQuery.of(context).size.width * 0.55,
                      fit: BoxFit.cover,
                    ),

                    // ~:Loading Indicator:~
                    Builder(
                      builder: (context) {
                        if (Platform.isIOS) {
                          return const CupertinoActivityIndicator(
                            radius: 12,
                          );
                        } else {
                          return const AndroidLoading(
                            strokeWidth: 3,
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
