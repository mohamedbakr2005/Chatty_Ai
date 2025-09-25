import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:chatty_ai/core/models/conversation.dart';
import 'package:chatty_ai/views/ChatScreen/Cubit/chat_screen_state.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

const OPENROUTER_API_KEY =
    "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";

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this.conversationBox, {String? conversationId})
    : super(ChatInitial()) {
    if (conversationId != null && conversationBox.containsKey(conversationId)) {
      conversation = conversationBox.get(conversationId)!;
    } else {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      conversation = Conversation(id: newId, messages: []);
    }
    emit(ChatLoaded(conversation: conversation, isGenerating: false));
  }

  final Box<Conversation> conversationBox;
  late Conversation conversation;
  StreamSubscription<dynamic>? _responseSubscription;
  http.StreamedResponse? _currentResponse;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    if (conversation.messages.isEmpty) {
      await conversationBox.put(conversation.id, conversation);
    }

    conversation.messages.insert(0, Message(text: text, isUser: true));
    conversation.lastUpdated = DateTime.now();
    conversation.save();

    if (conversation.messages.length == 1) {
      _generateChatTitle();
    }

    // AI Placeholder
    conversation.messages.insert(0, Message(text: "", isUser: false));
    emit(ChatLoaded(conversation: conversation, isGenerating: true));

    final aiIndex = 0;

    try {
      final request =
          http.Request(
              "POST",
              Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
            )
            ..headers.addAll({
              "Authorization": "Bearer $OPENROUTER_API_KEY",
              "Content-Type": "application/json",
            })
            ..body = jsonEncode({
              "model": "openai/gpt-4o-mini",
              "messages": [
                {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": text},
              ],
              "stream": true,
            });

      final response = await request.send();
      _currentResponse = response;

      _responseSubscription = response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) {
              if (line.startsWith("data: ")) {
                final jsonLine = line.substring(6).trim();

                if (jsonLine == "[DONE]") {
                  emit(
                    ChatLoaded(conversation: conversation, isGenerating: false),
                  );
                  return;
                }

                try {
                  final Map<String, dynamic> data = jsonDecode(jsonLine);
                  final delta = data["choices"]?[0]?["delta"]?["content"];

                  if (delta != null) {
                    final current = conversation.messages[aiIndex].text + delta;
                    conversation.messages[aiIndex] = Message(
                      text: current,
                      isUser: false,
                    );
                    conversation.save();
                    emit(
                      ChatLoaded(
                        conversation: conversation,
                        isGenerating: true,
                      ),
                    );
                  }
                } catch (_) {}
              }
            },
            onDone: () {
              _responseSubscription?.cancel();
              conversation.lastUpdated = DateTime.now();
              conversation.save();
              emit(ChatLoaded(conversation: conversation, isGenerating: false));
            },
            onError: (_) {
              _responseSubscription?.cancel();
              conversation.messages[aiIndex] = Message(
                text: "⚠️ Error while streaming",
                isUser: false,
              );
              conversation.lastUpdated = DateTime.now();
              conversation.save();
              emit(ChatLoaded(conversation: conversation, isGenerating: false));
            },
          );
    } catch (e) {
      conversation.messages[aiIndex] = Message(
        text: "⚠️ Error while streaming: $e",
        isUser: false,
      );
      emit(ChatLoaded(conversation: conversation, isGenerating: false));
      conversation.save();
    }
  }

  void stopGenerating() {
    _responseSubscription?.cancel();
    conversation.messages.insert(
      0,
      Message(text: "⚠️ Generation stopped.", isUser: false),
    );
    conversation.save();
    emit(ChatLoaded(conversation: conversation, isGenerating: false));
  }

  Future<void> _generateChatTitle() async {
    final firstMessage = conversation.messages.first.text;

    final request =
        http.Request(
            "POST",
            Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
          )
          ..headers.addAll({
            "Authorization": "Bearer $OPENROUTER_API_KEY",
            "Content-Type": "application/json",
          })
          ..body = jsonEncode({
            "model": "openai/gpt-4o-mini",
            "messages": [
              {
                "role": "system",
                "content":
                    "You are a helpful assistant that provides very short, one-sentence titles for chat conversations based on the user's first message.",
              },
              {
                "role": "user",
                "content":
                    "Please provide a short title for the following chat conversation: $firstMessage",
              },
            ],
          });

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> data = jsonDecode(responseBody);
      final title = data["choices"]?[0]?["message"]?["content"];

      if (title != null) {
        conversation.title = title.replaceAll('"', '');
        conversation.save();
        emit(ChatLoaded(conversation: conversation, isGenerating: false));
      }
    } catch (e) {
      debugPrint("Error generating chat title: $e");
    }
  }
}
