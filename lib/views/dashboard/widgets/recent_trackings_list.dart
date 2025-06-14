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
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No recent trackings',
                      style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  Text('Your tracked packages will appear here',
                      style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
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
                    const Text('Recent Trackings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      onTap: () {},
                      onDelete: () {
                        _showDeleteDialog(context, controller, index);
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

  void _showDeleteDialog(BuildContext context, TrackingController controller, int index) {
    final tracking = controller.trackingHistory[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tracking'),
        content: Text('Are you sure you want to delete tracking for ${tracking.awb}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.removeFromHistory(index);
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
  final TrackingModel tracking;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TrackingListItem({super.key, required this.tracking, required this.onTap, required this.onDelete});

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
        child: Icon(_getStatusIcon(), color: _getStatusColor()),
      ),
      title: Text(tracking.awb, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tracking.courier),
          Text(
            tracking.status,
            style: TextStyle(color: _getStatusColor(), fontWeight: FontWeight.w500),
          ),
        ],
      ),
      trailing: IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: Colors.grey)),
    );
  }

  Color _getStatusColor() {
    switch (tracking.status.toLowerCase()) {
      case 'terkirim':
      case 'delivered':
        return Colors.green;
      case 'dalam perjalanan':
      case 'on_transit':
        return Colors.orange;
      case 'manifest':
        return Colors.blue;
      case 'exception':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (tracking.status.toLowerCase()) {
      case 'terkirim':
      case 'delivered':
        return Icons.check_circle;
      case 'dalam perjalanan':
      case 'on_transit':
        return Icons.flight_takeoff;
      case 'manifest':
        return Icons.local_shipping;
      case 'exception':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }
}