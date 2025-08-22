// lib/widgets/sales_charts.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sip_sales/global/model.dart';

class ProspekStuCharts extends StatelessWidget {
  final List<DailyModel> data;

  const ProspekStuCharts({
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
            text: 'Prospek & STU by Day',
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
            LineSeries<DailyModel, String>(
              dataSource: data,
              animationDuration: 1500,
              xValueMapper: (DailyModel sales, _) => sales.hari.toString(),
              yValueMapper: (DailyModel sales, _) => sales.prospekD,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              color: Colors.indigo[700]!.withAlpha(150),
              legendIconType: LegendIconType.horizontalLine,
              legendItemText: 'Prospek',
              dataLabelMapper: (DailyModel sales, _) =>
                  sales.prospekD == 0 ? '' : sales.prospekD.toString(),
            ),
            BarSeries<DailyModel, String>(
              dataSource: data,
              animationDuration: 1500,
              xValueMapper: (DailyModel sales, _) => sales.hari.toString(),
              yValueMapper: (DailyModel sales, _) => sales.stud,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              color: Colors.orange[300],
              legendIconType: LegendIconType.rectangle,
              legendItemText: 'STU',
              dataLabelMapper: (DailyModel sales, _) =>
                  sales.stud == 0 ? '' : sales.stud.toString(),
            )
          ],
        ),
      ),
    );
  }
}
