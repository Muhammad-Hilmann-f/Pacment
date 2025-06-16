import 'dart:math' as math;
import 'package:intl/intl.dart';
class TrackingModel {
  final String awb;
  final String courier;
  final String status;
  final String date;
  final WaybillDetail detail;
  final List<WaybillHistory> history;
  final CourierAnalysis? analysis; // New field for courier analysis

  TrackingModel({
    required this.awb,
    required this.courier,
    required this.status,
    required this.date,
    required this.detail,
    required this.history,
    this.analysis,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    print('Full API Response: $json'); // Debug log
    
    final history = (json['data']['history'] as List<dynamic>?)
        ?.map((item) => WaybillHistory.fromJson(item))
        .toList() ?? [];
    
    final courier = json['data']['summary']['courier'] ?? '';
    
    return TrackingModel(
      awb: json['data']['summary']['awb'] ?? '',
      courier: courier,
      status: json['data']['summary']['status'] ?? '',
      date: json['data']['summary']['date'] ?? '',
      detail: WaybillDetail.fromJson(json['data']['detail'] ?? {}),
      history: history,
      analysis: CourierAnalysis.fromTrackingData(courier, history),
    );
  }

  // Method untuk mendapatkan estimasi delivery time berdasarkan analysis
  String getEstimatedDeliveryTime() {
    if (analysis == null) return 'Tidak dapat diestimasi';
    return analysis!.getEstimatedDeliveryTime();
  }

  // Method untuk mendapatkan performance rating
  CourierPerformanceLevel getPerformanceLevel() {
    if (analysis == null) return CourierPerformanceLevel.unknown;
    return analysis!.performanceLevel;
  }
}

class WaybillDetail {
  final String origin;
  final String destination;
  final String shipper;
  final String receiver;
  final double latitude;
  final double longitude;
  final double distance; // New field for distance calculation

