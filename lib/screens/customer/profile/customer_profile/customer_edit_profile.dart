import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/network/network_provider.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/res/toasts.dart';
import 'package:choice_app/screens/customer/profile/customer_profile/customer_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

import '../../../../appAssets/app_assets.dart';
import '../../../../l18n.dart';

class CustomerEditProfile extends StatefulWidget {
  const CustomerEditProfile({super.key});

  @override
  State<CustomerEditProfile> createState() => _CustomerEditProfileState();
}

class _CustomerEditProfileState extends State<CustomerEditProfile> {
  // Form controllers
  late final TextEditingController nameController;
  late final TextEditingController userNameController;
  late final TextEditingController bioController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  final _formKey = GlobalKey<FormState>();
  late PhoneController _phoneController;


  NetworkProvider networkProvider = NetworkProvider();

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    final provider = Provider.of<CustomerProfileProvider>(
      context,
      listen: false,
    );
    provider.reset();
    provider.profileImageUrl = provider.user?.profileImageUrl;
    nameController = TextEditingController(text: provider.user?.fullName);
    userNameController = TextEditingController(text: provider.user?.userName);
    bioController = TextEditingController(text: provider.user?.bio);
    emailController = TextEditingController(text: provider.user?.email);
    phoneController = TextEditingController(text: provider.user?.phoneNumber);
    debugPrint("Here ${provider.user?.phoneNumber}");
    provider.setPhoneNumber(null);
    _phoneController = PhoneController(initialValue: PhoneNumber.parse('+33'));
    networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    networkProvider.context = context;
  }

  @override
  void dispose() {
    // Dispose controllers
    nameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProfileProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: getHeight() * .1,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (context.canPop()) ...[
                    CustomBackButton(),
                    SizedBox(width: getWidth() * .02),
                  ],
                  Expanded(
                    child: CustomText(
                      text: al.editProfile,
                      fontSize: sizes?.fontSize28,
                      fontFamily: Assets.onsetSemiBold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getHeight() * .02),
              Stack(
                alignment: Alignment.bottomRight,
                clipBehavior: Clip.none, // allow overflow
                children: [
                  CircleAvatar(
                    radius: getHeight() * .07,
                    backgroundColor: AppColors.greyColor,
                    backgroundImage:
                        provider.profileImage != null
                            ? FileImage(provider.profileImage!)
                            : provider.profileImageUrl != null
                            ? NetworkImage(provider.profileImageUrl!)
                            : null,
                    child:
                        provider.profileImage == null &&
                                provider.profileImageUrl == null
                            ? SvgPicture.asset(
                              Assets.userIcon,
                              height: getHeight() * .05,
                              colorFilter: ColorFilter.mode(
                                Colors.grey.shade600,
                                BlendMode.srcIn,
                              ),
                            )
                            : null,
                  ),
                  Positioned(
                    right: -getWidth() * .017, // push outward horizontally
                    bottom: -getHeight() * .017, // push outward vertically
                    child: IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.getPrimaryColorFromContext(
                          context,
                        ),
                      ),
                      onPressed: () async {
                        provider.pickProfileImage();
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: getHeight() * .022,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: getHeight() * .03),
              CustomField(
                textEditingController: nameController,
                borderColor: AppColors.greyBordersColor,
                hint: al.fullName,
                label: al.fullName,
              ),
              SizedBox(height: getHeight() * .03),
              CustomField(
                textEditingController: userNameController,
                borderColor: AppColors.greyBordersColor,
                hint: al.userName,
                label: al.userName,
              ),
              SizedBox(height: getHeight() * .03),
              CustomField(
                textEditingController: emailController,
                borderColor: AppColors.greyBordersColor,
                hint: al.emailLabel,
                label: al.emailLabel,
                enabled: false,
                bgColor: AppColors.greyColor.withValues(alpha: 0.9),
              ),
              SizedBox(height: getHeight() * .02),
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
              SizedBox(height: getHeight() * .02),

              CustomField(
                textEditingController: bioController,
                height: getHeight() * .1,
                borderColor: AppColors.greyBordersColor,
                hint: al.writeAboutYourself,
                label: al.bio,
                maxLines: 3,
              ),
              SizedBox(height: getHeight() * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    buttonText: al.cancel,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    buttonWidth: getWidth() * .42,
                    backgroundColor: Colors.transparent,
                    borderColor: AppColors.blackColor,
                    textColor: AppColors.blackColor,
                    textFontWeight: FontWeight.w700,
                  ),
                  CustomButton(
                    buttonText: al.saveChanges,
                    onTap: () async {


                      final name = nameController.text.trim();
                      final username = userNameController.text.trim();
                      final bio = bioController.text.trim();
                      var phoneNumber = context.read<CustomerProfileProvider>().phoneNumber;

                      if (name.isEmpty) {
                        Toasts.getErrorToast(text: al.nameMissing); // or “Full name is required”
                        return;
                      }

                      if (username.isEmpty) {
                        Toasts.getErrorToast(text: al.usernameMissing);
                        return;
                      }

                      if (!_formKey.currentState!.validate()) {
                        if (phoneNumber == null || !_phoneController.value!.isValid()) {
                          Toasts.getErrorToast(text: "Please enter a valid phone number.");
                        }
                        return;
                      }

                      if(bio.isEmpty){
                        Toasts.getErrorToast(text: "Please Enter Bio");
                        return;
                      }

                      if (provider.profileImage != null) {
                        final bytes = await provider.profileImage!.readAsBytes();
                        provider.profileImageUrl = await networkProvider
                            .getUrlForFileUpload(bytes);
                        if (provider.profileImageUrl == null) {
                          Toasts.getErrorToast(text: al.failedToGetImageUrl);
                          return;
                        }
                      }
                      await provider.updateCustomerProfile(
                        name: name,
                        username: username,
                        bio: bio,
                      );
                    },
                    buttonWidth: getWidth() * .42,
                    backgroundColor: AppColors.getPrimaryColorFromContext(
                      context,
                    ),
                    borderColor: AppColors.getPrimaryColorFromContext(context),
                    textColor: AppColors.whiteColor,
                    textFontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
