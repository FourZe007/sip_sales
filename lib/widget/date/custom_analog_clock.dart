import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/widget/format.dart';
import 'package:analog_clock/analog_clock.dart';

class CustomAnalogClock extends StatefulWidget {
  const CustomAnalogClock(this.tgl, this.handle, this.isDisable,
      {this.isIpad = false, super.key});

  final String tgl;
  final Function handle;
  final bool isDisable;
  final bool isIpad;

  @override
  State<CustomAnalogClock> createState() => _CustomAnalogClockState();
}

class _CustomAnalogClockState extends State<CustomAnalogClock> {
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
            ),
            width: MediaQuery.of(context).size.width * 0.565,
            height: MediaQuery.of(context).size.height * 0.275,
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
                '${_monthOptions[int.parse(month) - 1]} ',
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
