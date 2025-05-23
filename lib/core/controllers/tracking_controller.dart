import 'package:flutter/material.dart';
import '../../services/aftership_service.dart';
import '../models/tracking_models.dart';

class TrackingController extends ChangeNotifier {
  TrackingInfo? _currentTracking;
  List<TrackingInfo> _trackingHistory = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  TrackingInfo? get currentTracking => _currentTracking;
  List<TrackingInfo> get trackingHistory => _trackingHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Track package
  Future<void> trackPackage(String trackingNumber, {String? courierSlug}) async {
    _setLoading(true);
    _clearError();

    try {
      // Try to get existing tracking first
      TrackingResponse response;
      
      try {
        response = await AfterShipService.getTracking(
          trackingNumber: trackingNumber,
          slug: courierSlug,
        );
      } catch (e) {
        // If tracking doesn't exist, create it
        response = await AfterShipService.createTracking(
          trackingNumber: trackingNumber,
          slug: courierSlug,
        );
      }

      _currentTracking = response.data.tracking;
      _addToHistory(_currentTracking!);
      
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Auto-detect courier and track
  Future<void> autoTrackPackage(String trackingNumber) async {
    _setLoading(true);
    _clearError();

    try {
      // First, detect the courier
      final couriers = await AfterShipService.detectCourier(
        trackingNumber: trackingNumber,
      );

      if (couriers.isNotEmpty) {
        // Use the first detected courier
        await trackPackage(trackingNumber, courierSlug: couriers.first.slug);
      } else {
        // If no courier detected, try without courier slug
        await trackPackage(trackingNumber);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Refresh current tracking
  Future<void> refreshTracking() async {
    if (_currentTracking == null) return;

    await trackPackage(
      _currentTracking!.trackingNumber,
      courierSlug: _currentTracking!.slug,
    );
  }

  // Load tracking history
  Future<void> loadTrackingHistory() async {
    _setLoading(true);
    _clearError();

    try {
      _trackingHistory = await AfterShipService.getAllTrackings();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Remove tracking from history
  Future<void> removeFromHistory(TrackingInfo tracking) async {
    try {
      final success = await AfterShipService.deleteTracking(
        trackingNumber: tracking.trackingNumber,
        slug: tracking.slug,
      );

      if (success) {
        _trackingHistory.removeWhere((t) => t.id == tracking.id);
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void _addToHistory(TrackingInfo tracking) {
    // Remove if already exists
    _trackingHistory.removeWhere((t) => t.trackingNumber == tracking.trackingNumber);
    // Add to beginning
    _trackingHistory.insert(0, tracking);
    notifyListeners();
  }

  void clearCurrentTracking() {
    _currentTracking = null;
    notifyListeners();
  }
}
