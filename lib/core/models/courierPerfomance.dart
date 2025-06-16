import '../../core/models/tracking_models.dart';

class CourierPerformance {
  final String courierName;
  final int totalShipments;
  final double averageDeliveryTime;

  CourierPerformance({
    required this.courierName,
    required this.totalShipments,
    required this.averageDeliveryTime,
  });

  static List<CourierPerformance> analyzeShipments(List<TrackingModel> shipments) {
    final Map<String, List<double>> courierTimes = {};

    for (var shipment in shipments) {
      if (shipment.history.isNotEmpty) {
        try {
          final startDate = DateTime.parse(shipment.history.first.date); // 🔥 Parse tanggal awal
          final endDate = DateTime.parse(shipment.history.last.date); // 🔥 Parse tanggal akhir

          if (startDate.isAfter(endDate)) continue; // 🔥 Hindari tanggal invalid

          final deliveryHours = endDate.difference(startDate).inHours.toDouble();
          if (deliveryHours <= 0) continue; // 🔥 Hindari waktu negatif atau kosong

          courierTimes.putIfAbsent(shipment.courier, () => []);
          courierTimes[shipment.courier]!.add(deliveryHours);
        } catch (e) {
          print("Error parsing date for ${shipment.awb}: ${e.toString()}"); // 🔥 Debug jika parsing gagal
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

  static double _calculateAverage(List<double> times) {
    if (times.isEmpty) return 0.0;
    return times.reduce((a, b) => a + b) / times.length;
  }
}