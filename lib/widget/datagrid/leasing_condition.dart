import 'package:flutter/cupertino.dart';
import 'package:sip_sales/global/model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LeasingConditionDataSource extends DataGridSource {
  LeasingConditionDataSource({required List<LeasingModel> categoryData}) {
    _leasingConditionData = categoryData;
    buildDataGridRows();
    notifyListeners();
  }

  late List<LeasingModel> _leasingConditionData;
  late List<DataGridRow> _leasingConditionDataGrid;

  void buildDataGridRows() {
    _leasingConditionDataGrid = _leasingConditionData
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<String>(
              columnName: 'name',
              value: e.leasingID,
            ),
            DataGridCell<String>(
              columnName: 'total',
              value: e.totalSPKLeasing.toString(),
            ),
            DataGridCell<String>(
              columnName: 'proses',
              value: e.spkProsesLeasing.toString(),
            ),
            DataGridCell<String>(
              columnName: 'terbuka',
              value: e.spkTerbukaLeasing.toString(),
            ),
            DataGridCell<String>(
              columnName: 'unit',
              value: e.spkApproveLeasing.toString(),
            ),
            DataGridCell<String>(
              columnName: '%',
              value: e.ratioLeasing.toString(),
            ),
          ]),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _leasingConditionDataGrid;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          dataGridCell.columnName == '%'
              ? '${dataGridCell.value.toString()}%'
              : dataGridCell.value.toString(),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      );
    }).toList());
  }
}
