import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/widget/format.dart';

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

    day = Format.dateFormat(date);
    month = Format.monthFormat(date);
    print('Month: $month');
    year = Format.yearFormat(date);
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
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.03,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DigitalClock(
            datetime: DateTime.now(),
            textScaleFactor: 1.75,
            isLive: true,
            showSeconds: false,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${weekdaysOptions[DateTime.now().weekday - 1]}, ',
                textAlign: TextAlign.center,
                style: widget.isIpad == true
                    ? GlobalFont.gigafontR
                    : GlobalFont.mediumgigafontR,
              ),
              Builder(
                builder: (context) {
                  if (day[0] == '0') {
                    return Text(
                      '${day[1]} ',
                      textAlign: TextAlign.center,
                      style: widget.isIpad == true
                          ? GlobalFont.gigafontR
                          : GlobalFont.mediumgigafontR,
                    );
                  } else {
                    return Text(
                      '$day ',
                      textAlign: TextAlign.center,
                      style: widget.isIpad == true
                          ? GlobalFont.gigafontR
                          : GlobalFont.mediumgigafontR,
                    );
                  }
                },
              ),
              Text(
                '${monthOptions[int.parse(month) - 1]} ',
                textAlign: TextAlign.center,
                style: widget.isIpad == true
                    ? GlobalFont.gigafontR
                    : GlobalFont.mediumgigafontR,
              ),
              Text(
                year,
                textAlign: TextAlign.center,
                style: widget.isIpad == true
                    ? GlobalFont.gigafontR
                    : GlobalFont.mediumgigafontR,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
