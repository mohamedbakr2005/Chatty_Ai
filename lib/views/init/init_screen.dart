import 'package:chatty_ai/views/Account/ui/Account_screen.dart';
import 'package:chatty_ai/views/History/ui/history_screen.dart';
import 'package:chatty_ai/views/Home/ui/Home_Screen.dart';
import 'package:chatty_ai/views/init/cubit/bottom_nav_cubit.dart';
import 'package:chatty_ai/views/init/cubit/bottom_nav_state.dart';
import 'package:chatty_ai/views/init/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            body: _buildBody(state.currentIndex),
            bottomNavigationBar: const BottomNavBar(),
          );
        },
      ),
    );
  }

  Widget _buildBody(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const HomeScreen();
      case 2:
        return const HistoryScreen();
      case 3:
        return const AccountScreen();
      case 4:
        return const HomeScreen();
      default:
        return const HomeScreen();
    }
  }
}
