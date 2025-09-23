import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_images.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:chatty_ai/views/Account/widgets/LogoutButton.dart';
import 'package:chatty_ai/views/Account/widgets/MenuItem.dart';
import 'package:chatty_ai/views/Account/widgets/ProfileCard.dart';
import 'package:chatty_ai/views/Account/widgets/SectionTitle.dart';
import 'package:chatty_ai/views/Account/widgets/ToggleMenuItem.dart';
import 'package:chatty_ai/views/Account/widgets/UpgradeCard.dart';
import 'package:chatty_ai/views/PersonalInfo/ui/Personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Account",
          style: TextStyle(
            color: AppColors.textInputBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.all(12.0),
          child: Image.asset(AppImages.mainIcon, fit: BoxFit.contain),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileCard(),
            verticalSpace(20),

            UpgradeCard(),
            verticalSpace(30),

            SectionTitle("", title: "General"),
            verticalSpace(10),
            MenuItem(
              icon: Icons.person_outline,
              title: "Personal Info",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalInfoScreen(),
                  ),
                );
              },
            ),
            MenuItem(icon: Icons.security, title: "Security"),
            MenuItem(
              icon: Icons.language,
              title: "Language",
              trailingText: "English (US)",
            ),
            ToggleMenuItem(icon: Icons.dark_mode_outlined, title: "Dark Mode"),
            verticalSpace(30),

            // About Section
            SectionTitle("", title: "About"),
            verticalSpace(10),
            MenuItem(icon: Icons.help_outline, title: "Help Center"),
            MenuItem(icon: Icons.lock_outline, title: "Privacy Policy"),
            MenuItem(icon: Icons.info_outline, title: "About ChattyAI"),
            verticalSpace(20),

            // Logout Button
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}
