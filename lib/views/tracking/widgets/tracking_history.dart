import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "../../../core/controllers/tracking_controller.dart";

class TrackingHistoryScreen extends StatelessWidget {
  const TrackingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TrackingController>(context);
    final history = controller.trackingHistory;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Push replacement ke /dashboard, jadi gak kembali ke history lagi
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
        title: const Text('Riwayat Pelacakan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Hapus Semua?'),
                  content: const Text('Yakin mau hapus semua riwayat?'),
                  actions: [
                    TextButton(
                      child: const Text('Batal'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    ElevatedButton(
                      child: const Text('Hapus'),
                      onPressed: () {
                        controller.clearAllHistory();
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: history.isEmpty
          ? const Center(child: Text('Belum ada riwayat'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (ctx, i) {
                final item = history[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.local_shipping),
                    title: Text(
                      '${item.awb} - ${item.courier.toUpperCase()}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${item.status}'),
                        Text('Tanggal: ${item.date}'),
                        Text('Asal: ${item.detail.origin}'),
                        Text('Tujuan: ${item.detail.destination}'),
                        Text('Pengirim: ${item.detail.shipper}'),
                        Text('Penerima: ${item.detail.receiver}'),
                        Text('Jarak: ${item.detail.distance.toStringAsFixed(1)} km'),
                        if (item.analysis != null)
                          Text(
                            'Rekomendasi: ${item.analysis!.recommendation}',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
               icon: const Icon(Icons.delete),
               onPressed: () async {
               final awb = item.awb; // Ambil resi yang mau dihapus
                controller.removeFromHistory(i); // Hapus lokal
                await controller.deleteTrackingFromFirestore(awb); // Hapus Firestore
              },
              ),

                    onTap: () {
                      // Buka halaman detail tracking dengan argumen item
                      Navigator.pushNamed(context, '/analytics', arguments: item);
                    },
                  ),
                );
              },
            ),
    );
  }
}
