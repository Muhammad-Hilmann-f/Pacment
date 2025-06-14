import 'package:flutter/material.dart';
import '../../../core/models/tracking_models.dart';

class TrackingStatusCard extends StatelessWidget {
  final TrackingModel trackingInfo;

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
              trackingInfo.status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Package ${trackingInfo.status.toLowerCase()}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
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
                  '${trackingInfo.detail.origin} → ${trackingInfo.detail.destination}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (trackingInfo.date.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Shipped: ${trackingInfo.date}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getStatusColors() {
    switch (trackingInfo.status.toUpperCase()) {
      case 'DELIVERED':
        return [const Color(0xFF4CAF50), const Color(0xFF45a049)];
      case 'ON_TRANSIT':
        return [const Color(0xFF2196F3), const Color(0xFF1976D2)];
      case 'ON_PROCESS':
        return [const Color(0xFFFF9800), const Color(0xFFE65100)];
      case 'MANIFEST':
        return [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)];
      default:
        return [const Color(0xFF9E9E9E), const Color(0xFF757575)];
    }
  }

  IconData _getStatusIcon() {
    switch (trackingInfo.status.toUpperCase()) {
      case 'DELIVERED':
        return Icons.check_circle;
      case 'ON_TRANSIT':
        return Icons.local_shipping;
      case 'ON_PROCESS':
        return Icons.flight_takeoff;
      case 'MANIFEST':
        return Icons.assignment;
      default:
        return Icons.info;
    }
  }
}
