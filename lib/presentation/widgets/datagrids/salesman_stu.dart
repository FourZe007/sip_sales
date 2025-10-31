import 'package:flutter/material.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/coordinator_dashboard.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesmanSTUDataSource extends DataGridSource {
  SalesmanSTUDataSource({required List<SalesmanStuModel> salesmanSTUData}) {
    _salesmanSTUData = salesmanSTUData;
    buildDataGridRows();
    notifyListeners();
  }

  late List<SalesmanStuModel> _salesmanSTUData;
  late List<DataGridRow> _salesmanSTUDataGrid;

  void buildDataGridRows() {
    _salesmanSTUDataGrid = _salesmanSTUData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'salesman',
                value: e.employeeName,
              ),
              DataGridCell<String>(
                columnName: 'targetStu',
                value: e.target.toString(),
              ),
              DataGridCell<String>(columnName: 'stu', value: e.stu.toString()),
              DataGridCell<String>(
                columnName: 'stuLm',
                value: e.stulm.toString(),
              ),
              DataGridCell<String>(columnName: '%', value: e.growth.toString()),
            ],
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _salesmanSTUDataGrid;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          // child: Text(
          //   dataGridCell.value.toString() == '0'
          //       ? '-'
          //       : dataGridCell.columnName == '%'
          //       ? '${dataGridCell.value.toString()}%'
          //       : Formatter.toTitleCase(dataGridCell.value.toString()),
          //   textAlign: TextAlign.center,
          // ),
          child: dataGridCell.columnName == 'salesman'
              ? Text(
                  Formatter.toTitleCase(dataGridCell.value.toString()),
                  textAlign: TextAlign.center,
                  style: TextThemes.styledTextButton.copyWith(
                    backgroundColor: Colors.transparent,
                  ),
                )
              : Text(
                  dataGridCell.value.toString() == '0'
                      ? '-'
                      : dataGridCell.columnName == '%'
                      ? '${dataGridCell.value.toString()}%'
                      : Formatter.toTitleCase(dataGridCell.value.toString()),
                  textAlign: TextAlign.center,
                  style: TextThemes.normal.copyWith(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      }).toList(),
    );
  }
}
