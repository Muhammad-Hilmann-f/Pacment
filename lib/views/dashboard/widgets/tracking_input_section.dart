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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _resiController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? selectedCourier;

  @override
  void dispose() {
    _resiController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackingProvider = context.watch<TrackingController>();

    return Column(
      children: [
        // 🔥 FORM + INPUT
        Form(
          key: _formKey,
          child: CustomTextField(
            controller: _resiController,
            hintText: 'Masukkan nomor resi atau scan QR',
            suffixIcon: Icons.qr_code_scanner,
            onSuffixIconTap: widget.onQRScan,
            onFieldSubmitted: (value) => _handleSubmit(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan nomor resi';
              }
              if (value.length < 8) {
                return 'Nomor resi minimal 8 karakter';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),

        // 🔥 DROPDOWN KURIR
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
            underline: const SizedBox(),
            items: [
              const DropdownMenuItem(value: null, child: Text("Pilih Kurir")),
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

        // 🔥 TOMBOL SUBMIT
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
    if (!_formKey.currentState!.validate()) return;

    final resi = _resiController.text.trim();
    final trackingProvider = context.read<TrackingController>();

    // ✅ Cek history dulu
    final existingTracking = trackingProvider.getTrackingFromHistory(resi);
    if (existingTracking != null) {
      trackingProvider.setCurrentTracking(existingTracking);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Resi ini sudah pernah dilacak, mohon lihat data dari history.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // ✅ Tracking baru
    if (selectedCourier != null && selectedCourier!.isNotEmpty) {
      await trackingProvider.trackPackage(
        awb: resi,
        courierCode: selectedCourier!,
      );
    } else {
      await trackingProvider.autoTrackPackage(resi);
    }

    if (!mounted) return;

    if (trackingProvider.hasData) {
      Navigator.pushNamed(
        context,
        '/tracking-result',
        arguments: trackingProvider.currentTracking,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(trackingProvider.error ?? 'Gagal melacak resi. Coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
