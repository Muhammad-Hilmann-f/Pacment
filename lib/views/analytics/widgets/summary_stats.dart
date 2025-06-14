import 'package:flutter/material.dart';

class SummaryStats extends StatelessWidget {
  const SummaryStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatItem('Total Views', '15.2K'),
        _buildStatItem('Avg Time Spent', '4m 32s'),
        _buildStatItem('Bounce Rate', '12.4%'),
      ],
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}