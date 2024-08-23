// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/pages/profile/profile.dart';
import 'package:sip_sales/widget/format.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
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
    historyList = await GlobalAPI.fetchAttendanceHistory(
      GlobalVar.nip!,
      startDate,
      endDate,
    );
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
    // TODO: implement initState
    // setDate();
    toggleIsBeginInit();
    toggleIsEndInit();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 800) {
      return Positioned(
        top: MediaQuery.of(context).size.height * 0.12,
        child: Container(
          height: MediaQuery.of(context).size.height,
          // height: double.infinity,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: Colors.white, // Replace with your body content
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.025,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02,
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Open Filter Button
                    InkWell(
                      // onTap: toggleFilter,
                      onTap: null,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.black, width: 1.5),
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const Icon(
                          Icons.filter_alt_rounded,
                          size: 30.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
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
                          // border: Border.all(color: Colors.black, width: 1.5),
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                        ),
                        child: isBeginInit == true
                            ? Text(
                                'Start Date',
                                style: GlobalFont.mediumgiantfontR,
                              )
                            : Text(
                                Format.tanggalFormat(beginDate),
                                style: GlobalFont.mediumgiantfontR,
                              ),
                      ),
                    ),
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
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                        ),
                        child: isEndInit == true
                            ? Text(
                                'End Date',
                                style: GlobalFont.mediumgiantfontR,
                              )
                            : Text(
                                Format.tanggalFormat(endDate),
                                style: GlobalFont.mediumgiantfontR,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.725,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                ),
                child: StreamBuilder(
                  stream: getHistory(
                    startDate: beginDate,
                    endDate: endDate,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Platform.isIOS
                              ? const CupertinoActivityIndicator(
                                  radius: 17.5,
                                )
                              : const CircleLoading(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          Text(
                            'Loading...',
                            style: GlobalFont.mediumgiantfontR,
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available'));
                    } else {
                      return ListView(
                        children: [
                          for (int i = 0; i < snapshot.data!.length; i++)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: const [
                                  BoxShadow(
                                    // Adjust shadow color as needed
                                    color: Colors.grey,
                                    // Adjust shadow offset
                                    offset: Offset(2.0, 6.0),
                                    // Adjust shadow blur radius
                                    blurRadius: 5.0,
                                    // Adjust shadow spread radius
                                    spreadRadius: 1.0,
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.01,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        child: Icon(
                                          Icons.add_chart_rounded,
                                          size: 37.5,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${snapshot.data![i].locationName} ${snapshot.data![i].branchName}',
                                              style: GlobalFont.giantfontRBold,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.0075,
                                            ),
                                            Text(
                                              Format.tanggalFormat(
                                                snapshot.data![i].date,
                                              ),
                                              style:
                                                  GlobalFont.mediumgiantfontR,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Text(
                                    snapshot.data![i].checkOut == ''
                                        ? 'Check In : ${snapshot.data![i].checkIn} - Check Out: -'
                                        : 'Check In : ${snapshot.data![i].checkIn} - Check Out: ${snapshot.data![i].checkOut}',
                                    style: GlobalFont.mediumgiantfontR,
                                    overflow: TextOverflow.clip,
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
            ],
          ),
        ),
      );
    } else {
      return Positioned(
        top: MediaQuery.of(context).size.height * 0.12,
        child: Container(
          height: MediaQuery.of(context).size.height,
          // height: double.infinity,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: Colors.white, // Replace with your body content
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.025,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02,
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Open Filter Button
                    InkWell(
                      onTap: null,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.black, width: 1.5),
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const Icon(
                          Icons.filter_alt_rounded,
                          size: 45.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
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
                          // border: Border.all(color: Colors.black, width: 1.5),
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                        ),
                        child: isBeginInit == true
                            ? Text(
                                'Start Date',
                                style: GlobalFont.gigafontR,
                              )
                            : Text(
                                beginDate,
                                style: GlobalFont.gigafontR,
                              ),
                      ),
                    ),
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
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                        ),
                        child: isEndInit == true
                            ? Text(
                                'End Date',
                                style: GlobalFont.gigafontR,
                              )
                            : Text(
                                endDate,
                                style: GlobalFont.gigafontR,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.725,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                ),
                child: StreamBuilder(
                  stream: getHistory(
                    startDate: beginDate,
                    endDate: endDate,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Platform.isIOS
                              ? const CupertinoActivityIndicator(
                                  radius: 17.5,
                                )
                              : const CircleLoading(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          Text(
                            'Loading...',
                            style: GlobalFont.mediumgiantfontR,
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available'));
                    } else {
                      return ListView(
                        children: [
                          for (int i = 0; i < snapshot.data!.length; i++)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: const [
                                  BoxShadow(
                                    // Adjust shadow color as needed
                                    color: Colors.grey,
                                    // Adjust shadow offset
                                    offset: Offset(2.0, 6.0),
                                    // Adjust shadow blur radius
                                    blurRadius: 5.0,
                                    // Adjust shadow spread radius
                                    spreadRadius: 1.0,
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.01,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        child: Icon(
                                          Icons.add_chart_rounded,
                                          size: 75,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${snapshot.data![i].locationName} ${snapshot.data![i].branchName}',
                                              style: GlobalFont.terafontRBold,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.0075,
                                            ),
                                            Text(
                                                Format.tanggalFormat(
                                                  snapshot.data![i].date,
                                                ),
                                                style: GlobalFont.gigafontR),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Text(
                                    snapshot.data![i].checkOut == ''
                                        ? 'Check In : ${snapshot.data![i].checkIn} - Check Out: -'
                                        : 'Check In : ${snapshot.data![i].checkIn} - Check Out: ${snapshot.data![i].checkOut}',
                                    style: GlobalFont.gigafontR,
                                    overflow: TextOverflow.clip,
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
            ],
          ),
        ),
      );
    }
  }
}
