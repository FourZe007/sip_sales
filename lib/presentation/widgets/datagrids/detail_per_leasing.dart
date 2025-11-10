import 'package:flutter/material.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/spk_leasing.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DetailPerLeasingDataSource extends DataGridSource {
  final BuildContext context;
  final List<SpkDataDetail1Model> _detailPerLeasingData;

  DetailPerLeasingDataSource({
    required this.context,
    required List<SpkDataDetail1Model> detailPerLeasingData,
  }) : _detailPerLeasingData = detailPerLeasingData {
    buildDataGridRows();
    notifyListeners();
  }
  late List<DataGridRow> _detailPerLeasingDataGrid;

  void buildDataGridRows() {
    _detailPerLeasingDataGrid = _detailPerLeasingData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'leasing',
                value: e.leasingId,
              ),
              DataGridCell<String>(
                columnName: 'total',
                value: e.totalSPK.toString(),
              ),
              DataGridCell<String>(
                columnName: 'opened',
                value: e.spkTerbuka.toString(),
              ),
              DataGridCell<String>(
                columnName: 'approved',
                value: e.spkApprove.toString(),
              ),
              DataGridCell<String>(
                columnName: 'approvedPercent',
                value: (e.spkApprove + e.spkReject) > 0
                    ? '${(e.spkApprove * 100 / (e.spkApprove + e.spkReject)).round()}%'
                    : '-',
              ),
              DataGridCell<String>(
                columnName: 'con',
                value: (e.spkApprove + e.spkReject) > 0
                    ? '${(e.spkApprove * 100 / (e.spkApprove + e.spkReject)).round()}%'
                    : '-',
              ),
              DataGridCell<String>(
                columnName: 'rejected',
                value: e.spkReject.toString(),
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _detailPerLeasingDataGrid;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            dataGridCell.value.toString() == '0'
                ? '-'
                : dataGridCell.columnName == 'leasing'
                ? Formatter.toTitleCase(
                    dataGridCell.value.toString(),
                  )
                : dataGridCell.value.toString(),
            textAlign: TextAlign.center,
            style: TextThemes.normal.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }
}
