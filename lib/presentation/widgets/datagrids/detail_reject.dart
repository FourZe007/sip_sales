import 'package:flutter/material.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/spk_leasing.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DetailRejectDataSource extends DataGridSource {
  final BuildContext context;
  final List<SpkDataDetail3Model> _detailRejectData;
  final int rejectedSpk;

  DetailRejectDataSource({
    required this.context,
    required List<SpkDataDetail3Model> detailRejectData,
    required this.rejectedSpk,
  }) : _detailRejectData = detailRejectData {
    buildDataGridRows();
    notifyListeners();
  }
  late List<DataGridRow> _detailRejectDataGrid;

  void buildDataGridRows() {
    _detailRejectDataGrid = _detailRejectData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'reason',
                value: e.reasonName,
              ),
              DataGridCell<String>(
                columnName: 'total',
                value: e.qty.toString(),
              ),
              DataGridCell<String>(
                columnName: 'con',
                value: rejectedSpk > 0
                    ? '${(e.qty * 100 / rejectedSpk).round()}%'
                    : '-',
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _detailRejectDataGrid;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            dataGridCell.columnName == 'reason'
                ? Formatter.toTitleCase(dataGridCell.value.toString())
                : dataGridCell.value.toString() == '0'
                ? '-'
                : dataGridCell.value.toString(),
            textAlign: TextAlign.center,
            style: TextThemes.normal,
          ),
        );
      }).toList(),
    );
  }
}
