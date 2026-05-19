import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/auth_provider.dart';
import 'package:choice_app/screens/authentication/auth_widgets.dart';
import 'package:choice_app/services/auth_service.dart';
import 'package:choice_app/userRole/role_provider.dart';
import 'package:choice_app/userRole/user_role.dart';
import 'package:choice_app/utilities/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../appAssets/app_assets.dart';
import '../../l18n.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;

  String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.restaurant:
        return 'restaurant';
      case UserRole.leisure:
        return 'leisure';
      case UserRole.wellness:
        return 'wellness';
      case UserRole.user:
        return 'user';
    }
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignup(AuthProvider auth) async {
    final businessName = _businessNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      auth.setError('Please fill in all required fields.');
      return;
    }
    if (!_agreedToTerms) {
      auth.setError('Please accept the terms to continue.');
      return;
    }

    final selectedRole = context.read<RoleProvider>().role;
    final roleStr = _roleToString(selectedRole);

    auth.setLoading(true);
    final result = await AuthService.producerRegister(
      email: email,
      password: password,
      businessName: businessName.isNotEmpty ? businessName : null,
      role: roleStr,
    );
    auth.setLoading(false);

    if (!mounted) return;

    if (result.success) {
      auth.setPendingEmail(email);
      context.push(Routes.otpVerificationRoute);
    } else {
      auth.setError(result.message ?? 'Registration failed.');
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
                      text: al.signupTitle,
                      fontSize: sizes?.fontSize28,
                      fontFamily: Assets.onsetSemiBold,
                    ),
                  ],
                ),
                SizedBox(height: getHeight() * .02),
                CustomText(
                  text: al.signupSubtitle,
                  fontSize: sizes?.fontSize16,
                  color: AppColors.primarySlateColor,
                  giveLinesAsText: true,
                ),
                SizedBox(height: getHeight() * .01),
                CustomField(
                  textEditingController: _businessNameController,
                  borderColor: AppColors.greyBordersColor,
                  hint: al.businessName,
                  label: al.businessName,
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
                  hidePassword: auth.signupPassVisibility,
                  maxLines: 1,
                  clickIcon: () => auth.toggleSignupPassVisibility(),
                ),
                SizedBox(height: getHeight() * .01),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Checkbox(
                      side: BorderSide(color: HexColor.fromHex("#B3B3B3")),
                      value: _agreedToTerms,
                      onChanged: (v) =>
                          setState(() => _agreedToTerms = v ?? false),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: "${al.signupAgreement} ",
                          style: TextStyle(
                            fontSize: sizes?.fontSize14,
                            fontFamily: Assets.onsetRegular,
                          ),
                          children: [
                            TextSpan(
                              text: al.termsOfService,
                              style: TextStyle(
                                  color: AppColors.restaurantPrimaryColor),
                            ),
                            TextSpan(text: " ${al.andLabel} "),
                            TextSpan(
                              text: " ${al.privacyPolicy} ",
                              style: TextStyle(
                                  color: AppColors.restaurantPrimaryColor),
                            ),
                          ],
                        ),
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
                  buttonText: auth.isLoading ? '...' : al.signupTitle,
                  onTap: auth.isLoading ? null : () => _onSignup(auth),
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
                      text: "${al.alreadyHaveAccount} ",
                      style: TextStyle(
                        fontSize: sizes?.fontSize16,
                        fontFamily: Assets.onsetRegular,
                      ),
                      children: [
                        TextSpan(
                          text: al.loginButton,
                          style: TextStyle(
                              color: AppColors.restaurantPrimaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                context.pushReplacement(Routes.loginRoute),
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
