
import 'package:flutter/material.dart';
import '/widgets/custom_text_field.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _trackingController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9370DB), // Light purple
              Color(0xFF1E213A), // Dark navy at bottom
            ],
            stops: [0.65, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              _buildAppBar(),
              
              // Main Content
              Expanded(
                child: _buildMainContent(),
              ),
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
          // Menu Icon
          Container(
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
          ),
          
          // App Logo
          Text('Pacment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),

          
          // Profile Icon
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () {
              // Add your onPressed functionality here
            },
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            splashRadius: 24,
            color: Colors.white.withOpacity(0.2),
          ),
        ],
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
            
            // Title
            const Text(
              'Track your shipment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Subtitle
            Text(
              'Please enter your tracking number',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Tracking Number Input Field
            CustomTextField(
              controller: _trackingController,
              hintText: 'Enter tracking number',
              suffixIcon: Icons.numbers_rounded,
              onSuffixIconTap: () {
                // Handle QR code scanning
              },
            ),
            
            const SizedBox(height: 16),
            
            // const SizedBox(height: 30),
            
            // Delivery Illustration
            // Center(
            //   child: Image.asset(
            //     'assets/images/delivery_illustration.png',
            //     height: 200,
            //     width: double.infinity,
            //     fit: BoxFit.contain,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}