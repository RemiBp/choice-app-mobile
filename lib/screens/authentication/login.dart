import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/auth_provider.dart';
import 'package:choice_app/screens/authentication/auth_widgets.dart';
import 'package:choice_app/utilities/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../userRole/role_provider.dart';
import '../../userRole/user_role.dart';

import '../../appAssets/app_assets.dart';
import '../../customWidgets/animations/fade_in_up.dart';
import 'package:choice_app/l18n.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppTranslations.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(getWidth() * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               if (context.canPop()) BackButton(color: Colors.black),
               SizedBox(height: 20),
               
               FadeInUp(
                 delay: Duration(milliseconds: 100),
                 child: CustomText(
                  text: al.loginButton,
                  fontSize: sizes?.fontSize32,
                  fontFamily: Assets.onsetBold,
                ),
               ),
               SizedBox(height: 10),
               FadeInUp(
                 delay: Duration(milliseconds: 200),
                 child: CustomText(
                  text: al.loginInstruction,
                  fontSize: sizes?.fontSize16,
                  color: AppColors.textGreyColor,
                ),
               ),
               SizedBox(height: 40),
               
               FadeInUp(
                 delay: Duration(milliseconds: 300),
                 child: Column(
                   children: [
                     CustomField(
                        controller: _emailController, // Connected
                        borderColor: AppColors.greyBordersColor,
                        hint: al.emailPlaceholder,
                        label: al.emailLabel,
                        prefixIcon: Icon(Icons.email, color: AppColors.textGreyColor),
                      ),
                      SizedBox(height: 16),
                      Consumer<AuthProvider>(
                        builder: (context, state, child) {
                          return CustomField(
                            controller: _passwordController, // Connected
                            borderColor: AppColors.greyBordersColor,
                            hint: al.passwordLabel,
                            label: al.passwordLabel,
                            prefixIcon: Icon(Icons.lock, color: AppColors.textGreyColor),
                            obscure: true,
                            hidePassword: state.loginPassVisibility,
                            maxLines: 1,
                            clickIcon: () {
                              state.toggleLoginPassVisibility();
                            },
                          );
                        },
                      ),
                   ],
                 ),
               ),
               
               SizedBox(height: 10),
               FadeInUp(
                 delay: Duration(milliseconds: 350),
                 child: Row(
                   children: [
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          context.push(Routes.forgotPasswordRoute);
                        },
                        child: CustomText(
                          text: "${al.forgotPassword}?",
                          fontSize: sizes?.fontSize14,
                          color: AppColors.getPrimaryColorFromContext(context), // Dynamic color
                          fontFamily: Assets.onsetSemiBold,
                        ),
                      ),
                   ],
                 ),
               ),
               
               SizedBox(height: 20),
               FadeInUp(
                 delay: Duration(milliseconds: 400),
                 child: Consumer<AuthProvider>(
                    builder: (context, auth, child) {
                      return CustomButton(
                        buttonText: auth.isLoading ? "Logging in..." : al.loginButton,
                        onTap: auth.isLoading ? () {} : () async {
                           // Basic Validation
                           if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text("Please fill all fields"))
                             );
                             return;
                           }
                           
                           final success = await auth.login(
                             _emailController.text, 
                             _passwordController.text,
                             context.read<RoleProvider>(), // Added
                           );
                           
                           if (success) {
                             if(context.mounted) _navigateBasedOnRole(context, auth.userRole);
                           } else {
                             if(context.mounted && auth.errorMessage != null) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                   content: Text(auth.errorMessage!),
                                   backgroundColor: Colors.red,
                                 )
                               );
                             }
                           }
                        },
                      );
                    }
                 ),
               ),
               
               SizedBox(height: 30),
               Center(child: Text("Or continue with", style: TextStyle(color: Colors.grey))),
               SizedBox(height: 30),
               
               FadeInUp(
                 delay: Duration(milliseconds: 500),
                 child: Row(
                   children: [
                     Expanded(child: SocialButton(buttonLabel: "Google", svgString: Assets.googleIcon, onPress: (){})),
                     SizedBox(width: 16),
                     Expanded(child: SocialButton(buttonLabel: "Apple", svgString: Assets.appleIcon, onPress: (){})),
                   ],
                 ),
               ),
               
               SizedBox(height: 40),
               Center(
                  child: Text.rich(
                    TextSpan(
                      text: "${al.noAccountPrompt} ",
                      style: TextStyle(
                        color: AppColors.textGreyColor,
                        fontSize: sizes?.fontSize14,
                        fontFamily: Assets.onsetMedium,
                      ),
                      children: [
                        TextSpan(
                          text: al.signupTitle,
                          style: TextStyle(
                            color: AppColors.getPrimaryColorFromContext(context), 
                            fontFamily: Assets.onsetBold
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.pushReplacement(Routes.signupRoute);
                            },
                        ),
                      ],
                    ),
                  ),
               ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateBasedOnRole(BuildContext context, UserRole? role) {
    debugPrint("Navigating for role: $role");
    switch (role) {
      case UserRole.restaurant:
        context.push(Routes.restaurantBottomTabRoute);
        break;
      case UserRole.wellness:
        context.push(Routes.restaurantBottomTabRoute); 
        break;
      case UserRole.user:
        context.push(Routes.customerHomeRoute);
        break;
      default:
        context.push(Routes.restaurantBottomTabRoute); 
        break;
    }
  }
}
