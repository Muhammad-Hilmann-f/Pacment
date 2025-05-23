import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/tracking_controller.dart';
import '../../../widgets/custom_text_field.dart';

class TrackingInputSection extends StatefulWidget {
  final VoidCallback onQRScan;
  final Function(String) onTrack;

  const TrackingInputSection({
    super.key,
    required this.onTrack,
    required this.onQRScan,
  });

  @override
  State<TrackingInputSection> createState() => _TrackingInputSectionState();
}

class _TrackingInputSectionState extends State<TrackingInputSection> {
  final _trackingController = TextEditingController();
  final _focusNode = FocusNode();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _trackingController.dispose();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackingProvider = context.watch<TrackingController>();

    return Column(
      children: [
        CustomTextField(
          controller: _trackingController,
          hintText: 'Masukkan nomor resi atau scan QR',
          suffixIcon: Icons.qr_code_scanner,
          onSuffixIconTap: widget.onQRScan,
          onFieldSubmitted: (value) => _handleSubmit(),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: trackingProvider.isLoading ? null : _handleSubmit,
            child: trackingProvider.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'CEK RESI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() async {
    if (_trackingController.text.trim().isEmpty) return;
    
    final resi = _trackingController.text.trim();
    await context.read<TrackingController>().trackPackage(resi);
    
    if (mounted) {
      _focusNode.unfocus();
      // Clear field after successful submission if needed
      // _trackingController.clear(); 
    }
  }
}