import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/act_types.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store.event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_state.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/head_act_types.dart';
import 'package:sip_sales_clean/presentation/cubit/image_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/dropdown/head_act_types.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/texts/section_title.dart';

class HeadNewActsScreen extends StatefulWidget {
  const HeadNewActsScreen({super.key});

  @override
  State<HeadNewActsScreen> createState() => _HeadNewActsScreenState();
}

class _HeadNewActsScreenState extends State<HeadNewActsScreen> {
  String activityType = '';
  String description = '';

  void setActivityType(String actType) {
    for (var i in context.read<HeadActTypesCubit>().state) {
      if (i.activityName.toLowerCase() == actType.toLowerCase()) {
        setState(() {
          activityType = i.activityName.toLowerCase();
          description = i.activityTemplate;
        });
        log('activity type: $activityType');
        break;
      }
    }
  }

  void setActivityDescription(String description) {
    this.description = description;
    log('description: $description');
  }

  void createHeadAct(BuildContext context) async {
    final activityID = activityType.isEmpty
        ? '01'
        : context
              .read<HeadActTypesCubit>()
              .getActTypes()
              .firstWhere(
                (element) =>
                    element.activityName.toLowerCase() ==
                    activityType.toLowerCase(),
              )
              .activityID;

    log('Desc: $description');
    final imageState = context.read<ImageCubit>().state;
    String image = '';
    if (imageState is ImageInitial) {
      Functions.customFlutterToast('Foto tidak ditemukan');
    } else if (imageState is ImageError) {
      Functions.customFlutterToast(imageState.message);
    } else if (imageState is ImageCaptured) {
      image = base64Encode(
        await imageState.image.readAsBytes(),
      );
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      log('Position: $position');
      log('Lat: ${position.latitude}');
      log('Lng: ${position.longitude}');
    } on LocationServiceDisabledException {
      Functions.customFlutterToast('Lokasi tidak diizinkan');
      return;
    } on PermissionDeniedException {
      Functions.customFlutterToast('Izin lokasi ditolak');
      return;
    } on TimeoutException {
      Functions.customFlutterToast('Waktu permintaan lokasi habis');
      return;
    } catch (e) {
      Functions.customFlutterToast('Gagal mendapatkan lokasi: ${e.toString()}');
      return;
    }
    log('Activity Id: $activityID');

    if (context.mounted) {
      // final loginState = (context.read<LoginBloc>().state as LoginSuccess).user;

      // context.read<HeadStoreBloc>().add(
      //   InsertHeadActs(
      //     employeeID: loginState.employeeID,
      //     activityID: activityID,
      //     branch: loginState.branch,
      //     shop: loginState.shop,
      //     date: DateFormat(
      //       'yyyy-MM-dd',
      //     ).format(DateTime.now()),
      //     time: DateFormat('HH:mm').format(DateTime.now()),
      //     lat: position.latitude,
      //     lng: position.longitude,
      //     desc: description,
      //     image: image,
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    activityType = activityType.isEmpty
        ? context.read<HeadActTypesCubit>().state.first.activityName
        : activityType;

    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.blue,
          toolbarHeight: 60,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          centerTitle: true,
          title: Text(
            'Buat Laporan',
            style: TextThemes.normal.copyWith(
              fontSize: 20,
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
            padding: EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 20),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                spacing: 16,
                children: [
                  // ~:Title:~
                  SectionTitleText(
                    title: 'Detail Aktivitas',
                    isHintEnabled: true,
                    hint: 'Masukkan jenis dan deskripsi aktivitas.',
                  ),

                  // ~:Head Act Types Dropdown:~
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: Text(
                          'Tipe',
                          style: TextThemes.normal.copyWith(fontSize: 18),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height * 0.04,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04,
                            vertical:
                                MediaQuery.of(context).size.height * 0.005,
                          ),
                          child: HeadActTypesDropdown(
                            listData: context.read<HeadActTypesCubit>().state,
                            inputan: activityType,
                            hint: 'Tipe Aktivitas Manajer',
                            handle: setActivityType,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ~:Head Act Description Box:~
                  Column(
                    spacing: 8,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01,
                        ),
                        child: Text(
                          'Deskripsi',
                          style: TextThemes.normal.copyWith(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01,
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom * 0.65,
                        ),
                        child: TextField(
                          maxLines: 10,
                          inputFormatters: [
                            Formatter.allowCommonTextInput,
                          ],
                          controller: TextEditingController(
                            text: description.isEmpty
                                ? context
                                      .read<HeadActTypesCubit>()
                                      .state
                                      .first
                                      .activityTemplate
                                : description,
                          ),
                          enabled: true,
                          style: TextThemes.normal.copyWith(
                            fontSize: 12,
                          ),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[400],
                            contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.04,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.005,
                            ),
                            hintStyle: TextThemes.normal.copyWith(
                              fontSize: 12,
                            ),
                            hintText: activityType == 'DAILY REPORT'
                                ? 'Masukkan Report Sore Anda.'
                                : 'Masukkan deskripsi Anda.',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onChanged: (newValues) => setActivityDescription(
                            newValues,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ~:Photo Section:~
                  Column(
                    spacing: 4,
                    children: [
                      // ~:Head Act Images Title:~
                      SectionTitleText(
                        title: 'Foto',
                        isTitleBold: false,
                        isHintEnabled: true,
                        hint: 'Unggah foto menggunakan kamera atau galeri.',
                      ),

                      // ~:Head Act Images:~
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          spacing: 12,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    final actType = context
                                        .read<HeadActTypesCubit>()
                                        .state
                                        .firstWhere(
                                          (e) =>
                                              e.activityName.toLowerCase() ==
                                              activityType.toLowerCase(),
                                          orElse: () => HeadActTypesModel(
                                            activityID: '',
                                            activityName: '',
                                            activityTemplate: '',
                                          ),
                                        );
                                    log(actType.activityID);
                                    if (actType.activityID == '02') {
                                      context.read<ImageCubit>().pickImage();
                                    } else {
                                      context.read<ImageCubit>().captureImage();
                                    }
                                  },
                                  child: const Text('Ambil Foto'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      context.read<ImageCubit>().clearImage(),
                                  child: const Text('Hapus Foto'),
                                ),
                              ],
                            ),
                            BlocConsumer<ImageCubit, ImageState>(
                              listener: (context, state) {
                                if (state is ImageError) {
                                  Functions.customFlutterToast(state.message);
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
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      File(state.image.path),
                                      height: 200,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: Text('Foto tidak ditemukan'),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ~:Create Button:~
                  ElevatedButton(
                    onPressed: () async => createHeadAct(context),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 40),
                      backgroundColor: Colors.blue,
                    ),
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
                        }
                        return Text(
                          'Buat',
                          style: TextThemes.normalTextButton.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        );
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
