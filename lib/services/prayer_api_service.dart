import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_time.dart';

class PrayerApiService {
  static const String baseUrl = 'https://api.aladhan.com/v1';

  Future<PrayerTimesData> getPrayerTimesByCity(String city, String country) async {
    try {
      final String url = '$baseUrl/timingsByCity?city=$city&country=$country';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['code'] == 200) {
          return PrayerTimesData.fromJson(data);
        } else {
          throw Exception('Failed to fetch prayer times');
        }
      } else {
        throw Exception('Failed to connect to server');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection');
      }
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<PrayerTimesData> getPrayerTimesByCoordinates(double latitude, double longitude) async {
    try {
      final String url = '$baseUrl/timings?latitude=$latitude&longitude=$longitude';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['code'] == 200) {
          return PrayerTimesData.fromJson(data);
        } else {
          throw Exception('Failed to fetch prayer times');
        }
      } else {
        throw Exception('Failed to connect to server');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection');
      }
      throw Exception('Error: ${e.toString()}');
    }
  }
}