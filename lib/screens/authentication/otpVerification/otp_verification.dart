import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/auth_provider.dart';
import 'package:choice_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key, this.isResetPassFlow = false});

  final bool isResetPassFlow;

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  String _pin = '';
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _onVerify() async {
    final auth = context.read<AuthProvider>();
    final email = auth.pendingEmail ?? '';

    if (_pin.length != 6) {
      setState(() => _errorMessage = 'Please enter the 6-digit code.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    AuthResult result;
    if (widget.isResetPassFlow) {
      result = await AuthService.producerVerifyForgotOtp(
        email: email,
        otp: _pin,
      );
    } else {
      result = await AuthService.producerVerifyOtp(
        email: email,
        otp: _pin,
      );
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      if (widget.isResetPassFlow) {
        context.push(Routes.resetPasswordRoute);
      } else {
        context.push(Routes.uploadDocsRoute);
      }
    } else {
      setState(() => _errorMessage = result.message ?? 'Verification failed.');
    }
  }

  Future<void> _onResend() async {
    final email = context.read<AuthProvider>().pendingEmail ?? '';
    if (email.isEmpty) return;
    await AuthService.producerResendOtp(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: getHeight() * .1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (Navigator.canPop(context)) ...[
                  CustomBackButton(),
                  SizedBox(width: getWidth() * .02),
                ],
                CustomText(
                  text: al.otpVerification,
                  fontSize: sizes?.fontSize28,
                  fontFamily: Assets.onsetSemiBold,
                ),
              ],
            ),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.verificationPrompt,
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              giveLinesAsText: true,
            ),
            SizedBox(height: getHeight() * .03),
            Pinput(
              length: 6,
              obscureText: true,
              obscuringCharacter: "-",
              defaultPinTheme: PinTheme(
                width: getWidth() * .15,
                height: getHeight() * .065,
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(30, 60, 87, 1),
                  fontWeight: FontWeight.w600,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyBordersColor),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onChanged: (val) => _pin = val,
              onCompleted: (val) => _pin = val,
            ),
            SizedBox(height: getHeight() * .02),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: sizes?.fontSize12),
              ),
            SizedBox(height: getHeight() * .01),
            GestureDetector(
              onTap: _onResend,
              child: Text.rich(
                TextSpan(
                  text: "${al.didNotReceiveCode} ",
                  style: TextStyle(
                    fontSize: sizes?.fontSize16,
                    fontFamily: Assets.onsetRegular,
                  ),
                  children: [
                    TextSpan(
                      text: al.resendCode,
                      style:
                          TextStyle(color: AppColors.restaurantPrimaryColor),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: getHeight() * .03),
            CustomButton(
              buttonText: _isLoading ? '...' : al.verifyButton,
              onTap: _isLoading ? null : _onVerify,
            ),
          ],
        ),
      ),
    );
  }
}
