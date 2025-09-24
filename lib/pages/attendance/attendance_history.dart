// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/pages/profile/profile.dart';
import 'package:sip_sales/widget/format.dart';
import 'package:sip_sales/widget/list/absent.dart';

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

  Future<void> getHistory(
    SipSalesState state, {
    String startDate = '',
    String endDate = '',
  }) async {
    log('Refresh');
    historyList.clear();
    historyList.addAll(await GlobalAPI.fetchAttendanceHistory(
      await state.readAndWriteUserId(),
      startDate,
      endDate,
    ));

    state.setAbsentHistoryList(historyList);

    // History list check
    // if (historyList.isNotEmpty) {
    //   print('Fetch succeed');
    // } else {
    //   print('Fetch failed');
    // }
  }

  void setSelectDate(
    BuildContext context,
    SipSalesState state,
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
        getHistory(state, startDate: tgl);
        toggleIsBeginInit();
      } else if (isEnd == true) {
        getHistory(state, endDate: tgl);
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
    getHistory(Provider.of<SipSalesState>(context, listen: false));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget attendanceHistoryBody(SipSalesState state) {
    return Column(
      children: state.getAbsentHistoryList.asMap().entries.map(
        (e) {
          final index = e.key;
          final data = e.value;

          if (index < state.getAbsentHistoryList.length - 1) {
            return Column(
              children: [
                AbsentList.type4(
                  context,
                  state,
                  data.checkIn,
                  data.date,
                ),
                Builder(
                  builder: (context) {
                    if (index != state.getAbsentHistoryList.length - 1) {
                      return Divider(
                        color: Colors.grey,
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ],
            );
          } else {
            return SizedBox();
          }
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SipSalesState>(context);

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
                          state,
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
                          state,
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
                    child: Builder(
                      builder: (context) {
                        if (Platform.isIOS) {
                          return CustomScrollView(
                            slivers: [
                              CupertinoSliverRefreshControl(
                                onRefresh: () => getHistory(
                                  state,
                                  startDate: beginDate,
                                  endDate: endDate,
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, _) => attendanceHistoryBody(state),
                                  childCount: 1,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return RefreshIndicator(
                            onRefresh: () async {
                              getHistory(
                                state,
                                startDate: beginDate,
                                endDate: endDate,
                              );
                            },
                            child: SingleChildScrollView(
                              // Note: you can use BouncingScrollPhysics() behavior too
                              physics: AlwaysScrollableScrollPhysics(),
                              child: attendanceHistoryBody(state),
                            ),
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
      ),
    );
  }
}
