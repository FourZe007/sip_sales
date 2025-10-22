import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sip_sales_clean/data/models/act_types.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class HeadActTypesDropdown extends StatefulWidget {
  const HeadActTypesDropdown({
    required this.listData,
    required this.inputan,
    required this.hint,
    required this.handle,
    this.disable = false,
    super.key,
  });
  final List<HeadActTypesModel> listData;
  final String inputan;
  final String hint;
  final Function handle;
  final bool disable;

  @override
  State<HeadActTypesDropdown> createState() => _HeadActTypesDropdownState();
}

class _HeadActTypesDropdownState extends State<HeadActTypesDropdown> {
  String teksDisable = '';
  String value = '';

  @override
  void initState() {
    value = widget.inputan;
    log('list length: ${widget.listData.length}');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        borderRadius: BorderRadius.circular(20),
        isExpanded: true,
        isDense: true,
        hint: Text(
          'Masukkan ${widget.hint}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Metropolis',
          ),
        ),
        value: value == '' ? null : value,
        icon: const Icon(
          Icons.arrow_drop_down_rounded,
          size: 25,
        ),
        items: widget.disable
            ? null
            : widget.listData.asMap().entries.map((entry) {
                final HeadActTypesModel activities = entry.value;

                return DropdownMenuItem(
                  value: activities.activityName,
                  child: Text(
                    activities.activityName,
                    style: TextThemes.normal.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
        onChanged: (newValues) {
          if (value != newValues) {
            setState(() => value = newValues.toString());
            widget.handle(newValues);
          }
        },
      ),
    );
  }
}
