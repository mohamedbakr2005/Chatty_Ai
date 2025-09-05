import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatty_ai/core/constants/api_config.dart';
import 'package:chatty_ai/core/models/chat_message.dart';
import 'package:chatty_ai/core/models/conversation.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  late Box<Conversation> _conversationsBox;
  late Box _settingsBox;
  bool _isInitialized = false;

  Future<void> initialize() async {
    try {
      if (_isInitialized) return;

      await Hive.initFlutter();

      // Register adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(ChatMessageAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(ConversationAdapter());
      }

      // Open boxes
      _conversationsBox = await Hive.openBox<Conversation>(
        ApiConfig.conversationsBoxName,
      );
      _settingsBox = await Hive.openBox(ApiConfig.settingsBoxName);

      _isInitialized = true;
      print('✅ Hive boxes opened successfully');
    } catch (e) {
      print('❌ Hive initialization failed: $e');
      rethrow;
    }
  }

  // Conversation operations
  Future<void> saveConversation(Conversation conversation) async {
    if (!_isInitialized) return;
    try {
      await _conversationsBox.put(conversation.id, conversation);
    } catch (e) {
      print('❌ Failed to save conversation: $e');
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    if (!_isInitialized) return;
    try {
      await _conversationsBox.delete(conversationId);
    } catch (e) {
      print('❌ Failed to delete conversation: $e');
    }
  }

  Future<void> updateConversation(Conversation conversation) async {
    if (!_isInitialized) return;
    try {
      await _conversationsBox.put(conversation.id, conversation);
    } catch (e) {
      print('❌ Failed to update conversation: $e');
    }
  }

  Conversation? getConversation(String conversationId) {
    if (!_isInitialized) return null;
    try {
      return _conversationsBox.get(conversationId);
    } catch (e) {
      print('❌ Failed to get conversation: $e');
      return null;
    }
  }

  List<Conversation> getAllConversations() {
    if (!_isInitialized) return [];
    try {
      return _conversationsBox.values.toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      print('❌ Failed to get all conversations: $e');
      return [];
    }
  }

  List<Conversation> getActiveConversations() {
    if (!_isInitialized) return [];
    try {
      return _conversationsBox.values.where((conv) => conv.isActive).toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      print('❌ Failed to get active conversations: $e');
      return [];
    }
  }

  Future<void> markConversationInactive(String conversationId) async {
    if (!_isInitialized) return;
    try {
      final conversation = _conversationsBox.get(conversationId);
      if (conversation != null) {
        final updatedConversation = conversation.copyWith(isActive: false);
        await _conversationsBox.put(conversationId, updatedConversation);
      }
    } catch (e) {
      print('❌ Failed to mark conversation inactive: $e');
    }
  }

  // Settings operations
  Future<void> setLanguage(String language) async {
    if (!_isInitialized) return;
    try {
      await _settingsBox.put('language', language);
    } catch (e) {
      print('❌ Failed to set language: $e');
    }
  }

  String getLanguage() {
    if (!_isInitialized) return 'en';
    try {
      return _settingsBox.get('language', defaultValue: 'en');
    } catch (e) {
      print('❌ Failed to get language: $e');
      return 'en';
    }
  }

  Future<void> setApiKey(String apiKey) async {
    if (!_isInitialized) return;
    try {
      await _settingsBox.put('api_key', apiKey);
    } catch (e) {
      print('❌ Failed to set API key: $e');
    }
  }

  String? getApiKey() {
    if (!_isInitialized) return null;
    try {
      return _settingsBox.get('api_key');
    } catch (e) {
      print('❌ Failed to get API key: $e');
      return null;
    }
  }

  // Utility methods
  String generateConversationId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String generateMessageId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  String generateConversationTitle(String firstMessage) {
    if (firstMessage.isEmpty) return 'New Chat';

    // Generate title from first message
    final words = firstMessage.split(' ');
    if (words.length <= 3) return firstMessage;

    return '${words.take(3).join(' ')}...';
  }

  // Cleanup
  Future<void> clearAllData() async {
    if (!_isInitialized) return;
    try {
      await _conversationsBox.clear();
      await _settingsBox.clear();
    } catch (e) {
      print('❌ Failed to clear all data: $e');
    }
  }

  Future<void> close() async {
    if (!_isInitialized) return;
    try {
      await _conversationsBox.close();
      await _settingsBox.close();
      _isInitialized = false;
    } catch (e) {
      print('❌ Failed to close Hive boxes: $e');
    }
  }

  // Statistics
  int getTotalConversations() {
    if (!_isInitialized) return 0;
    try {
      return _conversationsBox.length;
    } catch (e) {
      print('❌ Failed to get total conversations: $e');
      return 0;
    }
  }

  int getTotalMessages() {
    if (!_isInitialized) return 0;
    try {
      return _conversationsBox.values.fold(
        0,
        (sum, conv) => sum + conv.messages.length,
      );
    } catch (e) {
      print('❌ Failed to get total messages: $e');
      return 0;
    }
  }

  DateTime? getLastActivity() {
    if (!_isInitialized) return null;
    try {
      if (_conversationsBox.isEmpty) return null;

      final conversations = _conversationsBox.values.toList();
      conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return conversations.first.updatedAt;
    } catch (e) {
      print('❌ Failed to get last activity: $e');
      return null;
    }
  }

  bool get isInitialized => _isInitialized;
}
