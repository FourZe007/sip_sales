// DataGridSource implementation for the STU table
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LeasingInsertDataSource extends DataGridSource {
  final Function(int rowIndex, String columnName, int newValue)?
  onCellValueEdited;
  final bool isEditingAllowed;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  LeasingInsertDataSource(
    List<HeadLeasingMasterModel> data, {
    this.onCellValueEdited,
    this.isEditingAllowed = true,
  }) {
    log('Data Source length: ${data.length}');
    _leasingData = List<HeadLeasingMasterModel>.from(data);
    buildDataGridRows();
    notifyListeners();
  }

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

  // Method to update data and refresh the grid
  void updateData(List<HeadLeasingMasterModel> newData) {
    log('Updating data source with ${newData.length} items');
    _leasingData = List<HeadLeasingMasterModel>.from(newData);
    buildDataGridRows();
    notifyListeners();
  }

  // Method to add a new empty row
  // void addEmptyRow() {
  //   _stuData.add(LeasingData('JOE', 0, 0, 0, 0, 0));
  //   buildDataGridRows();
  //   notifyListeners();
  // }

  late List<HeadLeasingMasterModel> _leasingData;
  late List<DataGridRow> _dataGridRows;

  void buildDataGridRows() {
    _dataGridRows = _leasingData.map<DataGridRow>((data) {
      return DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'Leasing', value: data.leasingID),
          DataGridCell<int>(columnName: 'Total', value: data.total),
          DataGridCell<int>(columnName: 'Opened', value: data.terbuka),
          DataGridCell<int>(columnName: 'Accepted', value: data.disetujui),
          DataGridCell<int>(columnName: 'Rejected', value: data.ditolak),
          DataGridCell<double>(columnName: 'Approval', value: data.persentase),
        ],
      );
    }).toList();
    notifyListeners(); // Notify listeners after building rows
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = _dataGridRows.indexOf(row);
    if (rowIndex == -1) return const DataGridRowAdapter(cells: []);

    HeadLeasingMasterModel leasingEntry = _leasingData[rowIndex];

    if (!isEditingAllowed) {
      return DataGridRowAdapter(
        cells: row.getCells().asMap().entries.map<Widget>((entry) {
          final DataGridCell<dynamic> dataGridCell = entry.value;
          final String columnName = dataGridCell.columnName;

          if (columnName == 'Approval') {
            // Format the approvalRate (double 0.0-1.0) as a percentage string
            String approvalText = (leasingEntry.persentase ?? 0)
                .toStringAsFixed(
                  1,
                );
            return Center(
              child: Text(
                '$approvalText%',
                textAlign: TextAlign.center,
                style: TextThemes.normal, // (using existing style)
              ),
            );
          } else {
            // 'Leasing' column (Type)
            return Center(
              child: Text(
                dataGridCell.value.toString(),
                textAlign: TextAlign.center,
                style: TextThemes.normal,
              ),
            );
          }
        }).toList(),
      );
    } else {
      return DataGridRowAdapter(
        cells: row.getCells().asMap().entries.map<Widget>((entry) {
          final int cellIndex = entry.key;
          final DataGridCell<dynamic> dataGridCell = entry.value;
          final String columnName = dataGridCell.columnName;

          bool isEditable =
              columnName == 'Total' ||
              columnName == 'Opened' ||
              columnName == 'Accepted' ||
              columnName == 'Rejected';

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
                  }
                },
              ),
            );
          } else if (columnName == 'Approval') {
            // Format the approvalRate (double 0.0-1.0) as a percentage string
            String approvalText = (leasingEntry.persentase ?? 0)
                .toStringAsFixed(
                  1,
                );
            return Center(
              child: Text(
                '$approvalText%',
                textAlign: TextAlign.center,
                style: TextThemes.normal, // (using existing style)
              ),
            );
          } else {
            // 'Leasing' column (Type)
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
}
