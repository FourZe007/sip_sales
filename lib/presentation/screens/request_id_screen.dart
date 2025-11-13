import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/cubit/forgot_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/textfields/user_input.dart';

class RequestIdScreen extends StatefulWidget {
  const RequestIdScreen({super.key});

  @override
  State<RequestIdScreen> createState() => _RequestIdScreenState();
}

class _RequestIdScreenState extends State<RequestIdScreen> {
  String phoneNumber = '';

  void setPhoneNumber(String value) {
    phoneNumber = value;
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
            'Request Id',
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
                      spacing: 8,
                      children: [
                        // ~:Title Section:~
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ~:Page Title:~
                            Text(
                              'Detail Pengajuan',
                              style: TextThemes.normal.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // ~:Page Subtitle:~
                            Text(
                              'Masukkan informasi lengkap terkait request id karyawan.',
                              style: TextThemes.normal.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        // ~:Body Section:~
                        Column(
                          children: [
                            // ~:Phone Number Form:~
                            CustomUserInput(
                              setPhoneNumber,
                              phoneNumber,
                              mode: 0,
                              isIcon: true,
                              icon: Icons.phone_rounded,
                              label: 'Nomor telepon',
                              isNumber: true,
                            ),

                            // ~:Additional Note:~
                            Text(
                              'Note: pastikan nomor telepon yang diinputkan sesuai dengan nomor yang terdaftar di SIP.',
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
                ),

                // ~:Footer:~
                ElevatedButton(
                  onPressed: () =>
                      context.read<ForgotCubit>().requestId(phoneNumber),
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
                      if (state is RequestIdFailed) {
                        Functions.customFlutterToast(state.message);
                      } else if (state is RequestIdSucceed) {
                        Functions.customFlutterToast(
                          'Request ID berhasil!',
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
