import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:chatty_ai/core/models/conversation.dart';
import 'package:chatty_ai/core/services/hive_service.dart';
import 'package:chatty_ai/views/Home/cubit/chat_cubit.dart';

class HistoryScreen extends StatefulWidget {
  final VoidCallback? onStartNewChat;
  final Function(String)? onContinueConversation;

  const HistoryScreen({
    Key? key,
    this.onStartNewChat,
    this.onContinueConversation,
  }) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HiveService _hiveService = HiveService();
  List<Conversation> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() {
    setState(() {
      _conversations = _hiveService.getAllConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _conversations.isEmpty
                  ? _buildEmptyState()
                  : _buildConversationsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _startNewChat();
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.w),
          ),
          Expanded(
            child: Text(
              'Chat History',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80.w, color: AppColors.gray),
          verticalSpace(24),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          verticalSpace(16),
          Text(
            'Start your first chat to see it here',
            style: TextStyle(fontSize: 16.sp, color: AppColors.gray),
            textAlign: TextAlign.center,
          ),
          verticalSpace(32),
          ElevatedButton(
            onPressed: () {
              _startNewChat();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.w),
              ),
            ),
            child: Text(
              'Start New Chat',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsList() {
    return RefreshIndicator(
      onRefresh: () async {
        _loadConversations();
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final conversation = _conversations[index];
          return _buildConversationTile(conversation);
        },
      ),
    );
  }

  Widget _buildConversationTile(Conversation conversation) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        title: Text(
          conversation.title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(8),
            Text(
              conversation.previewText,
              style: TextStyle(fontSize: 14.sp, color: AppColors.gray),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            verticalSpace(8),
            Row(
              children: [
                Icon(Icons.message, size: 14.w, color: AppColors.gray),
                horizontalSpace(4),
                Text(
                  '${conversation.messageCount} messages',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.gray),
                ),
                horizontalSpace(16),
                Icon(Icons.access_time, size: 14.w, color: AppColors.gray),
                horizontalSpace(4),
                Text(
                  _formatDate(conversation.updatedAt),
                  style: TextStyle(fontSize: 12.sp, color: AppColors.gray),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: AppColors.gray),
          onSelected: (value) {
            _handleMenuAction(value, conversation);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'continue',
              child: Row(
                children: [
                  Icon(Icons.chat_bubble_outline),
                  SizedBox(width: 8),
                  Text('Continue'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          _continueConversation(conversation);
        },
      ),
    );
  }

  void _handleMenuAction(String action, Conversation conversation) {
    switch (action) {
      case 'continue':
        _continueConversation(conversation);
        break;
      case 'delete':
        _deleteConversation(conversation);
        break;
    }
  }

  void _continueConversation(Conversation conversation) {
    if (widget.onContinueConversation != null) {
      // Use callback if provided
      widget.onContinueConversation!(conversation.id);
    } else {
      // Try to access ChatCubit if available in context
      try {
        context.read<ChatCubit>().loadConversation(conversation.id);
      } catch (e) {
        // If ChatCubit is not available, just navigate back
        // The parent widget should handle the conversation loading
        print('ChatCubit not available: $e');
      }
    }
    Navigator.pop(context);
  }

  void _startNewChat() {
    if (widget.onStartNewChat != null) {
      // Use callback if provided
      widget.onStartNewChat!();
    } else {
      // Try to access ChatCubit if available in context
      try {
        context.read<ChatCubit>().startNewChat();
      } catch (e) {
        // If ChatCubit is not available, just navigate back
        // The parent widget should handle starting a new chat
        print('ChatCubit not available: $e');
      }
    }
    Navigator.pop(context);
  }

  void _deleteConversation(Conversation conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: Text(
          'Are you sure you want to delete "${conversation.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _hiveService.deleteConversation(conversation.id);
              Navigator.pop(context);
              _loadConversations();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
