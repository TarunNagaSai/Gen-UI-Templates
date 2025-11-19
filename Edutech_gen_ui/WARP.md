# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a Flutter-based AI-powered travel planning application called "Travel Gen AI" (package name: `education_gen_ui`). The app uses Firebase Gemini AI to generate conversational travel recommendations and dynamically generates UI components using the GenUI framework.

## Essential Commands

### Running the App
```bash
# Run on connected device/emulator
flutter run

# Or using derry script
derry run
```

### Code Generation
The project uses `build_runner` for code generation (particularly for AutoRoute):
```bash
# Generate code (routes, etc.)
dart run build_runner build --delete-conflicting-outputs

# Or using derry script
derry codegen
```

### Building APKs
```bash
# Build APK split per ABI
flutter build apk --split-per-abi

# Or using derry script
derry build-apk

# Build flavor-specific APKs (Note: main_test.dart and mainS.dart referenced but may not exist)
derry build-apk--test  # Test flavor
derry build-apk--prod  # Prod flavor
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
dart format .
```

## Architecture Overview

### State Management
- **BLoC Pattern**: Uses `flutter_bloc` for state management
- Main BLoC: `AiBloc` manages AI conversation state, message history, and Firebase Gemini AI interactions
- Events: `InitializeAiEvent`, `SendMessageEvent`, `ResetMessagesEvent`
- States: `AiInitial`, `AiInitializingState`, `AiLoadingState`, `AiLoadedState`, `AiErrorState`

### Firebase Integration
- **Firebase AI (Gemini)**: Primary AI model for conversation (`gemini-2.5-flash`)
- **Streaming Responses**: AI messages are streamed in real-time for better UX
- **Conversation Summary**: Maintains a rolling summary of conversation context (under 150 words)
- **Local Persistence**: Chat history saved using `shared_preferences`

### Navigation
- **AutoRoute**: Declarative routing system
- Route definitions in `lib/routes/routes.dart`
- Generated routes in `lib/routes/routes.gr.dart` (requires code generation)

### GenUI Framework
- Uses `genui` and `genui_firebase_ai` for dynamic UI generation
- **Custom Catalog Items**: `TripCard` component defined with JSON schema
- Firebase AI generates UI components based on user prompts
- System instruction configures AI as a travel assistant

### Key Components

#### Chat System (`lib/chat/`)
- `chat_screen.dart`: Main chat interface with dual AI systems (BLoC + GenUI)
- `ai_bloc.dart`: Manages conversation state, message persistence, and Gemini AI
- `chat_message.dart`: Message data model (message text + isUser flag)
- Widget components in `lib/chat/widgets/`:
  - `chat_message_list.dart`: Displays message history
  - `chat_message_input.dart`: Input field for user messages
  - `chat_empty_state.dart`: Empty state UI
  - `trip_card.dart`: Custom UI component for travel destinations

#### Constants (`lib/const/`)
- `constents.dart`: App-wide constants (AI model configuration)
- `theme.dart`: Material theme configuration

## Development Workflow

### Widget Creation
- **Always create stateless widgets, not functions** (per user preference)
- Use `const` constructors where possible for performance

### Firebase Configuration
- Firebase options auto-generated in `lib/firebase_options.dart`
- `.env` files are currently committed to git (project is private)

### Code Generation Workflow
After modifying routes or adding new `@RoutePage()` annotations:
1. Run `derry codegen` or `dart run build_runner build --delete-conflicting-outputs`
2. Import generated routes: `import 'package:education_gen_ui/routes/routes.gr.dart'`

### AI Model Configuration
- Model selection in `lib/const/constents.dart`
- Current model: `gemini-2.5-flash`
- To change model, update `AppConstants.geminiModel`

## Important Technical Details

### Dual AI System
The app uses two AI systems in parallel:
1. **BLoC-based AI**: Traditional chat with conversation summary and persistence
2. **GenUI AI**: Generates dynamic UI components from natural language

Both systems share the same chat interface but serve different purposes.

### Message Persistence
- Messages stored as JSON in `SharedPreferences`
- Keys: `"messages"` (list) and `"summary"` (string)
- Conversation summary maintained to provide context without sending full history

### Streaming Implementation
- `generateStreamingMessage()` in `AiBloc` handles real-time response streaming
- Response format includes `SUMMARY:` marker to extract conversation summary
- UI updates on each chunk for responsive feedback

## Project Structure
```
lib/
├── chat/
│   ├── bloc/              # BLoC state management
│   ├── widgets/           # Chat UI components
│   └── chat_message.dart  # Message model
├── const/                 # App constants and theme
├── routes/                # AutoRoute navigation
├── firebase_options.dart  # Firebase configuration
└── main.dart             # App entry point
```

## Dependencies Note
Key packages:
- `firebase_ai: ^3.6.0` - Gemini AI integration
- `genui: ^0.5.1` - Dynamic UI generation
- `auto_route: ^10.2.2` - Type-safe routing
- `flutter_bloc: ^9.1.1` - State management
- `shared_preferences: ^2.5.3` - Local storage

## Flavors/Build Variants
The project references build flavors in `pubspec.yaml` (Test, prod) but the corresponding entry point files (`main_test.dart`, `mainS.dart`) may not exist yet. Standard `main.dart` is the primary entry point.
