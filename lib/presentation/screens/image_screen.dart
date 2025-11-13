import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/data/models/salesman.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({this.headActs, this.salesActs, super.key});

  final HeadActsDetailsModel? headActs;
  final SalesActsModel? salesActs;

  @override
  Widget build(BuildContext context) {
    // void openMap(
    //   double lat,
    //   double lng,
    // ) async {
    //   Uri url = Uri.parse('https://maps.google.com/?q=$lat,$lng');

    //   if (await canLaunchUrl(url)) {
    //     await launchUrl(url);
    //   } else {
    //     Functions.customFlutterToast(
    //       'Tidak dapat membuka tautan. Silakan periksa URL dan coba lagi.',
    //     );
    //   }
    // }

    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[300],
          toolbarHeight: 0.0,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[300],
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 24,
          ),
          child: Column(
            spacing: 20,
            children: [
              // ~:Image:~
              Expanded(
                child: PhotoView.customChild(
                  maxScale: PhotoViewComputedScale.covered * 2,
                  minScale: PhotoViewComputedScale.contained,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      if (state is LoginSuccess && state.user.code == 0) {
                        if (headActs != null &&
                            headActs!.time.isNotEmpty &&
                            headActs!.lat != 0.0 &&
                            headActs!.lng != 0.0) {
                          return Align(
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.memory(
                                    base64Decode(headActs!.pic1),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // ~:Time:~
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(4.0),
                                        margin: const EdgeInsets.all(4.0),
                                        child: Text(
                                          headActs!.time,
                                          style: TextThemes.normal.copyWith(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      // ~:Map:~
                                      GestureDetector(
                                        onTap: () => Functions.openMap(
                                          headActs!.lat,
                                          headActs!.lng,
                                        ),
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.black,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5,
                                              vertical: 5,
                                            ),
                                            child: Icon(
                                              Icons.map_rounded,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      } else {
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.memory(
                                      base64Decode(headActs!.pic1),
                                      fit: BoxFit.cover,
                                      scale: 0.55,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.5,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                          0.015,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                          0.0075,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            if ((context.read<LoginBloc>().state
                                                        as LoginSuccess)
                                                    .user
                                                    .code ==
                                                0) {
                                              if (headActs!.time != '') {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[350],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.0,
                                                        ),
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                    5.0,
                                                  ),
                                                  margin: const EdgeInsets.all(
                                                    5.0,
                                                  ),
                                                  child: Text(
                                                    headActs!.time,
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                        ),
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            } else {
                                              if (salesActs!.startTime != '' &&
                                                  salesActs!.endTime != '') {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[350],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.0,
                                                        ),
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                    5.0,
                                                  ),
                                                  margin: const EdgeInsets.all(
                                                    5.0,
                                                  ),
                                                  child: Text(
                                                    '${salesActs!.startTime} - ${salesActs!.endTime}',
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                        ),
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            }
                                          },
                                        ),
                                        // Builder(
                                        //   builder: (context) {
                                        //     if (headActs!.lat != 0.0 &&
                                        //         headActs!.lng != 0.0) {
                                        //       return GestureDetector(
                                        //         onTap: () => openMap(
                                        //           headActs!.lat,
                                        //           widget.lng,
                                        //         ),
                                        //         child: CircleAvatar(
                                        //           radius: 25,
                                        //           backgroundColor: Colors.grey[350],
                                        //           child: Padding(
                                        //             padding: EdgeInsets.symmetric(
                                        //               horizontal: 5,
                                        //               vertical: 5,
                                        //             ),
                                        //             child: Icon(
                                        //               Icons.map_rounded,
                                        //               size: 30,
                                        //               color: Colors.black,
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       );
                                        //     } else {
                                        //       return const SizedBox();
                                        //     }
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),

              // ~:Back Button:~
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  fixedSize: Size(MediaQuery.of(context).size.width, 60),
                ),
                child: Text(
                  'Kembali',
                  style: TextThemes.normal.copyWith(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
