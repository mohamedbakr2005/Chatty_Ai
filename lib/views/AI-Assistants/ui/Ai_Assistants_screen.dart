import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiAssistantsScreen extends StatefulWidget {
  const AiAssistantsScreen({super.key});

  @override
  State<AiAssistantsScreen> createState() => _AiAssistantsScreenState();
}

class _AiAssistantsScreenState extends State<AiAssistantsScreen> {
  final List<String> _categories = [
    "All",
    "Writing",
    "Creative",
    "Business",
    "Social Media",
    "Developer",
    "Personal",
    "Others",
  ];
  String _selectedCategory = "All";

  final Map<String, List<Map<String, dynamic>>> _assistantsByCategory = {
    "Writing": [
      {
        "icon": Icons.edit_note,
        "iconColor": AppColors.primary,
        "title": "Write an Articles",
        "subtitle": "Generate well-written articles on any topic you want.",
        "bgColor": AppColors.primary.withOpacity(0.1),
      },
      {
        "icon": Icons.school_outlined,
        "iconColor": AppColors.primary,
        "title": "Academic Writer",
        "subtitle":
            "Generate educational writing such as essays, reports, etc.",
        "bgColor": AppColors.primary.withOpacity(0.1),
      },
    ],
    "Creative": [
      {
        "icon": Icons.mic_none,
        "iconColor": Colors.teal,
        "title": "Songs/Lyrics",
        "subtitle": "Generate lyrics to a song and music genre you want.",
        "bgColor": Colors.teal.withOpacity(0.1),
      },
      {
        "icon": Icons.book_outlined,
        "iconColor": Colors.cyan,
        "title": "Storyteller",
        "subtitle": "Generate stories from any given topic.",
        "bgColor": Colors.cyan.withOpacity(0.1),
      },
    ],
    "Business": [
      {
        "icon": Icons.mail_outline,
        "iconColor": Colors.brown,
        "title": "Email Writer",
        "subtitle": "Generate templates for emails, letters, etc.",
        "bgColor": Colors.brown.withOpacity(0.1),
      },
      {
        "icon": Icons.question_answer_outlined,
        "iconColor": Colors.blueGrey,
        "title": "Answer Interviewer",
        "subtitle": "Generate answers to interview questions.",
        "bgColor": Colors.blueGrey.withOpacity(0.1),
      },
    ],
    "Social Media": [
      {
        "icon": Icons.facebook,
        "iconColor": AppColors.primary,
        "title": "LinkedIn",
        "subtitle": "Create attention-grabbing posts on LinkedIn.",
        "bgColor": AppColors.primary.withOpacity(0.1),
      },
      {
        "icon": Icons.photo_camera_outlined,
        "iconColor": Colors.purple,
        "title": "Instagram",
        "subtitle": "Write captions that will get attention on Instagram.",
        "bgColor": Colors.purple.withOpacity(0.1),
      },
    ],
    "Developer": [
      {
        "icon": Icons.code,
        "iconColor": AppColors.primary,
        "title": "Write Code",
        "subtitle": "Write apps & websites in any programming language.",
        "bgColor": AppColors.primary.withOpacity(0.1),
      },
      {
        "icon": Icons.description_outlined,
        "iconColor": Colors.red,
        "title": "Explain Code",
        "subtitle": "Explain complicated programming code snippets.",
        "bgColor": Colors.red.withOpacity(0.1),
      },
    ],
    "Personal": [
      {
        "icon": Icons.cake_outlined,
        "iconColor": Colors.yellow.shade700,
        "title": "Birthday",
        "subtitle": "Generate creative birthday wishes for loved ones.",
        "bgColor": Colors.yellow.shade700.withOpacity(0.1),
      },
      {
        "icon": Icons.sentiment_satisfied_alt_outlined,
        "iconColor": Colors.orange,
        "title": "Apology",
        "subtitle": "Write an apology for the mistakes that have been made.",
        "bgColor": Colors.orange.withOpacity(0.1),
      },
    ],
    "Others": [
      {
        "icon": Icons.chat_bubble_outline,
        "iconColor": AppColors.textInputBackground,
        "title": "Create Conversation",
        "subtitle": "Create a conversation between two or more people.",
        "bgColor": AppColors.textInputBackground.withOpacity(0.1),
      },
      {
        "icon": Icons.sentiment_very_satisfied_outlined,
        "iconColor": AppColors.primary,
        "title": "Tell a Joke",
        "subtitle":
            "Write funny jokes to help you to relax and make them laugh.",
        "bgColor": AppColors.primary.withOpacity(0.1),
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "AI Assistants",
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
            preferredSize: Size.fromHeight(50.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: TabBar(
                dividerColor: AppColors.white,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                indicatorPadding: EdgeInsets.zero,
                indicator: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.textInputBackground,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                tabs: _categories.map((category) {
                  return Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.5.w,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(category),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: _categories.map((category) {
            final List<Map<String, dynamic>> assistants = (category == "All")
                ? _assistantsByCategory.values.expand((list) => list).toList()
                : _assistantsByCategory[category] ?? [];

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: _buildCategoryGrid(assistants),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Widget to build the grid for a specific category
  Widget _buildCategoryGrid(List<Map<String, dynamic>> assistants) {
    if (assistants.isEmpty) {
      return const Center(
        child: Text("No assistants found for this category."),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.8,
      ),
      itemCount: assistants.length,
      itemBuilder: (context, index) {
        final assistant = assistants[index];
        return _buildAssistantCard(
          icon: assistant['icon'] as IconData,
          iconColor: assistant['iconColor'] as Color,
          title: assistant['title'] as String,
          subtitle: assistant['subtitle'] as String,
          backgroundColor: assistant['bgColor'] as Color,
        );
      },
    );
  }

  // Widget to build a single AI assistant card
  Widget _buildAssistantCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 30.w),
          ),
          verticalSpace(10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textInputBackground,
            ),
          ),
          verticalSpace(5),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12.sp, color: AppColors.gray),
          ),
        ],
      ),
    );
  }
}
