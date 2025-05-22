import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import '../../widgets/custom_text_field.dart';
import '../../widgets/profile_avatar.dart';
import '../qrCode/qr_scan_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _trackingController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _trackingController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF9370DB),
              const Color(0xFF1E213A),
            ],
            stops: const [0.65, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildMainContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMenuButton(),
          _buildTitle(),
          ProfileAvatar(
            onTap: () {
              _showProfileDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: const Icon(
        Icons.menu,
        color: Colors.white,
        size: 22,
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Pacment',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildHeading(),
            const SizedBox(height: 12),
            _buildSubheading(),
            const SizedBox(height: 24),
            _buildTextField(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading() {
    return const Text(
      'Track your shipment',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubheading() {
    return Text(
      'Please enter your tracking number or qr code',
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 14,
      ),
    );
  }

  Widget _buildTextField() {
    return CustomTextField(
      controller: _trackingController,
      hintText: 'Enter tracking number or qr code',
      suffixIcon: Icons.qr_code_scanner,
      onSuffixIconTap: () async {
        // Handle QR code scanning
        final result = await Navigator.push(context, MaterialPageRoute(
          builder: (context) => const QRScanScreen(),
        ),
        );
        if (result != null && result.isNotEmpty) {
          setState(() {
            _trackingController.text = result;
          });
          
        }
      },
    );
  }

  void _showProfileDialog(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E213A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Hello, ${user?.displayName ?? 'User'}',
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user?.email != null)
                Text(
                  user!.email!,
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

