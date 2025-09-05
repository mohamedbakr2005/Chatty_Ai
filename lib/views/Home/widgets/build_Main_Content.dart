import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_images.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:chatty_ai/core/components/app_button.dart';
import 'package:chatty_ai/views/Home/cubit/home_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildMainContent extends StatelessWidget {
  const BuildMainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large logo
          Image.asset(AppImages.mainIcon, width: 120.w, height: 120.h),

          verticalSpace(32),

          // Welcome text
          Text(
            'Welcome to',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ChattyAI',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              horizontalSpace(8),
              Text('👋', style: TextStyle(fontSize: 28.sp)),
            ],
          ),

          verticalSpace(24),

          // Instructional text
          Text(
            'Start chatting with ChattyAI now.',
            style: TextStyle(fontSize: 16.sp, color: AppColors.gray),
          ),

          verticalSpace(8),

          Text(
            'You can ask me anything.',
            style: TextStyle(fontSize: 16.sp, color: AppColors.gray),
          ),

          verticalSpace(48),

          // Start Chat button
          AppButton(
            onPressed: () {
              context.read<HomeCubit>().showChat();
            },
            text: 'Start Chat',
            backgroundColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
