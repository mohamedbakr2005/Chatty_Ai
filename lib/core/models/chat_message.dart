import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final bool isUser;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final bool isGenerating;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final String? errorMessage;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isGenerating = false,
    this.isCompleted = true,
    this.errorMessage,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    bool? isGenerating,
    bool? isCompleted,
    String? errorMessage,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isGenerating: isGenerating ?? this.isGenerating,
      isCompleted: isCompleted ?? this.isCompleted,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'isGenerating': isGenerating,
      'isCompleted': isCompleted,
      'errorMessage': errorMessage,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      text: json['text'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      isGenerating: json['isGenerating'] ?? false,
      isCompleted: json['isCompleted'] ?? true,
      errorMessage: json['errorMessage'],
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, text: $text, isUser: $isUser, timestamp: $timestamp, isGenerating: $isGenerating, isCompleted: $isCompleted)';
  }
}
