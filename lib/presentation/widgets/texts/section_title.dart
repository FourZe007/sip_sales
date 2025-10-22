import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class SectionTitleText extends StatelessWidget {
  const SectionTitleText({
    required this.title,
    this.isTitleBold = false,
    this.isHintEnabled = false,
    this.hint = '',
    super.key,
  });

  final String title;
  final bool isTitleBold;
  final bool isHintEnabled;
  final String hint;

  @override
  Widget build(BuildContext context) {
    if (isHintEnabled) {
      return Row(
        spacing: 8,
        children: [
          Text(
            title,
            style: TextThemes.normal.copyWith(
              fontSize: 20,
              fontWeight: isTitleBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),

          InfoPopupWidget(
            arrowTheme: InfoPopupArrowTheme(
              color: Colors.grey,
            ),
            dismissTriggerBehavior: PopupDismissTriggerBehavior.onTapArea,
            contentTitle: hint,
            child: Icon(
              Icons.info_outlined,
              color: Colors.black,
            ),
          ),
        ],
      );
    } else {
      return Text(
        title,
        style: TextThemes.normal.copyWith(
          fontSize: 20,
          fontWeight: isTitleBold ? FontWeight.bold : FontWeight.normal,
        ),
      );
    }
  }
}
