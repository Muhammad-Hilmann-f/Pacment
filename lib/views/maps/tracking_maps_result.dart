import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/models/tracking_models.dart';
import 'widgets/tracking_info_card.dart';
import 'widgets/tracking_marker.dart';

class TrackingMapScreen extends StatefulWidget {
  final TrackingModel trackingInfo;

  const TrackingMapScreen({super.key, required this.trackingInfo});

  @override
  State<TrackingMapScreen> createState() => _TrackingMapScreenState();
}

class _TrackingMapScreenState extends State<TrackingMapScreen> {
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    // Debugging: Print koordinat untuk memastikan data valid
    print('Latitude: ${widget.trackingInfo.detail.latitude}');
    print('Longitude: ${widget.trackingInfo.detail.longitude}');

    // Validasi koordinat
    if (widget.trackingInfo.detail.latitude == 0.0 && 
        widget.trackingInfo.detail.longitude == 0.0) {
      return _buildNoLocationScreen();
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Info card
          TrackingInfoCard(trackingInfo: widget.trackingInfo),
          // Map
          Expanded(
            child: _buildMap(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildNoLocationScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking Paket"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Lokasi paket tidak tersedia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Data koordinat tidak ditemukan dari API',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Tracking: ${widget.trackingInfo.awb}"),
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: () {
            _centerMapOnPackage();
          },
        ),
      ],
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(
          widget.trackingInfo.detail.latitude,
          widget.trackingInfo.detail.longitude,
        ),
        initialZoom: 15.0,
        minZoom: 5.0,
        maxZoom: 18.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.pacment',
          maxZoom: 19,
        ),
        MarkerLayer(
          markers: [
            TrackingMarker(
              trackingInfo: widget.trackingInfo,
              onTap: () => _showPackageDetails(),
            ).build(),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _centerMapOnPackage,
      child: const Icon(Icons.my_location),
    );
  }

  void _centerMapOnPackage() {
    mapController.move(
      LatLng(
        widget.trackingInfo.detail.latitude,
        widget.trackingInfo.detail.longitude,
      ),
      15.0,
    );
  }

  void _showPackageDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('📦 ${widget.trackingInfo.detail.destination}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AWB: ${widget.trackingInfo.awb}'),
            Text('Status: ${widget.trackingInfo.status}'),
            Text('Kurir: ${widget.trackingInfo.courier}'),
            const Divider(),
            Text('📤 Pengirim: ${widget.trackingInfo.detail.shipper}'),
            Text('📍 Dari: ${widget.trackingInfo.detail.origin}'),
            const SizedBox(height: 8),
            Text('📥 Penerima: ${widget.trackingInfo.detail.receiver}'),
            Text('📍 Ke: ${widget.trackingInfo.detail.destination}'),
            const SizedBox(height: 8),
            Text('🕒 Terakhir: ${widget.trackingInfo.date}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}