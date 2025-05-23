import 'package:flutter/material.dart';
import 'greeting_section.dart';
import 'tracking_input_section.dart';
import 'motorcycle_image_widget.dart';

class DashboardContent extends StatelessWidget {
  final VoidCallback onQRScan;
  final Function(String) onTrack;

  const DashboardContent({
    super.key,
    required this.onTrack,
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
              onQRScan: onQRScan,
              onTrack: onTrack,
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