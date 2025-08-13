import 'package:flutter/material.dart';
import '../models/prayer_time.dart';
import '../services/prayer_api_service.dart';

class PrayerTimesProvider extends ChangeNotifier {
  final PrayerApiService _apiService = PrayerApiService();

  PrayerTimesData? _prayerTimes;
  bool _loading = false;
  String? _error;

  PrayerTimesData? get prayerTimes => _prayerTimes;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchPrayerTimes(String city, String country) async {
    try {
      _setLoading(true);
      _error = null;

      _prayerTimes = await _apiService.getPrayerTimesByCity(city, country);

      _setLoading(false);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _prayerTimes = null;
      _setLoading(false);
    }
  }

  Future<void> fetchPrayerTimesByCoordinates(double latitude, double longitude) async {
    try {
      _setLoading(true);
      _error = null;

      _prayerTimes = await _apiService.getPrayerTimesByCoordinates(latitude, longitude);

      _setLoading(false);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _prayerTimes = null;
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearData() {
    _prayerTimes = null;
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}