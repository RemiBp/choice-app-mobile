import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/auth_provider.dart';
import 'package:choice_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../l18n.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.producerForgotPassword(email: email);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      context.read<AuthProvider>().setPendingEmail(email, forgotFlow: true);
      context.push(Routes.otpVerificationRoute, extra: {'isResetPassFlow': true});
    } else {
      setState(() => _errorMessage = result.message ?? 'Failed to send OTP.');
    }
  }

  @override
  Widget build(BuildContext context) {
    AppTranslations.init(context);
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
              textEditingController: _emailController,
              borderColor: AppColors.greyBordersColor,
              hint: al.emailPlaceholder,
              label: al.emailLabel,
              textInputType: TextInputType.emailAddress,
            ),
            if (_errorMessage != null) ...[
              SizedBox(height: getHeight() * .01),
              Text(
                _errorMessage!,
                style: TextStyle(
                    color: Colors.red, fontSize: sizes?.fontSize12),
              ),
            ],
            SizedBox(height: getHeight() * .04),
            CustomButton(
              buttonText: _isLoading ? '...' : al.sendOtpButton,
              onTap: _isLoading ? null : _onSendOtp,
            ),
            SizedBox(height: getHeight() * .02),
          ],
        ),
      ),
    );
  }
}
