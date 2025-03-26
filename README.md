# SMS Handler

A Flutter application for managing and handling SMS messages with pattern matching capabilities.

## Prerequisites

- Flutter SDK (^3.6.1)
- Android Studio / VS Code with Flutter extensions
- Android device or emulator (Android 5.0 or higher)
- SMS permissions enabled on device

## Getting Started

1. Clone the repository:
```bash
git clone https://github.com/yourusername/sms_handler.git
cd sms_handler
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

lib/
├── app.dart              # Main app widget
├── main.dart            # App entry point
├── screens/
│   └── home_screen.dart  # Home screen widget
├── services/
│   ├── api_service.dart  # API service
│   └── sms_service.dart  # SMS service
└── widgets/
    ├── loading_indicator.dart
    ├── message_card.dart
    └── message_list.dart