import 'package:flutter/material.dart';
import 'package:chatty_ai/views/Home/widgets/build_Main_Content.dart';
import 'package:chatty_ai/views/Home/widgets/build_header.dart';
import 'package:chatty_ai/views/History/ui/history_screen.dart';
import 'package:chatty_ai/core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo and app name
            const BuildHeader(),
            // Main content area
            const Expanded(child: BuildMainContent()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showHistoryScreen(context);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.history, color: AppColors.white),
      ),
    );
  }

  void _showHistoryScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryScreen()),
    );
  }
}
