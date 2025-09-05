import 'package:chatty_ai/core/models/chat_message.dart';

abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool isGenerating;
  final String? currentConversationId;

  const ChatLoaded({
    required this.messages,
    this.isGenerating = false,
    this.currentConversationId,
  });

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isGenerating,
    String? currentConversationId,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isGenerating: isGenerating ?? this.isGenerating,
      currentConversationId:
          currentConversationId ?? this.currentConversationId,
    );
  }
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);
}
