import 'package:chatty_ai/core/models/conversation.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Conversation> conversations;
  HistoryLoaded(this.conversations);
}

class HistoryEmpty extends HistoryState {}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}
