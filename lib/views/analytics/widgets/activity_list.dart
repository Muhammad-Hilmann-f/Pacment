import 'package:flutter/material.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildActivityItem('Login Attempt', 'Success'),
        _buildActivityItem('Data Update', '3 min ago'),
        _buildActivityItem('System Check', 'Passed'),
      ],
    );
  }

  Widget _buildActivityItem(String title, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}