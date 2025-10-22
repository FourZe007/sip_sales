import 'package:flutter/material.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/coordinator_dashboard.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesFUOverviewDataSource extends DataGridSource {
  final BuildContext context;
  final List<SalesFUOverviewModel> _salesFUOverviewData;

  SalesFUOverviewDataSource({
    required this.context,
    required List<SalesFUOverviewModel> salesFUOverviewData,
  }) : _salesFUOverviewData = salesFUOverviewData {
    buildDataGridRows();
    notifyListeners();
  }
  late List<DataGridRow> _salesFUOverviewDataGrid;

  void buildDataGridRows() {
    _salesFUOverviewDataGrid = _salesFUOverviewData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'salesman',
                value: e.employeeName,
              ),
              DataGridCell<String>(
                columnName: 'prosesFU',
                value: e.prosesFU.toString(),
              ),
              DataGridCell<String>(
                columnName: 'closing',
                value: e.closing.toString(),
              ),
              DataGridCell<String>(
                columnName: 'cancel',
                value: e.batal.toString(),
              ),
              DataGridCell<String>(
                columnName: 'blmFU',
                value: e.belumFU.toString(),
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _salesFUOverviewDataGrid;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 4.0),
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
                      : dataGridCell.value.toString(),
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
