import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TrendChart extends StatelessWidget {
  final Map<DateTime, double> data;

  const TrendChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final rates = data.values.toList();
    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                rates.length,
                (i) => FlSpot(i.toDouble(), rates[i]),
              ),
              isCurved: true,
              dotData: FlDotData(show: true),
              color: Colors.indigo,
              belowBarData: BarAreaData(show: false),
            )
          ],
        ),
      ),
    );
  }
}