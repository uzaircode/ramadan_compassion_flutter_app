import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import 'prayer_times_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    PrayerTimesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        title: Text(
          AppStrings.appName,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        authProvider.signOut();
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: AppColors.errorRed),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textLight,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: AppStrings.prayerTimes,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_manual_record),
            label: AppStrings.tasbeeh,
          ),
        ],
      ),
    );
  }
}