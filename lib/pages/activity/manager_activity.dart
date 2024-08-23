import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/activity/mananger_activity_details.dart';
import 'package:sip_sales/widget/format.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';

class ManagerActivityPage extends StatefulWidget {
  const ManagerActivityPage({super.key});

  @override
  State<ManagerActivityPage> createState() => _ManagerActivityPageState();
}

class _ManagerActivityPageState extends State<ManagerActivityPage> {
  String date = DateTime.now().toString().split(' ')[0];
  bool isDateInit = false;

  StreamController<List<ModelManagerActivities>> managerController =
      StreamController<List<ModelManagerActivities>>();

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
      await fetchData(state, tgl);
      if (isInit == true) {
        toggleFunction();
      }

      if (isStart == true) {
        toggleIsDateInit();
      }
    }
  }

  Future<void> fetchData(
    SipSalesState state,
    String date,
  ) async {
    print('Date: $date');
    managerController = StreamController<List<ModelManagerActivities>>();
    managerController.add(await state.fetchManagerActivities(date));
  }

  @override
  void initState() {
    managerController = StreamController<List<ModelManagerActivities>>();
    fetchData(
      Provider.of<SipSalesState>(context, listen: false),
      date,
    );
    toggleIsDateInit();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    managerController.close();
    super.dispose();
  }

  Widget activityView(BuildContext context) {
    final managerActivityState = Provider.of<SipSalesState>(context);

    return Column(
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
                  managerActivityState,
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
                  // child: isDateInit == true
                  //     ? Text(
                  //         // 'Date',
                  //         Format.tanggalFormat(
                  //           DateTime.now().toString().substring(0, 10),
                  //         ),
                  //         style: GlobalFont.mediumgiantfontR,
                  //       )
                  //     : Text(
                  //         Format.tanggalFormat(date),
                  //         style: GlobalFont.mediumgiantfontR,
                  //       ),
                  child: Text(
                    Format.tanggalFormat(date),
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
            stream: managerController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleLoading(),
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
                return const Center(child: Text('Data tidak tersedia.'));
              } else {
                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cabang: ',
                            style: GlobalFont.giantfontR,
                          ),
                          Text(
                            snapshot.data![0].shopName,
                            style: GlobalFont.giantfontRBold,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.675,
                      child: ListView(
                        children: snapshot.data!.asMap().entries.map((e) {
                          final int i = e.key;
                          final ModelManagerActivities data = e.value;

                          return Container(
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
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.035,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Aktivitas',
                                          style: GlobalFont.bigfontRBold,
                                        ),
                                        Text(
                                          Format.tanggalFormat(
                                            data.date,
                                          ),
                                          style: GlobalFont.bigfontR,
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (Platform.isIOS) {
                                          GlobalDialog.showCrossPlatformDialog(
                                            context,
                                            'Pantau Terus!',
                                            'Fitur baru sedang dalam pengembangan.',
                                            () => Navigator.pop(context),
                                            'Tutup',
                                            isIOS: true,
                                          );
                                        } else {
                                          GlobalDialog.showCrossPlatformDialog(
                                            context,
                                            'Pantau Terus!',
                                            'Fitur baru sedang dalam pengembangan.',
                                            () => Navigator.pop(context),
                                            'Tutup',
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.more_vert_rounded,
                                        size: 30.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 0.5,
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Icon(
                                        Icons.event_note_rounded,
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
                                            data.activityName,
                                            style: GlobalFont.giantfontRBold,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
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
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ManagerActivityDetails(i),
                                        ),
                                      ),
                                      hoverColor: Colors.transparent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.5,
                                          vertical: 5.0,
                                        ),
                                        child: Text(
                                          'Lihat Detail',
                                          style: GlobalFont.mediumgiantfontR,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final managerActivityState = Provider.of<SipSalesState>(context);

    return Positioned(
      top: MediaQuery.of(context).size.height * 0.12,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025,
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Platform.isIOS
            ? CupertinoSliverRefreshControl(
                onRefresh: () => fetchData(
                  managerActivityState,
                  date,
                ),
              )
            : RefreshIndicator(
                onRefresh: () => fetchData(
                  managerActivityState,
                  date,
                ),
                child: activityView(context),
              ),
      ),
    );
  }
}
