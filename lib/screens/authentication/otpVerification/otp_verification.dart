import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/passwordManagement/reset_password.dart';
import 'package:choice_app/screens/authentication/upload_docs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import 'package:choice_app/l18n.dart';
import '../../../res/res.dart';

class OtpVerification extends StatelessWidget {
  const OtpVerification({super.key, this.isResetPassFlow = false});

  final bool isResetPassFlow;

  @override
  Widget build(BuildContext context) {
    // final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    // final isResetPassFlow = extra?["isResetPassFlow"] ?? false;

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
              // validator: (s) {
              //   return s == '2222' ? null : 'Pin is incorrect';
              // },
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) => print(pin),
            ),
            SizedBox(height: getHeight() * .03),
            Text.rich(
              TextSpan(
                text: "${al.didNotReceiveCode} ",
                style: TextStyle(
                  fontSize: sizes?.fontSize16,
                  fontFamily: Assets.onsetRegular,
                ),
                children: [
                  TextSpan(
                    text: al.resendCode,
                    style: TextStyle(color: AppColors.getPrimaryColorFromContext(context)),
                  ),
                ],
              ),
            ),
            SizedBox(height: getHeight() * .03),
            CustomButton(
              buttonText: al.verifyButton,
              onTap: () {
                if (isResetPassFlow) {
                  context.push(Routes.resetPasswordRoute);
                  return;
                }
                context.push(Routes.uploadDocsRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
