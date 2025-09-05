import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:chatty_ai/core/components/app_text_form_field.dart';
import 'package:chatty_ai/core/constants/app_images.dart';
import 'package:chatty_ai/core/models/chat_message.dart';
import 'package:chatty_ai/views/Home/cubit/chat_cubit.dart';
import 'package:chatty_ai/views/Home/cubit/chat_state.dart';

class StartChatScreen extends StatefulWidget {
  const StartChatScreen({Key? key}) : super(key: key);

  @override
  State<StartChatScreen> createState() => _StartChatScreenState();
}

class _StartChatScreenState extends State<StartChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _showChat = false;

  @override
  void initState() {
    super.initState();
    // Initialize chat when the screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().initializeChat();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back arrow and centered title
            _buildHeader(),

            // Main content area - either capabilities or chat
            Expanded(
              child: _showChat ? _buildChatInterface() : _buildMainContent(),
            ),

            // Bottom input bar
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Back arrow button
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.w),
          ),

          // Centered title
          Expanded(
            child: Text(
              'ChattyAI',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Empty space to balance the back button
          SizedBox(width: 48.w),
        ],
      ),
    );
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

  Widget _buildChatInterface() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoaded) {
          return _buildChatMessages(state.messages);
        } else if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.w, color: Colors.red),
                verticalSpace(16),
                Text(
                  'Error: ${state.message}',
                  style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
                verticalSpace(16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ChatCubit>().initializeChat();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('Initializing chat...'));
      },
    );
  }

  Widget _buildChatMessages(List<ChatMessage> messages) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Column(
          children: [
            _buildMessageBubble(message),
            if (index == messages.length - 1 && message.isGenerating)
              _buildStopGeneratingButton(),
            verticalSpace(16),
          ],
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.grayLight,
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 16.sp,
                color: isUser ? AppColors.white : AppColors.black,
              ),
            ),
            if (!isUser && message.isCompleted) ...[
              verticalSpace(8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Copy message
                      _copyMessage(message.text);
                    },
                    icon: Icon(Icons.copy, size: 16.w, color: AppColors.gray),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 24.w,
                      minHeight: 24.h,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Share message
                      _shareMessage(message.text);
                    },
                    icon: Icon(Icons.share, size: 16.w, color: AppColors.gray),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 24.w,
                      minHeight: 24.h,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStopGeneratingButton() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16.h),
        child: ElevatedButton(
          onPressed: () {
            context.read<ChatCubit>().stopGenerating();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.grayLight,
            foregroundColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.w),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              horizontalSpace(8),
              Text(
                'Stop generating...',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
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

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          // Input field
          Expanded(
            child: AppTextFormField(
              hintText: 'Ask me anything...',
              controller: _messageController,
              onChanged: (value) {
                // Switch to chat interface when user starts typing
                if (value.isNotEmpty && !_showChat) {
                  setState(() {
                    _showChat = true;
                  });
                }
              },
            ),
          ),

          horizontalSpace(12),

          // Send button
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24.w),
            ),
            child: IconButton(
              onPressed: () {
                _sendMessage();
              },
              icon: Icon(Icons.send, color: AppColors.white, size: 20.w),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Switch to chat interface if not already there
      if (!_showChat) {
        setState(() {
          _showChat = true;
        });
      }

      context.read<ChatCubit>().sendMessage(message);
      _messageController.clear();
    }
  }

  void _copyMessage(String text) {
    // TODO: Implement copy to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareMessage(String text) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share functionality coming soon'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
