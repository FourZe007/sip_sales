// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/enum.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state/dashboard_slidingup_cubit.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/global/state/smactivitiesdashboard/sm_activities_dashboard_bloc.dart';
import 'package:sip_sales/global/state/smactivitiesdashboard/sm_activities_dashboard_event.dart';
import 'package:sip_sales/global/state/smactivitiesdashboard/sm_activities_dashboard_state.dart';
import 'package:sip_sales/pages/activity/mananger_activity_details.dart';
import 'package:sip_sales/widget/format.dart';

class ManagerActivityPage extends StatefulWidget {
  ManagerActivityPage({this.isInserted = false, super.key});

  bool isInserted;

  @override
  State<ManagerActivityPage> createState() => _ManagerActivityPageState();
}

class _ManagerActivityPageState extends State<ManagerActivityPage> {
  String date = DateTime.now().toString().split(' ')[0];
  bool isDateInit = false;

  void setDate(String value) {
    date = value;
  }

  void toggleIsDateInit() {
    setState(() {
      isDateInit = !isDateInit;
    });
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
      print('Fetch Data');

      await refreshPage(context, state, tgl);

      if (isInit == true) {
        toggleFunction();
      }

      if (isStart == true) {
        toggleIsDateInit();
      }
    }
  }

  Future<void> refreshPage(
    BuildContext context,
    SipSalesState state,
    String date,
  ) async {
    log('Refresh or Load Data');
    log('Date: $date');
    try {
      await state.fetchManagerActivities(date: date).then((res) {
        state.setManagerActivities(res);
      });
      log('Manager activities length: ${state.getManagerActivitiesList.length}');
    } catch (e) {
      log(e.toString());
      if (Platform.isIOS) {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Peringatan!',
          e.toString(),
          () => Navigator.pop(context),
          'Tutup',
          isIOS: true,
        );
      } else {
        GlobalDialog.showCrossPlatformDialog(
          context,
          'Peringatan!',
          e.toString(),
          () => Navigator.pop(context),
          'Tutup',
        );
      }
    }
  }

  @override
  void initState() {
    toggleIsDateInit();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget activityView(BuildContext context, SipSalesState state) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      alignment: Alignment.center,
      child: Builder(
        builder: (context) {
          if (state.getManagerActivitiesList.isEmpty) {
            return Text('Data tidak ditemukan.');
          } else {
            return ListView(
              physics: NeverScrollableScrollPhysics(),
              children: state.getManagerActivitiesList.asMap().entries.map((e) {
                final int i = e.key;
                final ModelManagerActivities data = e.value;

                return Column(
                  children: [
                    // ~:Branch:~
                    Builder(
                      builder: (context) {
                        if (i == 0) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.005,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cabang: ',
                                  style: GlobalFont.giantfontR,
                                ),
                                Expanded(
                                  child: Text(
                                    state.getManagerActivitiesList[0].shopName,
                                    style: GlobalFont.giantfontRBold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),

                    // ~:Card:~
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
                            // Adjust shadow blur radius
                            blurRadius: 7.5,
                            // Adjust shadow spread radius
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.01125,
                        vertical: MediaQuery.of(context).size.height * 0.002,
                      ),
                      padding: EdgeInsets.fromLTRB(
                        0,
                        MediaQuery.of(context).size.height * 0.015,
                        MediaQuery.of(context).size.width * 0.03,
                        MediaQuery.of(context).size.height * 0.015,
                      ),
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ~:Card Information:~
                          Row(
                            children: [
                              Builder(
                                builder: (context) {
                                  if (data.activityId == '00') {
                                    return const Expanded(
                                      child: Icon(
                                        Icons.flare_rounded,
                                        size: 37.5,
                                      ),
                                    );
                                  } else if (data.activityId == '01') {
                                    return const Expanded(
                                      child: Icon(
                                        Icons.shopping_bag_rounded,
                                        size: 37.5,
                                      ),
                                    );
                                  } else if (data.activityId == '02') {
                                    return const Expanded(
                                      child: Icon(
                                        Icons.find_in_page_rounded,
                                        size: 37.5,
                                      ),
                                    );
                                  } else if (data.activityId == '03') {
                                    return const Expanded(
                                      child: Icon(
                                        Icons.note_rounded,
                                        size: 37.5,
                                      ),
                                    );
                                  } else {
                                    return const Expanded(
                                      child: Icon(
                                        Icons.event_note_rounded,
                                        size: 37.5,
                                      ),
                                    );
                                  }
                                },
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.activityName,
                                      style: GlobalFont.mediumgiantfontRBold,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.0075,
                                    ),
                                    Text(
                                      'Waktu: ${data.time}',
                                      style: GlobalFont.mediumgiantfontR,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // ~:Card Utilities:~
                          Row(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // ~:View Details Button :~
                              ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ManagerActivityDetails(
                                      date,
                                      data.activityId,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(120, 20),
                                  // backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.5,
                                    vertical: 5.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  shadowColor: Colors.grey,
                                ),
                                child: Text(
                                  'Lihat Detail',
                                  style: GlobalFont.mediumgiantfontR,
                                ),
                              ),

                              // ~:Delete Button:~
                              ElevatedButton(
                                onPressed: () {
                                  // ~:Save required parameters to delete certain report:~
                                  context.read<SMActivitiesDashboardBloc>().add(
                                        SaveSMActivitiesDashboard(
                                          employeeID: data.employeeId,
                                          activityID: data.activityId,
                                        ),
                                      );

                                  // ~:toggling panel:~
                                  context
                                      .read<DashboardSlidingUpCubit>()
                                      .changeType(
                                        DashboardSlidingUpType
                                            .deleteManagerActivity,
                                      );
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(80, 20),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.5,
                                    vertical: 5.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  shadowColor: Colors.grey,
                                ),
                                child: Text(
                                  'Hapus',
                                  style: GlobalFont.mediumgiantfontR,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ~:Divider:~
                    Builder(
                      builder: (context) {
                        if (i == state.getManagerActivitiesList.length - 1) {
                          return SizedBox();
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015,
                          );
                        }
                      },
                    ),
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SipSalesState>(context);

    return Positioned(
      top: MediaQuery.of(context).size.height * 0.12,
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
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.025,
          MediaQuery.of(context).size.height * 0.02,
          MediaQuery.of(context).size.width * 0.025,
          (Platform.isIOS)
              ? MediaQuery.of(context).size.height * 0.02
              : MediaQuery.of(context).size.height * 0.05,
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
              child: Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Open Filter Button
                  InkWell(
                    // onTap: toggleFilter,
                    onTap: null,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height,
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

                  // Modify Begin Date
                  InkWell(
                    onTap: () => setSelectDate(
                      context,
                      state,
                      date,
                      isDateInit,
                      setDate,
                      toggleIsDateInit,
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
                      child: Text(
                        Format.tanggalFormat(date),
                        style: GlobalFont.mediumgiantfontR,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ~:Body:~
            Expanded(
              child: Builder(
                builder: (context) {
                  if (Platform.isIOS) {
                    return CustomScrollView(
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () => refreshPage(
                            context,
                            state,
                            date,
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, _) => activityView(context, state),
                            childCount: 1,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () => refreshPage(
                        context,
                        state,
                        date,
                      ),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: activityView(context, state),
                      ),
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
