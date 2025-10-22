import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class FollowupDatePicker extends StatelessWidget {
  final String label;
  final String? date;
  final bool isEditable;
  final VoidCallback onTap;
  final bool enableDateFormatter;

  const FollowupDatePicker({
    super.key,
    required this.label,
    this.date,
    required this.isEditable,
    required this.onTap,
    this.enableDateFormatter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextThemes.normal.copyWith(fontSize: 16),
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
                    style: TextThemes.normal.copyWith(
                      fontSize: 16,
                      color: Colors.blue,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : Text(
                  date != null && date!.isNotEmpty
                      ? enableDateFormatter
                            ? DateFormat(
                                'dd MMMM yyyy',
                                'id_ID',
                              ).format(DateTime.parse(date!))
                            : date!
                      : '-',
                  style: TextThemes.normal.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                  ),
                ),
        ),
      ],
    );
  }
}
