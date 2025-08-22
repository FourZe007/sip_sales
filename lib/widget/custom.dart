import 'package:flutter/material.dart';
import 'package:sip_sales/global/global.dart';

class CustomWidget {
  static Widget buildStatBox({
    required BuildContext context,
    required String label,
    required int value,
    double boxWidth = 64,
    double boxHeight = 75,
    double labelHeight = 20,
    double labelSize = 16,
    Color boxColor = Colors.amber,
  }) {
    return Container(
      width: boxWidth,
      height: boxHeight,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: labelHeight,
            alignment: Alignment.center,
            child: Text(
              label,
              style: GlobalFont.bigfontR.copyWith(fontSize: labelSize),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Text(
                value.toString(),
                style: GlobalFont.bigfontRBold.copyWith(
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
