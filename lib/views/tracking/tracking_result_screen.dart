import 'package:flutter/material.dart';
import '../../core/models/tracking_models.dart';
import '../../widgets/backgrounds/gradient_background.dart';
import 'widgets/tracking_header.dart';
import 'widgets/tracking_status_card.dart';
import 'widgets/tracking_timeline.dart';

class TrackingResultScreen extends StatelessWidget {
  final TrackingInfo trackingInfo;

  const TrackingResultScreen({
    super.key,
    required this.trackingInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const GradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              TrackingHeader(
                trackingNumber: trackingInfo.trackingNumber,
                courierName: trackingInfo.courierName,
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TrackingStatusCard(trackingInfo: trackingInfo),
                      const SizedBox(height: 20),
                      TrackingTimeline(checkpoints: trackingInfo.checkpoints),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}