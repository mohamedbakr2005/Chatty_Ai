import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatty_ai/views/Home/cubit/home_cubit.dart';
import 'package:chatty_ai/views/Home/cubit/home_state.dart';
import 'package:chatty_ai/views/Home/cubit/chat_cubit.dart';
import 'package:chatty_ai/views/Home/widgets/build_Main_Content.dart';
import 'package:chatty_ai/views/Home/widgets/build_header.dart';
import 'package:chatty_ai/views/Home/widgets/Start_chat_screen.dart';
import 'package:chatty_ai/views/Home/widgets/history_screen.dart';
import 'package:chatty_ai/core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeCubit()..showWelcome()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeWelcome) {
            return _buildWelcomeScreen(context);
          } else if (state is HomeChat) {
            return const StartChatScreen();
          } else if (state is HomeLoading) {
            return _buildLoadingScreen();
          } else if (state is HomeError) {
            return _buildErrorScreen(context, state.message);
          } else {
            return _buildWelcomeScreen(context);
          }
        },
      ),
    );
  }

  Widget _buildWelcomeScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo and app name
            const BuildHeader(),
            // Main content area
            Expanded(child: BuildMainContent()),
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

  Widget _buildLoadingScreen() {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget _buildErrorScreen(BuildContext context, String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $message', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<HomeCubit>().reset();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistoryScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
          onStartNewChat: () {
            // Navigate back and trigger chat state
            Navigator.pop(context);
            context.read<HomeCubit>().showChat();
          },
          onContinueConversation: (conversationId) {
            // Navigate back and load the conversation
            Navigator.pop(context);
            context.read<HomeCubit>().showChat();
            // The StartChatScreen will handle loading the conversation
            // We can pass the conversation ID through the state if needed
          },
        ),
      ),
    );
  }
}
