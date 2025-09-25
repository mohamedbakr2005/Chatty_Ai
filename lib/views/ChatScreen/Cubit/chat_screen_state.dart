import 'package:chatty_ai/core/models/conversation.dart';
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final Conversation conversation;
  final bool isGenerating;

  ChatLoaded({required this.conversation, required this.isGenerating});
}
