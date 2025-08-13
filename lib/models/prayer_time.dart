class PrayerTime {
  final String name;
  final String time;

  PrayerTime({
    required this.name,
    required this.time,
  });

  factory PrayerTime.fromJson(String name, String time) {
    return PrayerTime(name: name, time: time);
  }
}

class PrayerTimesData {
  final String city;
  final String country;
  final String date;
  final List<PrayerTime> prayers;

  PrayerTimesData({
    required this.city,
    required this.country,
    required this.date,
    required this.prayers,
  });

  factory PrayerTimesData.fromJson(Map<String, dynamic> json) {
    final timings = json['data']['timings'];
    final meta = json['data']['meta'];
    final dateInfo = json['data']['date'];

    List<PrayerTime> prayerList = [
      PrayerTime(name: 'Fajr', time: timings['Fajr']),
      PrayerTime(name: 'Dhuhr', time: timings['Dhuhr']),
      PrayerTime(name: 'Asr', time: timings['Asr']),
      PrayerTime(name: 'Maghrib', time: timings['Maghrib']),
      PrayerTime(name: 'Isha', time: timings['Isha']),
    ];

    return PrayerTimesData(
      city: meta['timezone'] ?? 'Unknown',
      country: meta['timezone'] ?? 'Unknown',
      date: dateInfo['readable'] ?? '',
      prayers: prayerList,
    );
  }
}

