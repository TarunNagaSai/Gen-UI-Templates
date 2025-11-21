# Edutech Gen UI

An AI-powered interactive learning application built with Flutter, Firebase Gemini AI, and the GenUI framework. This app transforms education into an engaging, conversational experience with integrated YouTube videos, AI-generated summaries, and interactive quizzes.

## App Concept

Edutech Gen UI is designed to provide a comprehensive learning experience through AI-powered conversations:

### 📚 Learning Flow

1. **Ask & Learn**: Users ask questions about any topic they want to understand
2. **AI Explanation**: The AI provides detailed explanations with relevant YouTube video recommendations via custom function calling
3. **Embedded Video Player**: Watch educational videos directly within the chat interface using YouTube player
4. **Smart Summaries**: AI-generated quick summaries with view tracking and keyword extraction
5. **Interactive Quizzes**: After learning, take AI-generated quizzes (up to 5 questions) based on the content
6. **Progress Tracking**: Save quiz results and learning progress locally with comprehensive statistics
7. **Notes Management**: Summaries automatically saved as notes for future reference
8. **Persistent Chat History**: All conversations stored locally with full CRUD operations

### ✨ Key Features

- 🤖 **AI-Powered Learning**: Conversational explanations using Firebase Gemini AI with custom tools
- 🎥 **YouTube Integration**: Search and embed educational videos using YouTube Data API v3
- 📝 **Smart Summaries**: AI-generated summaries with metadata (keywords, view count, language)
- 🎯 **Dynamic Quizzes**: Structured quiz system with multiple-choice questions and detailed results
- 📊 **Progress Tracking**: Comprehensive quiz results with topic-based filtering and statistics
- 💾 **Local Storage Service**: Robust SharedPreferences-based persistence layer with full CRUD operations
- 🎨 **Dynamic UI Generation**: GenUI framework with custom catalog items (QuizCard, YouTubeCard)
- 📱 **Cross-platform**: Works on Android & iOS
- ⚡ **Real-time Streaming**: Live AI responses via GenUI conversation system
- 🔄 **State Management**: Riverpod with code generation for reactive state

## Prerequisites

- Flutter SDK (3.10.0 or higher)
- Dart SDK (3.10.0 or higher)
- Firebase account with Firebase AI (Gemini) enabled
- YouTube Data API v3 key
- Android Studio / Xcode (for mobile development)

## Setup

### Step 1: Firebase Setup

⚠️ **Important**: You need to set up your own Firebase project to run this app.

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

### Step 3: YouTube API Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Enable **YouTube Data API v3**
3. Create an API key for YouTube Data API

### Step 4: Environment Configuration

Create a `.env` file in the project root:

```env
YOUTUBE_API_KEY=your_youtube_api_key_here
```



## Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd Edutech_gen_ui

# Install dependencies
flutter pub get

# Generate code (for AutoRoute, JSON serialization, and Riverpod)
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
├── src/
│   ├── catalogs/              # GenUI custom catalog items
│   │   ├── quiz_card_widget.dart
│   │   ├── youtube_video_card_widget.dart
│   │   └── catalogs.dart      # Combined catalog definition
│   ├── chat/
│   │   ├── chat_screen.dart   # Main chat interface
│   │   └── widgets/           # Chat UI components
│   ├── const/
│   │   ├── constents.dart     # App-wide constants
│   │   ├── education_system_prompt.dart  # AI system prompt
│   │   └── theme.dart         # Material theme configuration
│   ├── models/                # Data models with JSON serialization
│   │   ├── chat_entry.dart    # Complete chat interaction model
│   │   ├── chat_message.dart  # Simple message model
│   │   ├── quiz.dart          # Quiz structure
│   │   ├── quiz_question.dart # Quiz question model
│   │   ├── quiz_result.dart   # Quiz completion results
│   │   ├── summary.dart       # Video/content summary
│   │   └── youtube_search_response.dart
│   ├── providers/             # Riverpod state management
│   │   └── ai_provider.dart   # AI chat state provider
│   ├── routes/                # AutoRoute navigation
│   │   ├── routes.dart
│   │   └── routes.gr.dart     # Generated routes
│   ├── services/              # Business logic services
│   │   ├── local_storage_service.dart  # SharedPreferences wrapper
│   │   └── youtube_service.dart        # YouTube API client
│   └── tools/
│       └── youtube_search_key_tool.dart  # Custom GenUI tool
├── firebase_options.dart      # Firebase configuration
└── main.dart                  # App entry point
```

## Architecture

### State Management
- **Riverpod**: Modern reactive state management with code generation
- **AI Provider**: Manages chat state, messages, and loading states

### AI & UI Generation
- **GenUI Conversation**: Handles AI interactions with custom tools
- **Firebase Gemini AI**: Content generation with custom system prompts
- **Custom Tools**: YouTube search integration via function calling
- **Custom Catalog**: QuizCard and YouTubeCard components for dynamic UI

### Navigation
- **AutoRoute**: Type-safe declarative routing with code generation

### Data Layer
- **LocalStorageService**: Singleton service wrapping SharedPreferences
- **Structured Models**: JSON-serializable models with code generation
- **Full CRUD Operations**: Create, read, update, delete for all data types
- **Statistics & Analytics**: Built-in storage statistics and topic-based filtering

### Services
- **YouTubeService**: Dio-based HTTP client for YouTube Data API v3
- **Error Handling**: Comprehensive exception handling and user-friendly messages

### Key Design Patterns
- **Singleton Pattern**: LocalStorageService for global state
- **Factory Pattern**: Model deserialization from JSON
- **Observer Pattern**: ValueListenableBuilder for GenUI conversation updates
- **Repository Pattern**: LocalStorageService acts as data repository


## Data Models

The app uses strongly-typed models with JSON serialization:

### ChatEntry
Complete record of a learning interaction including user query, AI explanation, video references, and associated quiz/summary IDs.

### Summary
AI-generated summaries with metadata (keywords, view count, language), marking as saved notes, and topic categorization.

### Quiz & QuizQuestion
Structured quiz system with multiple-choice questions, correct answers, and explanations.

### QuizResult
Detailed quiz completion data including score, answers, time spent, and topic.

## Custom GenUI Tools

### YouTubeSearchKeyTool
Integrates YouTube Data API v3 with GenUI's function calling system, allowing the AI to search and embed relevant educational videos in response to user queries.

## Example Queries

Try asking the AI tutor:
- "Explain the concept of photosynthesis with examples."
- "How does the water cycle work? Provide real-life examples."
- "Can you give me examples of Newton's three laws of motion?"
- "What are some examples of chemical reactions in everyday life?"
- "Explain the concept of supply and demand with examples."

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Security Notes

⚠️ **Currently committed to version control** (project is private):
- `.env` (contains YouTube API key)
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

⚠️ **For production deployment**: Add these files to `.gitignore` and use secure environment variable management.
