// tracking_input_section.dart - FIXED VERSION
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/tracking_controller.dart';
import '../../../widgets/custom_text_field.dart';

class TrackingInputSection extends StatefulWidget {
  final VoidCallback onQRScan;

  const TrackingInputSection({
    super.key,
    required this.onQRScan,
  });

  @override
  State<TrackingInputSection> createState() => _TrackingInputSectionState();
}

class _TrackingInputSectionState extends State<TrackingInputSection> {
  final _trackingController = TextEditingController();
  final _focusNode = FocusNode();
  String? selectedCourier;

  @override
  void dispose() {
    _trackingController.dispose();
    _focusNode.dispose();
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
        
        // Dropdown untuk Pilih Kurir Manual
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: selectedCourier,
            hint: const Text("Pilih Kurir (Opsional)"),
            isExpanded: true,
            underline: const SizedBox(), // Hilangkan underline default
            items: [
              const DropdownMenuItem(value: null, child: Text("Auto Detect")),
              ...['jne', 'tiki', 'sicepat', 'pos', 'jnt', 'wahana', 'ninja', 'lion'].map((courier) {
                return DropdownMenuItem(
                  value: courier,
                  child: Text(courier.toUpperCase()),
                );
              }).toList(),
            ],
            onChanged: (newCourier) {
              setState(() {
                selectedCourier = newCourier;
              });
            },
          ),
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

  Future<void> _handleSubmit() async {
    final resi = _trackingController.text.trim();
    if (resi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nomor resi terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final trackingProvider = context.read<TrackingController>();
    _focusNode.unfocus();

    try {
      if (selectedCourier != null && selectedCourier!.isNotEmpty) {
        // Jika user memilih kurir manual
        await trackingProvider.trackPackage(awb: resi, courierCode: selectedCourier!);
      } else {
        // Jika tidak, sistem coba auto-detect kurir
        await trackingProvider.autoTrackPackage(resi);
      }

      // Cek apakah tracking berhasil dan ada data
      if (trackingProvider.currentTracking != null && mounted) {
        // ✅ PERBAIKAN: Pass data melalui arguments
        Navigator.pushNamed(
          context, 
          '/tracking-result',
          arguments: trackingProvider.currentTracking, // Pass the TrackingModel here
        );
      } else {
        // Show error jika tracking gagal
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(trackingProvider.error ?? 'Gagal melacak resi. Coba lagi.'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}