  WaybillDetail({
    required this.origin,
    required this.destination,
    required this.shipper,
    required this.receiver,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory WaybillDetail.fromJson(Map<String, dynamic> json) {
    print('Detail JSON: $json'); // Debug log
    
    String origin = json['origin'] ?? '';
    String destination = json['destination'] ?? '';
    
    // Karena API BinderByte tidak memberikan lat/lng, kita generate berdasarkan kota
    Map<String, double> originCoords = _getCityCoordinates(origin, '');
    Map<String, double> destCoords = _getCityCoordinates(destination, '');
    
    // Calculate distance between origin and destination
    double calculatedDistance = _calculateDistance(
      originCoords['lat']!, originCoords['lng']!,
      destCoords['lat']!, destCoords['lng']!,
    );
    
    print('Generated coordinates for $origin -> $destination: ${destCoords['lat']}, ${destCoords['lng']}');
    print('Calculated distance: ${calculatedDistance.toStringAsFixed(2)} km');
    
    return WaybillDetail(
      origin: origin,
      destination: destination,
      shipper: json['shipper'] ?? '',
      receiver: json['receiver'] ?? '',
      latitude: destCoords['lat']!,
      longitude: destCoords['lng']!,
      distance: calculatedDistance,
    );
  }
  
  // Helper method untuk menghitung jarak antara dua koordinat (Haversine formula)
  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth radius in kilometers
    
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }
  
  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
  
  // Helper method untuk mendapatkan koordinat kota berdasarkan nama
  static Map<String, double> _getCityCoordinates(String origin, String destination) {
    final cityMap = {
      // Jawa Barat
      'BANDUNG': {'lat': -6.9175, 'lng': 107.6191},
      'SUKAJADI': {'lat': -6.8951, 'lng': 107.5929}, // Sukajadi Bandung
      'SUKAJADI,BANDUNG': {'lat': -6.8951, 'lng': 107.5929},
      'TASIKMALAYA': {'lat': -7.3274, 'lng': 108.2207},
      'BEKASI': {'lat': -6.2349, 'lng': 106.9896},
      'BOGOR': {'lat': -6.5971, 'lng': 106.8060},
      'DEPOK': {'lat': -6.4025, 'lng': 106.7942},
      'CIMAHI': {'lat': -6.8723, 'lng': 107.5425},
      'GARUT': {'lat': -7.2136, 'lng': 107.9073},
      'CIANJUR': {'lat': -6.8174, 'lng': 107.1427},
      'SUBANG': {'lat': -6.5628, 'lng': 107.7595},
      'CIREBON': {'lat': -6.7063, 'lng': 108.5571},
      'KARAWANG': {'lat': -6.3015, 'lng': 107.3089},
      
      // DKI Jakarta
      'JAKARTA': {'lat': -6.2088, 'lng': 106.8456},
      'JAKARTA PUSAT': {'lat': -6.1865, 'lng': 106.8239},
      'JAKARTA UTARA': {'lat': -6.1384, 'lng': 106.8644},
      'JAKARTA SELATAN': {'lat': -6.2615, 'lng': 106.8106},
      'JAKARTA BARAT': {'lat': -6.1352, 'lng': 106.8133},
      'JAKARTA TIMUR': {'lat': -6.2250, 'lng': 106.9004},
      'TANGERANG': {'lat': -6.1783, 'lng': 106.6319},
      'TANGERANG SELATAN': {'lat': -6.2970, 'lng': 106.7085},
      
      // Jawa Tengah
      'SEMARANG': {'lat': -6.9667, 'lng': 110.4167},
      'SOLO': {'lat': -7.5755, 'lng': 110.8243},
      'SURAKARTA': {'lat': -7.5755, 'lng': 110.8243},
      'YOGYAKARTA': {'lat': -7.7956, 'lng': 110.3695},
      'MAGELANG': {'lat': -7.4698, 'lng': 110.2177},
      'PURWOKERTO': {'lat': -7.4218, 'lng': 109.2379},
      'TEGAL': {'lat': -6.8694, 'lng': 109.1402},
      'PEKALONGAN': {'lat': -6.8886, 'lng': 109.6753},
      
      // Jawa Timur
      'SURABAYA': {'lat': -7.2575, 'lng': 112.7521},
      'MALANG': {'lat': -7.9666, 'lng': 112.6326},
      'KEDIRI': {'lat': -7.8148, 'lng': 112.0178},
      'BLITAR': {'lat': -8.0983, 'lng': 112.1682},
      'MOJOKERTO': {'lat': -7.4664, 'lng': 112.4338},
      'JEMBER': {'lat': -8.1844, 'lng': 113.7068},
      'BANYUWANGI': {'lat': -8.2191, 'lng': 114.3691},
      
      // Sumatra
      'MEDAN': {'lat': 3.5952, 'lng': 98.6722},
      'PALEMBANG': {'lat': -2.9761, 'lng': 104.7754},
      'PEKANBARU': {'lat': 0.5071, 'lng': 101.4478},
      'PADANG': {'lat': -0.9471, 'lng': 100.4172},
      'BANDAR LAMPUNG': {'lat': -5.3971, 'lng': 105.2668},
      'JAMBI': {'lat': -1.6101, 'lng': 103.6131},
      'BATAM': {'lat': 1.1043, 'lng': 104.0304},
      
      // Kalimantan
      'BALIKPAPAN': {'lat': -1.2379, 'lng': 116.8529},
      'SAMARINDA': {'lat': -0.4978, 'lng': 117.1436},
      'PONTIANAK': {'lat': -0.0263, 'lng': 109.3425},
      'BANJARMASIN': {'lat': -3.3194, 'lng': 114.5906},
      
      // Sulawesi
      'MAKASSAR': {'lat': -5.1477, 'lng': 119.4327},
      'MANADO': {'lat': 1.4748, 'lng': 124.8421},
      'PALU': {'lat': -0.8917, 'lng': 119.8707},
      
      // Bali & Nusa Tenggara
      'DENPASAR': {'lat': -8.6705, 'lng': 115.2126},
      'MATARAM': {'lat': -8.5833, 'lng': 116.1167},
      
      // Papua
      'JAYAPURA': {'lat': -2.5489, 'lng': 140.7017},
    };
    
    String searchKey = (destination.isNotEmpty ? destination : origin).toUpperCase().trim();
    
    if (cityMap.containsKey(searchKey)) {
      return cityMap[searchKey]!;
    }
    
    // Cari partial match
    for (String city in cityMap.keys) {
      if (searchKey.contains(city) || city.contains(searchKey)) {
        return cityMap[city]!;
      }
    }
    
    // Default ke Bandung
    print('City not found, using default Bandung coordinates');
    return {'lat': -6.9175, 'lng': 107.6191};
  }
}

class WaybillHistory {
  final String date;
  final String desc;
  final String location;
  final DateTime? parsedDate; // New field for easier date operations

