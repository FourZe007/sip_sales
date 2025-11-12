import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/forgot_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/textfields/user_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    this.isResetPassword = false,
    super.key,
  });

  final bool isResetPassword;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String currentPassword = '';
  String newPassword = '';
  String confirmNewPassword = '';

  void setCurrentPassword(String pass) {
    currentPassword = pass;
  }

  void setNewPassword(String pass) {
    newPassword = pass;
  }

  void setConfirmNewPassword(String pass) {
    confirmNewPassword = pass;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          toolbarHeight: 60,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          shadowColor: Colors.blue,
          centerTitle: true,
          titleSpacing: 16,
          title: Text(
            'Lupa Password',
            style: TextThemes.normal.copyWith(fontSize: 16),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Platform.isIOS
                  ? Icons.arrow_back_ios_new_rounded
                  : Icons.arrow_back_rounded,
              size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
              color: Colors.black,
            ),
          ),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Column(
              spacing: 16,
              children: [
                // ~:Header:~
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      spacing: 12,
                      children: [
                        // ~:Title Section:~
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ~:Page Title:~
                            Text(
                              'Kata Sandi Baru',
                              style: TextThemes.normal.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // ~:Page Subtitle:~
                            BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                                // if (widget.isResetPassword) {
                                //   return Text(
                                //     'Buat kata sandi baru untuk akun anda.',
                                //     style: TextThemes.normal.copyWith(
                                //       fontSize: 14,
                                //     ),
                                //   );
                                // } else {}
                                if (state is LoginSuccess) {
                                  return Text(
                                    'Buat kata sandi baru untuk akun dengan ID ${state.user.employeeID}',
                                    style: TextThemes.normal.copyWith(
                                      fontSize: 16,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'Buat kata sandi baru untuk akun anda',
                                    style: TextThemes.normal.copyWith(
                                      fontSize: 16,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),

                        // ~:Body Section:~
                        Column(
                          spacing: 4,
                          children: [
                            // ~:Current Password Form:~
                            CustomUserInput(
                              setCurrentPassword,
                              currentPassword,
                              mode: 0,
                              isPass: true,
                              isIcon: true,
                              useHint: false,
                              icon: Icons.lock,
                              label: 'Kata Sandi Lama',
                              useValidator: true,
                              passDiscriminator: currentPassword,
                            ),

                            // ~:New Password Form:~
                            CustomUserInput(
                              setNewPassword,
                              newPassword,
                              mode: 0,
                              isPass: true,
                              isIcon: true,
                              useHint: false,
                              icon: Icons.lock,
                              label: 'Kata Sandi Baru',
                              useValidator: true,
                              passDiscriminator: confirmNewPassword,
                            ),

                            // ~:New Password Form:~
                            CustomUserInput(
                              setConfirmNewPassword,
                              confirmNewPassword,
                              mode: 0,
                              isPass: true,
                              isIcon: true,
                              useHint: false,
                              icon: Icons.lock,
                              label: 'Ketik Ulang Kata Sandi Baru',
                              useValidator: true,
                              passDiscriminator: newPassword,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ~:Footer:~
                ElevatedButton(
                  onPressed: () => context.read<ForgotCubit>().forgotPassword(
                    (context.read<LoginBloc>().state as LoginSuccess)
                        .user
                        .employeeID,
                    currentPassword,
                    newPassword,
                  ),
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.95,
                      MediaQuery.of(context).size.height * 0.04,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: Colors.blue[300],
                  ),
                  child: BlocConsumer<ForgotCubit, ForgotState>(
                    listener: (context, state) async {
                      if (state is PasswordChangeFailed) {
                        Functions.customFlutterToast(state.message);
                      } else if (state is PasswordChangeSucceed) {
                        await Functions.readAndWriteUserPass(
                          pass: newPassword,
                          isLogin: true,
                        );
                        Functions.customFlutterToast(
                          'Password berhasil diubah',
                        );

                        if (context.mounted) {
                          context.read<ForgotCubit>().resetState();
                          Navigator.pop(context);
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is ForgotLoading) {
                        if (Platform.isIOS) {
                          return const CupertinoActivityIndicator(
                            radius: 12.5,
                            color: Colors.black,
                          );
                        } else {
                          return const AndroidLoading(
                            warna: Colors.black,
                            strokeWidth: 3,
                          );
                        }
                      } else {
                        return Text(
                          'Ubah',
                          style: TextThemes.normal.copyWith(fontSize: 16),
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
    );
  }
}
