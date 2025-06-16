import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/tracking_controller.dart';
import '../qrCode/qr_scan_screen.dart';
import '../navigations/sidebar.dart';
import 'widgets/dashboard_app_bar.dart';
import 'widgets/dashboard_content.dart';
// import 'widgets/recent_trackings_list.dart';
import 'dialog/profile_dialog.dart';
import '../../widgets/backgrounds/gradient_background.dart';
import '../tracking/tracking_result_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(currentRoute: '/dashboard'),
      body: Container(
        width: double.infinity,
        decoration: const GradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              DashboardAppBar(
                onProfileTap: () => _showProfileDialog(context),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      DashboardContent(
                        onQRScan: _handleQRScan,
                        onTrack: _handleTrackPackage, // Add this callback
                      ),
                      const SizedBox(height: 20),
                      // const Expanded(
                      //   // child: RecentTrackingsList(),
                      // ),
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

  Future<void> _handleQRScan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScanScreen()),
    );
    
    if (result != null && result.isNotEmpty && mounted) {
      await _handleTrackPackage(result);
    }
  }

Future<void> _handleTrackPackage(String trackingNumber) async {
    final controller = context.read<TrackingController>();
    await controller.autoTrackPackage(trackingNumber); // Ini sudah memanggil _saveTrackingHistory internal
    if (!mounted) return;

    if (controller.hasData) {
      // Auto-redirect to results
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrackingResultScreen(
            trackingInfo: controller.currentTracking!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.error ?? 'Gagal melacak paket'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ProfileDialog(),
    );
  }
}