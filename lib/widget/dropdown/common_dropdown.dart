// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/provider.dart';

class CommonDropdown extends StatefulWidget {
  CommonDropdown(
    this.value, {
    this.defaultValue = '',
    super.key,
  });

  String value;
  final String defaultValue;

  @override
  State<CommonDropdown> createState() => _CommonDropdownState();
}

class _CommonDropdownState extends State<CommonDropdown> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SipSalesState>(context);

    return DropdownButtonFormField<String>(
      isExpanded: true,
      isDense: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(25.0),
        ),
        filled: true,
        fillColor: Colors.grey[350],
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
      ),
      value: widget.value == '' ? widget.defaultValue : widget.value,
      hint: Text('Select an option'),
      items: <String>[
        widget.defaultValue,
        'EVENT',
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: GlobalFont.bigfontR,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        state.setAbsentType(newValue!);
      },
    );
  }
}
