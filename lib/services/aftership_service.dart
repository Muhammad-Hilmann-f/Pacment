// aftership_service.dart - FIXED VERSION WITH ENV
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/models/tracking_models.dart';
import '../core/config/env_config.dart'; // Import env config

class BinderByteService {
  static const String _baseUrl = 'https://api.binderbyte.com/v1';
  
  // ✅ Ambil API key dari environment
  static String get _apiKey => EnvConfig.binderApiKey;

  // ✅ **1. Enhanced Tracking Waybill dengan Env**
  static Future<TrackingModel?> trackWaybill({
    required String awb,
    required String courierCode,
  }) async {
    // Validasi API key terlebih dahulu
    if (!EnvConfig.isApiKeyValid) {
      throw Exception('API key tidak valid atau tidak di-set. Periksa konfigurasi environment.');
    }

    try {
      final url = '$_baseUrl/track?api_key=$_apiKey&courier=$courierCode&awb=$awb';
      print('🔍 Tracking URL: $url'); // Debug log (remove in production)
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('📡 Response Status: ${response.statusCode}'); // Debug log
      print('📦 Response Body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // ✅ Enhanced validation
        if (data == null) {
          throw Exception('Response kosong dari server.');
        }
        
        if (data['status'] == false || data['data'] == null) {
          final message = data['message'] ?? 'Resi tidak ditemukan';
          throw Exception('API Error: $message');
        }
        
        if (data['data']['summary'] == null) {
          throw Exception('Data tracking tidak lengkap dari server.');
        }

        return TrackingModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('API key tidak valid atau kadaluarsa.');
      } else if (response.statusCode == 404) {
        throw Exception('Resi tidak ditemukan atau kurir tidak didukung.');
      } else if (response.statusCode == 429) {
        throw Exception('Terlalu banyak permintaan. Coba lagi nanti.');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on FormatException catch (e) {
      throw Exception('Format response tidak valid: $e');
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Tidak ada koneksi internet');
      }
      throw Exception("Error tracking waybill: $e");
    }
  }

  // ✅ **2. Enhanced Validasi Format Waybill**
  static bool isValidWaybillFormat(String waybillNumber) {
    if (waybillNumber.isEmpty || waybillNumber.length < 8 || waybillNumber.length > 25) {
      return false;
    }
    return RegExp(r'^[A-Za-z0-9\-_]+$').hasMatch(waybillNumber);
  }

  // ✅ **3. Enhanced Deteksi Kurir Otomatis**
  static String? detectCourier(String waybillNumber) {
    if (waybillNumber.isEmpty) return null;
    final waybill = waybillNumber.toUpperCase().trim();

    // JNE Detection
    if ((waybill.startsWith('JP') && waybill.length >= 10) ||
        (waybill.startsWith('JNE') && waybill.length >= 10) ||
        (RegExp(r'^[0-9]{10,13}$').hasMatch(waybill))) {
      return 'jne';
    }

    // J&T Detection
    if (waybill.startsWith('JP00') || 
        waybill.startsWith('JT') || 
        waybill.startsWith('JNT')) {
      return 'jnt';
    }

    // TIKI Detection
    if (waybill.startsWith('TK') || 
        RegExp(r'^[0-9]{9,10}$').hasMatch(waybill)) {
      return 'tiki';
    }

    // SiCepat Detection
    if (waybill.startsWith('SICE') || 
        waybill.startsWith('SD') || 
        waybill.startsWith('000')) {
      return 'sicepat';
    }

    // Pos Indonesia Detection
    if ((waybill.startsWith('CP') || waybill.startsWith('EE') || waybill.startsWith('RR')) && 
        waybill.endsWith('ID')) {
      return 'pos';
    }

    // Wahana Detection
    if (waybill.startsWith('WH') && waybill.length >= 10) {
      return 'wahana';
    }

    // Ninja Detection
    if (waybill.startsWith('NINJA') || waybill.startsWith('NJ')) {
      return 'ninja';
    }

    // Lion Parcel Detection
    if (waybill.startsWith('LP') || waybill.startsWith('LIO')) {
      return 'lion';
    }

    return null;
  }

  // ✅ **4. Enhanced Cek Ongkir dengan Env**
  static Future<Map<String, dynamic>> checkShippingCost({
    required String origin,
    required String destination,
    required int weight,
    required String courier,
  }) async {
    // Validasi API key
    if (!EnvConfig.isApiKeyValid) {
      throw Exception('API key tidak valid atau tidak di-set.');
    }

    try {
      final url = '$_baseUrl/cost?api_key=$_apiKey&courier=$courier&origin=$origin&destination=$destination&weight=$weight';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data == null || data.isEmpty) {
          throw Exception('Data ongkir tidak ditemukan.');
        }
        
        if (data['status'] == false) {
          final message = data['message'] ?? 'Gagal mengambil data ongkir';
          throw Exception('API Error: $message');
        }
        
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('API key tidak valid.');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception("Error checking shipping cost: $e");
    }
  }

  // ✅ **5. Method untuk test API key**
  static Future<bool> testApiKey() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/track?api_key=$_apiKey&courier=jne&awb=test'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      // Jika tidak error 401, berarti API key valid
      return response.statusCode != 401;
    } catch (e) {
      return false;
    }
  }
}