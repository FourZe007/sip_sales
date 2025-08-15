import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales/global/global.dart';

class FollowupDatePicker extends StatelessWidget {
  final String label;
  final String? date;
  final bool isEditable;
  final VoidCallback onTap;

  const FollowupDatePicker({
    super.key,
    required this.label,
    this.date,
    required this.isEditable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: GlobalFont.bigfontR,
          ),
        ),
        Expanded(
          flex: 2,
          child: isEditable
              ? InkWell(
                  onTap: onTap,
                  child: Text(
                    DateFormat('dd MMMM yyyy', 'id_ID').format(
                      date != null && date!.isNotEmpty
                          ? DateTime.parse(date!)
                          : DateTime.now(),
                    ),
                    style: GlobalFont.bigfontR.copyWith(
                      color: Colors.blue,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : Text(
                  date != null && date!.isNotEmpty
                      ? DateFormat('dd MMMM yyyy', 'id_ID')
                          .format(DateTime.parse(date!))
                      : '-',
                  style: GlobalFont.bigfontR.copyWith(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                  ),
                ),
        ),
      ],
    );
  }
}
