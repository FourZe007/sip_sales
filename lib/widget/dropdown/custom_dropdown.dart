import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state_management.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown(
      {required this.listData,
      required this.inputan,
      required this.hint,
      required this.handle,
      this.disable = false,
      super.key});
  final List<dynamic> listData;
  final String inputan;
  final String hint;
  final Function handle;
  final bool disable;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String teksDisable = '';
  String value = '';

  @override
  void initState() {
    value = widget.inputan;
    print('list length: ${widget.listData.length}');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropdownState = Provider.of<SipSalesState>(context);

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        borderRadius: BorderRadius.circular(20),
        isExpanded: true,
        isDense: true,
        hint: Text(
          'Masukkan ${widget.hint}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: 'Metropolis',
          ),
        ),
        value: value == '' ? null : value,
        icon: const Icon(
          Icons.arrow_drop_down_rounded,
          size: 25,
        ),
        items: widget.disable == true
            ? null
            : widget.listData.asMap().entries.map((entry) {
                // final int index = entry.key;
                final ModelActivities activities = entry.value;

                return DropdownMenuItem(
                  value: activities.activityName,
                  child: Text(
                    activities.activityName,
                    style: GlobalFont.mediumfontR,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
        onChanged: (newValues) {
          if (value != newValues) {
            setState(() => value = newValues.toString());
            // print('Dropdown value: $value');
            if (widget.hint == 'Manager Activity Type') {
              dropdownState.setTypeListener(value, true);
              for (ModelActivities value in widget.listData) {
                if (value.activityName == newValues) {
                  // print(newValues);
                  // print(value.activityTemplate);
                  widget.handle(newValues, value.activityTemplate);
                  break;
                }
              }
            } else {
              dropdownState.setTypeListener(value, false);
              widget.handle(newValues);
            }
            dropdownState.filteredList.clear();
            dropdownState.setIsDisable(true);
          }
        },
      ),
    );
  }
}
