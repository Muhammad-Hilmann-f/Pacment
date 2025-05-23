import 'package:flutter/material.dart';

class TrackingHeader extends StatelessWidget {
  final String trackingNumber;
  final String courierName;
  final VoidCallback onBack;

  const TrackingHeader({
    super.key,
    required this.trackingNumber,
    required this.courierName,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trackingNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  courierName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Share functionality
            },
            icon: const Icon(Icons.share, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
