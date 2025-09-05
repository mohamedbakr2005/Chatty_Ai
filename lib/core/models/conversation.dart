import 'package:hive/hive.dart';
import 'chat_message.dart';

part 'conversation.g.dart';

@HiveType(typeId: 1)
class Conversation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<ChatMessage> messages;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5)
  final bool isActive;

  @HiveField(6)
  final String? language;

  Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.language = 'en',
  });

  Conversation copyWith({
    String? id,
    String? title,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? language,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      language: language ?? this.language,
    );
  }

  String get previewText {
    if (messages.isEmpty) return 'No messages yet';

    // Get the last user message or AI message
    for (int i = messages.length - 1; i >= 0; i--) {
      final message = messages[i];
      if (message.text.isNotEmpty) {
        return message.text.length > 50
            ? '${message.text.substring(0, 50)}...'
            : message.text;
      }
    }
    return 'No messages yet';
  }

  int get messageCount => messages.length;

  bool get hasUnreadMessages =>
      messages.any((msg) => !msg.isUser && !msg.isCompleted);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'language': language,
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      messages: (json['messages'] as List)
          .map((msg) => ChatMessage.fromJson(msg))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isActive: json['isActive'] ?? true,
      language: json['language'] ?? 'en',
    );
  }

  @override
  String toString() {
    return 'Conversation(id: $id, title: $title, messageCount: $messageCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
