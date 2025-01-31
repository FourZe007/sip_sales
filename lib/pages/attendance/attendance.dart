import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/pages/attendance/attendance_history.dart';
import 'package:sip_sales/pages/attendance/event.dart';
import 'package:sip_sales/widget/date/custom_digital_clock.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sip_sales/widget/dropdown/common_dropdown.dart';
import 'package:sip_sales/widget/list/absent.dart';
import 'package:sip_sales/widget/status/loading_animation.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String displayDate = '';
  String absentType = '';

  void setDisplayDate(String value) {
    displayDate = value;
  }

  void setAbsentType(String value) {
    setState(() {
      absentType = value;
    });
  }

  void userAbsent({bool isClockIn = false}) {
    final state = Provider.of<SipSalesState>(context, listen: false);
    state.clearState();

    if (isClockIn) {
      if (state.getAbsentType != 'EVENT') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LoadingAnimationPage(false, true, false, false, false, false),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDescPage(),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoadingAnimationPage(false, false, true, false, false, false),
        ),
      );
    }
  }

  Stream<List<ModelAttendanceHistory>> getHistory(
    SipSalesState state, {
    String startDate = '',
    String endDate = '',
  }) async* {
    print('Refresh');
    state.absentHistoryList.clear();
    state.absentHistoryList.addAll(await GlobalAPI.fetchAttendanceHistory(
      GlobalVar.nip!,
      startDate,
      endDate,
    ));

    // History list check
    if (state.absentHistoryList.isNotEmpty) {
      print('Fetch succeed');
      yield [
        state.absentHistoryList[0],
        state.absentHistoryList[1],
        state.absentHistoryList[2],
      ];
    } else {
      print('Fetch failed');
      yield state.absentHistoryList;
    }
  }

  @override
  Widget build(BuildContext context) {
    // State Management
    final state = Provider.of<SipSalesState>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.12,
      ),
      child: RefreshIndicator(
        onRefresh: () async => getHistory(state),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            child: Column(
              children: [
                // ~:Date and Time:~
                CustomDigitalClock(
                  displayDate,
                  setDisplayDate,
                  false,
                  isIpad:
                      (MediaQuery.of(context).size.width < 800) ? false : true,
                ),

                // ~:Attendance Frame:~
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.0225,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ~:Attendance Title:~
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        alignment: Alignment.center,
                        child: Text(
                          'Absensi',
                          style: GlobalFont.mediumgigafontRBold,
                        ),
                      ),
                      // ~:Absent Type:~
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: MediaQuery.of(context).size.width * 0.005,
                      //     vertical: MediaQuery.of(context).size.height * 0.005,
                      //   ),
                      //   child: CommonDropdown(
                      //     state.absentType,
                      //     defaultValue:
                      //         GlobalVar.userAccountList[0].locationName,
                      //   ),
                      //   // child: DropdownButtonFormField<String>(
                      //   //   decoration: InputDecoration(
                      //   //     enabledBorder: OutlineInputBorder(
                      //   //       borderSide: BorderSide.none,
                      //   //       borderRadius: BorderRadius.circular(25.0),
                      //   //     ),
                      //   //     focusedBorder: OutlineInputBorder(
                      //   //       borderSide: BorderSide.none,
                      //   //       borderRadius: BorderRadius.circular(25.0),
                      //   //     ),
                      //   //     filled: true,
                      //   //     fillColor: Colors.grey[350],
                      //   //     contentPadding: EdgeInsets.symmetric(
                      //   //       horizontal: 25,
                      //   //       vertical: 10,
                      //   //     ),
                      //   //   ),
                      //   //   value: absentType == ''
                      //   //       ? GlobalVar.userAccountList[0].locationName
                      //   //       : absentType,
                      //   //   hint: Text('Select an option'),
                      //   //   items: <String>[
                      //   //     GlobalVar.userAccountList[0].locationName,
                      //   //     'EVENT',
                      //   //   ].map((String value) {
                      //   //     return DropdownMenuItem<String>(
                      //   //       value: value,
                      //   //       child: Text(value),
                      //   //     );
                      //   //   }).toList(),
                      //   //   onChanged: (String? newValue) {
                      //   //     setState(() {
                      //   //       absentType = newValue!;
                      //   //     });
                      //   //   },
                      //   // ),
                      // ),
                      // ~:Clock In and Out Section:~
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.005,
                          vertical: MediaQuery.of(context).size.height * 0.005,
                        ),
                        child: Row(
                          children: [
                            // ~:Absent Type:~
                            // ~:Alt 1:~
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width * 0.275,
                            //   child: CommonDropdown(
                            //     state.absentType,
                            //     defaultValue:
                            //         GlobalVar.userAccountList[0].locationName,
                            //   ),
                            // ),
                            // ~:Alt 2:~
                            Expanded(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: CommonDropdown(
                                  state.absentType,
                                  defaultValue:
                                      GlobalVar.userAccountList[0].locationName,
                                ),
                              ),
                            ),
                            // ~:Devider:~
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.025,
                            ),
                            // ~:Clock In Button:~
                            Expanded(
                              child: GestureDetector(
                                onTap: () => userAbsent(isClockIn: true),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
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
                                  child: Text(
                                    'Clock In',
                                    style: GlobalFont.bigfontR,
                                  ),
                                ),
                              ),
                            ),
                            // // ~:Devider:~
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width * 0.025,
                            // ),
                            // // ~:Clock Out Button:~
                            // Expanded(
                            //   child: GestureDetector(
                            //     onTap: () => userAbsent(),
                            //     child: Container(
                            //       height:
                            //           MediaQuery.of(context).size.height * 0.05,
                            //       alignment: Alignment.center,
                            //       decoration: BoxDecoration(
                            //         color: Colors.white,
                            //         borderRadius: BorderRadius.circular(20),
                            //         boxShadow: const [
                            //           BoxShadow(
                            //             // Adjust shadow color as needed
                            //             color: Colors.grey,
                            //             // No shadow offset
                            //             // Adjust shadow blur radius
                            //             blurRadius: 5.0,
                            //             // Adjust shadow spread radius
                            //             spreadRadius: 1.0,
                            //           ),
                            //         ],
                            //       ),
                            //       child: Text(
                            //         'Clock Out',
                            //         style: GlobalFont.bigfontR,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      // ~:Current Location Button:~
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.005,
                          vertical: MediaQuery.of(context).size.height * 0.005,
                        ),
                        child: GestureDetector(
                          onTap: () => state.openMap(context),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
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
                            child: Text(
                              'Lokasi Anda',
                              style: GlobalFont.bigfontR,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ~:Attendance List:~
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.365,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: Column(
                    children: [
                      // ~:Attendance List Header:~
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daftar Absensi',
                            style: GlobalFont.giantfontR,
                          ),
                          GestureDetector(
                            onTap: () {
                              state.clearState();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AttendanceHistoryPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Lihat log',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.65),
                                fontFamily: GlobalFontFamily.fontRubik,
                                fontSize: GlobalSize.mediumgiantfont,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ~:Devider:~
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.007,
                      ),

                      // ~:Attendance List Content:~
                      Expanded(
                        child: StreamBuilder(
                          stream: getHistory(state),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.white,
                                period: const Duration(milliseconds: 1000),
                                child: ListView.builder(
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.075,
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
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.005,
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.008,
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('Data not available.'),
                              );
                            } else {
                              return ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: snapshot.data!.asMap().entries.map(
                                  (e) {
                                    final index = e.key;
                                    final data = e.value;

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
                                            if (index !=
                                                snapshot.data!.length - 1) {
                                              return Divider(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                              );
                                            } else {
                                              return SizedBox();
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ).toList(),
                              );
                            }
                          },
                        ),
                      ),
                    ],
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
