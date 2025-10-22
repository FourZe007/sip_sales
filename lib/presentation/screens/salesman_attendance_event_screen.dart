// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/presentation/blocs/attendance/attendance_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/attendance/attendance_event.dart';
import 'package:sip_sales_clean/presentation/blocs/attendance/attendance_state.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/image_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/textfields/adjustable_text_fields.dart';
import 'package:sip_sales_clean/presentation/widgets/texts/section_title.dart';

class SalesmanAttendanceEventScreen extends StatefulWidget {
  const SalesmanAttendanceEventScreen({super.key});

  @override
  State<SalesmanAttendanceEventScreen> createState() =>
      _SalesmanAttendanceEventScreenState();
}

class _SalesmanAttendanceEventScreenState
    extends State<SalesmanAttendanceEventScreen> {
  TextEditingController eventTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          toolbarHeight: 60,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          shadowColor: Colors.blue,
          centerTitle: true,
          titleSpacing: 16,
          title: Text(
            'Absensi Event',
            style: TextThemes.normal.copyWith(fontSize: 16),
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                spacing: 20,
                children: [
                  // ~:Page Content:~
                  Column(
                    spacing: 12,
                    children: [
                      // ~:Header:~
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Event',
                            style: TextThemes.normal.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Masukkan informasi terkait event dengan lengkap.',
                            style: TextThemes.normal.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      // ~:Content:~
                      Column(
                        spacing: 20,
                        children: [
                          // ~:Description Box:~
                          AdjustableTextFields(eventTextController),

                          // ~:Photo Box:~
                          Column(
                            spacing: 12,
                            children: [
                              // ~:Salesman Event Images Title:~
                              SectionTitleText(
                                title: 'Foto',
                                isTitleBold: false,
                                isHintEnabled: true,
                                hint:
                                    'Unggah foto menggunakan kamera atau galeri.',
                              ),

                              // ~:Salesman Event Images:~
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withValues(
                                        alpha: 0.5,
                                      ),
                                      spreadRadius: 4,
                                      blurRadius: 4,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(vertical: 8),
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  spacing: 12,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => context
                                              .read<ImageCubit>()
                                              .captureImage(),
                                          child: const Text('Ambil Foto'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => context
                                              .read<ImageCubit>()
                                              .clearImage(),
                                          child: const Text('Hapus Foto'),
                                        ),
                                      ],
                                    ),
                                    BlocConsumer<ImageCubit, ImageState>(
                                      listener: (context, state) {
                                        if (state is ImageError) {
                                          Functions.customFlutterToast(
                                            state.message,
                                          );
                                        } else if (state is ImageCaptured) {
                                          Functions.customFlutterToast(
                                            'Foto berhasil di upload',
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is ImageLoading) {
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
                                        } else if (state is ImageError) {
                                          return Center(
                                            child: Text(state.message),
                                          );
                                        } else if (state is ImageCaptured) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: Image.file(
                                              File(state.image.path),
                                              height: 200,
                                              fit: BoxFit.contain,
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                            child: Text(
                                              'Foto tidak ditemukan',
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      final imageState = context.read<ImageCubit>().state;
                      String image = '';
                      if (imageState is ImageCaptured) {
                        image = base64Encode(
                          await imageState.image.readAsBytes(),
                        );
                      }

                      context.read<AttendanceBloc>().add(
                        EventAttendance(
                          employee:
                              (context.read<LoginBloc>().state as LoginSuccess)
                                  .user,
                          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          time: DateFormat('HH:mm').format(DateTime.now()),
                          eventDesc: eventTextController.text,
                          image: image,
                          coordinate: await Geolocator.getCurrentPosition(),
                        ),
                      );
                    },
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
                    child: BlocConsumer<AttendanceBloc, AttendanceState>(
                      listener: (context, state) {
                        if (state is EventAttendanceError) {
                          Functions.customFlutterToast(state.message);
                        } else if (state is EventAttendanceSuccess) {
                          Functions.customFlutterToast(
                            'Berhasil membuat absensi',
                          );

                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is EventAttendanceLoading) {
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
                            'Buat',
                            style: TextThemes.normalTextButton.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
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
      ),
    );
  }
}
