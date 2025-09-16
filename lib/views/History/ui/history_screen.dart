// HistoryScreen.dart
import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_images.dart';
import 'package:chatty_ai/core/models/conversation.dart';
import 'package:chatty_ai/views/ChatScreen/ui/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversationBox = Hive.box<Conversation>('conversations');

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundLight,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Image.asset(AppImages.mainIcon, width: 24.w, height: 24.h),
        ),
        title: Text(
          "History",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: () {}),
          SizedBox(width: 8.w),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: ValueListenableBuilder(
        valueListenable: conversationBox.listenable(),
        builder: (context, Box<Conversation> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No conversations yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final conversations = box.values.toList().reversed.toList();

          return ListView.builder(
            itemCount: conversations.length,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            itemBuilder: (context, index) {
              final convo = conversations[index];

              return Card(
                margin: EdgeInsets.only(bottom: 12.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.w),
                ),
                color: AppColors.grayLight,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  title: Text(
                    convo.title ?? "New Chat",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        convo.lastUpdated != null
                            ? '${_formatDate(convo.lastUpdated!)} - ${_formatTime(convo.lastUpdated!)}'
                            : '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18.w,
                    color: Colors.grey[600],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(conversationId: convo.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day} ${_getMonthAbbreviation(dateTime.month)} ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? 'AM' : 'PM'}';
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
