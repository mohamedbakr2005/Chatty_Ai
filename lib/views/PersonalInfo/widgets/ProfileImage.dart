import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60.w,
          backgroundImage: Image.asset(AppImages.userAvatar).image,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // Handle image upload/change
            },
            child: Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 3.w),
              ),
              child: const Icon(Icons.edit, color: AppColors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
