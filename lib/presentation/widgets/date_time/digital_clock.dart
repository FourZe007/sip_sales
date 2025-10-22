import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class CustomDigitalClock extends StatefulWidget {
  const CustomDigitalClock(
    this.tgl,
    this.handle,
    this.isDisable, {
    this.isIpad = false,
    super.key,
  });

  final String tgl;
  final Function handle;
  final bool isDisable;
  final bool isIpad;

  @override
  State<CustomDigitalClock> createState() => _CustomDigitalClockState();
}

class _CustomDigitalClockState extends State<CustomDigitalClock> {
  String date = '';
  String day = '';
  String month = '';
  String year = '';

  void customize() {
    date = widget.tgl == ''
        ? DateTime.now().toString().substring(0, 10)
        : widget.tgl;

    day = Formatter.dayFormat(date);
    month = Formatter.monthFormat(date);
    log('Month: $month');
    year = Formatter.yearFormat(date);
  }

  final List<String> weekdaysOptions = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  final List<String> monthOptions = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  void initState() {
    customize();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 102,
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ~:Time:~
          DigitalClock(
            datetime: DateTime.now(),
            textScaleFactor: 1.75,
            isLive: true,
            showSeconds: false,
          ),

          // ~:Date:~
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${weekdaysOptions[DateTime.now().weekday - 1]}, ',
                textAlign: TextAlign.center,
                style: widget.isIpad == true
                    ? TextThemes.normal.copyWith(fontSize: 28)
                    : TextThemes.normal.copyWith(fontSize: 24),
              ),
              Builder(
                builder: (context) {
                  if (day[0] == '0') {
                    return Text(
                      '${day[1]} ',
                      textAlign: TextAlign.center,
                      style: widget.isIpad == true
                          ? TextThemes.normal.copyWith(fontSize: 28)
                          : TextThemes.normal.copyWith(fontSize: 24),
                    );
                  } else {
                    return Text(
                      '$day ',
                      textAlign: TextAlign.center,
                      style: widget.isIpad == true
                          ? TextThemes.normal.copyWith(fontSize: 28)
                          : TextThemes.normal.copyWith(fontSize: 24),
                    );
                  }
                },
              ),
              Text(
                '${monthOptions[int.parse(month) - 1]} ',
                textAlign: TextAlign.center,
                style: widget.isIpad == true
                    ? TextThemes.normal.copyWith(fontSize: 28)
                    : TextThemes.normal.copyWith(fontSize: 24),
              ),
              Text(
                year,
                textAlign: TextAlign.center,
                style: widget.isIpad == true
                    ? TextThemes.normal.copyWith(fontSize: 28)
                    : TextThemes.normal.copyWith(fontSize: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
