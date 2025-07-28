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
    return SizedBox(
      height: 300,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Prospek & STU by Day',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                  ),
                  series: [
                    LineSeries<DailyModel, String>(
                      dataSource: data,
                      xValueMapper: (DailyModel sales, _) =>
                          sales.hari.toString(),
                      yValueMapper: (DailyModel sales, _) => sales.prospekD,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      color: Colors.indigo[700]!.withAlpha(150),
                      legendIconType: LegendIconType.horizontalLine,
                      legendItemText: 'Prospek',
                    ),
                    BarSeries<DailyModel, String>(
                      dataSource: data,
                      xValueMapper: (DailyModel sales, _) =>
                          sales.hari.toString(),
                      yValueMapper: (DailyModel sales, _) => sales.stud,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      color: Colors.orange[300],
                      legendIconType: LegendIconType.rectangle,
                      legendItemText: 'STU',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
