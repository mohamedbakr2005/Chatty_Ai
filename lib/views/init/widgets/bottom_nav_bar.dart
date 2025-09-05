import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/views/init/cubit/bottom_nav_cubit.dart';
import 'package:chatty_ai/views/init/cubit/bottom_nav_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(
                    context,
                    index: 0,
                    icon: Icons.chat,
                    activeIcon: Icons.chat,
                    label: 'Home',
                    isActive: state.currentIndex == 0,
                  ),
                  _buildNavItem(
                    context,
                    index: 1,
                    icon: Icons.grid_view,
                    activeIcon: Icons.grid_view,
                    label: 'Search',
                    isActive: state.currentIndex == 1,
                  ),
                  _buildNavItem(
                    context,
                    index: 2,
                    icon: Icons.history,
                    activeIcon: Icons.history,
                    label: 'Saved',
                    isActive: state.currentIndex == 2,
                  ),
                  _buildNavItem(
                    context,
                    index: 3,
                    icon: Icons.person_outline,
                    activeIcon: Icons.person_outline,
                    label: 'Cart',
                    isActive: state.currentIndex == 3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => context.read<BottomNavCubit>().changeTab(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            size: 24.sp,
            color: isActive ? AppColors.primary : AppColors.gray,
          ),

          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isActive ? AppColors.primary : AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}
