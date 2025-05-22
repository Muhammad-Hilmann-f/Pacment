import 'package:flutter/material.dart';
// import '../../widgets/custom_text_field.dart';
import '../qrCode/qr_scan_screen.dart';
import 'widgets/dashboard_app_bar.dart';
import 'widgets/dashboard_content.dart';
import 'dialog/profile_dialog.dart';
import '../../widgets/backgrounds/gradient_background.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _trackingController = TextEditingController();

  @override
  void dispose() {
    _trackingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: DashboardContent(
                  trackingController: _trackingController,
                  onQRScan: _handleQRScan,
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
    
    if (result != null && result.isNotEmpty) {
      setState(() {
        _trackingController.text = result;
      });
    }
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ProfileDialog(),
    );
  }
}
