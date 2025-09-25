import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:chatty_ai/core/models/conversation.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final Box<Conversation> conversationBox;

  HistoryCubit(this.conversationBox) : super(HistoryInitial()) {
    loadConversations();
  }

  void loadConversations() {
    try {
      if (conversationBox.isEmpty) {
        emit(HistoryEmpty());
      } else {
        final conversations = conversationBox.values.toList().reversed.toList();
        emit(HistoryLoaded(conversations));
      }
    } catch (e) {
      emit(HistoryError("Failed to load conversations"));
    }
  }

  void deleteConversation(Conversation convo) {
    convo.delete();
    loadConversations();
  }

  void clearAllConversations() {
    conversationBox.clear();
    emit(HistoryEmpty());
  }
}