  WaybillHistory({
    required this.date,
    required this.desc,
    required this.location,
    this.parsedDate,
  });

  factory WaybillHistory.fromJson(Map<String, dynamic> json) {
    String dateStr = json['date'] ?? '';
    DateTime? parsed = _parseDate(dateStr);
    
    return WaybillHistory(
      date: dateStr,
      desc: json['desc'] ?? '',
      location: json['location'] ?? '',
      parsedDate: parsed,
    );
  }
  
  static DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) return null;
    
    try {
      // Common Indonesian date formats
      List<String> formats = [
        'dd-MM-yyyy HH:mm:ss',
        'yyyy-MM-dd HH:mm:ss',
        'dd/MM/yyyy HH:mm:ss',
        'dd-MM-yyyy',
        'yyyy-MM-dd',
        'dd/MM/yyyy',
      ];
      
      for (String format in formats) {
        try {
          return DateFormat(format).parse(dateStr);
        } catch (e) {
          continue;
        }
      }
      
      // Try parsing with DateTime.parse as fallback
      return DateTime.parse(dateStr);
    } catch (e) {
      print('Failed to parse date: $dateStr');
      return null;
    }
  }
}

// New classes for courier analysis
enum CourierPerformanceLevel {
  excellent,   // < 2 hari
  good,        // 2-3 hari
  average,     // 4-5 hari
  slow,        // 6-7 hari
  verySlow,    // > 7 hari
  unknown
}

class CourierAnalysis {
  final String courierName;
  final int totalDays;
  final double averageSpeedKmPerDay;
  final CourierPerformanceLevel performanceLevel;
  final List<String> milestones;
  final String recommendation;

  CourierAnalysis({
    required this.courierName,
    required this.totalDays,
    required this.averageSpeedKmPerDay,
    required this.performanceLevel,
    required this.milestones,
    required this.recommendation,
  });

  factory CourierAnalysis.fromTrackingData(String courier, List<WaybillHistory> history) {
    if (history.isEmpty) {
      return CourierAnalysis._empty(courier);
    }

    // Sort history by date (oldest first)
    List<WaybillHistory> sortedHistory = history.where((h) => h.parsedDate != null).toList();
    sortedHistory.sort((a, b) => a.parsedDate!.compareTo(b.parsedDate!));

    if (sortedHistory.length < 2) {
      return CourierAnalysis._empty(courier);
    }

    // Calculate total days
    DateTime startDate = sortedHistory.first.parsedDate!;
    DateTime endDate = sortedHistory.last.parsedDate!;
    int totalDays = endDate.difference(startDate).inDays;
    if (totalDays == 0) totalDays = 1; // Minimum 1 day

    // Extract milestones
    List<String> milestones = sortedHistory.map((h) => 
        '${h.date}: ${h.desc} (${h.location})').toList();

    // Determine performance level
    CourierPerformanceLevel performance = _determinePerformance(totalDays);

    // Generate recommendation
    String recommendation = _generateRecommendation(courier, performance, totalDays);

    // Calculate average speed (this would need distance data for accuracy)
    double avgSpeed = _calculateAverageSpeed(courier, totalDays);

    return CourierAnalysis(
      courierName: courier,
      totalDays: totalDays,
      averageSpeedKmPerDay: avgSpeed,
      performanceLevel: performance,
      milestones: milestones,
      recommendation: recommendation,
    );
  }

