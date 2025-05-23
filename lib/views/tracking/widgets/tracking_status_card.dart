import 'package:flutter/material.dart';
import '../../../core/models/tracking_models.dart';

class TrackingStatusCard extends StatelessWidget {
  final TrackingInfo trackingInfo;

  const TrackingStatusCard({
    super.key,
    required this.trackingInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: _getStatusColors(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _getStatusIcon(),
              size: 60,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              trackingInfo.statusText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              trackingInfo.subtagMessage.isNotEmpty 
                  ? trackingInfo.subtagMessage 
                  : 'Tracking information updated',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            if (trackingInfo.latestCheckpoint != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      trackingInfo.latestCheckpoint!.fullLocation,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(trackingInfo.latestCheckpoint!.checkpointTime),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Color> _getStatusColors() {
    switch (trackingInfo.tag.toLowerCase()) {
      case 'delivered':
        return [const Color(0xFF4CAF50), const Color(0xFF45a049)];
      case 'outfordelivery':
        return [const Color(0xFF2196F3), const Color(0xFF1976D2)];
      case 'intransit':
        return [const Color(0xFFFF9800), const Color(0xFFE65100)];
      case 'exception':
        return [const Color(0xFFf44336), const Color(0xFFd32f2f)];
      default:
        return [const Color(0xFF9E9E9E), const Color(0xFF757575)];
    }
  }

  IconData _getStatusIcon() {
    switch (trackingInfo.tag.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle;
      case 'outfordelivery':
        return Icons.local_shipping;
      case 'intransit':
        return Icons.flight_takeoff;
      case 'exception':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}