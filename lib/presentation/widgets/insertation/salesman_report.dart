import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/salesman_data_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesmanInsertDataSource extends DataGridSource {
  final Function(int rowIndex, String columnName, int newValue)?
  onCellValueEdited;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  SalesmanInsertDataSource(List<SalesmanData> data, {this.onCellValueEdited}) {
    _salesmanData = data;
    buildDataGridRows();
    notifyListeners();
  }

  List<SalesmanData> _salesmanData = [];
  List<DataGridRow> dataGridRows = [];

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

  void updateData(List<SalesmanData> newData) {
    _salesmanData = newData;
    buildDataGridRows();
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows {
    log('Accessing rows getter, current row count: ${dataGridRows.length}');
    return dataGridRows;
  }

  void buildDataGridRows() {
    log(
      'Starting buildDataGridRows with ${_salesmanData.length} salesman items',
    );
    dataGridRows.clear();
    dataGridRows.addAll(
      _salesmanData.asMap().entries.map<DataGridRow>((entry) {
        final index = entry.key;
        final salesman = entry.value;
        log('Processing salesman at index $index: ${salesman.name}');
        return DataGridRow(
          cells: [
            DataGridCell<String>(columnName: 'Nama', value: salesman.name),
            DataGridCell<String>(
              columnName: 'Posisi',
              value: salesman.position,
            ),
            DataGridCell<int>(columnName: 'SPK', value: salesman.spk),
            DataGridCell<int>(columnName: 'STU', value: salesman.stu),
            DataGridCell<int>(columnName: 'STU LM', value: salesman.stuLm),
          ],
        );
      }),
    );

    log('DataGridRows built: ${dataGridRows.length} rows');

    // Log all rows and cells in debug mode
    assert(() {
      for (int i = 0; i < dataGridRows.length; i++) {
        final row = dataGridRows[i];
        log('Row $i:');
        for (var cell in row.getCells()) {
          log('  - ${cell.columnName}: ${cell.value}');
        }
      }
      return true;
    }());
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    log('Row length: ${row.getCells().length}');
    final int rowIndex = dataGridRows.indexOf(row);
    if (rowIndex == -1) return const DataGridRowAdapter(cells: []);

    return DataGridRowAdapter(
      cells: row.getCells().asMap().entries.map<Widget>((entry) {
        final int cellIndex = entry.key;
        final DataGridCell<dynamic> dataGridCell = entry.value;
        final String columnName = dataGridCell.columnName;

        // Check if the cell is editable (SPK, STU, or STU LM columns)
        bool isEditable =
            columnName == 'SPK' ||
            columnName == 'STU' ||
            columnName == 'STU LM';

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

          // Editable cell with TextFormField
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

                if (parsedValue != null && onCellValueEdited != null) {
                  onCellValueEdited!(rowIndex, columnName, parsedValue);
                } else if (newValue.isEmpty && onCellValueEdited != null) {
                  // Handle clearing the field by sending 0
                  onCellValueEdited!(rowIndex, columnName, 0);
                }
              },
            ),
          );
        } else {
          // Non-editable cell
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              Formatter.toTitleCase(dataGridCell.value.toString()),
              textAlign: TextAlign.center,
            ),
          );
        }
      }).toList(),
    );
  }
}
