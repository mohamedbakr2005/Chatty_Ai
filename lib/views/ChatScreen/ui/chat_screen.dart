import 'package:chatty_ai/core/components/app_text_form_field.dart';
import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:chatty_ai/core/models/conversation.dart';
import 'package:chatty_ai/views/ChatScreen/Cubit/chat_screen_cubit.dart';
import 'package:chatty_ai/views/ChatScreen/Cubit/chat_screen_state.dart';
import 'package:chatty_ai/views/ChatScreen/widgets/Chat_Main_Content%20.dart';
import 'package:chatty_ai/views/ChatScreen/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatelessWidget {
  final String? conversationId;

  const ChatScreen({super.key, this.conversationId});

  @override
  Widget build(BuildContext context) {
    final conversationBox = Hive.box<Conversation>('conversations');

    return BlocProvider(
      create: (_) => ChatCubit(conversationBox, conversationId: conversationId),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoaded) {
            final messages = state.conversation.messages;

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
                        Expanded(child: ChatMainContent()),
                        _buildInput(context),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.0.w,
                        vertical: 5.h,
                      ),
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
                          if (state.isGenerating)
                            ElevatedButton.icon(
                              onPressed: () =>
                                  context.read<ChatCubit>().stopGenerating(),
                              icon: const Icon(Icons.stop, color: Colors.white),
                              label: const Text("Stop generating..."),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                            ),
                          _buildInput(context),
                        ],
                      ),
                    ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    final controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10).r,
      child: Row(
        children: [
          Expanded(
            child: AppTextFormField(
              controller: controller,
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
              onPressed: () {
                context.read<ChatCubit>().sendMessage(controller.text);
                controller.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
