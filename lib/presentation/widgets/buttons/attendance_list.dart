import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/salesman.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class AttendanceList extends StatelessWidget {
  const AttendanceList({required this.attendanceData, super.key});

  final SalesmanAttendanceModel attendanceData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // final now = DateTime.now();
        // final todayDate = DateTime(now.year, now.month, now.day);

        // if (checkIn.isNotEmpty) {
        //   state.absentHistoryDetail = state.getAbsentHistoryList
        //       .where((e) => e.date == date)
        //       .first;
        //
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => AbsentDetailsPage(),
        //     ),
        //   );
        // } else {
        //   if (todayDate.toString().split(' ')[0] == date) {
        //     GlobalDialog.showCrossPlatformDialog(
        //       context,
        //       'Peringatan!',
        //       'Anda belum absen hari ini. ',
        //       () => Navigator.pop(context),
        //       'Tutup',
        //       isIOS: Platform.isIOS ? true : false,
        //     );
        //   } else {
        //     GlobalDialog.showCrossPlatformDialog(
        //       context,
        //       'Peringatan!',
        //       'Anda tidak absen pada ${Format.tanggalFormat(date)}',
        //       () => Navigator.pop(context),
        //       'Tutup',
        //       isIOS: Platform.isIOS ? true : false,
        //     );
        //   }
        // }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.008,
          horizontal: MediaQuery.of(context).size.width * 0.01,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ~:Left Side:~
            Expanded(
              child: Wrap(
                spacing: 15,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      if (attendanceData.checkIn.isNotEmpty) {
                        return Icon(
                          Icons.exit_to_app,
                          size: 40,
                        );
                      } else {
                        return Icon(
                          Icons.exit_to_app,
                          size: 40,
                          color: Colors.red,
                        );
                      }
                    },
                  ),
                  Builder(
                    builder: (context) {
                      if (attendanceData.checkIn.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              attendanceData.checkIn,
                              style: TextThemes.normal.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              Formatter.dateFormat(attendanceData.date),
                              style: TextThemes.normal.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '00:00',
                              style: TextThemes.normal.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              Formatter.dateFormat(attendanceData.date),
                              style: TextThemes.normal.copyWith(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // ~:Right Side:~
            Builder(
              builder: (context) {
                if (attendanceData.checkIn.isNotEmpty) {
                  return Icon(
                    (Platform.isIOS)
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.arrow_right_rounded,
                    size: (Platform.isIOS) ? 20 : 40,
                  );
                } else {
                  return Icon(
                    (Platform.isIOS)
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.arrow_right_rounded,
                    size: (Platform.isIOS) ? 20 : 40,
                    color: Colors.red,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
