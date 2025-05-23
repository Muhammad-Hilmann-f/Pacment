import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/tracking_controller.dart';
import '../../../core/models/tracking_models.dart';
import '../../tracking/tracking_result_screen.dart';

class RecentTrackingsList extends StatelessWidget {
  const RecentTrackingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackingController>(
      builder: (context, controller, child) {
        if (controller.trackingHistory.isEmpty && !controller.isLoading) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(40),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No recent trackings',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your tracked packages will appear here',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Trackings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (controller.isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: controller.trackingHistory.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final tracking = controller.trackingHistory[index];
                    return TrackingListItem(
                      tracking: tracking,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrackingResultScreen(
                              trackingInfo: tracking,
                            ),
                          ),
                        );
                      },
                      onDelete: () {
                        _showDeleteDialog(context, controller, tracking);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    TrackingController controller,
    TrackingInfo tracking,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tracking'),
        content: Text(
          'Are you sure you want to delete tracking for ${tracking.trackingNumber}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.removeFromHistory(tracking);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class TrackingListItem extends StatelessWidget {
  final TrackingInfo tracking;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TrackingListItem({
    super.key,
    required this.tracking,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _getStatusColor().withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _getStatusIcon(),
          color: _getStatusColor(),
        ),
      ),
      title: Text(
        tracking.trackingNumber,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tracking.courierName),
          Text(
            tracking.statusText,
            style: TextStyle(
              color: _getStatusColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: onDelete,
        icon: const Icon(Icons.delete_outline, color: Colors.grey),
      ),
    );
  }

  Color _getStatusColor() {
    switch (tracking.tag.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'outfordelivery':
        return Colors.blue;
      case 'intransit':
        return Colors.orange;
      case 'exception':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (tracking.tag.toLowerCase()) {
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
}