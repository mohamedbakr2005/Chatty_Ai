import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          _buildContactItem(
            icon: Icons.headphones_outlined,
            title: "Contact us",
          ),
          _buildContactItem(
            icon: Icons.call, // Placeholder for WhatsApp icon
            title: "WhatsApp",
          ),
          _buildContactItem(
            icon: Icons.photo_camera_outlined, // Placeholder for Instagram icon
            title: "Instagram",
          ),
          _buildContactItem(icon: Icons.facebook, title: "Facebook"),
          _buildContactItem(
            icon: Icons.message_outlined, // Placeholder for Twitter icon
            title: "Twitter",
          ),
          _buildContactItem(icon: Icons.public, title: "Website"),
        ],
      ),
    );
  }

  // Widget to build a single contact item
  Widget _buildContactItem({required IconData icon, required String title}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grayLight, width: 1.w),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24.w),
            horizontalSpace(15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textInputBackground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
