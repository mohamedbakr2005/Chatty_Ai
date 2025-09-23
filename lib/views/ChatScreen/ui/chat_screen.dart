import 'dart:async';
import 'dart:convert';
import 'package:chatty_ai/core/components/app_text_form_field.dart';
import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_images.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:chatty_ai/core/models/conversation.dart';
import 'package:chatty_ai/views/ChatScreen/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hive/hive.dart';

const OPENROUTER_API_KEY =
    "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";

class ChatScreen extends StatefulWidget {
  final String? conversationId; // لو جاي من History

  const ChatScreen({super.key, this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  StreamSubscription<dynamic>? _responseSubscription;
  final TextEditingController _controller = TextEditingController();
  late Box<Conversation> conversationBox;
  late Conversation conversation;
  bool _isGenerating = false;
  http.StreamedResponse? _currentResponse;

  @override
  void initState() {
    super.initState();
    conversationBox = Hive.box<Conversation>('conversations');

    if (widget.conversationId != null &&
        conversationBox.containsKey(widget.conversationId)) {
      conversation = conversationBox.get(widget.conversationId)!;
    } else {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      conversation = Conversation(id: newId, messages: []);
    }
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
        setState(() {
          conversation.title = title.replaceAll('"', '');
        });
        conversation.save();
      }
    } catch (e) {
      debugPrint("Error generating chat title: $e");
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    if (conversation.messages.isEmpty) {
      await conversationBox.put(conversation.id, conversation);
    }

    setState(() {
      conversation.messages.insert(0, Message(text: text, isUser: true));
      conversation.lastUpdated = DateTime.now();
    });
    conversation.save();

    _controller.clear();

    if (conversation.messages.length == 1) {
      _generateChatTitle();
    }
    setState(() {
      conversation.messages.insert(0, Message(text: "", isUser: false));
      _isGenerating = true;
    });
    conversation.save();

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
                  setState(() => _isGenerating = false);
                  return;
                }

                try {
                  final Map<String, dynamic> data = jsonDecode(jsonLine);
                  final delta = data["choices"]?[0]?["delta"]?["content"];

                  if (delta != null) {
                    setState(() {
                      final current =
                          conversation.messages[aiIndex].text + delta;
                      conversation.messages[aiIndex] = Message(
                        text: current,
                        isUser: false,
                      );
                    });
                    conversation.save();
                  }
                } catch (_) {}
              }
            },
            onDone: () {
              _responseSubscription?.cancel();
              setState(() {
                _isGenerating = false;
                conversation.lastUpdated = DateTime.now();
              });
              conversation.save();
            },
            onError: (_) {
              _responseSubscription?.cancel();
              setState(() {
                conversation.messages[aiIndex] = Message(
                  text: "⚠️ Error while streaming",
                  isUser: false,
                );
                _isGenerating = false;
                conversation.lastUpdated = DateTime.now();
              });
              conversation.save();
            },
          );
    } catch (e) {
      setState(() {
        conversation.messages[aiIndex] = Message(
          text: "⚠️ Error while streaming: $e",
          isUser: false,
        );
        _isGenerating = false;
      });
      conversation.save();
    }
  }

  void _stopGenerating() {
    _responseSubscription?.cancel();
    setState(() {
      _isGenerating = false;
      conversation.messages.insert(
        0,
        Message(text: "⚠️ Generation stopped.", isUser: false),
      );
    });
    conversation.save();
  }

  @override
  Widget build(BuildContext context) {
    final messages = conversation.messages;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundLight,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Chatty AI"),
        centerTitle: true,
      ),
      body: messages.isEmpty
          ? Column(
              children: [
                Expanded(child: _buildMainContent()),
                _buildInput(),
              ],
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 5.h),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return MessageBubble(
                          text: msg.text,
                          isUser: msg.isUser,
                        );
                      },
                    ),
                  ),
                  if (_isGenerating)
                    ElevatedButton.icon(
                      onPressed: _stopGenerating,
                      icon: const Icon(Icons.stop, color: Colors.white),
                      label: const Text("Stop generating..."),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  _buildInput(),
                ],
              ),
            ),
    );
  }

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10).r,
      child: Row(
        children: [
          Expanded(
            child: AppTextFormField(
              controller: _controller,
              hintText: "Ask me anything...",
            ),
          ),
          horizontalSpace(10),
          Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(100.w),
            ),
            child: IconButton(
              color: AppColors.white,
              icon: const Icon(Icons.send),
              onPressed: () => _sendMessage(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMainContent() {
  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large AI logo
          Image.asset(
            AppImages.mainIconGrey,
            width: 90.w,
            height: 90.h,
            fit: BoxFit.contain,
          ),

          verticalSpace(32),

          // Capabilities title
          Text(
            'Capabilities',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.gray,
            ),
          ),

          verticalSpace(24),

          // Capability boxes
          _buildCapabilityBox(
            mainText: 'Answer all your questions.',
            subText: '(Just ask me anything you like!)',
          ),

          verticalSpace(16),

          _buildCapabilityBox(
            mainText: 'Generate all the text you want.',
            subText: '(essays, articles, reports, stories, & more)',
          ),

          verticalSpace(16),

          _buildCapabilityBox(
            mainText: 'Conversational AI.',
            subText: '(I can talk to you like a natural human)',
          ),

          verticalSpace(24),

          // Concluding text
          Text(
            'These are just a few examples of what I can do.',
            style: TextStyle(fontSize: 16.sp, color: AppColors.gray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget _buildCapabilityBox({
  required String mainText,
  required String subText,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: AppColors.grayLight,
      borderRadius: BorderRadius.circular(12.w),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          mainText,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.grayLight2,
          ),
        ),
        verticalSpace(4),
        Text(
          subText,
          style: TextStyle(fontSize: 14.sp, color: AppColors.grayLight2),
        ),
      ],
    ),
  );
}
