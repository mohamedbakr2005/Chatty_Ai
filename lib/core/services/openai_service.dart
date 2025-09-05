import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chatty_ai/core/constants/api_config.dart';

class OpenAIService {
  static final OpenAIService _instance = OpenAIService._internal();
  factory OpenAIService() => _instance;
  OpenAIService._internal();

  final http.Client _client = http.Client();

  Future<String> generateResponse({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
    String? language = 'en',
  }) async {
    try {
      // Check if API key is configured
      if (ApiConfig.openaiApiKey == 'your_openai_api_key_here') {
        // Return dummy response for testing
        return _generateDummyResponse(userMessage, language);
      }

      final messages = [
        {'role': 'system', 'content': _getSystemPrompt(language)},
        ...conversationHistory.map(
          (msg) => {
            'role': msg['role'] ?? 'user',
            'content': msg['content'] ?? '',
          },
        ),
        {'role': 'user', 'content': userMessage},
      ];

      final response = await _client
          .post(
            Uri.parse(
              '${ApiConfig.openaiBaseUrl}${ApiConfig.chatCompletionsEndpoint}',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${ApiConfig.openaiApiKey}',
            },
            body: jsonEncode({
              'model': ApiConfig.openaiModel,
              'messages': messages,
              'max_tokens': 1000,
              'temperature': 0.7,
            }),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ??
            'No response generated';
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Return dummy response on error
      return _generateDummyResponse(userMessage, language);
    }
  }

  String _getSystemPrompt(String? language) {
    switch (language) {
      case 'ar':
        return '''أنت مساعد ذكي ومفيد. يمكنك مساعدة المستخدمين في مجموعة متنوعة من المهام.
        - الإجابة على الأسئلة
        - كتابة النصوص والمقالات
        - حل المشاكل
        - المساعدة في الكتابة والترجمة
        تحدث باللغة العربية وكن مفيداً ومهذباً.''';
      default:
        return '''You are a helpful and intelligent AI assistant. You can help users with various tasks:
        - Answer questions
        - Write texts and articles
        - Solve problems
        - Help with writing and translation
        Be helpful, polite, and concise in your responses.''';
    }
  }

  String _generateDummyResponse(String userMessage, String? language) {
    final message = userMessage.toLowerCase();

    if (language == 'ar') {
      if (message.contains('مرحبا') || message.contains('السلام عليكم')) {
        return 'مرحباً! كيف يمكنني مساعدتك اليوم؟';
      } else if (message.contains('ماذا تستطيع') ||
          message.contains('قدراتك')) {
        return '''مرحباً! أنا مساعد ذكي يمكنني مساعدتك في:
        • الإجابة على الأسئلة: اسألني أي شيء تريده!
        • كتابة النصوص: مقالات، تقارير، قصص، والمزيد
        • الذكاء الاصطناعي المحادث: يمكنني التحدث معك كإنسان طبيعي
        • حل المشاكل: مساعدة في المهام التحليلية والإبداعية
        • المساعدة اللغوية: قواعد اللغة، الكتابة، والترجمة''';
      } else if (message.contains('شكرا') || message.contains('شكراً')) {
        return 'العفو! يسعدني أن أكون مفيداً لك. هل هناك شيء آخر تريد مساعدة فيه؟';
      } else {
        return 'أفهم أنك قلت: "$userMessage". كيف يمكنني مساعدتك في ذلك؟';
      }
    } else {
      if (message.contains('hello') || message.contains('hi')) {
        return 'Hello! How can I help you today?';
      } else if (message.contains('what you can do') ||
          message.contains('capabilities')) {
        return '''Of course! As an AI language model, I am designed to assist with a variety of tasks. Here are some examples of what I can do:

• Answer questions: Just ask me anything you like!
• Generate text: I can write essays, articles, reports, stories, and more
• Conversational AI: I can talk to you like a natural human
• Problem solving: Help with various analytical and creative tasks
• Language assistance: Grammar, writing, and translation help''';
      } else if (message.contains('thank')) {
        return "You're welcome! I'm glad I could help. Is there anything else you'd like assistance with?";
      } else {
        return 'I understand you said: "$userMessage". How can I help you with that?';
      }
    }
  }

  void dispose() {
    _client.close();
  }
}
