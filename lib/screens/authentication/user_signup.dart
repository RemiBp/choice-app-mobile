import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/auth_widgets.dart';
import 'package:choice_app/screens/customer/profile/customer_profile/customer_profile_provider.dart';
import 'package:choice_app/utilities/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../appAssets/app_assets.dart';
import '../../l18n.dart';
import '../../res/toasts.dart';
import '../../userRole/role_provider.dart';
import '../../utilities/input_formatters.dart';
import '../restaurant/profile/profile_provider.dart';
import 'auth_provider.dart';
import 'dart:io' show Platform;

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late PhoneController _phoneController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AuthProvider>(context, listen: false);
    provider.init(context);

    // Clear phone number on opening signup
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.setPhoneNumber(null);
    _phoneController = PhoneController(initialValue: PhoneNumber.parse('+33'));
  }


  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProfileProvider>(context);
    AppTranslations.init(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: getHeight() * .07,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (context.canPop()) ...[
                    CustomBackButton(),
                    SizedBox(width: getWidth() * .02),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: al.signupTitle,
                          fontSize: sizes?.fontSize28,
                          fontFamily: Assets.onsetSemiBold,
                        ),
                        SizedBox(height: getHeight() * .005),
                        CustomText(
                          text: al.signupSubtitle,
                          fontSize: sizes?.fontSize16,
                          color: AppColors.primarySlateColor,
                          giveLinesAsText: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: getHeight() * .02),

              // FULL NAME
              CustomField(
                textEditingController: fullNameController,
                borderColor: AppColors.greyBordersColor,
                hint: al.fullName,
                label: al.fullNamePlaceholder,
                inputFormatters: [AllowOnlyAlphanumericUnderscore()],
              ),
              SizedBox(height: getHeight() * .015),

              // USERNAME
              CustomField(
                textEditingController: userNameController,
                borderColor: AppColors.greyBordersColor,
                hint: al.userName,
                label: al.userNamePlaceholder,
                inputFormatters: [AllowOnlyAlphanumericUnderscore()],
              ),
              SizedBox(height: getHeight() * .015),

              // EMAIL
              CustomField(
                textEditingController: emailController,
                borderColor: AppColors.greyBordersColor,
                hint: al.emailPlaceholder,
                label: al.emailLabel,
                textInputType: TextInputType.emailAddress,
                inputFormatters: [AllowOnlyAlphabetUnderscore()],
              ),
              SizedBox(height: getHeight() * .015),

              // PHONE NUMBER
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: al.phoneNumber,
                        fontSize: sizes!.fontSize14,
                        fontFamily: Assets.onsetMedium,
                      ),
                      CustomText(
                        text: ' *',
                        fontSize: sizes!.fontSize14,
                        fontFamily: Assets.onsetMedium,
                        color: AppColors.redColor,
                      ),
                    ],
                  ),
                  SizedBox(height: getHeight() * .01),
                  PhoneFormField(
                    controller: _phoneController,
                    //initialValue: provider.phoneNumber ?? PhoneNumber.parse('+33'),
                    countrySelectorNavigator:
                    const CountrySelectorNavigator.page(),
                    onChanged: (phoneNumber) => provider.setPhoneNumber(phoneNumber),
                    decoration: InputDecoration(
                      border: buildOutlineInputBorder(AppColors.greyBordersColor),
                      focusedBorder:
                      buildOutlineInputBorder(AppColors.inputHintColor),
                      errorBorder: buildOutlineInputBorder(AppColors.redColor),
                      focusedErrorBorder: buildOutlineInputBorder(AppColors.redColor),
                    ),
                    validator: PhoneValidator.compose([
                      PhoneValidator.required(context, errorText: al.phoneNumberMissing),
                      PhoneValidator.valid(context),
                    ]),
                    enabled: true,
                    isCountrySelectionEnabled: true,
                    isCountryButtonPersistent: true,
                    countryButtonStyle: const CountryButtonStyle(
                      showDialCode: true,
                      showIsoCode: true,
                      showFlag: true,
                      flagSize: 16,
                    ),
                  ),
                ],
              ),

              SizedBox(height: getHeight() * .015),

              // PASSWORD
              Consumer<AuthProvider>(
                builder: (context, state, child) {
                  return CustomField(
                    validate: (value) {
                      return validatePassword(value ?? "");
                    },
                    textEditingController: passwordController,
                    borderColor: AppColors.greyBordersColor,
                    hint: al.passwordLabel,
                    label: al.passwordLabel,
                    obscure: true,
                    hidePassword: state.signupPassVisibility,
                    maxLines: 1,
                    inputFormatters: [AllowOnlyAsciiCharacters()],
                    clickIcon: () {
                      state.toggleSignupPassVisibility();
                    },
                  );
                },
              ),

              SizedBox(height: getHeight() * .02),

              // TERMS CHECKBOX
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -7),
                    child: Padding(
                      padding: EdgeInsets.only(right: getWidth() * 0.02),
                      child: Consumer<AuthProvider>(
                        builder: (context, state, child) {
                          return Checkbox(
                            side: BorderSide(color: HexColor.fromHex("#B3B3B3")),
                            value: state.agreed,
                            onChanged: (value) {
                              state.toggleAgreement(value!);
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            activeColor: AppColors.getPrimaryColorFromContext(context),
                          );
                        },
                      ),                  ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                          text: al.signupAgreement,
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
                              text: al.privacyPolicy,
                              style: TextStyle(color: AppColors.getPrimaryColorFromContext(context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: getHeight() * .025),

              //  SIGNUP BUTTON
              CustomButton(
                buttonText: al.signupTitle,
                onTap: onSignupTap,
              ),

              SizedBox(height: getHeight() * .02),

              //  DIVIDER
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.greyBordersColor)),
                  CustomText(text: "  Or  ", fontSize: sizes?.fontSize14),
                  Expanded(child: Divider(color: AppColors.greyBordersColor)),
                ],
              ),

              SizedBox(height: getHeight() * .02),

              //  SOCIAL BUTTONS
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

              //  ALREADY HAVE ACCOUNT
              Center(
                child: Text.rich(
                  TextSpan(
                    text: al.alreadyHaveAccount,
                    style: TextStyle(
                      fontSize: sizes?.fontSize16,
                      fontFamily: Assets.onsetRegular,
                    ),
                    children: [
                      TextSpan(
                        text: al.loginButton,
                        style: TextStyle(
                          color: AppColors.getPrimaryColorFromContext(context),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pushReplacement(Routes.loginRoute);
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
  onSignupTap() {
    var email = emailController.text.toString().trim();
    var password = passwordController.text.toString().trim();
    var fullName = fullNameController.text.toString().trim();
    var userName = userNameController.text.toString().trim();
    var phoneNumber = context.read<CustomerProfileProvider>().phoneNumber;

    // Validate name fields
    if (fullName.isEmpty) {
      Toasts.getErrorToast(text: al.nameMissing);
      return;
    } else if (userName.isEmpty) {
      Toasts.getErrorToast(text: al.usernameMissing);
      return;
    }

    if (email.isEmpty) {
      Toasts.getErrorToast(text: al.emailMissing);
      return;
    } else if (email.validateEmail() == false) {
      Toasts.getErrorToast(text: al.invalidEmail);
      return;
    }

    // Validate phone number
    if (!_formKey.currentState!.validate()) {
      if (phoneNumber == null || !_phoneController.value!.isValid()) {
        Toasts.getErrorToast(text: "Please enter a valid phone number.");
      }
      return;
    }

    // Validate email


    // Validate password
    // if (password.isEmpty) {
    //   Toasts.getErrorToast(text: al.passwordMissing);
    //   return;
    // }
    //
    // final passwordError = validatePassword(password);
    // if (passwordError != null) {
    //   Toasts.getErrorToast(text: passwordError);
    //   return;
    // }

    final cleanedPhone = phoneNumber?.international.replaceAll(RegExp(r'\D'), '');
    // final authProvider = context.read<AuthProvider>();

    if (_formKey.currentState!.validate()) {
      // Check agreement before proceeding
      // if (!authProvider.agreed) {
      //   Toasts.getErrorToast(text: "Please agree to the terms and conditions");
      //   return;
      // }
      // If agreement is checked, proceed with registration
      context.read<AuthProvider>().registerUser(
        fullName: fullName,
        userName: userName,
        phone: cleanedPhone ?? "nil",
        email: email,
        role: context.read<RoleProvider>().role.name,
        password: password,
      );
    }

  }

  String? validatePassword(String password) {
    if (password.length < 8) {
      // Toasts.getErrorToast(text: al.passwordMustBeAtLeast8Chars);
      return al.passwordMustBeAtLeast8Chars;
    }

    if (password.contains(' ')) {
      // Toasts.getErrorToast(text: al.passwordCannotContainSpaces);
      return al.passwordCannotContainSpaces;
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      // Toasts.getErrorToast(text: al.passwordMustContainUppercase);
      return al.passwordMustContainUppercase;
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      // Toasts.getErrorToast(text: al.passwordMustContainLowercase);
      return al.passwordMustContainLowercase;
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      // Toasts.getErrorToast(text: al.passwordMustContainNumber);
      return al.passwordMustContainNumber;
    }

    if (!RegExp(r'[!@#$%&]').hasMatch(password)) {
      // Toasts.getErrorToast(text: al.passwordMustContainSpecialChar);
      return al.passwordMustContainSpecialChar;
    }

    if (!RegExp(r'^[a-zA-Z0-9!@#$%&]+$').hasMatch(password)) {
      // Toasts.getErrorToast(text: al.passwordInvalidCharacters);
      return al.passwordInvalidCharacters;
    }

    return null; // No error
  }
  // onSignupTap() {
  //   var email = emailController.text.toString().trim();
  //   var password = passwordController.text.toString().trim();
  //   var fullName = fullNameController.text.toString().trim();
  //   var userName = userNameController.text.toString().trim();
  //   var phoneNumber = context.read<CustomerProfileProvider>().phoneNumber;
  //
  //
  //
  //   // debugPrint("phone is : ${phone?.nsn}");
  //   if (fullName.isEmpty) {
  //     Toasts.getErrorToast(text: al.nameMissing);
  //   } else if (userName.isEmpty) {
  //     Toasts.getErrorToast(text: al.usernameMissing);
  //   }
  //   if (!_formKey.currentState!.validate()) {
  //     // If phone validation fails, show custom toast
  //     if (phoneNumber == null || !_phoneController.value!.isValid()) {
  //       Toasts.getErrorToast(text: "Please enter a valid phone number.");
  //     }
  //     return;
  //   }
  //   else if (email.isEmpty) {
  //     Toasts.getErrorToast(text: al.emailMissing);
  //   } else if (email.validateEmail() == false) {
  //     Toasts.getErrorToast(text: al.invalidEmail);
  //   } else if (password.isEmpty) {
  //     Toasts.getErrorToast(text: al.passwordMissing);
  //   } else {
  //     final cleanedPhone = phoneNumber?.international.replaceAll(RegExp(r'\D'), '');
  //     context.read<AuthProvider>().registerUser(
  //       fullName: fullName,
  //       userName: userName,
  //       phone:cleanedPhone ?? "nil" ,
  //       email: email, role: context
  //         .read<RoleProvider>()
  //         .role.name, password: password,);
  //   }
  // }
}
