import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/authentication/login.dart';
import 'package:choice_app/screens/authentication/passwordManagement/password_provider.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import 'package:choice_app/l18n.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: getHeight() * .1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (Navigator.of(context).canPop()) ...[
                  CustomBackButton(),
                  SizedBox(width: getWidth() * .02),
                ],
                CustomText(
                  text: al.resetPasswordTitle,
                  fontSize: sizes?.fontSize28,
                  fontFamily: Assets.onsetSemiBold,
                ),
              ],
            ),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.resetPasswordNote,
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              giveLinesAsText: true,
            ),
            SizedBox(height: getHeight() * .03),
            Consumer<PasswordProvider>(
              builder: (context, state, child) {
                return CustomField(
                  controller: _passwordController,
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
            SizedBox(height: getHeight() * .02),
            Consumer<PasswordProvider>(
              builder: (context, state, child) {
                return CustomField(
                  controller: _confirmPasswordController,
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

            SizedBox(height: getHeight() * .04),
            CustomButton(
              buttonText: al.verifyButton,
              onTap: () {
                // while (context.canPop()) {
                   Navigator.pop(context);
                // }
                // context.pushReplacement(Routes.loginRoute);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Login()),
                  (_) => false,
                );
              },
            ),
            SizedBox(height: getHeight() * .02),
          ],
        ),
      ),
    );
  }
}
