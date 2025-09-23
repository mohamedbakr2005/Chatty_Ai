import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          "Privacy Policy",
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "At ChattyAI, we respect and protect the privacy of our users. This Privacy Policy outlines the types of personal information we collect, how we use it, and how we protect your information.",
              style: TextStyle(fontSize: 16.sp, color: AppColors.gray),
            ),
            verticalSpace(20),
            _buildSectionTitle("Information We Collect"),
            verticalSpace(10),
            _buildParagraph(
              "When you use our app, we may collect the following types of personal information:",
            ),
            _buildListItem(
              "Device Information: We may collect information about the type of device you use, its operating system, and other technical details to help us improve our app.",
            ),
            _buildListItem(
              "Usage Information: We may collect information about how you use our app, such as which features you use and how often you use them.",
            ),
            _buildListItem(
              "Personal Information: We may collect personal information, such as your name, email address, or phone number, if you choose to provide it to us.",
            ),
            verticalSpace(20),
            _buildSectionTitle("How We Use Your Information"),
            verticalSpace(10),
            _buildParagraph(
              "We use your information for the following purposes:",
            ),
            _buildListItem(
              "To provide and improve our app: We use your information to operate and maintain our app, and to develop new features and services.",
            ),
            _buildListItem(
              "To communicate with you: We may use your information to send you updates, newsletters, and marketing materials. You can opt out of these communications at any time.",
            ),
            _buildListItem(
              "To protect our rights: We may use your information to enforce our terms of service, and to protect our rights, property, or safety.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textInputBackground,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16.sp, color: AppColors.gray),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, bottom: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(fontSize: 16.sp, color: AppColors.gray),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16.sp, color: AppColors.gray),
            ),
          ),
        ],
      ),
    );
  }
}
