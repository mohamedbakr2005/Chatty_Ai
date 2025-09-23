import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = "English (US)";

  final List<String> _suggestedLanguages = ["English (US)", "English (UK)"];

  final List<String> _otherLanguages = [
    "Mandarin",
    "Spanish",
    "French",
    "Arabic",
    "Bengali",
    "Russian",
    "Japanese",
    "Korean",
    "Indonesian",
  ];

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
          "Language",
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Suggested"),
            verticalSpace(10),
            ..._buildLanguageList(_suggestedLanguages),
            verticalSpace(20),

            _buildSectionTitle("Language"),
            verticalSpace(10),
            ..._buildLanguageList(_otherLanguages),
          ],
        ),
      ),
    );
  }

  // A helper function to build the list of language items
  List<Widget> _buildLanguageList(List<String> languages) {
    List<Widget> listItems = [];
    for (int i = 0; i < languages.length; i++) {
      listItems.add(_buildLanguageItem(languages[i]));
      // Add a divider after each item except the last one
      if (i < languages.length - 1) {
        listItems.add(
          Divider(
            color: AppColors.grayLight,
            height: 1.h,
            thickness: 1.w,
            indent: 10.w,
            endIndent: 10.w,
          ),
        );
      }
    }
    return listItems;
  }

  // Widget to create a single selectable language item
  Widget _buildLanguageItem(String language) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textInputBackground,
              ),
            ),
            if (_selectedLanguage == language)
              const Icon(Icons.check, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.gray,
      ),
    );
  }
}
