import 'package:chatty_ai/core/constants/app_colors.dart';
import 'package:chatty_ai/core/constants/app_images.dart';
import 'package:chatty_ai/core/constants/app_spacing.dart';
import 'package:chatty_ai/views/PersonalInfo/widgets/ProfileImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// A placeholder for your custom text form field
class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget? suffixIcon;
  final bool isReadOnly;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.suffixIcon,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.gray),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.grayLight),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  // Controllers for the form fields
  final _fullNameController = TextEditingController(text: "Mohamed Ahmed");
  final _emailController = TextEditingController(
    text: "mohamed.ahm.bakr@gmail.com",
  );
  final _phoneController = TextEditingController(text: "+1 111 467 378 399");
  final _genderController = TextEditingController(text: "Male");
  final _dobController = TextEditingController(text: "12/27/1995");
  final _addressController = TextEditingController(
    text: "3517 W. Gray Street, New York",
  );
  final _countryController = TextEditingController(text: "United States");

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundLight,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Personal Info",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {
              // Handle edit functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [ProfileImage(), verticalSpace(30), _buildInfoForm()],
        ),
      ),
    );
  }

  // Widget to build the form section with all the fields
  Widget _buildInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name
        _buildSectionTitle("Full Name"),
        verticalSpace(5),
        AppTextFormField(controller: _fullNameController, labelText: ""),
        verticalSpace(15),

        // Email
        _buildSectionTitle("Email"),
        verticalSpace(5),
        AppTextFormField(
          controller: _emailController,
          labelText: "",
          isReadOnly: true,
        ),
        verticalSpace(15),

        // Phone Number
        _buildSectionTitle("Phone Number"),
        verticalSpace(5),
        Row(
          children: [
            // Country flag and dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.grayLight, width: 1.5.h),
                ),
              ),
              child: const Text("🇺🇸 ▼", style: TextStyle(fontSize: 16)),
            ),
            horizontalSpace(10),
            Expanded(
              child: AppTextFormField(
                controller: _phoneController,
                labelText: "",
                suffixIcon: const Icon(Icons.phone, color: AppColors.gray),
              ),
            ),
          ],
        ),
        verticalSpace(15),

        // Gender
        _buildSectionTitle("Gender"),
        verticalSpace(5),
        AppTextFormField(
          controller: _genderController,
          labelText: "",
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.gray,
          ),
          isReadOnly: true, // Typically read-only with a dropdown
        ),
        verticalSpace(15),

        // Date of Birth
        _buildSectionTitle("Date of Birth"),
        verticalSpace(5),
        AppTextFormField(
          controller: _dobController,
          labelText: "",
          suffixIcon: const Icon(Icons.calendar_month, color: AppColors.gray),
          isReadOnly: true,
        ),
        verticalSpace(15),

        // Street Address
        _buildSectionTitle("Street Address"),
        verticalSpace(5),
        AppTextFormField(controller: _addressController, labelText: ""),
        verticalSpace(15),

        // Country
        _buildSectionTitle("Country"),
        verticalSpace(5),
        AppTextFormField(
          controller: _countryController,
          labelText: "",
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.gray,
          ),
          isReadOnly: true,
        ),
      ],
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 14.sp, color: AppColors.gray),
    );
  }
}
