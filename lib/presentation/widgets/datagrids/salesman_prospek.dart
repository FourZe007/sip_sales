import 'package:flutter/material.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/coordinator_dashboard.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesmanProspekDataSource extends DataGridSource {
  final BuildContext context;
  final List<SalesmanProspekModel> _salesmanProspekData;

  SalesmanProspekDataSource({
    required this.context,
    required List<SalesmanProspekModel> salesmanProspekData,
  }) : _salesmanProspekData = salesmanProspekData {
    buildDataGridRows();
    notifyListeners();
  }
  late List<DataGridRow> _salesmanProspekDataGrid;

  void buildDataGridRows() {
    _salesmanProspekDataGrid = _salesmanProspekData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'salesman',
                value: e.employeeName,
              ),
              DataGridCell<String>(
                columnName: 'targetProspek',
                value: e.targetP.toString(),
              ),
              DataGridCell<String>(
                columnName: 'prospek',
                value: e.prospek.toString(),
              ),
              DataGridCell<String>(
                columnName: 'targetSPK',
                value: e.targetS.toString(),
              ),
              DataGridCell<String>(columnName: 'spk', value: e.spk.toString()),
            ],
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _salesmanProspekDataGrid;

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
