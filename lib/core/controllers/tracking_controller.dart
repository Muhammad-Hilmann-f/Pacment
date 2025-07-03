// tracking_controller.dart - ENHANCED VERSION
import 'package:flutter/material.dart';
import '../../services/aftership_service.dart';
import '../../core/models/tracking_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class TrackingController extends ChangeNotifier {
  TrackingModel? _currentTracking;
  List<TrackingModel> _trackingHistory = []; // Pastikan ini ada dan digunakan
  bool _isLoading = false;
  String? _error;
  String? _lastSearchedAwb;
  
// Getters
  TrackingModel? get currentTracking => _currentTracking;
  List<TrackingModel> get trackingHistory => _trackingHistory; // Ini getter yang akan diakses AnalyticsScreen
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get lastSearchedAwb => _lastSearchedAwb;
  bool get hasData => _currentTracking != null;


  // ✅ **1. Enhanced Validasi Nomor Resi**
  bool _isValidResi(String awb) {
    if (awb.isEmpty) return false;
    final cleanAwb = awb.trim();
    
    // Basic length and character validation
    if (cleanAwb.length < 8 || cleanAwb.length > 25) return false;
    
    // Allow alphanumeric characters, dashes, and some special chars
    return RegExp(r'^[0-9A-Za-z\-_]+$').hasMatch(cleanAwb);
  }

  void setCurrentTracking(TrackingModel tracking) {
  _currentTracking = tracking;
  notifyListeners();
  }

  Future<void> _saveTrackingToFirestore(TrackingModel tracking) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    debugPrint('🚫 User not logged in, skip saving tracking');
    return;
  }

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('trackings')
        .add({
          'resi': tracking.awb,
          'kurir': tracking.courier,
          'status': tracking.status,
          'date': tracking.date,
          'detail': {
            'origin': tracking.detail.origin,
            'destination': tracking.detail.destination,
            'shipper': tracking.detail.shipper,
            'receiver': tracking.detail.receiver,
            'latitude': tracking.detail.latitude,
            'longitude': tracking.detail.longitude,
            'distance': tracking.detail.distance,
          },
          'history': tracking.history.map((h) => {
            'date': h.date,
            'desc': h.desc,
            'location': h.location,
          }).toList(),
          'createdAt': FieldValue.serverTimestamp(),
        });
    debugPrint('✅ Tracking saved to Firestore');
  } catch (e) {
    debugPrint('❌ Failed to save tracking: $e');
  }
}

  // ✅ **2. Enhanced Tracking Paket with better error handling**
  Future<void> trackPackage({required String awb, required String courierCode}) async {
    _setLoading(true);
    _clearError();
    _lastSearchedAwb = awb.trim();

    if (!_isValidResi(awb)) {
      _setError('Nomor resi tidak valid. Pastikan format resi benar (8-25 karakter).');
      _setLoading(false);
      return;
    }


    try {
      final trackingData = await BinderByteService.trackWaybill(
        awb: awb.trim(),
        courierCode: courierCode.toLowerCase().replaceAll(' ', ''),
      );

      if (trackingData != null) {
  _currentTracking = trackingData;
  _saveTrackingHistory(trackingData);
  await _saveTrackingToFirestore(trackingData); // 🟢 Ini yang bikin auto save!
  _clearError();
  notifyListeners();
}
      if (trackingData != null) {
        _currentTracking = trackingData;
        _saveTrackingHistory(trackingData);
        _clearError(); // Clear any previous errors
        notifyListeners();
      } else {
        _setError('Resi tidak ditemukan atau kurir tidak sesuai. Coba pilih kurir yang berbeda.');
      }
    } catch (e) {
      debugPrint('Tracking error: $e'); // For debugging
      _setError(_formatError(e.toString()));
    } finally {
      _setLoading(false);
    }
  }

  // ✅ **3. Enhanced Auto-Detect Kurir & Tracking**
  Future<void> autoTrackPackage(String awb) async {
    _setLoading(true);
    _clearError();
    _lastSearchedAwb = awb.trim();

    if (!_isValidResi(awb)) {
      _setError('Format resi tidak valid. Periksa kembali nomor resi Anda.');
      _setLoading(false);
      return;
    }

    try {
      final detectedCourier = BinderByteService.detectCourier(awb.trim());
      
      if (detectedCourier != null) {
        debugPrint('Detected courier: $detectedCourier for AWB: $awb'); // Debug log
        await trackPackage(awb: awb.trim(), courierCode: detectedCourier);
      } else {
        _setError('Kurir tidak dapat dideteksi otomatis. Silakan pilih kurir secara manual.');
      }
    } catch (e) {
      debugPrint('Auto tracking error: $e'); // For debugging
      _setError(_formatError(e.toString()));
    } finally {
      _setLoading(false);
    }
  }

  // ✅ **4. Enhanced Simpan Riwayat Pencarian**
