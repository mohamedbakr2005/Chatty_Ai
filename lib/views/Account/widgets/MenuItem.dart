import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;
  const MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(icon, color: AppColors.gray, size: 24.w),
            horizontalSpace(15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textInputBackground,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText ?? '',
                style: TextStyle(fontSize: 14.sp, color: AppColors.gray),
              ),
            horizontalSpace(5),
            const Icon(Icons.chevron_right, color: AppColors.gray),
          ],
        ),
      ),
    );
  }
}
