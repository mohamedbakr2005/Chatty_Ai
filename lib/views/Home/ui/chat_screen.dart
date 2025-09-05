import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:openai_dart/openai_dart.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

// حط الـ API Key بتاع OpenRouter هنا
const OPENROUTER_API_KEY =
    "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";

class _ChatScreenState extends State<ChatScreen> {
  final ChatUser _currentUser = ChatUser(
    id: '1',
    firstName: 'Mohamed',
    lastName: "Ahmed",
  );

  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: 'Chatty',
    lastName: "Ai",
  );

  List<ChatMessage> _messages = <ChatMessage>[];
  late final OpenAIClient _openRouter;

  @override
  void initState() {
    super.initState();
    _openRouter = OpenAIClient(
      apiKey: OPENROUTER_API_KEY,
      baseUrl: 'https://openrouter.ai/api/v1', // مهم!
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashChat(
        currentUser: _currentUser,
        messageOptions: MessageOptions(
          currentUserContainerColor: AppColors.primary,
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
    });

    final messagesHistory = _messages.reversed.map((msg) {
      if (msg.user.id == _currentUser.id) {
        return ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(msg.text),
        );
      } else {
        return ChatCompletionMessage.assistant(content: msg.text);
      }
    }).toList();

    messagesHistory.insert(
      0,
      ChatCompletionMessage.system(content: 'You are a helpful assistant.'),
    );

    try {
      final response = await _openRouter.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('openai/gpt-4o'),
          // ممكن تغيرها لـ 'anthropic/claude-3.5-sonnet' أو 'mistral/mixtral-8x7b-instruct'
          messages: messagesHistory,
          temperature: 0.7,
          maxTokens: 200,
        ),
      );

      if (response.choices.isNotEmpty) {
        final content = response.choices.first.message?.content?.trim();
        if (content != null && content.isNotEmpty) {
          setState(() {
            _messages.insert(
              0,
              ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text: content,
              ),
            );
          });
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
