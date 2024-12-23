// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/pages/profile/profile.dart';
import 'package:sip_sales/widget/format.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  StreamController streamController = StreamController();
  String beginDate = '';
  String endDate = '';
  bool isBeginInit = false;
  bool isEndInit = false;
  List<ModelAttendanceHistory> historyList = [];
  bool isOpened = false; // for Filter feature

  // Location Service
  Location location = Location();
  double? latitude = 0.0;
  double? longitude = 0.0;
  String time = '';

  void setBeginDate(String value) {
    beginDate = value;
  }

  void setEndDate(String value) {
    endDate = value;
  }

  void toggleIsBeginInit() {
    setState(() {
      isBeginInit = !isBeginInit;
    });
  }

  void toggleIsEndInit() {
    setState(() {
      isEndInit = !isEndInit;
    });
  }

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  Stream<List<ModelAttendanceHistory>> getHistory({
    String startDate = '',
    String endDate = '',
  }) async* {
    historyList.clear();
    historyList.addAll(await GlobalAPI.fetchAttendanceHistory(
      GlobalVar.nip!,
      startDate,
      endDate,
    ));

    // History list check
    // if (historyList.isNotEmpty) {
    //   print('Fetch succeed');
    // } else {
    //   print('Fetch failed');
    // }

    yield historyList;
  }

  void setSelectDate(
    BuildContext context,
    String tgl,
    bool isInit,
    Function handle,
    Function toggleFunction, {
    bool isStart = false,
    bool isEnd = false,
  }) async {
    tgl = tgl == '' ? DateTime.now().toString().substring(0, 10) : tgl;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl == '' ? DateTime.now() : DateTime.parse(tgl),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != DateTime.parse(tgl)) {
      setState(() {
        tgl = picked.toString().substring(0, 10);
      });
      handle(tgl);
      if (isInit == true) {
        toggleFunction();
      }

      if (isStart == true) {
        getHistory(startDate: tgl);
        toggleIsBeginInit();
      } else if (isEnd == true) {
        getHistory(endDate: tgl);
        toggleIsEndInit();
      }
    }
  }

  Future<double> getDeviceWidth() async {
    return MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    toggleIsBeginInit();
    toggleIsEndInit();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ~:Old widget without Scaffold:~
    // return Positioned(
    // top: MediaQuery.of(context).size.height * 0.12,
    // );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: (MediaQuery.of(context).size.width < 800)
            ? Text(
                'Riwayat Abensi',
                style: GlobalFont.giantfontRBold,
              )
            : Text(
                'Riwayat Abensi',
                style: GlobalFont.terafontRBold,
              ),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) {
            if (Platform.isIOS) {
              return IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            } else {
              return IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.025,
              MediaQuery.of(context).size.height * 0.02,
              MediaQuery.of(context).size.width * 0.025,
              0.0,
            ),
            child: Column(
              children: [
                // ~:Filter Section:~
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.05,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    children: [
                      // Open Filter Button
                      InkWell(
                        onTap: null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 7.5),
                          child: const Icon(
                            Icons.filter_alt_rounded,
                            size: 30.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // Devider
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.025,
                      ),
                      // Modify Begin Date
                      InkWell(
                        onTap: () => setSelectDate(
                          context,
                          beginDate,
                          isBeginInit,
                          setBeginDate,
                          toggleIsBeginInit,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02,
                          ),
                          child: Builder(
                            builder: (context) {
                              if (isBeginInit) {
                                return Text(
                                  'Start Date',
                                  style: GlobalFont.mediumgiantfontR,
                                );
                              } else {
                                return Text(
                                  Format.tanggalFormat(beginDate),
                                  style: GlobalFont.mediumgiantfontR,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      // Devider
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.025,
                      ),
                      // Modify End Date
                      InkWell(
                        onTap: () => setSelectDate(
                          context,
                          endDate,
                          isEndInit,
                          setEndDate,
                          toggleIsEndInit,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.black, width: 1.5),
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02,
                          ),
                          child: Builder(
                            builder: (context) {
                              if (isEndInit) {
                                return Text(
                                  'End Date',
                                  style: GlobalFont.mediumgiantfontR,
                                );
                              } else {
                                return Text(
                                  Format.tanggalFormat(endDate),
                                  style: GlobalFont.mediumgiantfontR,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ~:History Section:~
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        getHistory(
                          startDate: beginDate,
                          endDate: endDate,
                        );
                      },
                      child: StreamBuilder(
                        stream: getHistory(
                          startDate: beginDate,
                          endDate: endDate,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.white,
                                    period: const Duration(milliseconds: 1000),
                                    child: ListView.builder(
                                      itemCount: 6,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.125,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: const [
                                              BoxShadow(
                                                // Adjust shadow color as needed
                                                color: Colors.grey,
                                                // No shadow offset
                                                // Adjust shadow blur radius
                                                blurRadius: 5.0,
                                                // Adjust shadow spread radius
                                                spreadRadius: 1.0,
                                              ),
                                            ],
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No data available'),
                            );
                          } else {
                            return ListView(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              children: snapshot.data!.asMap().entries.map(
                                (e) {
                                  final data = e.value;

                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: (data.checkIn.isEmpty &&
                                              data.checkOut.isEmpty)
                                          ? Border.all(
                                              color: Colors.red,
                                              width: 2.0,
                                            )
                                          : null,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          // Adjust shadow color as needed
                                          color: Colors.grey,
                                          // No shadow offset
                                          // Adjust shadow blur radius
                                          blurRadius: 5.0,
                                          // Adjust shadow spread radius
                                          spreadRadius: 1.0,
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Expanded(
                                              child: Icon(
                                                Icons.add_chart_rounded,
                                                size: 37.5,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: SizedBox(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${data.locationName} ${data.branchName}',
                                                      style: GlobalFont
                                                          .giantfontRBold,
                                                    ),
                                                    Text(
                                                      Format.tanggalFormat(
                                                        data.date,
                                                      ),
                                                      style: GlobalFont
                                                          .mediumgiantfontR,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.025,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              if (data.checkIn.isEmpty &&
                                                  data.checkOut.isEmpty) {
                                                return Text(
                                                  'Clock In: - , Clock Out: -',
                                                  style: GlobalFont
                                                      .mediumgiantfontR,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.start,
                                                );
                                              } else if (data
                                                      .checkIn.isNotEmpty &&
                                                  data.checkOut.isEmpty) {
                                                return Text(
                                                  'Clock In: ${data.checkIn}, Clock Out: -',
                                                  style: GlobalFont
                                                      .mediumgiantfontR,
                                                  overflow: TextOverflow.clip,
                                                );
                                              } else if (data.checkIn.isEmpty &&
                                                  data.checkOut.isNotEmpty) {
                                                return Text(
                                                  'Clock In: - , Clock Out: ${data.checkOut}',
                                                  style: GlobalFont
                                                      .mediumgiantfontR,
                                                  overflow: TextOverflow.clip,
                                                );
                                              } else {
                                                return Text(
                                                  'Clock In: ${data.checkIn}, Clock Out: ${data.checkOut}',
                                                  style: GlobalFont
                                                      .mediumgiantfontR,
                                                  overflow: TextOverflow.clip,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
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
      ),
    );
  }
}
