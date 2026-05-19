import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/auth_provider.dart';
import 'package:choice_app/screens/authentication/passwordManagement/password_provider.dart';
import 'package:choice_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../l18n.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _onReset(AuthProvider auth) async {
    final newPass = _newPassController.text.trim();
    final confirmPass = _confirmPassController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      setState(() => _errorMessage = 'Please fill in both fields.');
      return;
    }
    if (newPass != confirmPass) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }

    final email = auth.pendingEmail ?? '';
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Session expired. Please start over.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // The OTP was already verified — pass empty string; backend checks the verified flag
    final result = await AuthService.producerResetPassword(
      email: email,
      otp: '',
      password: newPass,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      context.go(Routes.loginRoute);
    } else {
      setState(() => _errorMessage = result.message ?? 'Reset failed.');
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
        child: Consumer2<PasswordProvider, AuthProvider>(
          builder: (context, passState, auth, _) {
            return Column(
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
                CustomField(
                  textEditingController: _newPassController,
                  borderColor: AppColors.greyBordersColor,
                  hint: al.newPasswordLabel,
                  label: al.newPasswordLabel,
                  obscure: true,
                  hidePassword: passState.newPassVisibility,
                  maxLines: 1,
                  clickIcon: () => passState.toggleNewPassVisibility(),
                ),
                SizedBox(height: getHeight() * .02),
                CustomField(
                  textEditingController: _confirmPassController,
                  borderColor: AppColors.greyBordersColor,
                  hint: al.confirmPasswordLabel,
                  label: al.confirmPasswordLabel,
                  obscure: true,
                  hidePassword: passState.confirmPassVisibility,
                  maxLines: 1,
                  clickIcon: () => passState.toggleConfirmPassVisibility(),
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
                  buttonText: _isLoading ? '...' : al.verifyButton,
                  onTap: _isLoading ? null : () => _onReset(auth),
                ),
                SizedBox(height: getHeight() * .02),
              ],
            );
          },
        ),
      ),
    );
  }
}
