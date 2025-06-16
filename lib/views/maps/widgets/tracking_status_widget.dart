import 'package:flutter/material.dart';

class TrackingStatusWidget extends StatelessWidget {
  final String status;

  const TrackingStatusWidget({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getStatusColor(status),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Mendapatkan warna berdasarkan status paket
  static Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'DELIVERED':
        return Colors.green;
      case 'ON PROCESS':
      case 'WITH DELIVERY COURIER':
        return Colors.orange;
      case 'SHIPMENT RECEIVED':
      case 'PICKED UP':
        return Colors.blue;
      default:
        return Colors.red;
    }
  }

  /// Mendapatkan ikon berdasarkan status paket
  static IconData getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'DELIVERED':
        return Icons.check_circle;
      case 'ON PROCESS':
      case 'WITH DELIVERY COURIER':
        return Icons.local_shipping;
      case 'SHIPMENT RECEIVED':
      case 'PICKED UP':
        return Icons.inventory_2;
      default:
        return Icons.local_shipping;
    }
  }
}