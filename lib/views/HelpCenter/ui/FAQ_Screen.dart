import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<String> _faqCategories = [
    "General",
    "Account",
    "Service",
    "Chatbot",
  ];
  String _selectedCategory = "General";

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          verticalSpace(10),
          _buildCategoryFilters(),
          verticalSpace(20),
          _buildSearchBar(),
          verticalSpace(20),
          _buildFAQList(),
        ],
      ),
    );
  }

  // Widget for the category filter chips
  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _faqCategories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Chip(
                label: Text(category),
                backgroundColor: isSelected
                    ? AppColors.primary
                    : AppColors.white,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.white
                      : AppColors.textInputBackground,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.grayLight,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Widget for the search bar
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: AppColors.gray),
          hintText: "Search",
          hintStyle: TextStyle(color: AppColors.gray),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 10.w,
          ),
        ),
      ),
    );
  }

  // Widget to build the list of expandable FAQ items
  Widget _buildFAQList() {
    return Column(
      children: [
        _buildFAQItem(
          "What is ChattyAI?",
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        ),
        _buildFAQItem(
          "Is the ChattyAI App free?",
          "Yes, the basic version of ChattyAI is free to use. You can upgrade to the PRO version for additional features and benefits.",
        ),
        _buildFAQItem(
          "How can I use ChattyAI?",
          "You can use ChattyAI to ask questions, generate text, and have conversational chats.",
        ),
        _buildFAQItem(
          "How can I log out from ChattyAI?",
          "You can log out from the Account screen by tapping on the 'Logout' button.",
        ),
        _buildFAQItem(
          "How to close ChattyAI account?",
          "Please contact our support team at support@chattyai.com to close your account.",
        ),
      ],
    );
  }

  // Widget for a single expandable FAQ item
  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textInputBackground,
          ),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              answer,
              style: TextStyle(fontSize: 14.sp, color: AppColors.gray),
            ),
          ),
        ],
      ),
    );
  }
}
