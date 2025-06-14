import 'package:flutter/material.dart';
import '../../core/models/tracking_models.dart';
import '../../widgets/backgrounds/gradient_background.dart';
import 'package:provider/provider.dart';
import '../../core/controllers/tracking_controller.dart';
import 'widgets/tracking_header.dart';
import 'widgets/tracking_status_card.dart';
import 'widgets/tracking_timeline.dart';

class TrackingResultScreen extends StatelessWidget {
  final TrackingModel trackingInfo;

  const TrackingResultScreen({
    super.key,
    required this.trackingInfo,
  });

  @override
  Widget build(BuildContext context) {
    final TrackingModel? trackingResult = Provider.of<TrackingController>(context).currentTracking;

    return Scaffold(
      body: Container(
        decoration: const GradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              TrackingHeader(
                trackingNumber: trackingInfo.awb,
                courierName: trackingInfo.courier,
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TrackingStatusCard(trackingInfo: trackingInfo),
                      if (trackingResult != null) ...[
                        const SizedBox(height: 20),
                        TrackingTimeline(checkpoints: trackingResult.history),
                      ],
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
