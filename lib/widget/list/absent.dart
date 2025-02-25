import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sip_sales/global/dialog.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state_management.dart';
import 'package:sip_sales/widget/format.dart';
import 'dart:math' as math;

import 'package:sip_sales/widget/list/absent_details.dart';

class AbsentList {
  // ~:Clock In & Clock Out:~
  static Widget type1(
    BuildContext context,
    String checkIn,
    String checkOut,
    String date,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.01,
        vertical: MediaQuery.of(context).size.height * 0.005,
      ),
      child: Wrap(
        runSpacing: 15,
        runAlignment: WrapAlignment.center,
        children: [
          // ~:Clock In:~
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 15,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Builder(
                      builder: (context) {
                        if (checkIn.isNotEmpty) {
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
                        if (checkIn.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                checkIn,
                                style: GlobalFont.mediumgiantfontRBold,
                              ),
                              Text(
                                Format.tanggalFormat(date),
                                style: GlobalFont.mediumgiantfontR,
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '00:00',
                                style: GlobalFont.giantfontRBoldRed,
                              ),
                              Text(
                                Format.tanggalFormat(date),
                                style: GlobalFont.mediumgiantfontRRed,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  if (checkIn.isNotEmpty) {
                    return Text(
                      'In',
                      style: GlobalFont.giantfontRBold,
                    );
                  } else {
                    return Text(
                      'In',
                      style: GlobalFont.giantfontRBoldRed,
                    );
                  }
                },
              ),
            ],
          ),

          // ~:Clock Out:~
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 15,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Transform.rotate(
                      angle: 180 * math.pi / 180,
                      child: Builder(
                        builder: (context) {
                          if (checkOut.isNotEmpty) {
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
                    ),
                    Builder(
                      builder: (context) {
                        if (checkOut.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                checkOut,
                                style: GlobalFont.mediumgiantfontR,
                              ),
                              Text(
                                Format.tanggalFormat(date),
                                style: GlobalFont.mediumgiantfontR,
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '00:00',
                                style: GlobalFont.giantfontRBoldRed,
                              ),
                              Text(
                                Format.tanggalFormat(date),
                                style: GlobalFont.mediumgiantfontRRed,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  if (checkOut.isNotEmpty) {
                    return Text(
                      'Out',
                      style: GlobalFont.giantfontRBold,
                    );
                  } else {
                    return Text(
                      'Out',
                      style: GlobalFont.giantfontRBoldRed,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ~:Old Absent List Design:~
  static Widget type2(
    BuildContext context,
    String locationName,
    String branchName,
    String checkIn,
    String checkOut,
    String date,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: (checkIn.isEmpty && checkOut.isEmpty)
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
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.01,
      ),
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
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
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$locationName $branchName',
                          style: GlobalFont.giantfontRBold,
                        ),
                        Text(
                          Format.tanggalFormat(date),
                          style: GlobalFont.mediumgiantfontR,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Builder(
              builder: (context) {
                if (checkIn.isEmpty && checkOut.isEmpty) {
                  return Text(
                    'Clock In: - , Clock Out: -',
                    style: GlobalFont.mediumgiantfontR,
                    overflow: TextOverflow.clip,
                  );
                } else if (checkIn.isNotEmpty && checkOut.isEmpty) {
                  return Text(
                    'Clock In: $checkIn, Clock Out: -',
                    style: GlobalFont.mediumgiantfontR,
                    overflow: TextOverflow.clip,
                  );
                } else if (checkIn.isEmpty && checkOut.isNotEmpty) {
                  return Text(
                    'Clock In: - , Clock Out: $checkOut',
                    style: GlobalFont.mediumgiantfontR,
                    overflow: TextOverflow.clip,
                  );
                } else {
                  return Text(
                    'Clock In: $checkIn, Clock Out: $checkOut',
                    style: GlobalFont.mediumgiantfontR,
                    overflow: TextOverflow.clip,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ~:Same Design with Type1, but only show Clock In:~
  static Widget type3(
    BuildContext context,
    String checkIn,
    String date,
  ) {
    return Container(
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
                    if (checkIn.isNotEmpty) {
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
                    if (checkIn.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            checkIn,
                            style: GlobalFont.mediumgiantfontRBold,
                          ),
                          Text(
                            Format.tanggalFormat(date),
                            style: GlobalFont.mediumgiantfontR,
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '00:00',
                            style: GlobalFont.giantfontRBoldRed,
                          ),
                          Text(
                            Format.tanggalFormat(date),
                            style: GlobalFont.mediumgiantfontRRed,
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
              if (checkIn.isNotEmpty) {
                return Text(
                  'In',
                  style: GlobalFont.giantfontRBold,
                );
              } else {
                return Text(
                  'In',
                  style: GlobalFont.giantfontRBoldRed,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ~:Same Design with Type3, but with arrow at the right side:~
  static Widget type4(
    BuildContext context,
    SipSalesState state,
    String checkIn,
    String date,
  ) {
    return InkWell(
      onTap: () {
        final now = DateTime.now();
        final todayDate = DateTime(now.year, now.month, now.day);

        if (checkIn.isNotEmpty) {
          state.absentHistoryDetail =
              state.getAbsentHistoryList.where((e) => e.date == date).first;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AbsentDetailsPage(),
            ),
          );
        } else {
          if (todayDate.toString().split(' ')[0] == date) {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Peringatan!',
              'Anda belum absen hari ini. ',
              () => Navigator.pop(context),
              'Tutup',
              isIOS: Platform.isIOS ? true : false,
            );
          } else {
            GlobalDialog.showCrossPlatformDialog(
              context,
              'Peringatan!',
              'Anda tidak absen pada ${Format.tanggalFormat(date)}',
              () => Navigator.pop(context),
              'Tutup',
              isIOS: Platform.isIOS ? true : false,
            );
          }
        }
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
                      if (checkIn.isNotEmpty) {
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
                      if (checkIn.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              checkIn,
                              style: GlobalFont.mediumgiantfontRBold,
                            ),
                            Text(
                              Format.tanggalFormat(date),
                              style: GlobalFont.mediumgiantfontR,
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '00:00',
                              style: GlobalFont.giantfontRBoldRed,
                            ),
                            Text(
                              Format.tanggalFormat(date),
                              style: GlobalFont.mediumgiantfontRRed,
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
                if (checkIn.isNotEmpty) {
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
