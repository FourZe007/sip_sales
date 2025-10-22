// lib/widgets/sales_charts.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sip_sales_clean/data/models/coordinator_dashboard.dart';

class DbStuCharts extends StatelessWidget {
  final List<ProspekTypeModel> data;

  const DbStuCharts({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCartesianChart(
          enableMultiSelection: true,
          title: ChartTitle(
            text: 'Asal Database & STU',
            textStyle: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
          ),
          primaryXAxis: CategoryAxis(labelRotation: -30),
          series: [
            LineSeries<ProspekTypeModel, String>(
              dataSource: data,
              animationDuration: 1500,
              xValueMapper: (ProspekTypeModel sales, _) =>
                  sales.prospekType.toString(),
              yValueMapper: (ProspekTypeModel sales, _) => sales.stut,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              color: Colors.orange,
              legendIconType: LegendIconType.horizontalLine,
              legendItemText: 'STU',
              dataLabelMapper: (ProspekTypeModel sales, _) =>
                  sales.stut == 0 ? '' : sales.stut.toString(),
            ),
            BarSeries<ProspekTypeModel, String>(
              dataSource: data,
              animationDuration: 1500,
              xValueMapper: (ProspekTypeModel sales, _) =>
                  sales.prospekType.toString(),
              yValueMapper: (ProspekTypeModel sales, _) => sales.prospekT,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              color: Colors.teal[800]!,
              legendIconType: LegendIconType.rectangle,
              legendItemText: 'Prospek',
              dataLabelMapper: (ProspekTypeModel sales, _) =>
                  sales.prospekT == 0 ? '' : sales.prospekT.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
