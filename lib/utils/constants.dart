import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF0A7E3E);
  static const Color secondaryGreen = Color(0xFF10A858);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color darkGreen = Color(0xFF065028);
  static const Color gold = Color(0xFFFFD700);
  static const Color lightGold = Color(0xFFFFF8DC);
  static const Color backgroundWhite = Color(0xFFFAFAFA);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Color(0xFF757575);
  static const Color errorRed = Color(0xFFD32F2F);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textLight,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

class AppStrings {
  static const String appName = 'Ramadan Companion';
  static const String welcome = 'Assalamu Alaikum';
  static const String login = 'Login';
  static const String register = 'Register';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String name = 'Name';
  static const String logout = 'Logout';
  static const String prayerTimes = 'Prayer Times';
  static const String tasbeeh = 'Tasbeeh';
  static const String city = 'City';
  static const String country = 'Country';
  static const String getTimes = 'Get Times';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String retry = 'Retry';
}