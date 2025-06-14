import 'package:flutter/material.dart';
import '../../../core/models/tracking_models.dart';

class TrackingTimeline extends StatelessWidget {
  final List<WaybillHistory> checkpoints;

  const TrackingTimeline({
    super.key,
    required this.checkpoints,
  });

  @override
  Widget build(BuildContext context) {
    if (checkpoints.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: const Column(
            children: [
              Icon(Icons.timeline, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No tracking information available yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Sort checkpoints by date (most recent first for display)
    final sortedCheckpoints = List<WaybillHistory>.from(checkpoints);
    sortedCheckpoints.sort((a, b) {
      final dateA = _parseDate(a.date);
      final dateB = _parseDate(b.date);
      return dateB.compareTo(dateA); // Most recent first
    });

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tracking Timeline',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...sortedCheckpoints.asMap().entries.map((entry) {
              final index = entry.key;
              final checkpoint = entry.value;
              final isLast = index == sortedCheckpoints.length - 1;
              
              return TimelineItem(
                checkpoint: checkpoint,
                isLast: isLast,
                isFirst: index == 0,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  DateTime _parseDate(String dateTimeString) {
    try {
      // Handle various date formats that might come from the API
      if (dateTimeString.isEmpty) return DateTime.now();
      
      // Try to parse the date string
      // You might need to adjust this based on the actual format from RajaOngkir
      return DateTime.tryParse(dateTimeString) ?? DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }
}

class TimelineItem extends StatelessWidget {
  final WaybillHistory checkpoint;
  final bool isLast;
  final bool isFirst;

  const TimelineItem({
    super.key,
    required this.checkpoint,
    required this.isLast,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFirst ? Colors.green : Colors.blue,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  checkpoint.desc.isNotEmpty 
                      ? checkpoint.desc 
                      : 'Package update',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                    color: isFirst ? Colors.green : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                if (checkpoint.location.isNotEmpty)
                  Text(
                    checkpoint.location,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(checkpoint.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    if (dateTimeString.isEmpty) return 'Unknown time';
    
    try {
      final date = DateTime.tryParse(dateTimeString);
      if (date != null) {
        return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      }
      
      // If parsing fails, return the original string
      return dateTimeString;
    } catch (e) {
      return dateTimeString;
    }
  }
}