import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/authentication/otpVerification/otp_verification.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../appAssets/app_assets.dart';
import 'package:choice_app/l18n.dart';
import '../../../routes/routes.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
                if (context.canPop()) ...[
                  CustomBackButton(),
                  SizedBox(width: getWidth() * .02),
                ],
                CustomText(
                  text: al.forgotPassword,
                  fontSize: sizes?.fontSize28,
                  fontFamily: Assets.onsetSemiBold,
                ),
              ],
            ),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.forgotPasswordInstruction,
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              giveLinesAsText: true,
            ),
            SizedBox(height: getHeight() * .01),
            CustomField(
              controller: _emailController,
              borderColor: AppColors.greyBordersColor,
              hint: al.emailPlaceholder,
              label: al.emailLabel,
            ),

            SizedBox(height: getHeight() * .04),
            CustomButton(
              buttonText: al.sendOtpButton,
              onTap: () {

                context.push(Routes.otpVerificationRoute, extra: {
                  "isResetPassFlow":true
                });
              },
            ),
            SizedBox(height: getHeight() * .02),
          ],
        ),
      ),
    );
  }
}
