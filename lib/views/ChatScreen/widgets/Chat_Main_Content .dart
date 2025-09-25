import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_images.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:chatty_ai/views/ChatScreen/widgets/capability_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMainContent extends StatelessWidget {
  const ChatMainContent({super.key});

  @override
  Widget build(BuildContext context) {
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
            const CapabilityBox(
              mainText: 'Answer all your questions.',
              subText: '(Just ask me anything you like!)',
            ),

            verticalSpace(16),

            const CapabilityBox(
              mainText: 'Generate all the text you want.',
              subText: '(essays, articles, reports, stories, & more)',
            ),

            verticalSpace(16),

            const CapabilityBox(
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
}
