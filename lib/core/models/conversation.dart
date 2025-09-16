import 'package:hive/hive.dart';

part 'conversation.g.dart';

@HiveType(typeId: 0)
class Conversation extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  List<Message> messages;

  @HiveField(2) 
  String? title;

  @HiveField(3) 
  DateTime? lastUpdated;
  Conversation({required this.id, required this.messages});
}

@HiveType(typeId: 1)
class Message {
  @HiveField(0)
  String text;

  @HiveField(1)
  bool isUser;

  Message({required this.text, required this.isUser});
}
