import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReportDataGrid extends StatelessWidget {
  const ReportDataGrid({
    super.key,
    required this.dataSource,
    required this.loadedData,
    this.tableHeight = 260,
    this.enableAddRow = false,
    this.allowEditing = false,
    this.headerRowHeight = 48,
    this.rowHeight = 48,
    this.columnWidthMode = ColumnWidthMode.fitByColumnName,
    this.horizontalScrollPhysics = const NeverScrollableScrollPhysics(),
    this.verticalScrollPhysics = const NeverScrollableScrollPhysics(),
    this.rowHeaderWidth = 60,
    this.rowBodyWidth = 60,
    this.textStyle,
    this.textAlignment = Alignment.center,
    this.addFunction,
  });

  final DataGridSource dataSource;
  final List<String> loadedData;
  final double tableHeight;
  final bool enableAddRow;
  final bool allowEditing;
  final double headerRowHeight;
  final double rowHeight;
  final ColumnWidthMode columnWidthMode;
  final ScrollPhysics horizontalScrollPhysics;
  final ScrollPhysics verticalScrollPhysics;
  final double rowHeaderWidth;
  final double rowBodyWidth;
  final TextStyle? textStyle;
  final Alignment textAlignment;
  final VoidCallback? addFunction;

  @override
  Widget build(BuildContext context) {
    String firstValue = loadedData[0];

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: tableHeight,
      child: SfDataGrid(
        source: dataSource,
        allowEditing: allowEditing,
        columnWidthMode: columnWidthMode,
        horizontalScrollPhysics: horizontalScrollPhysics,
        verticalScrollPhysics: verticalScrollPhysics,
        footerHeight: 0.0,
        footer: const SizedBox(),
        stackedHeaderRows: [
          StackedHeaderRow(
            cells: [
              StackedHeaderCell(
                columnNames: loadedData,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (enableAddRow)
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Add Row',
                        onPressed: addFunction,
                      ),
                    Text(
                      firstValue == 'sales'
                          ? 'Daftar ${(firstValue[0].toUpperCase() + firstValue.substring(1))}man'
                          : firstValue != 'stu'
                          ? 'Laporan ${(firstValue[0].toUpperCase() + firstValue.substring(1))}'
                          : 'Laporan ${firstValue.toUpperCase()}',
                      style: textStyle?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        columns: loadedData.asMap().entries.map((name) {
          final int index = name.key;
          final String data = name.value;

          if (index == 0) {
            return GridColumn(
              columnName: data,
              width: rowHeaderWidth,
              label: Container(
                alignment: textAlignment,
                child: Text(
                  data != 'stu'
                      ? data[0].toUpperCase() + data.substring(1)
                      : data.toUpperCase(),
                  style: textStyle?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else {
            return GridColumn(
              columnName: data,
              width: rowHeaderWidth,
              label: Container(
                alignment: textAlignment,
                child: Text(
                  data == 'stu' || data == 'stuLm' || data == 'spk'
                      ? data == 'stuLm'
                            ? 'STU LM'
                            : data.toUpperCase()
                      : data[0].toUpperCase() + data.substring(1),
                  style: textStyle?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
        }).toList(),
      ),
    );
  }
}
