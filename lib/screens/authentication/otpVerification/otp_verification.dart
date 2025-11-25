import 'dart:async';

import 'package:choice_app/res/toasts.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/otpVerification/otp_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  String otp = "";
  Timer? _timer;
  late ValueNotifier<int> _countdown;
  // late ValueNotifier<bool> _canResend;

  @override
  void initState() {
    super.initState();
    _countdown = ValueNotifier(0);
    final provider = Provider.of<OtpProvider>(context, listen: false);
    provider.init(context);
    _startTimer();
  }

  void _startTimer() {
    _countdown.value = 60;
    // _canResend.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_countdown.value == 0) {
        timer.cancel();
        // _canResend.value = true;
      } else {
        _countdown.value--;
      }
    });
  }


  String _formatTime(int seconds) {
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countdown.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final email = extra?["email"] ?? "nil";
    final isResetPassFlow = extra?["isResetPassFlow"] ?? true;
    final provider = context.read<OtpProvider>();
    debugPrint("Called");
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
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
              text: al.verificationPrompt(email),
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              giveLinesAsText: true,
            ),
            SizedBox(height: getHeight() * .03),
            Pinput(
              length: 6,
              //obscureText: true,
              //obscuringCharacter: "-",
              defaultPinTheme: PinTheme(
                width: getWidth() * .15,
                height: getHeight() * .065,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(30, 60, 87, 1),
                  fontWeight: FontWeight.w600,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyBordersColor),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              preFilledWidget: CustomText(
                text: "-",
                fontSize: 16,
                fontFamily: Assets.onsetMedium,
                color: AppColors.inputHintColor,
                fontWeight: FontWeight.w500,
              ),
              // validator: (s) {
              //   return s == '2222' ? null : 'Pin is incorrect';
              // },
              onChanged: (value) {
                otp = value;
              },
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) => print(pin),
            ),
            SizedBox(height: getHeight() * .03),

            ValueListenableBuilder(
              valueListenable: _countdown,
              builder: (BuildContext context, value, Widget? child) {
                return Text.rich(
                  TextSpan(
                    text:
                    value==0
                        ? "${al.didNotReceiveCode} "
                        : "Resend code in ${_formatTime(value)}\n",
                    style: TextStyle(
                      fontSize: sizes?.fontSize16,
                      fontFamily: Assets.onsetRegular,
                    ),
                    children:
                    value==0
                        ? [
                      TextSpan(
                        text: al.resendCode,
                        style: TextStyle(
                          color:
                          AppColors.getPrimaryColorFromContext(
                            context,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            provider.resendOtp(email: email, isResetPassFlow: isResetPassFlow);
                            _startTimer();
                            // Toasts.getSuccessToast(text: al.otpResentSuccess);
                          },
                      ),
                    ]
                        : [],
                  ),
                  textAlign: TextAlign.start,
                );
              },
            ),

            SizedBox(height: getHeight() * .03),
            CustomButton(
              buttonText: al.verifyButton,
              onTap: () {
                //context.push(Routes.uploadReclaimDocsRoute);
                if (otp.length < 6) {
                  Toasts.getErrorToast(text: al.enterOtpPlaceholder);
                  return;
                }
                if (isResetPassFlow) {
                  provider.verifyFgOtp(
                    email: email,
                    otp: otp,
                    isResetPassFlow: isResetPassFlow,
                  );
                  return;
                }
                provider.verifyOtp(
                  email: email,
                  otp: otp,
                  isResetPassFlow: isResetPassFlow,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
