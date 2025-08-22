import 'package:flutter/cupertino.dart';
import 'package:sip_sales/global/model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesCategoryDataSource extends DataGridSource {
  SalesCategoryDataSource({required List<CategoryModel> categoryData}) {
    _categoryData = categoryData;
    buildDataGridRows();
    notifyListeners();
  }

  late List<CategoryModel> _categoryData;
  late List<DataGridRow> _categoryDataGrid;

  void buildDataGridRows() {
    _categoryDataGrid = _categoryData
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<String>(
                columnName: 'method', value: e.salesCategorySC),
            DataGridCell<String>(
                columnName: 'pros', value: e.prospekSC.toString()),
            DataGridCell<String>(columnName: 'spk', value: e.spksc.toString()),
            DataGridCell<String>(columnName: 'stu', value: e.stusc.toString()),
            DataGridCell<String>(columnName: 'lm', value: e.lmsc.toString()),
            DataGridCell<String>(columnName: '%', value: e.ratioSC.toString()),
          ]),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _categoryDataGrid;

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
              : dataGridCell.columnName == '%'
                  ? '${dataGridCell.value.toString()}%'
                  : dataGridCell.value.toString(),
          textAlign: TextAlign.center,
        ),
      );
    }).toList());
  }
}
