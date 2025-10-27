import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:one_clock/one_clock.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class CustomDigitalClock extends StatefulWidget {
  const CustomDigitalClock({
    /// This is a string that represents the type of device. It can be one of the
    /// following:
    /// - 'Phone': A small device with a narrow screen.
    /// - 'Phablet': A device with a wide screen, but not as large as a tablet.
    /// - 'Tablet': A device with a large screen, typically between 7 inches and
    ///   10 inches.
    /// - 'Larger Device': A device with a screen size larger than 10 inches.
    required this.deviceType,
    super.key,
  });

  final String deviceType;

  @override
  State<CustomDigitalClock> createState() => _CustomDigitalClockState();
}

class _CustomDigitalClockState extends State<CustomDigitalClock> {
  @override
  void initState() {
    initializeDateFormatting('id_ID', null);

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
                '${DateFormat('EEEE', 'id_ID').format(DateTime.now())}, ',
                textAlign: TextAlign.center,
                style:
                    widget.deviceType == 'tablet' ||
                        widget.deviceType == 'larger device'
                    ? TextThemes.normal.copyWith(fontSize: 28)
                    : TextThemes.normal.copyWith(fontSize: 24),
              ),
              Text(
                DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now()),
                textAlign: TextAlign.center,
                style:
                    widget.deviceType == 'tablet' ||
                        widget.deviceType == 'larger device'
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
