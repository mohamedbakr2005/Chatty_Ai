// HistoryScreen.dart
import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_images.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:chatty_ai/core/models/conversation.dart';
import 'package:chatty_ai/views/ChatScreen/ui/chat_screen.dart';
import 'package:chatty_ai/views/Search/ui/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversationBox = Hive.box<Conversation>('conversations');
    void _showClearHistoryDialog(BuildContext context, Box<Conversation> box) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Clear All History?"),
          content: const Text(
            "Are you sure you want to delete all conversations? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // إغلاق الـ dialog
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                box.clear(); // حذف كل المحادثات
                Navigator.of(context).pop(); // إغلاق الـ dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All conversations deleted!")),
                );
              },
              child: const Text(
                "Clear All",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
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
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _showClearHistoryDialog(context, conversationBox);
            },
          ),
          SizedBox(width: 8.w),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: ValueListenableBuilder(
        valueListenable: conversationBox.listenable(),
        builder: (context, Box<Conversation> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(AppImages.empty),
                    width: 200.w,
                    height: 200.h,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Empty History",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  verticalSpace(10),
                  Text(
                    "You Have No Chats Yet",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final conversations = box.values.toList().reversed.toList();

          return ListView.builder(
            itemCount: conversations.length,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            itemBuilder: (context, index) {
              final convo = conversations[index];

              return Dismissible(
                key: Key(convo.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.w),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  convo.delete();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Chat deleted")));
                },
                child: Card(
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
