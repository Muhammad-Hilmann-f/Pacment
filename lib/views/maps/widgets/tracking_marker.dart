import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/models/tracking_models.dart';
import 'tracking_status_widget.dart';

class TrackingMarker {
  final TrackingModel trackingInfo;
  final VoidCallback? onTap;

  const TrackingMarker({
    required this.trackingInfo,
    this.onTap,
  });

  /// Membangun marker untuk peta
  Marker build() {
    return Marker(
      point: LatLng(
        trackingInfo.detail.latitude,
        trackingInfo.detail.longitude,
      ),
      width: 50,
      height: 50,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: TrackingStatusWidget.getStatusColor(trackingInfo.status),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            TrackingStatusWidget.getStatusIcon(trackingInfo.status),
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }

  /// Membuat multiple markers jika diperlukan (untuk future development)
  static List<Marker> buildMultipleMarkers({
    required List<TrackingModel> trackingList,
    Function(TrackingModel)? onMarkerTap,
  }) {
    return trackingList.map((tracking) {
      return TrackingMarker(
        trackingInfo: tracking,
        onTap: onMarkerTap != null ? () => onMarkerTap(tracking) : null,
      ).build();
    }).toList();
  }

  /// Membuat marker khusus dengan custom icon dan warna
  static Marker buildCustomMarker({
    required double latitude,
    required double longitude,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
    double size = 50,
  }) {
    return Marker(
      point: LatLng(latitude, longitude),
      width: size,
      height: size,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}