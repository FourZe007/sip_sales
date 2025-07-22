import 'package:flutter/material.dart';
import 'package:sip_sales/global/model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesCategoryDataSource extends DataGridSource {
  SalesCategoryDataSource({required List<CategoryModel> salesData}) {
    _salesData = salesData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'cara jual',
                value: e.salesCategorySC,
              ),
              DataGridCell<int>(columnName: 'pros', value: e.prospekSC),
              DataGridCell<int>(columnName: 'spk', value: e.spksc),
              DataGridCell<int>(columnName: 'stu', value: e.stusc),
              DataGridCell<int>(columnName: 'lm', value: e.lmsc),
              DataGridCell<String>(
                columnName: '%',
                value: e.ratioSC.toString(),
              ),
            ]))
        .toList();
  }

  List<DataGridRow> _salesData = [];

  @override
  List<DataGridRow> get rows => _salesData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

class SalesCategoryDataTable extends StatefulWidget {
  SalesCategoryDataTable(
      {required List<CategoryModel> salesCategory, super.key})
      : _salesCategory = List.unmodifiable(salesCategory);

  final List<CategoryModel> _salesCategory;

  List<CategoryModel> get getSalesCategory => _salesCategory;

  @override
  State<SalesCategoryDataTable> createState() => _SalesCategoryDataTableState();
}

class _SalesCategoryDataTableState extends State<SalesCategoryDataTable> {
  late SalesCategoryDataSource _salesCategoryDataSource;
  List<CategoryModel> _salesCategory = [];

  @override
  void initState() {
    super.initState();
    _salesCategory = widget.getSalesCategory;
    _salesCategoryDataSource =
        SalesCategoryDataSource(salesData: _salesCategory);
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: _salesCategoryDataSource,
      columnWidthMode: ColumnWidthMode.fill,
      columns: <GridColumn>[
        GridColumn(
          columnName: 'caraJual',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('CARA JUAL'),
          ),
        ),
        GridColumn(
          columnName: 'pros',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('PROS'),
          ),
        ),
        GridColumn(
          columnName: 'spk',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('SPK'),
          ),
        ),
        GridColumn(
          columnName: 'stu',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('STU'),
          ),
        ),
        GridColumn(
          columnName: 'lm',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('LM'),
          ),
        ),
        GridColumn(
          columnName: 'percentage',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('%'),
          ),
        ),
      ],
    );
  }
}
