import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageBubble({super.key, required this.text, required this.isUser});

  void _copyText() {
    Clipboard.setData(ClipboardData(text: text));
  }

  void _shareText() {
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.grayLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isUser ? AppColors.white : AppColors.black,
              ),
            ),

            if (!isUser) SizedBox(height: 8.h),

            if (!isUser)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _copyText,
                    child: Icon(Icons.copy, size: 20.w, color: AppColors.gray),
                  ),
                  SizedBox(width: 10.w),

                  GestureDetector(
                    onTap: _shareText,
                    child: Icon(Icons.share, size: 20.w, color: AppColors.gray),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