  factory CourierAnalysis._empty(String courier) {
    return CourierAnalysis(
      courierName: courier,
      totalDays: 0,
      averageSpeedKmPerDay: 0,
      performanceLevel: CourierPerformanceLevel.unknown,
      milestones: [],
      recommendation: 'Data tracking tidak cukup untuk analisis',
    );
  }

  static CourierPerformanceLevel _determinePerformance(int days) {
    if (days <= 2) return CourierPerformanceLevel.excellent;
    if (days <= 3) return CourierPerformanceLevel.good;
    if (days <= 5) return CourierPerformanceLevel.average;
    if (days <= 7) return CourierPerformanceLevel.slow;
    return CourierPerformanceLevel.verySlow;
  }

  static String _generateRecommendation(String courier, CourierPerformanceLevel performance, int days) {
    Map<String, String> courierStrengths = {
      'JNE': 'Jaringan luas, reliable untuk jarak jauh',
      'J&T': 'Cepat untuk area urban, harga kompetitif',
      'POS': 'Jangkauan ke daerah terpencil',
      'TIKI': 'Handling barang fragile yang baik',
      'SICEPAT': 'Delivery cepat area Jabodetabek',
      'ANTERAJA': 'Teknologi tracking yang baik',
      'NINJA': 'Same day delivery untuk area tertentu',
      'LION': 'Koneksi udara yang baik',
    };

    String strength = courierStrengths[courier.toUpperCase()] ?? 'Courier dengan layanan standard';
    
    switch (performance) {
      case CourierPerformanceLevel.excellent:
        return '✅ Excellent! $courier menunjukkan performa sangat baik ($days hari). $strength';
      case CourierPerformanceLevel.good:
        return '👍 Good! $courier memberikan layanan yang baik ($days hari). $strength';
      case CourierPerformanceLevel.average:
        return '⚡ Average. $courier memerlukan $days hari, masih dalam batas wajar. $strength';
      case CourierPerformanceLevel.slow:
        return '⚠️ Agak lambat. $courier memerlukan $days hari. Pertimbangkan courier lain untuk urgent delivery.';
      case CourierPerformanceLevel.verySlow:
        return '🐌 Sangat lambat. $courier memerlukan $days hari. Tidak direkomendasikan untuk pengiriman urgent.';
      default:
        return 'Data tidak cukup untuk memberikan rekomendasi';
    }
  }

  static double _calculateAverageSpeed(String courier, int days) {
    // Estimasi berdasarkan typical courier performance
    Map<String, double> courierSpeeds = {
      'JNE': 200.0,
      'J&T': 250.0,
      'SICEPAT': 300.0,
      'TIKI': 180.0,
      'POS': 150.0,
      'ANTERAJA': 220.0,
      'NINJA': 350.0,
      'LION': 400.0,
    };

    double baseSpeed = courierSpeeds[courier.toUpperCase()] ?? 200.0;
    return baseSpeed / (days > 0 ? days : 1);
  }

  String getEstimatedDeliveryTime() {
    switch (performanceLevel) {
      case CourierPerformanceLevel.excellent:
        return '1-2 hari kerja';
      case CourierPerformanceLevel.good:
        return '2-3 hari kerja';
      case CourierPerformanceLevel.average:
        return '4-5 hari kerja';
      case CourierPerformanceLevel.slow:
        return '6-7 hari kerja';
      case CourierPerformanceLevel.verySlow:
        return '7+ hari kerja';
      default:
        return 'Tidak dapat diestimasi';
    }
  }

  String getPerformanceEmoji() {
    switch (performanceLevel) {
      case CourierPerformanceLevel.excellent:
        return '🚀';
      case CourierPerformanceLevel.good:
        return '✅';
      case CourierPerformanceLevel.average:
        return '⚡';
      case CourierPerformanceLevel.slow:
        return '⚠️';
      case CourierPerformanceLevel.verySlow:
        return '🐌';
      default:
        return '❓';
    }
  }
}

