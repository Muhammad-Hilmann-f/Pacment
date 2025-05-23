import 'package:flutter/material.dart';
import '../../../core/models/tracking_models.dart';

class TrackingTimeline extends StatelessWidget {
  final List<Checkpoint> checkpoints;

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
            ...checkpoints.asMap().entries.map((entry) {
              final index = entry.key;
              final checkpoint = entry.value;
              final isLast = index == checkpoints.length - 1;
              
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
}

class TimelineItem extends StatelessWidget {
  final Checkpoint checkpoint;
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
                  checkpoint.message.isNotEmpty 
                      ? checkpoint.message 
                      : checkpoint.subtagMessage,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                    color: isFirst ? Colors.green : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                if (checkpoint.fullLocation.isNotEmpty)
                  Text(
                    checkpoint.fullLocation,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(checkpoint.checkpointTime),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
