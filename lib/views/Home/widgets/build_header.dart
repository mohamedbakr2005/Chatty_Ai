import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_images.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Back arrow button
          IconButton(
            onPressed: () {
              // TODO: Navigate back
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
}
