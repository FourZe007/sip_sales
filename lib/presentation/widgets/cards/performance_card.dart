import 'package:flutter/material.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class PerformanceCard {
  static Widget base(
    final String title,
    final String value, {
    final Color boxColor = Colors.lightBlue,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: boxColor,
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextThemes.normal,
          ),
          Text(
            value,
            style: TextThemes.normal.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
