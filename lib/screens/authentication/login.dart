import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/auth_provider.dart';
import 'package:choice_app/screens/authentication/auth_widgets.dart';
import 'package:choice_app/utilities/extensions.dart';
import 'package:choice_app/utilities/input_formatters.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../appAssets/app_assets.dart';
import '../../l18n.dart';
import '../../res/toasts.dart';
import '../../userRole/role_provider.dart';
import '../../userRole/user_role.dart';
import '../../utilities/validators.dart';
import 'dart:io' show Platform;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AuthProvider>(context, listen: false);
    provider.init(context);
  }
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
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
              textEditingController: emailController,
              borderColor: AppColors.greyBordersColor,
              hint: al.emailPlaceholder,
              label: al.emailLabel,
              inputFormatters: [AllowOnlyAlphabetUnderscore()],
              validate: (value) =>
                  Validators.validateEmail(value, al.emailMissing, al.invalidEmail),
            ),
            SizedBox(height: getHeight() * .01),
            Consumer<AuthProvider>(
              builder: (context, state, child) {
                return CustomField(
                  textEditingController: passwordController,
                  borderColor: AppColors.greyBordersColor,
                  hint: al.passwordLabel,
                  label: al.passwordLabel,
                  obscure: true,
                  inputFormatters: [AllowOnlyAsciiCharacters()],
                  hidePassword: state.loginPassVisibility,
                  maxLines: 1,
                  clickIcon: () {
                    state.toggleLoginPassVisibility();
                  },
                  validate: (value) =>
                      Validators.validatePassword(value, al.passwordMissing, al.invalidPassword),
                );
              },
            ),
            SizedBox(height: getHeight() * .01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, // ensures vertical alignment
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<AuthProvider>(
                      builder: (context, state, child) {
                        return Checkbox(
                          side: BorderSide(color: HexColor.fromHex("#B3B3B3")),
                          value: state.rememberMe,
                          onChanged: (value) {
                            state.toggleRememberMe(value!);
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          activeColor: AppColors.getPrimaryColorFromContext(context),

                        );
                      },
                    ),
                    SizedBox(width: getWidth() * 0.02,),
                    CustomText(
                      text: al.rememberMe,
                      fontSize: sizes?.fontSize16,
                      color: AppColors.primarySlateColor,
                    ),
                  ],
                ),
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      context.push(Routes.forgotPasswordRoute);
                    },
                    child: CustomText(
                      text: "${al.forgotPassword}?",
                      fontSize: sizes?.fontSize16,
                      color: AppColors.getPrimaryColorFromContext(context),
                      textDecoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight() * .02),
            CustomButton(
              buttonText: al.loginButton,
              onTap: onLoginTap,
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
                if(Platform.isIOS)...[
                  Expanded(
                    child: SocialButton(
                      buttonLabel: al.signupWithApple,
                      svgString: Assets.appleIcon,
                      onPress: () {},
                    ),
                  ),
                  SizedBox(width: 20,),
                ],
                Expanded(
                  child: SocialButton(
                    buttonLabel: al.signupWithGoogle,
                    svgString: Assets.googleIcon,
                    onPress: () {},
                  ),
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
                      style: TextStyle(color:  AppColors.getPrimaryColorFromContext(context),),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {

                              final roleProvider = context.read<RoleProvider>();

                              if (roleProvider.role == UserRole.user) {
                                // Navigate to user signup
                                context.pushReplacement(Routes.userSignupRoute);
                              } else {
                                // Navigate to normal signup
                                context.pushReplacement(Routes.reClaimAccountRoute);
                              }


                            },
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

  onLoginTap() {
    // context.push(Routes.restaurantProfileRoute);
   // context.push(Routes.restaurantBottomTabRoute);
    //return;
    var email = emailController.text.toString().trim();
    var password = passwordController.text.toString().trim();
    if (email.isEmpty) {
      Toasts.getErrorToast(text: al.emailMissing);
    } else if (email.validateEmail() == false) {
      Toasts.getErrorToast(text: al.invalidEmail);
    } else if (password.isEmpty) {
      Toasts.getErrorToast(text: al.passwordMissing);
    } else {
      context.read<AuthProvider>().loginUser(
        email: email, password: password,);
    }
  }
}
