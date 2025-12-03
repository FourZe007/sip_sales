import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/image_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/buttons/counter.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/textfields/custom_textformfield.dart';
import 'package:sip_sales_clean/presentation/widgets/texts/title.dart';
import 'package:dotted_border/dotted_border.dart';

class CreateBriefingScreen extends StatefulWidget {
  const CreateBriefingScreen({super.key});

  @override
  State<CreateBriefingScreen> createState() => _CreateBriefingScreenState();
}

class _CreateBriefingScreenState extends State<CreateBriefingScreen> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        toolbarHeight: 60,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Text(
          'Morning Briefing',
          style: TextThemes.normal.copyWith(
            fontSize: 16,
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
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            spacing: 4,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    spacing: 8,
                    children: [
                      // ~:Screen Header:~
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ~:Screen Title:~
                            CustomText(
                              'Informasi Briefing',
                              fontSize: 16,
                            ),

                            // ~:Screen Subtitle:~
                            CustomText(
                              'Masukkan data untuk membuat laporan pagi.',
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),

                      // ~:Body:~
                      // ~:Location Textfield:~
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          if (state is LoginSuccess) {
                            // ~:Set the location controller text:~
                            locationController.text = state.user.bsName;
                          }

                          return CustomTextFormField(
                            'your location',
                            'Location',
                            const Icon(Icons.location_pin),
                            locationController,
                            inputFormatters: [Formatter.normalFormatter],
                            borderRadius: 24,
                            isEnabled: false,
                          );
                        },
                      ),

                      // ~:Counter Section:~
                      Column(
                        spacing: 12,
                        children: [
                          // ~:Number of Shop Manager:~
                          Counter.person(
                            context,
                            'shop_manager',
                            'Shop Manager',
                          ),

                          // ~:Number of Sales Counter:~
                          Counter.person(
                            context,
                            'sales_counter',
                            'Sales Counter',
                          ),

                          // ~:Number of Salesman:~
                          Counter.person(context, 'salesman', 'Salesman'),

                          // ~:Number of Others:~
                          Counter.person(context, 'others', 'Other'),

                          // ~:Total Person:~
                          Counter.automaticPerson(
                            context,
                            'total',
                            'Jumlah Peserta',
                          ),
                        ],
                      ),

                      // ~:Description Textfield:~
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: TextField(
                          controller: descriptionController,
                          maxLines: 8,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter your description',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextThemes.textfieldPlaceholder,
                            labelText: 'Description',
                            labelStyle: TextThemes.textfieldPlaceholder,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),

                      // ~:Photo Section:~
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 4),
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            radius: Radius.circular(16),
                            color: Colors.black,
                            strokeWidth: 2,
                            dashPattern: const [4, 4],
                            strokeCap: StrokeCap.round,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                            child: BlocConsumer<ImageCubit, ImageState>(
                              listener: (context, state) {
                                if (state is ImageError) {
                                  Functions.customSnackBar(
                                    context,
                                    state.message,
                                  );
                                } else if (state is ImageDeleted) {
                                  Functions.customSnackBar(
                                    context,
                                    'Foto berhasil dihapus!',
                                  );
                                } else if (state is ImageCaptured) {
                                  Functions.customSnackBar(
                                    context,
                                    'Foto berhasil diupload!',
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
                                } else if (state is ImageCaptured) {
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  backgroundColor: Colors.white,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    child: Image.file(
                                                      File(state.image.path),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: Image.file(
                                              File(state.image.path),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          left: 52,
                                          child: InkWell(
                                            onTap: () => context
                                                .read<ImageCubit>()
                                                .clearImage(isDeleted: true),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(
                                                4,
                                              ),
                                              child: const Icon(
                                                Icons.close_rounded,
                                                size: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () async => context
                                        .read<ImageCubit>()
                                        .captureImage(),
                                    child: SizedBox(
                                      width: MediaQuery.of(
                                        context,
                                      ).size.width,
                                      child: const Row(
                                        spacing: 8,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt_rounded,
                                            size: 20,
                                          ),
                                          Text(
                                            'Upload Foto',
                                            style: TextThemes.subtitle,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 24,
                    alignment: Alignment.center,
                    child: Text(
                      'Buat',
                      style: TextThemes.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
