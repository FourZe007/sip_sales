// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/location/image_view.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';

class ManagerActivityDetails extends StatelessWidget {
  ManagerActivityDetails(this.date, this.actId, {super.key});

  String date;
  String actId;

  @override
  Widget build(BuildContext context) {
    final activityDetailsState = Provider.of<SipSalesState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        toolbarHeight: (MediaQuery.of(context).size.width < 800)
            ? MediaQuery.of(context).size.height * 0.075
            : MediaQuery.of(context).size.height * 0.075,
        title: (MediaQuery.of(context).size.width < 800)
            ? Text(
                'Detail',
                style: GlobalFont.giantfontRBold,
              )
            : Text(
                'Detail',
                style: GlobalFont.terafontRBold,
              ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.025,
            ),
            child: FutureBuilder(
              future: activityDetailsState.fetchManagerActivityDetails(
                date,
                actId,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Platform.isIOS
                          ? const CupertinoActivityIndicator(
                              color: Colors.black,
                            )
                          : const CircleLoading(
                              warna: Colors.black,
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        'Loading...',
                        style: GlobalFont.mediumgiantfontR,
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else if (snapshot.data == null) {
                  return const Center(child: Text('Tidak ada data'));
                } else {
                  final details = snapshot.data!;

                  return ListView(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          details.actDesc,
                          style: GlobalFont.bigfontR,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      (details.pic1 != '')
                          ? Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1.5),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 7.5,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    spacing: 15.0,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.memory(
                                          base64Decode(
                                            details.pic1,
                                          ),
                                          fit: BoxFit.cover,
                                          height: 62.5,
                                          width: 62.5,
                                        ),
                                      ),
                                      Text(
                                        'Bukti Aktivitas',
                                        style: GlobalFont.bigfontR,
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageView(
                                            details.pic1,
                                            lat: details.lat,
                                            lng: details.lng,
                                            startTime: details.time,
                                            isManager: true,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Lihat',
                                      style:
                                          GlobalFont.mediumgiantfontRBoldBlue,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
