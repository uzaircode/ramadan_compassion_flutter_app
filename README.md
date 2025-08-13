# Ramadan Companion App

A Flutter application that provides prayer times and a digital Tasbeeh counter for Muslims during Ramadan and throughout the year.

## Features

### 1. **Firebase Authentication**
- User registration with email, password, and display name
- Secure login with email and password
- Session persistence
- Logout functionality
- Real-time authentication state management

### 2. **Prayer Times**
- Fetch accurate prayer times using the Al Adhan API
- Search by city and country
- Display five daily prayer times (Fajr, Dhuhr, Asr, Maghrib, Isha)
- Beautiful card-based UI with gradient design
- Loading and error states handling

### 3. **Tasbeeh Counter (Digital Dhikr Counter)**
- Interactive counter with haptic feedback
- Preset targets (33, 99, 100) or custom target setting
- Visual progress indicator
- Total count tracking
- Data persistence using SharedPreferences
- Completion notifications with vibration feedback
- Reset functionality

## Test Account

For testing purposes, you can use the following pre-created account:

```
Email: test@ramadan.com
Password: test123456
```

**Note:** You'll need to create this account in your Firebase project first, or create your own test account.

## Setup Instructions

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- Firebase account

### Installation

1. **Clone the repository:**
```bash
git clone [your-repository-url]
cd ramadhan_companion
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Firebase Configuration:**
    - Create a new Firebase project at https://console.firebase.google.com
    - Enable Email/Password authentication in Firebase Console
    - Add an Android app to your Firebase project
    - Download the `google-services.json` file
    - Replace the placeholder file at `android/app/google-services.json` with your actual file
    - Update `lib/firebase_options.dart` with your Firebase configuration

4. **Run the app:**
```bash
flutter run
```

### Building APK

To build a release APK:
```bash
flutter build apk --release
```

The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── user_model.dart
│   └── prayer_time.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── prayer_times_provider.dart
│   └── tasbeeh_provider.dart
├── screens/                  # UI screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── prayer_times_screen.dart
│   │   └── tasbeeh_screen.dart
│   └── wrapper.dart
├── services/                 # Business logic
│   ├── auth_service.dart
│   └── prayer_api_service.dart
├── widgets/                  # Reusable widgets
│   ├── prayer_time_card.dart
│   ├── loading_widget.dart
│   └── error_widget.dart
└── utils/                    # Constants and utilities
    └── constants.dart
```

## Technical Details

### State Management
The app uses the Provider package for state management, implementing:
- `AuthProvider` for authentication state
- `PrayerTimesProvider` for prayer times data
- `TasbeehProvider` for counter state

### API Integration
- **Al Adhan API** (https://aladhan.com/prayer-times-api) for accurate prayer times
- RESTful API calls using the `http` package

### Authentication Flow
- Firebase Authentication with email/password
- Stream-based auth state management using `authStateChanges`
- Automatic navigation based on authentication status

### Data Persistence
- SharedPreferences for storing Tasbeeh counter data
- Firebase for user authentication data

## Design Features

- **Islamic Green Theme**: Traditional Islamic color palette
- **Gradient Designs**: Modern UI with gradient backgrounds
- **Responsive Layout**: Adapts to different screen sizes
- **Material Design 3**: Latest Material Design guidelines
- **Haptic Feedback**: Enhanced user experience with tactile feedback

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^4.0.0
  firebase_auth: ^6.0.1
  provider: ^6.1.2
  http: ^1.2.2
  intl: ^0.19.0
  shared_preferences: ^2.3.4
```

## Firebase Project Configuration

To add our reviewer as a Viewer to your Firebase project:
1. Go to Firebase Console
2. Select your project
3. Go to Project Settings > Users and Permissions
4. Add the reviewer's email with "Viewer" role

## Known Issues

- The app requires an active internet connection for prayer times
- Firebase configuration must be properly set up before running
- Minimum Android SDK version is 30

## Future Enhancements

- Qibla direction compass
- Prayer time notifications
- Multiple calculation methods for prayer times
- Offline support with cached prayer times
- User profiles with statistics
- Social features for community engagement

## License

This project is created for assessment purposes.

## Support

For any issues or questions, please contact the development team.
