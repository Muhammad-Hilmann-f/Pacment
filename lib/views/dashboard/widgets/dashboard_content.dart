import 'package:flutter/material.dart';
import 'greeting_section.dart';
import 'tracking_input_section.dart';
import 'motorcycle_image_widget.dart';

class DashboardContent extends StatelessWidget {
  final TextEditingController trackingController;
  final VoidCallback onQRScan;

  const DashboardContent({
    super.key,
    required this.trackingController,
    required this.onQRScan,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const GreetingSection(),
            const SizedBox(height: 24),
            TrackingInputSection(
              controller: trackingController,
              onQRScan: onQRScan,
            ),
            const SizedBox(height: 16),
            const MotorcycleImageWidget(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}