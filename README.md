# ChattyAI - Flutter Chat Application

A complete Flutter chat application with AI integration, built using your existing UI design and modern Flutter architecture.

## 🚀 Features

### Core Functionality
- **AI Chat Integration**: Chat with OpenAI GPT API (with fallback dummy responses)
- **Local Storage**: Persistent conversations using Hive database
- **Multi-language Support**: English and Arabic support
- **Conversation Management**: Start new chats, view history, continue conversations
- **Real-time Chat**: Live message updates with loading indicators

### UI Features (Using Your Existing Design)
- **Welcome Screen**: Capabilities showcase with "Start Chat" button
- **Chat Interface**: Message bubbles, copy/share options, stop generation
- **History Screen**: View past conversations with search and management
- **Responsive Design**: Optimized for different screen sizes

### Technical Features
- **State Management**: Cubit (flutter_bloc) for clean state handling
- **Local Database**: Hive for fast, persistent storage
- **API Integration**: HTTP client with OpenAI API support
- **Error Handling**: Comprehensive error handling and fallbacks

## 🛠️ Setup Instructions

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Hive Code
```bash
flutter packages pub run build_runner build
```

### 3. Configure OpenAI API (Optional)
Edit `lib/core/constants/api_config.dart`:
```dart
static const String openaiApiKey = 'your_actual_api_key_here';
```

If no API key is provided, the app will use intelligent dummy responses.

### 4. Run the App
```bash
flutter run
```

## 📱 App Structure

### Screens
1. **Welcome Screen**: Shows app capabilities and "Start Chat" button
2. **Chat Screen**: Main chat interface with AI responses
3. **History Screen**: View and manage past conversations

### Navigation Flow
```
Welcome Screen → Start Chat → Chat Interface
     ↓
History Screen (Floating Action Button)
     ↓
Continue Conversation or Start New Chat
```

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/
│   │   └── api_config.dart
│   ├── models/
│   │   ├── chat_message.dart
│   │   └── conversation.dart
│   └── services/
│       ├── hive_service.dart
│       └── openai_service.dart
├── views/
│   └── Home/
│       ├── cubit/
│       │   ├── chat_cubit.dart
│       │   ├── chat_state.dart
│       │   ├── home_cubit.dart
│       │   └── home_state.dart
│       ├── ui/
│       │   └── Home_Screen.dart
│       └── widgets/
│           ├── build_header.dart
│           ├── build_Main_Content.dart
│           ├── Start_chat_screen.dart
│           └── history_screen.dart
└── main.dart
```

### State Management
- **HomeCubit**: Manages navigation between welcome and chat screens
- **ChatCubit**: Handles chat functionality, messages, and AI responses
- **HiveService**: Manages local storage operations
- **OpenAIService**: Handles API calls and response generation

## 🔧 Configuration

### API Configuration
```dart
// lib/core/constants/api_config.dart
class ApiConfig {
  static const String openaiApiKey = 'your_api_key';
  static const String openaiBaseUrl = 'https://api.openai.com/v1';
  static const String openaiModel = 'gpt-3.5-turbo';
}
```

### Language Support
```dart
// Supported languages
'en' // English (default)
'ar' // Arabic
```

## 📊 Data Models

### ChatMessage
```dart
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isGenerating;
  final bool isCompleted;
  final String? errorMessage;
}
```

### Conversation
```dart
class Conversation {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final String? language;
}
```

## 🚀 Usage

### Starting a New Chat
1. Tap "Start Chat" on the welcome screen
2. Type your message in the input field
3. Send message and wait for AI response
4. Continue the conversation

### Viewing History
1. Tap the history icon (floating action button) on welcome screen
2. Browse past conversations
3. Tap any conversation to continue
4. Use menu options to delete conversations

### Language Switching
- The app automatically detects and uses the user's preferred language
- AI responses are generated in the selected language
- Support for English and Arabic

## 🔒 Privacy & Security

- **Local Storage**: All conversations are stored locally on the device
- **API Security**: API keys are stored locally and not shared
- **Data Control**: Users can delete conversations at any time
- **Offline Support**: App works without internet (with dummy responses)

## 🐛 Troubleshooting

### Common Issues

1. **Hive Code Generation Error**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **API Key Issues**
   - Check if API key is correctly set in `api_config.dart`
   - Verify internet connection
   - App will fallback to dummy responses if API fails

3. **Storage Issues**
   - Clear app data if Hive encounters corruption
   - Ensure sufficient device storage

### Debug Mode
```bash
flutter run --debug
```

## 📈 Future Enhancements

- [ ] Voice message support
- [ ] Image generation integration
- [ ] Advanced conversation search
- [ ] Export conversations
- [ ] Cloud backup options
- [ ] More language support
- [ ] Custom AI models

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check the troubleshooting section
- Review the code comments for implementation details

---

**Note**: This app uses your existing UI design without modifications. All functionality is built around your current layout, colors, and components.