// Utility class untuk analisis multiple couriers
class CourierComparison {
  static List<CourierAnalysis> rankCouriers(List<TrackingModel> trackings) {
    List<CourierAnalysis> analyses = trackings
        .where((t) => t.analysis != null)
        .map((t) => t.analysis!)
        .toList();

    // Sort by performance (fastest first)
    analyses.sort((a, b) {
      int aScore = _getPerformanceScore(a.performanceLevel);
      int bScore = _getPerformanceScore(b.performanceLevel);
      
      if (aScore != bScore) {
        return bScore.compareTo(aScore); // Higher score = better performance
      }
      
      return a.totalDays.compareTo(b.totalDays); // Lower days = better
    });

    return analyses;
  }

  static int _getPerformanceScore(CourierPerformanceLevel level) {
    switch (level) {
      case CourierPerformanceLevel.excellent: return 5;
      case CourierPerformanceLevel.good: return 4;
      case CourierPerformanceLevel.average: return 3;
      case CourierPerformanceLevel.slow: return 2;
      case CourierPerformanceLevel.verySlow: return 1;
      default: return 0;
    }
  }

  static Map<String, dynamic> generateReport(List<TrackingModel> trackings) {
    List<CourierAnalysis> analyses = trackings
        .where((t) => t.analysis != null)
        .map((t) => t.analysis!)
        .toList();

    if (analyses.isEmpty) {
      return {
        'summary': 'Tidak ada data untuk analisis',
        'fastest_courier': null,
        'slowest_courier': null,
        'average_days': 0,
        'recommendations': [],
      };
    }

    List<CourierAnalysis> ranked = rankCouriers(trackings);
    
    double avgDays = analyses.map((a) => a.totalDays).reduce((a, b) => a + b) / analyses.length;

    return {
      'summary': 'Analisis ${analyses.length} pengiriman dari ${Set.from(analyses.map((a) => a.courierName)).length} courier berbeda',
      'fastest_courier': ranked.isNotEmpty ? ranked.first : null,
      'slowest_courier': ranked.isNotEmpty ? ranked.last : null,
      'average_days': avgDays.toStringAsFixed(1),
      'recommendations': _generateGeneralRecommendations(ranked),
      'courier_ranking': ranked,
    };
  }

  static List<String> _generateGeneralRecommendations(List<CourierAnalysis> ranked) {
    if (ranked.isEmpty) return ['Tidak ada data untuk rekomendasi'];

    List<String> recommendations = [];
    
    if (ranked.isNotEmpty) {
      CourierAnalysis fastest = ranked.first;
      recommendations.add('🏆 Courier tercepat: ${fastest.courierName} (${fastest.totalDays} hari)');
    }

    if (ranked.length > 1) {
      CourierAnalysis slowest = ranked.last;
      recommendations.add('🐌 Courier terlambat: ${slowest.courierName} (${slowest.totalDays} hari)');
    }

    // Analysis by performance level
    Map<CourierPerformanceLevel, int> levelCounts = {};
    for (var analysis in ranked) {
      levelCounts[analysis.performanceLevel] = (levelCounts[analysis.performanceLevel] ?? 0) + 1;
    }

    int excellentCount = levelCounts[CourierPerformanceLevel.excellent] ?? 0;
    int totalCount = ranked.length;

    if (excellentCount > totalCount * 0.5) {
      recommendations.add('✅ ${((excellentCount/totalCount)*100).toInt()}% courier menunjukkan performa excellent');
    } else if (excellentCount == 0) {
      recommendations.add('⚠️ Tidak ada courier yang mencapai level excellent, pertimbangkan evaluasi mitra');
    }

    return recommendations;
  }
}

// Don't forget to import required packages at the top of your file:
// import 'dart:math' as math;
// import 'package:intl/intl.dart';