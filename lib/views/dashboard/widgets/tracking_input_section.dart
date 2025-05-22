import 'package:flutter/material.dart';
import '../../../widgets/custom_text_field.dart';

class TrackingInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onQRScan;

  const TrackingInputSection({
    super.key,
    required this.controller,
    required this.onQRScan,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: 'Enter tracking number or qr code',
      suffixIcon: Icons.qr_code_scanner,
      onSuffixIconTap: onQRScan,
    );
  }
}
