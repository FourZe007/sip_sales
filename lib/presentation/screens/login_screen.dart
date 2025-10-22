import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_event.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_event.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_type.dart';
import 'package:sip_sales_clean/presentation/cubit/navbar_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/buttons/static_button.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/textfields/user_input.dart';
import 'package:sip_sales_clean/presentation/widgets/texts/title.dart';
import 'package:upgrader/upgrader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String employeeId = '';
  String password = '';

  void setEmployeeId(String id) {
    employeeId = id.toUpperCase();
  }

  void setPassword(String pass) {
    password = pass;
  }

  @override
  Widget build(BuildContext context) {
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
                              CustomUserInput(
                                setEmployeeId,
                                employeeId,
                                mode: 0,
                                isIcon: true,
                                icon: Icons.person,
                                label: 'NIP Karyawan',
                                isCapital: true,
                              ),
                              CustomUserInput(
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
                            onPressed: () async {
                              log('Login Button Pressed');
                              log('Employee ID: $employeeId');
                              log('Password: $password');

                              context.read<LoginBloc>().add(
                                LoginButtonPressed(
                                  context: context,
                                  id: employeeId,
                                  pass: password,
                                ),
                              );
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: BlocConsumer<LoginBloc, LoginState>(
                                listener: (context, state) async {
                                  log('Login state: $state');
                                  if (state is LoginUnauthenticated) {
                                    Functions.customFlutterToast(
                                      'NIP dan Password tidak boleh kosong',
                                    );
                                  } else if (state is LoginFailed) {
                                    Functions.customFlutterToast(state.message);
                                  } else if (state is LoginSuccess) {
                                    // make sure the user enter the initiated navbar
                                    context
                                        .read<NavbarCubit>()
                                        .changeNavbarType(0);

                                    if (state.user.code == 2) {
                                      if (context.mounted) {
                                        context.read<ShopCoordinatorBloc>().add(
                                          LoadCoordinatorDashboard(
                                            state.user.employeeID,
                                            DateTime.now()
                                                .toIso8601String()
                                                .split('T')[0],
                                          ),
                                        );

                                        context
                                            .read<DashboardTypeCubit>()
                                            .changeType(DashboardType.salesman);

                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/home',
                                        );
                                      }
                                    } else {
                                      if (state.user.code == 0) {
                                        context
                                            .read<NavbarCubit>()
                                            .changeNavbarType(0);
                                      }

                                      Functions.displayProminentDisclosure(
                                        context,
                                      );
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
                                      return const AndroidLoading(
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
                        'v1.2.0 beta',
                        style: TextThemes.normal,
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
                              () => Functions.openUserGuideline(
                                context,
                                'https://www.canva.com/design/DAGfnPUa7_Q/nE2tAQYp5NGFOTKE_SrzvQ/edit?utm_content=DAGfnPUa7_Q&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton',
                              ),
                              Icons.menu_book_rounded,
                              'Manual Book',
                            ),

                            // ~:Unbind Button:~
                            StaticButton(
                              () => Functions.loginUtilization(context, '0'),
                              Icons.person_off_rounded,
                              'Request Unbind',
                            ),

                            // ~:NIP Button:~
                            StaticButton(
                              () => Functions.loginUtilization(context, '1'),
                              Icons.badge,
                              'Request NIP',
                            ),

                            // ~:Reset Button:~
                            StaticButton(
                              () => Functions.loginUtilization(context, '2'),
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
