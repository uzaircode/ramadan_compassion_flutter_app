import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/prayer_times_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/prayer_time_card.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({Key? key}) : super(key: key);

  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _getPrayerTimes() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<PrayerTimesProvider>(context, listen: false);
      provider.fetchPrayerTimes(
        _cityController.text.trim(),
        _countryController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryGreen,
                    AppColors.secondaryGreen,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppStrings.welcome},',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    user?.displayName ?? 'User',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _cityController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: AppStrings.city,
                            labelStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(Icons.location_city, color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white30),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.gold),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.gold, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorStyle: TextStyle(color: AppColors.gold),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a city';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _countryController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: AppStrings.country,
                            labelStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(Icons.public, color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white30),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.gold),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.gold, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorStyle: TextStyle(color: AppColors.gold),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a country';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _getPrayerTimes,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              AppStrings.getTimes,
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Consumer<PrayerTimesProvider>(
              builder: (context, provider, child) {
                if (provider.loading) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: LoadingWidget(message: 'Fetching prayer times...'),
                  );
                }

                if (provider.error != null) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: ErrorMessageWidget(
                      message: provider.error!,
                      onRetry: _getPrayerTimes,
                    ),
                  );
                }

                if (provider.prayerTimes == null) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.mosque,
                          size: 80,
                          color: AppColors.textLight.withOpacity(0.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Enter your city and country\nto get prayer times',
                          style: AppTextStyles.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Text(
                            provider.prayerTimes!.date,
                            style: AppTextStyles.bodySmall,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${provider.prayerTimes!.city}',
                            style: AppTextStyles.heading3,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    ...provider.prayerTimes!.prayers.map(
                          (prayer) => PrayerTimeCard(prayerTime: prayer),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}