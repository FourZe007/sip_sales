import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/cubit/forgot_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/textfields/user_input.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String id = '';

  void setId(String value) {
    id = value;
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
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // ~:Header:~
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ~:Title:~
                          Text(
                            'Detail Pengajuan',
                            style: TextThemes.normal.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // ~:Subtitle:~
                          Text(
                            'Masukkan informasi lengkap terkait reset password.',
                            style: TextThemes.normal.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      // ~:Body:~
                      Column(
                        spacing: 12,
                        children: [
                          // ~:ID Text Field:~
                          CustomUserInput(
                            setId,
                            id,
                            mode: 0,
                            isIcon: true,
                            icon: Icons.phone_rounded,
                            label: 'NIP karyawan',
                            isCapital: true,
                          ),

                          // ~:Additional Note:~
                          Text(
                            'Note: pastikan NIP yang diinputkan sesuai dengan NIP yang terdaftar di SIP.',
                            style: TextThemes.normal.copyWith(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ~:Footer:~
                ElevatedButton(
                  onPressed: () =>
                      context.read<ForgotCubit>().resetPassword(id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height * 0.05,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: BlocConsumer<ForgotCubit, ForgotState>(
                    listener: (context, state) {
                      if (state is PasswordResetFailed) {
                        Functions.customFlutterToast(state.message);
                      } else if (state is PasswordResetSucceed) {
                        Functions.customFlutterToast(
                          'Password berhasil direset',
                        );
                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is ForgotLoading) {
                        if (Platform.isIOS) {
                          return CupertinoActivityIndicator(
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
                          'Submit',
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
