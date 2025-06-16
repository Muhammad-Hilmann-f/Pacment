import '../../core/models/tracking_models.dart';
import '../models/courierPerfomance.dart';

class CourierAnalysisController {
  /// 🔥 Menghitung performa pengiriman dari daftar `shipments`
  List<CourierPerformance> getCourierPerformance(List<TrackingModel> shipments) {
    if (shipments.isEmpty) {
      print("⚠️ Tidak ada data pengiriman yang tersedia");
      return [];
    }

    return _analyzeShipments(shipments);
  }

  /// 🔥 Fungsi private untuk memproses data pengiriman
  List<CourierPerformance> _analyzeShipments(List<TrackingModel> shipments) {
    final Map<String, List<double>> courierTimes = {};

    for (var shipment in shipments) {
      if (shipment.history.isNotEmpty) {
        try {
          final startDate = DateTime.parse(shipment.history.first.date);
          final endDate = DateTime.parse(shipment.history.last.date);
          
          if (startDate.isAfter(endDate)) continue; // 🔥 Hindari tanggal invalid

          final deliveryHours = endDate.difference(startDate).inHours.toDouble();
          if (deliveryHours <= 0) continue; // 🔥 Hindari waktu kosong atau negatif

          courierTimes.putIfAbsent(shipment.courier, () => []);
          courierTimes[shipment.courier]!.add(deliveryHours);
        } catch (e) {
          print("⚠️ Error parsing date untuk ${shipment.awb}: ${e.toString()}");
        }
      }
    }

    return courierTimes.entries.map((entry) {
      return CourierPerformance(
        courierName: entry.key,
        totalShipments: entry.value.length,
        averageDeliveryTime: _calculateAverage(entry.value),
      );
    }).toList()
      ..sort((a, b) => a.averageDeliveryTime.compareTo(b.averageDeliveryTime)); // 🔥 Urutkan dari tercepat
  }

  /// 🔥 Menghitung rata-rata waktu pengiriman
  double _calculateAverage(List<double> times) {
    if (times.isEmpty) return 0.0;
    return times.reduce((a, b) => a + b) / times.length;
  }
}