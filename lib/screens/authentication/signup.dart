import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/auth_widgets.dart';
import 'package:choice_app/screens/restaurant/setting/setting_view.dart';
import 'package:choice_app/utilities/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../userRole/role_provider.dart';
import '../../userRole/user_role.dart';

import '../../appAssets/app_assets.dart';
import 'package:choice_app/l18n.dart';
import '../onboarding/add_cuisine/add_cuisine.dart';
import 'auth_provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() { 
    _businessNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              controller: _businessNameController,
              borderColor: AppColors.greyBordersColor,
              hint: al.businessName,
              label: al.businessName,
            ),
            SizedBox(height: getHeight() * .01),
            CustomField(
              controller: _emailController,
              borderColor: AppColors.greyBordersColor,
              hint: al.emailPlaceholder,
              label: al.emailLabel,
            ),
            SizedBox(height: getHeight() * .01),
            Consumer<AuthProvider>(
              builder: (context, state, child) {
                return CustomField(
                  controller: _passwordController,
                  borderColor: AppColors.greyBordersColor,
                  hint: al.passwordLabel,
                  label: al.passwordLabel,
                  obscure: true,
                  hidePassword: state.signupPassVisibility,
                  maxLines: 1,
                  clickIcon: () {
                    state.toggleSignupPassVisibility();
                  },
                );
              },
            ),
            SizedBox(height: getHeight() * .01),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Checkbox(
                  side: BorderSide(color: HexColor.fromHex("#B3B3B3")),
                  value: true,
                  onChanged: (value) {},
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
                          style: TextStyle(color: AppColors.getPrimaryColorFromContext(context)),
                        ),
                        TextSpan(text: " ${al.andLabel} "),
                        TextSpan(
                          text: " ${al.privacyPolicy} ",
                          style: TextStyle(color: AppColors.getPrimaryColorFromContext(context)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight() * .02),
            Consumer<AuthProvider>(
              builder: (context, auth, child) {
                return CustomButton(
                  buttonText: auth.isLoading ? "Signing up..." : al.signupTitle,
                  onTap: auth.isLoading ? () {} : () async {
                    if (_businessNameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
                       return;
                    }
                    
                    final success = await auth.signup({
                      'businessName': _businessNameController.text,
                      'email': _emailController.text,
                      'password': _passwordController.text,
                      'role': context.read<RoleProvider>().role.name,
                    });

                    if (success) {
                      if (context.mounted) context.push(Routes.otpVerificationRoute);
                    } else {
                      if (context.mounted && auth.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(auth.errorMessage!), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                );
              },
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
                      style: TextStyle(color: AppColors.getPrimaryColorFromContext(context)),
                      recognizer: TapGestureRecognizer()..onTap=(){
                        context.pushReplacement(Routes.loginRoute);
                      }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
