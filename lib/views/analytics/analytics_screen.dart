import 'package:flutter/material.dart';
import '../../widgets/backgrounds/gradient_background.dart';
import './widgets/bar_chart.dart';
import './widgets/summary_stats.dart';
import './widgets/activity_list.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const GradientBackground(),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // Adjust padding based on screen width
          vertical: 24,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analytics Overview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: constraints.maxWidth < 600 ? 12 : 24),
                const BarChartWidget(),
                SizedBox(height: constraints.maxWidth < 600 ? 12 : 24),
                const SummaryStats(),
                SizedBox(height: constraints.maxWidth < 600 ? 12 : 24),
                const ActivityList(),
              ],
            );
          },
        ),
      ),
    );
  }
}