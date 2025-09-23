import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  // State variables for the switches
  bool _rememberMe = true;
  bool _biometricId = false;
  bool _faceId = false;
  bool _smsAuthenticator = false;
  bool _googleAuthenticator = false;

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
          "Security",
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
          children: [
            // Remember me
            _buildToggleItem(
              title: "Remember me",
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
            _buildDivider(),

            // Biometric ID
            _buildToggleItem(
              title: "Biometric ID",
              value: _biometricId,
              onChanged: (value) {
                setState(() {
                  _biometricId = value;
                });
              },
            ),
            _buildDivider(),

            // Face ID
            _buildToggleItem(
              title: "Face ID",
              value: _faceId,
              onChanged: (value) {
                setState(() {
                  _faceId = value;
                });
              },
            ),
            _buildDivider(),

            // SMS Authenticator
            _buildToggleItem(
              title: "SMS Authenticator",
              value: _smsAuthenticator,
              onChanged: (value) {
                setState(() {
                  _smsAuthenticator = value;
                });
              },
            ),
            _buildDivider(),

            // Google Authenticator
            _buildToggleItem(
              title: "Google Authenticator",
              value: _googleAuthenticator,
              onChanged: (value) {
                setState(() {
                  _googleAuthenticator = value;
                });
              },
            ),
            _buildDivider(),

            // Device Management
            _buildNavigationItem(
              title: "Device Management",
              onTap: () {
                // Handle navigation to Device Management screen
              },
            ),

            verticalSpace(30),

            // Change Password Button
            _buildChangePasswordButton(),
          ],
        ),
      ),
    );
  }

  // Widget to create a settings item with a toggle switch
  Widget _buildToggleItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textInputBackground,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // Widget to create a settings item with a right arrow icon
  Widget _buildNavigationItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textInputBackground,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gray),
          ],
        ),
      ),
    );
  }

  // Widget to create a thin, gray divider
  Widget _buildDivider() {
    return Container(height: 1.h, color: AppColors.grayLight);
  }

  // Widget for the "Change Password" button
  Widget _buildChangePasswordButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle change password logic
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.primary,
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.w),
        ),
        elevation: 1,
      ),
      child: const Text(
        "Change Password",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
