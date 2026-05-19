import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/auth_provider.dart';
import 'package:choice_app/screens/authentication/auth_widgets.dart';
import 'package:choice_app/services/auth_service.dart';
import 'package:choice_app/utilities/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../appAssets/app_assets.dart';
import '../../l18n.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin(AuthProvider auth) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      auth.setError('Please enter your email and password.');
      return;
    }

    auth.setLoading(true);
    final result = await AuthService.producerLogin(
      email: email,
      password: password,
    );
    auth.setLoading(false);

    if (!mounted) return;

    if (result.success) {
      if (result.message == 'needs_otp') {
        // Account registered but not yet OTP-verified
        auth.setPendingEmail(email);
        context.push(Routes.otpVerificationRoute);
      } else {
        context.go(Routes.restaurantBottomTabRoute);
      }
    } else {
      auth.setError(result.message ?? 'Login failed.');
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
        child: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (context.canPop()) ...[
                      CustomBackButton(),
                      SizedBox(width: getWidth() * .02),
                    ],
                    CustomText(
                      text: al.loginButton,
                      fontSize: sizes?.fontSize28,
                      fontFamily: Assets.onsetSemiBold,
                    ),
                  ],
                ),
                SizedBox(height: getHeight() * .02),
                CustomText(
                  text: al.loginInstruction,
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
                SizedBox(height: getHeight() * .01),
                CustomField(
                  textEditingController: _passwordController,
                  borderColor: AppColors.greyBordersColor,
                  hint: al.passwordLabel,
                  label: al.passwordLabel,
                  obscure: true,
                  hidePassword: auth.loginPassVisibility,
                  maxLines: 1,
                  clickIcon: () => auth.toggleLoginPassVisibility(),
                ),
                SizedBox(height: getHeight() * .01),
                Row(
                  children: [
                    Checkbox(
                      side: BorderSide(color: HexColor.fromHex("#B3B3B3")),
                      value: _rememberMe,
                      onChanged: (v) => setState(() => _rememberMe = v ?? true),
                    ),
                    CustomText(
                      text: al.rememberMe,
                      fontSize: sizes?.fontSize16,
                      color: AppColors.primarySlateColor,
                      giveLinesAsText: true,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.push(Routes.forgotPasswordRoute),
                      child: CustomText(
                        text: "${al.forgotPassword}?",
                        fontSize: sizes?.fontSize16,
                        color: AppColors.restaurantPrimaryColor,
                        textDecoration: TextDecoration.underline,
                        giveLinesAsText: true,
                      ),
                    ),
                  ],
                ),
                if (auth.errorMessage != null) ...[
                  SizedBox(height: getHeight() * .01),
                  Text(
                    auth.errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: sizes?.fontSize12,
                    ),
                  ),
                ],
                SizedBox(height: getHeight() * .02),
                CustomButton(
                  buttonText: auth.isLoading ? '...' : al.loginButton,
                  onTap: auth.isLoading ? null : () => _onLogin(auth),
                ),
                SizedBox(height: getHeight() * .02),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.greyBordersColor)),
                    CustomText(text: "  Or  ", fontSize: sizes?.fontSize14),
                    Expanded(child: Divider(color: AppColors.greyBordersColor)),
                  ],
                ),
                SizedBox(height: getHeight() * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SocialButton(
                      buttonLabel: al.signupWithApple,
                      svgString: Assets.appleIcon,
                      onPress: () {},
                    ),
                    SocialButton(
                      buttonLabel: al.signupWithGoogle,
                      svgString: Assets.googleIcon,
                      onPress: () {},
                    ),
                  ],
                ),
                SizedBox(height: getHeight() * .02),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "${al.noAccountPrompt} ",
                      style: TextStyle(
                        fontSize: sizes?.fontSize16,
                        fontFamily: Assets.onsetRegular,
                      ),
                      children: [
                        TextSpan(
                          text: al.signupTitle,
                          style: TextStyle(
                              color: AppColors.restaurantPrimaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                context.pushReplacement(Routes.signupRoute),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
