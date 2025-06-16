import 'package:flutter/material.dart';
import '../../../core/models/tracking_models.dart';
import 'tracking_status_widget.dart';

class TrackingInfoCard extends StatelessWidget {
  final TrackingModel trackingInfo;

  const TrackingInfoCard({
    super.key,
    required this.trackingInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildCourierInfo(),
          const SizedBox(height: 8),
          _buildOriginDestination(),
          const Divider(height: 16),
          _buildShipperReceiver(),
          if (trackingInfo.date.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildLastUpdate(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        TrackingStatusWidget(status: trackingInfo.status),
        const Spacer(),
        Text(
          trackingInfo.awb,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCourierInfo() {
    return Row(
      children: [
        const Icon(Icons.business, size: 16, color: Colors.blue),
        const SizedBox(width: 8),
        Text('Kurir: ${trackingInfo.courier}'),
      ],
    );
  }

  Widget _buildOriginDestination() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.send, size: 16, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(child: Text('Dari: ${trackingInfo.detail.origin}')),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(child: Text('Ke: ${trackingInfo.detail.destination}')),
          ],
        ),
      ],
    );
  }

  Widget _buildShipperReceiver() {
    return Row(
      children: [
        const Icon(Icons.person_outline, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text('${trackingInfo.detail.shipper} → ${trackingInfo.detail.receiver}'),
        ),
      ],
    );
  }

  Widget _buildLastUpdate() {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 16, color: Colors.orange),
        const SizedBox(width: 8),
        Text('Update: ${trackingInfo.date}'),
      ],
    );
  }
}