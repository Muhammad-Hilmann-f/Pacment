import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/models/tracking_models.dart';

class AfterShipService {
  static const String _baseUrl = 'https://api.aftership.com/v4/trackings';
  static const String _apiKey = 'AFTERSHIP_API_KEY'; 
  
  static Map<String, String> get _headers => {
    'aftership-api-key': _apiKey,
    'Content-Type': 'application/json',
  };

  // Create tracking
  static Future<TrackingResponse> createTracking({
    required String trackingNumber,
    String? slug, // courier slug (optional, AfterShip akan auto-detect)
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        'tracking': {
          'tracking_number': trackingNumber,
          if (slug != null) 'slug': slug,
          if (additionalFields != null) ...additionalFields,
        }
      };

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: json.encode(requestBody),
      );

      return _handleResponse(response);
    } catch (e) {
      throw TrackingException('Failed to create tracking: $e');
    }
  }

  // Get tracking by tracking number
  static Future<TrackingResponse> getTracking({
    required String trackingNumber,
    String? slug,
  }) async {
    try {
      String url = '$_baseUrl/$trackingNumber';
      if (slug != null) {
        url = '$_baseUrl/$slug/$trackingNumber';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw TrackingException('Failed to get tracking: $e');
    }
  }

  // Get all trackings
  static Future<List<TrackingInfo>> getAllTrackings({
    int page = 1,
    int limit = 100,
    String? keyword,
    String? tag,
    List<String>? slugs,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (keyword != null) 'keyword': keyword,
        if (tag != null) 'tag': tag,
        if (slugs != null) 'slug': slugs.join(','),
      };

      final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> trackings = data['data']['trackings'];
        
        return trackings
            .map((tracking) => TrackingInfo.fromJson(tracking))
            .toList();
      } else {
        throw TrackingException('Failed to get trackings: ${response.body}');
      }
    } catch (e) {
      throw TrackingException('Failed to get all trackings: $e');
    }
  }

  // Delete tracking
  static Future<bool> deleteTracking({
    required String trackingNumber,
    String? slug,
  }) async {
    try {
      String url = '$_baseUrl/$trackingNumber';
      if (slug != null) {
        url = '$_baseUrl/$slug/$trackingNumber';
      }

      final response = await http.delete(
        Uri.parse(url),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw TrackingException('Failed to delete tracking: $e');
    }
  }

  // Get courier list
  static Future<List<Courier>> getCouriers() async {
    try {
      const String couriersUrl = 'https://api.aftership.com/v4/couriers';
      final response = await http.get(
        Uri.parse(couriersUrl),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> couriers = data['data']['couriers'];
        
        return couriers
            .map((courier) => Courier.fromJson(courier))
            .toList();
      } else {
        throw TrackingException('Failed to get couriers: ${response.body}');
      }
    } catch (e) {
      throw TrackingException('Failed to get couriers: $e');
    }
  }

  // Auto-detect courier from tracking number
  static Future<List<Courier>> detectCourier({
    required String trackingNumber,
  }) async {
    try {
      const String detectUrl = 'https://api.aftership.com/v4/couriers/detect';
      final Map<String, dynamic> requestBody = {
        'tracking': {
          'tracking_number': trackingNumber,
        }
      };

      final response = await http.post(
        Uri.parse(detectUrl),
        headers: _headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> couriers = data['data']['couriers'];
        
        return couriers
            .map((courier) => Courier.fromJson(courier))
            .toList();
      } else {
        throw TrackingException('Failed to detect courier: ${response.body}');
      }
    } catch (e) {
      throw TrackingException('Failed to detect courier: $e');
    }
  }

  static TrackingResponse _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return TrackingResponse.fromJson(data);
    } else {
      final error = json.decode(response.body);
      throw TrackingException(
        error['meta']['message'] ?? 'Unknown error occurred'
      );
    }
  }
}
