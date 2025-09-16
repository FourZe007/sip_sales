import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/formatter.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_bloc.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_event.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesmanProspekDataSource extends DataGridSource {
  final BuildContext context;
  final List<SalesmanProspekModel> _salesmanProspekData;
  final String date;

  SalesmanProspekDataSource({
    required this.context,
    required List<SalesmanProspekModel> salesmanProspekData,
    required this.date,
  }) : _salesmanProspekData = salesmanProspekData {
    buildDataGridRows();
    notifyListeners();
  }
  late List<DataGridRow> _salesmanProspekDataGrid;

  void buildDataGridRows() {
    _salesmanProspekDataGrid = _salesmanProspekData
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<String>(columnName: 'salesman', value: e.employeeName),
            DataGridCell<String>(
                columnName: 'targetProspek', value: e.targetP.toString()),
            DataGridCell<String>(
                columnName: 'prospek', value: e.prospek.toString()),
            DataGridCell<String>(
                columnName: 'targetSPK', value: e.targetS.toString()),
            DataGridCell<String>(columnName: 'spk', value: e.spk.toString()),
          ]),
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
            ? GestureDetector(
                onTap: () async {
                  final rowIndex = _salesmanProspekDataGrid.indexOf(row);
                  if (rowIndex != -1 &&
                      rowIndex < _salesmanProspekData.length) {
                    final rowData = _salesmanProspekData[rowIndex];
                    context.read<SalesDashboardBloc>().add(LoadSalesDashboard(
                          rowData.employeeId,
                          date,
                        ));

                    if (context.mounted) {
                      Navigator.pushNamed(context, '/salesDashboard');
                    }
                  }
                },
                child: Text(
                  Formatter.toTitleCase(dataGridCell.value.toString()),
                  textAlign: TextAlign.center,
                  style:
                      GlobalFont.bigfontRUnderlinedBlue.copyWith(fontSize: 13),
                ),
              )
            : Text(
                dataGridCell.value.toString() == '0'
                    ? '-'
                    : dataGridCell.value.toString(),
                textAlign: TextAlign.center,
                style: GlobalFont.bigfontR,
              ),
      );
    }).toList());
  }
}
