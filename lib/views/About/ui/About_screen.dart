import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_images.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutChattyAIScreen extends StatelessWidget {
  const AboutChattyAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "About ChattyAI",
          style: TextStyle(
            color: AppColors.textInputBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textInputBackground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            verticalSpace(30),
            // Placeholder for the logo. You can replace this with an Image.asset
            Image.asset(AppImages.mainIcon, width: 100.w, height: 100.h),
            verticalSpace(10),
            Text(
              "ChattyAI v0.1.0",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textInputBackground,
              ),
            ),
            verticalSpace(30),
            _buildMenuItem("Job Vacancy"),
            _buildMenuItem("Developer"),
            _buildMenuItem("Partner"),
            _buildMenuItem("Accessibility"),
            _buildMenuItem("Terms of Use"),
            _buildMenuItem("Feedback"),
            _buildMenuItem("Rate us"),
            _buildMenuItem("Visit Our Website"),
            _buildMenuItem("Follow us on Social Media"),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return GestureDetector(
      onTap: () {
        // Handle navigation or action for each item
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textInputBackground,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gray),
          ],
        ),
      ),
    );
  }
}