void _saveTrackingHistory(TrackingModel tracking) {
    // Check if tracking already exists in history (avoid duplicates)
    final existingIndex = _trackingHistory.indexWhere( // Menggunakan _trackingHistory
      (item) => item.awb == tracking.awb && item.courier == tracking.courier,
    );
    if (existingIndex != -1) {
      // Update existing entry
      _trackingHistory[existingIndex] = tracking; // Menggunakan _trackingHistory
    } else {
      // Add new entry at the beginning
      _trackingHistory.insert(0, tracking); // Menggunakan _trackingHistory
    }
    
    // Keep only last 15 entries
    if (_trackingHistory.length > 15) { // Menggunakan _trackingHistory
      _trackingHistory.removeRange(15, _trackingHistory.length); // Menggunakan _trackingHistory
    }
    
    notifyListeners();
  
  }

  Future<void> deleteTrackingFromFirestore(String awb) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    debugPrint('🚫 User not logged in, skip deleting tracking');
    return;
  }

  try {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('trackings')
        .where('resi', isEqualTo: awb)
        .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
      debugPrint('🗑️ Tracking deleted from Firestore: ${doc.id}');
    }
  } catch (e) {
    debugPrint('❌ Failed to delete tracking from Firestore: $e');
  }
}


  // ✅ **5. Hapus Tracking dari History**
  void removeFromHistory(int index) {
    if (index >= 0 && index < trackingHistory.length) {
      trackingHistory.removeAt(index);
      notifyListeners();
    }
  }

  // ✅ **6. Clear specific tracking from history by AWB**
  void removeTrackingByAwb(String awb) {
    trackingHistory.removeWhere((tracking) => tracking.awb == awb);
    notifyListeners();
  }

  // ✅ **7. Reset Data**
  void clearCurrentTracking() {
    _currentTracking = null;
    _clearError();
    notifyListeners();
  }

  void clearAllHistory() {
    trackingHistory.clear();
    notifyListeners();
  }

  // ✅ **8. Enhanced Helper untuk Error Handling**
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  String _formatError(String error) {
    // More comprehensive error formatting
    if (error.contains('HTTP 400')) {
      return 'Permintaan tidak valid. Periksa nomor resi dan pilihan kurir.';
    }
    if (error.contains('HTTP 401')) {
      return 'Layanan sementara tidak tersedia. Coba lagi nanti.';
    }
    if (error.contains('HTTP 404')) {
      return 'Resi tidak ditemukan. Pastikan nomor resi dan kurir sudah benar.';
    }
    if (error.contains('HTTP 429')) {
      return 'Terlalu banyak permintaan. Tunggu sebentar dan coba lagi.';
    }
    if (error.contains('HTTP 500')) {
      return 'Server sedang bermasalah. Coba lagi dalam beberapa menit.';
    }
    if (error.contains('SocketException') || error.contains('NetworkException')) {
      return 'Tidak ada koneksi internet. Periksa koneksi Anda.';
    }
    if (error.contains('TimeoutException')) {
      return 'Koneksi timeout. Periksa koneksi internet Anda.';
    }
    if (error.contains('FormatException')) {
      return 'Data tidak valid dari server. Coba lagi nanti.';
    }
    
    // Clean up generic error messages
    String cleanError = error
        .replaceAll('Exception: ', '')
        .replaceAll('Error tracking waybill: ', '')
        .replaceAll('Error: ', '');
    
    return cleanError.isNotEmpty ? cleanError : 'Terjadi kesalahan tidak dikenal. Coba lagi.';
  }

  // ✅ **9. Utility method to refresh current tracking**
  Future<void> refreshCurrentTracking() async {
    if (_currentTracking != null) {
      await trackPackage(
        awb: _currentTracking!.awb, 
        courierCode: _currentTracking!.courier,
      );
    }
  }

TrackingModel? getTrackingFromHistory(String awb) {
    try {
      return _trackingHistory.firstWhere(
        (tracking) => tracking.awb == awb.trim(),
      );
    } catch (_) {
      return null;
    }
  }
}