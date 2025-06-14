import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/analytics_data.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(dummyData[value.toInt()].month, style: const TextStyle(color: Colors.white));
                },
                reservedSize: 22,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: dummyData.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [BarChartRodData(toY: entry.value.value, color: Colors.blue)],
            );
          }).toList(),
        ),
      ),
    );
  }
}