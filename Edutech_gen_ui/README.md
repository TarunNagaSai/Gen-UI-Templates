# Edutech Gen UI

An AI-powered interactive learning application built with Flutter, Firebase Gemini AI, and the GenUI framework. This app transforms education into an engaging, conversational experience with integrated YouTube videos, AI-generated summaries, and interactive quizzes.

## App Concept

Edutech Gen UI is designed to provide a comprehensive learning experience through AI-powered conversations:

### 📚 Learning Flow

1. **Ask & Learn**: Users ask questions about any topic they want to understand
2. **AI Explanation**: The AI provides detailed explanations with relevant YouTube video recommendations
3. **Embedded Video Player**: Watch educational videos directly within the chat interface
4. **Smart Summaries**: Click the summary button below any video to get an AI-generated quick summary
5. **Interactive Quizzes**: After learning, take AI-generated quizzes (up to 5 questions) based on the content
6. **Progress Tracking**: Save quiz results and learning progress locally
7. **Notes Management**: Summaries are automatically saved as notes for future reference
8. **Persistent Chat History**: All conversations are stored locally for easy review

### ✨ Key Features

- 🤖 **AI-Powered Learning**: Conversational explanations using Google Gemini API
- 🎥 **Embedded YouTube Player**: Watch educational videos without leaving the app
- 📝 **Auto-Generated Summaries**: Quick AI summaries of video content
- 🎯 **Dynamic Quizzes**: AI-generated quizzes based on learned content
- 📊 **Progress Tracking**: Save and review quiz results
- 💾 **Local Storage**: Chat history, notes, and quiz results saved locally
- 🎨 **Dynamic UI Generation**: GenUI framework for flexible, AI-driven interfaces
- 📱 **Cross-platform**: Works on Android & iOS
- ⚡ **Real-time Streaming**: Live AI responses as they're generated

## Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Firebase account
- Android Studio / Xcode (for mobile development)

## Firebase Setup

⚠️ **Important**: You need to set up your own Firebase project to run this app.

### Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project or use an existing one
3. Enable Firebase AI (Gemini API) for your project

### Step 2: Configure Firebase for Flutter

#### Option A: Using FlutterFire CLI (Recommended)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

This will automatically generate `lib/firebase_options.dart` with your configuration.

#### Option B: Manual Configuration

1. Add Android and iOS apps in Firebase Console
2. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
3. Place them in:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
4. Copy `lib/firebase_options.dart.template` to `lib/firebase_options.dart`
5. Fill in your Firebase configuration values

### Step 3: Enable Firebase Services

In Firebase Console:
1. Enable **Firebase AI** (Gemini API)
2. Enable **Firebase Authentication** (if needed)
3. Enable **Cloud Storage** (if needed)
4. Set up **Firebase Security Rules**

## Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd Edutech_gen_ui

# Install dependencies
flutter pub get

# Generate code (for AutoRoute)
dart run build_runner build --delete-conflicting-outputs
# Or using derry
derry codegen

# Run the app
flutter run
# Or using derry
derry run
```

## Development

### Running Tests

```bash
flutter test
```

### Code Generation

After modifying routes or adding new `@RoutePage()` annotations:

```bash
derry codegen
```

### Building APKs

```bash
# Build APK split per ABI
derry build-apk

# Or manually
flutter build apk --split-per-abi
```

### Code Quality

```bash
# Analyze code
flutter analyze

# Format code
dart format .
```

## Project Structure

```
lib/
├── chat/
│   ├── bloc/              # BLoC state management
│   ├── widgets/           # Chat UI components
│   └── chat_message.dart  # Message model
├── const/                 # App constants and theme
├── routes/                # AutoRoute navigation
├── firebase_options.dart  # Firebase configuration (gitignored)
└── main.dart             # App entry point
```

## Architecture

- **State Management**: BLoC pattern with `flutter_bloc`
- **Navigation**: AutoRoute for type-safe routing
- **AI Integration**: Firebase Gemini AI with streaming responses
- **UI Generation**: GenUI framework for dynamic components
- **Persistence**: SharedPreferences for local storage

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Security Notes

⚠️ **Never commit the following files to version control**:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

These files contain sensitive Firebase configuration and are included in `.gitignore`.