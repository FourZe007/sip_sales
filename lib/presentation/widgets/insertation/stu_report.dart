// Define a model for the STU data

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// DataGridSource implementation for the STU table
class StuInsertDataSource extends DataGridSource {
  final Function(int rowIndex, String columnName, int newValue)?
  onCellValueEdited;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  StuInsertDataSource(
    List<HeadStuCategoriesMasterModel> data, {
    this.onCellValueEdited,
  }) {
    _stuData = data;
    buildDataGridRows();
    notifyListeners();
  }

  late List<HeadStuCategoriesMasterModel> _stuData;
  late List<DataGridRow> _dataGridRows;

  @override
  void dispose() {
    // Clean up all controllers and focus nodes
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String _getControllerKey(int rowIndex, int cellIndex) {
    return '${rowIndex}_$cellIndex';
  }

  void buildDataGridRows() {
    _dataGridRows = _stuData.map<DataGridRow>((data) {
      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'STU', value: data.category),
          DataGridCell<int>(columnName: 'Target', value: data.target),
          DataGridCell<int>(columnName: 'Tm', value: data.tm),
          DataGridCell<String>(columnName: 'Ach', value: data.acv.toString()),
          DataGridCell<int>(columnName: 'LM', value: data.lm),
          DataGridCell<String>(
            columnName: 'Growth',
            value: data.growth.toString(),
          ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int rowIndex = _dataGridRows.indexOf(row);
    if (rowIndex == -1) return null;

    final HeadStuCategoriesMasterModel stuEntry = _stuData[rowIndex];

    return DataGridRowAdapter(
      cells: row.getCells().asMap().entries.map<Widget>((entry) {
        final int cellIndex = entry.key;
        final DataGridCell<dynamic> dataGridCell = entry.value;
        final String columnName = dataGridCell.columnName;

        bool isEditable =
            columnName == 'Tm' || columnName == 'Target' || columnName == 'LM';

        if (isEditable) {
          // Create or get controller and focus node for this cell
          final controllerKey = _getControllerKey(rowIndex, cellIndex);
          final controller =
              _controllers[controllerKey] ??
              TextEditingController(text: dataGridCell.value.toString());
          final focusNode = _focusNodes[controllerKey] ?? FocusNode();

          // Store them if they're new
          if (!_controllers.containsKey(controllerKey)) {
            _controllers[controllerKey] = controller;
            _focusNodes[controllerKey] = focusNode;

            // Set up focus listener to select all text when focused
            focusNode.addListener(() {
              if (focusNode.hasFocus) {
                controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: controller.text.length,
                );
              }
            });
          } else {
            // Update controller value if it already exists
            controller.text = dataGridCell.value.toString();
          }

          // ~:Editable TextFormField for Result, Target, and LM:~
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: (String newValue) {
                int? parsedValue = int.tryParse(newValue);
                if (rowIndex != -1) {
                  switch (cellIndex) {
                    case 1:
                      _stuData[rowIndex].target = parsedValue ?? 0;
                      break;
                    case 2:
                      _stuData[rowIndex].tm = parsedValue ?? 0;
                      break;
                    case 4:
                      _stuData[rowIndex].lm = parsedValue ?? 0;
                      break;
                    default:
                      break;
                  }
                }

                if (parsedValue != null && onCellValueEdited != null) {
                  onCellValueEdited!(rowIndex, columnName, parsedValue);
                }
              },
            ),
          );
        } else if (columnName == 'Ach') {
          // ~:Display achievement rate as a percentage string:~
          String achievementRate = stuEntry.acv.toString();
          return Center(
            child: Text(
              '$achievementRate%',
              textAlign: TextAlign.center,
              style: TextThemes.normal,
            ),
          );
        } else if (columnName == 'Growth') {
          // ~:Display growth rate as a percentage string:~
          String growthRate = stuEntry.growth.toString();
          return Center(
            child: Text(
              '$growthRate%',
              textAlign: TextAlign.center,
              style: TextThemes.normal,
            ),
          );
        } else {
          // ~:STU Type:~
          return Center(
            child: Text(
              dataGridCell.value.toString(),
              textAlign: TextAlign.center,
              style: TextThemes.normal.copyWith(
                fontWeight: FontWeight.bold,
              ), //
            ),
          );
        }
      }).toList(),
    );
  }
}
