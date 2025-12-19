import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store.event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_state.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/head_acts_master.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/buttons/counter.dart';
import 'package:sip_sales_clean/presentation/widgets/image/dotted_rounded_image_picker.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/textfields/custom_textformfield.dart';
import 'package:sip_sales_clean/presentation/widgets/texts/title.dart';

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
            spacing: 8,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
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
                              'Informasi Laporan',
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
                      // ~:Location Textfield using LoginBloc:~
                      // BlocBuilder<LoginBloc, LoginState>(
                      //   builder: (context, state) {
                      //     if (state is LoginSuccess) {
                      //       // ~:Set the location controller text:~
                      //       locationController.text = state.user.bsName;
                      //     }
                      //
                      //     return CustomTextFormField(
                      //       'your location',
                      //       'Location',
                      //       const Icon(Icons.location_pin),
                      //       locationController,
                      //       inputFormatters: [Formatter.normalFormatter],
                      //       borderRadius: 24,
                      //       isEnabled: false,
                      //     );
                      //   },
                      // ),

                      // ~:Location Textfield using HeadActsMasterCubit:~
                      BlocBuilder<HeadActsMasterCubit, HeadActsMasterState>(
                        builder: (context, state) {
                          if (state is HeadActsMasterLoaded) {
                            // ~:Set the location controller text:~
                            locationController.text =
                                Formatter.toCompanyAbbForm(
                                  (state.briefingMaster as List)[0].bsName,
                                );
                          }
                          log(
                            'Location Controller: ${locationController.text}',
                          );

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
                            'Jumlah Peserta',
                            [
                              'shop_manager',
                              'sales_counter',
                              'salesman',
                              'others',
                            ],
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
                      DottedRoundedImagePicker(),
                    ],
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () async => await Functions.manageNewHeadStoreAct(
                  context,
                  '00',
                  descriptionController.text,
                ),
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
                  child: BlocConsumer<HeadStoreBloc, HeadStoreState>(
                    buildWhen: (previous, current) =>
                        (current is HeadStoreLoading &&
                            current.isInsert &&
                            !current.isActs &&
                            !current.isDashboard) ||
                        current is HeadStoreInsertSucceed ||
                        current is HeadStoreInsertFailed,
                    listener: (context, state) {
                      if (state is HeadStoreInsertFailed) {
                        Functions.customFlutterToast(state.message);
                      } else if (state is HeadStoreInsertSucceed) {
                        Functions.customFlutterToast(
                          'Aktivitas berhasil dibuat',
                        );

                        context.read<HeadStoreBloc>().add(
                          LoadHeadActs(
                            employeeID:
                                (context.read<LoginBloc>().state
                                        as LoginSuccess)
                                    .user
                                    .employeeID,
                            date: DateFormat(
                              'yyyy-MM-dd',
                            ).format(DateTime.now()),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is HeadStoreLoading &&
                          state.isInsert &&
                          !state.isActs &&
                          !state.isDashboard &&
                          !state.isActsDetail &&
                          !state.isDelete) {
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
                          style: TextThemes.subtitle,
                          textAlign: TextAlign.center,
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
    );
  }
}
