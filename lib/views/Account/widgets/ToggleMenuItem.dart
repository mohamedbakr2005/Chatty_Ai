import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToggleMenuItem extends StatefulWidget {
  final IconData icon;
  final String title;

  ToggleMenuItem({Key? key, required this.icon, required this.title})
    : super(key: key);

  @override
  State<ToggleMenuItem> createState() => _ToggleMenuItemState();
}

class _ToggleMenuItemState extends State<ToggleMenuItem> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(widget.icon, color: AppColors.gray, size: 24.w),
          horizontalSpace(15),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textInputBackground,
              ),
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
