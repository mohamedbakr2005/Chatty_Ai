import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatty_ai/core/models/chat_message.dart';
import 'package:chatty_ai/core/models/conversation.dart';
import 'package:chatty_ai/core/services/hive_service.dart';
import 'package:chatty_ai/core/services/openai_service.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatInitial());

  final HiveService _hiveService = HiveService();
  // final OpenAIService _openaiService = OpenAIService();

  Conversation? _currentConversation;
  String _currentLanguage = 'en';

  // Getters
  Conversation? get currentConversation => _currentConversation;
  String get currentLanguage => _currentLanguage;

  Future<void> initializeChat() async {
    try {
      emit(const ChatLoading());

      // Get language preference
      _currentLanguage = _hiveService.getLanguage();

      // Create initial greeting
      final greetingMessage = ChatMessage(
        id: _hiveService.generateMessageId(),
        text: _getGreetingMessage(_currentLanguage),
        isUser: false,
        timestamp: DateTime.now(),
      );

      // Create new conversation
      _currentConversation = Conversation(
        id: _hiveService.generateConversationId(),
        title: 'New Chat',
        messages: [greetingMessage],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        language: _currentLanguage,
      );

      // Save conversation
      await _hiveService.saveConversation(_currentConversation!);

      emit(
        ChatLoaded(
          messages: _currentConversation!.messages,
          isGenerating: false,
          currentConversationId: _currentConversation!.id,
        ),
      );
    } catch (e) {
      emit(ChatError('Failed to initialize chat: $e'));
    }
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    try {
      // Add user message
      final userMessage = ChatMessage(
        id: _hiveService.generateMessageId(),
        text: text.trim(),
        isUser: true,
        timestamp: DateTime.now(),
      );

      // Add AI response placeholder
      final aiMessage = ChatMessage(
        id: _hiveService.generateMessageId(),
        text: '',
        isUser: false,
        timestamp: DateTime.now(),
        isGenerating: true,
        isCompleted: false,
      );

      // Update conversation
      _currentConversation = _currentConversation!.copyWith(
        messages: [..._currentConversation!.messages, userMessage, aiMessage],
        updatedAt: DateTime.now(),
        title: _currentConversation!.title == 'New Chat'
            ? _hiveService.generateConversationTitle(text.trim())
            : _currentConversation!.title,
      );

      // Save to Hive
      await _hiveService.updateConversation(_currentConversation!);

      // Emit state
      emit(
        ChatLoaded(
          messages: _currentConversation!.messages,
          isGenerating: true,
          currentConversationId: _currentConversation!.id,
        ),
      );

      // Generate AI response
      await _generateAIResponse(text.trim());
    } catch (e) {
      emit(ChatError('Failed to send message: $e'));
    }
  }

  Future<void> _generateAIResponse(String userMessage) async {
    try {
      // Prepare conversation history for API
      final history = _currentConversation!.messages
          .where((msg) => msg.isCompleted && msg.text.isNotEmpty)
          .map(
            (msg) => {
              'role': msg.isUser ? 'user' : 'assistant',
              'content': msg.text,
            },
          )
          .toList();

      // Get AI response
      // final aiResponse = await _openaiService.generateResponse(
      //   userMessage: userMessage,
      //   conversationHistory: history,
      //   language: _currentLanguage,
      // );

      // Update AI message
      final updatedMessages = _currentConversation!.messages.map((msg) {
        if (msg.id == _currentConversation!.messages.last.id) {
          return msg.copyWith(
            // text: aiResponse,
            isGenerating: false,
            isCompleted: true,
          );
        }
        return msg;
      }).toList();

      // Update conversation
      _currentConversation = _currentConversation!.copyWith(
        messages: updatedMessages,
        updatedAt: DateTime.now(),
      );

      // Save to Hive
      await _hiveService.updateConversation(_currentConversation!);

      // Emit state
      emit(
        ChatLoaded(
          messages: _currentConversation!.messages,
          isGenerating: false,
          currentConversationId: _currentConversation!.id,
        ),
      );
    } catch (e) {
      // Update AI message with error
      final updatedMessages = _currentConversation!.messages.map((msg) {
        if (msg.id == _currentConversation!.messages.last.id) {
          return msg.copyWith(
            text: 'Sorry, I encountered an error. Please try again.',
            isGenerating: false,
            isCompleted: true,
            errorMessage: e.toString(),
          );
        }
        return msg;
      }).toList();

      _currentConversation = _currentConversation!.copyWith(
        messages: updatedMessages,
        updatedAt: DateTime.now(),
      );

      await _hiveService.updateConversation(_currentConversation!);

      emit(
        ChatLoaded(
          messages: _currentConversation!.messages,
          isGenerating: false,
          currentConversationId: _currentConversation!.id,
        ),
      );
    }
  }

  void stopGenerating() async {
    if (_currentConversation != null &&
        _currentConversation!.messages.isNotEmpty &&
        _currentConversation!.messages.last.isGenerating) {
      final updatedMessages = _currentConversation!.messages.map((msg) {
        if (msg.id == _currentConversation!.messages.last.id) {
          return msg.copyWith(
            text: 'Response generation stopped.',
            isGenerating: false,
            isCompleted: true,
          );
        }
        return msg;
      }).toList();

      _currentConversation = _currentConversation!.copyWith(
        messages: updatedMessages,
        updatedAt: DateTime.now(),
      );

      await _hiveService.updateConversation(_currentConversation!);

      emit(
        ChatLoaded(
          messages: _currentConversation!.messages,
          isGenerating: false,
          currentConversationId: _currentConversation!.id,
        ),
      );
    }
  }

  void loadConversation(String conversationId) async {
    try {
      emit(const ChatLoading());

      final conversation = _hiveService.getConversation(conversationId);
      if (conversation != null) {
        _currentConversation = conversation;
        _currentLanguage = conversation.language ?? 'en';

        emit(
          ChatLoaded(
            messages: _currentConversation!.messages,
            isGenerating: false,
            currentConversationId: _currentConversation!.id,
          ),
        );
      } else {
        emit(const ChatError('Conversation not found'));
      }
    } catch (e) {
      emit(ChatError('Failed to load conversation: $e'));
    }
  }

  Future<void> startNewChat() async {
    try {
      // Mark current conversation as inactive if exists
      if (_currentConversation != null) {
        await _hiveService.markConversationInactive(_currentConversation!.id);
      }

      // Initialize new chat
      await initializeChat();
    } catch (e) {
      emit(ChatError('Failed to start new chat: $e'));
    }
  }

  void changeLanguage(String language) async {
    try {
      _currentLanguage = language;
      await _hiveService.setLanguage(language);

      // Update current conversation language if exists
      if (_currentConversation != null) {
        _currentConversation = _currentConversation!.copyWith(
          language: language,
          updatedAt: DateTime.now(),
        );
        await _hiveService.updateConversation(_currentConversation!);

        emit(
          ChatLoaded(
            messages: _currentConversation!.messages,
            isGenerating: false,
            currentConversationId: _currentConversation!.id,
          ),
        );
      }
    } catch (e) {
      emit(ChatError('Failed to change language: $e'));
    }
  }

  void clearChat() async {
    try {
      if (_currentConversation != null) {
        await _hiveService.deleteConversation(_currentConversation!.id);
        _currentConversation = null;
      }
      emit(const ChatInitial());
    } catch (e) {
      emit(ChatError('Failed to clear chat: $e'));
    }
  }

  String _getGreetingMessage(String language) {
    switch (language) {
      case 'ar':
        return 'مرحباً! كيف يمكنني مساعدتك اليوم؟';
      default:
        return 'Hello! How may I assist you today?';
    }
  }
}
