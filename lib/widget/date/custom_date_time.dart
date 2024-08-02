import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/widget/format.dart';
import 'package:analog_clock/analog_clock.dart';

class CustomDateTime extends StatefulWidget {
  const CustomDateTime(this.tgl, this.handle, this.isDisable,
      {this.isIpad = false, super.key});

  final String tgl;
  final Function handle;
  final bool isDisable;
  final bool isIpad;

  @override
  State<CustomDateTime> createState() => _CustomDateTimeState();
}

class _CustomDateTimeState extends State<CustomDateTime> {
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
    year = Format.yearFormat(date);

    // print('$day-$month-$year');
  }

  // final List<String> _monthOptions = [
  //   'January',
  //   'February',
  //   'March',
  //   'April',
  //   'May',
  //   'June',
  //   'July',
  //   'August',
  //   'September',
  //   'October',
  //   'November',
  //   'December',
  // ];

  final List<String> _monthOptions = [
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
          AnalogClock(
            decoration: BoxDecoration(
              border: Border.all(width: 3.0, color: Colors.black),
              color: Colors.black,
              shape: BoxShape.circle,
            ), // decoration
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.25,
            isLive: true,
            hourHandColor: Colors.white,
            minuteHandColor: Colors.white,
            showSecondHand: true,
            numberColor: Colors.white,
            showNumbers: true,
            textScaleFactor: 1.5,
            showTicks: true,
            showDigitalClock: true,
            digitalClockColor: Colors.white,
            datetime: DateTime.now(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$day ',
                textAlign: TextAlign.center,
                style: widget.isIpad == true
                    ? GlobalFont.petafontRBold
                    : GlobalFont.gigafontRBold,
              ),
              Text(
                '${_monthOptions[int.parse(month.substring(1)) - 1]} ',
                textAlign: TextAlign.center,
                style: widget.isIpad == true
                    ? GlobalFont.petafontRBold
                    : GlobalFont.gigafontRBold,
              ),
              Text(
                year,
                textAlign: TextAlign.center,
                style: widget.isIpad == true
                    ? GlobalFont.petafontRBold
                    : GlobalFont.gigafontRBold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
