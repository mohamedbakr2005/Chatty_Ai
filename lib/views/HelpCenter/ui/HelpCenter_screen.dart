import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/views/HelpCenter/ui/Contact_US_screen.dart';
import 'package:chatty_ai/views/HelpCenter/ui/FAQ_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Help Center",
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.h),
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TabBar(
                indicatorColor: AppColors.primary,
                indicatorWeight: 3.w,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.gray,
                labelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: "FAQ"),
                  Tab(text: "Contact us"),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(children: [FAQScreen(), ContactUsScreen()]),
      ),
    );
  }
}
