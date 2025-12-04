import 'package:choice_app/appAssets/app_assets.dart';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/res/res.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../customWidgets/common_app_bar.dart';
import '../../../l18n.dart';
import '../../../res/toasts.dart';
import '../../authentication/passwordManagement/password_provider.dart';
import '../../restaurant/profile/profile_provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: al.passwordManager),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * 0.05,
          vertical: getHeight() * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<PasswordProvider>(
              builder: (context, state, _) {
                return CustomField(
                  textEditingController: currentPasswordController,
                  borderColor: AppColors.greyBordersColor,
                  hint: al.currentPassword,
                  label: al.currentPassword,
                  obscure: true,
                  hidePassword: state.currentPassVisibility,
                  maxLines: 1,
                  clickIcon: () {
                    state.toggleCurrentPassVisibility();
                  },
                );
              },
            ),
            SizedBox(height: getHeight() * 0.02),
            Consumer<PasswordProvider>(
              builder: (context, state, _) {
                return CustomField(
                  textEditingController: newPasswordController,
                  borderColor: AppColors.greyBordersColor,
                  hint: al.newPasswordLabel,
                  label: al.newPasswordLabel,
                  obscure: true,
                  hidePassword: state.newPassVisibility,
                  maxLines: 1,
                  clickIcon: () {
                    state.toggleNewPassVisibility();
                  },
                );
              },
            ),
            SizedBox(height: getHeight() * 0.02),
            Consumer<PasswordProvider>(
              builder: (context, state, _) {
                return CustomField(
                  textEditingController: confirmPasswordController,
                  borderColor: AppColors.greyBordersColor,
                  hint: al.confirmPasswordLabel,
                  label: al.confirmPasswordLabel,
                  obscure: true,
                  hidePassword: state.confirmPassVisibility,
                  maxLines: 1,
                  clickIcon: () {
                    state.toggleConfirmPassVisibility();
                  },
                );
              },
            ),
          ],
        ),
      ),

      // Stick the buttons at bottom
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(getWidth() * 0.05),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                buttonText: al.cancel,
                onTap: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.transparent,
                textColor: AppColors.blackColor,
                borderColor: AppColors.blackColor,
              ),
            ),
            SizedBox(width: getWidth() * 0.04),
            Expanded(
              child: CustomButton(
                buttonText: al.saveChanges,

                  onTap: () async {
                    final currentPassword = currentPasswordController.text.trim();
                    final newPassword = newPasswordController.text.trim();
                    final confirmPassword = confirmPasswordController.text.trim();

                    final provider = context.read<ProfileProvider>();
                    provider.init(context);

                    // Validation 1: Current Password Empty
                    if (currentPassword.isEmpty) {
                      Toasts.getErrorToast(text: al.pleaseEnterCurrentPassword);
                      return;
                    }

                    // Validation 2: New Password Empty
                    if (newPassword.isEmpty) {
                      Toasts.getErrorToast(text: al.pleaseEnterNewPassword);
                      return;
                    }

                    if (!_isPasswordValid(newPassword)) {
                      Toasts.getErrorToast(
                          text: al.passwordMustInclude
                      );
                      return;
                    }

                    // Validation 3: Confirm Password Empty
                    if (confirmPassword.isEmpty) {
                      Toasts.getErrorToast(text: al.confirmPasswordEmpty);
                      return;
                    }

                    // Validation 4: Passwords don't match
                    if (newPassword != confirmPassword) {
                      Toasts.getErrorToast(text: al.passwordsDoNotMatch);
                      return;
                    }
                    // Validation 5: New password same as current password
                    if (newPassword == currentPassword) {
                      Toasts.getErrorToast(text: al.newPasswordSameAsCurrent);
                      return;
                    }
                    context.read<ProfileProvider>().updatePassword(
                      currentPassword: currentPassword,
                      newPassword: newPassword,
                      confirmPassword: confirmPassword,
                    );
                  },
                backgroundColor: AppColors.getPrimaryColorFromContext(context),
                textColor: AppColors.whiteColor,
                borderColor: AppColors.getPrimaryColorFromContext(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool _isPasswordValid(String password) {
    // At least 8 characters
    if (password.length < 8) return false;

    // Contains uppercase
    if (!password.contains(RegExp(r'[A-Z]'))) return false;

    // Contains lowercase
    if (!password.contains(RegExp(r'[a-z]'))) return false;

    // Contains number
    if (!password.contains(RegExp(r'[0-9]'))) return false;

    // Contains special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;

    return true;
  }
}


