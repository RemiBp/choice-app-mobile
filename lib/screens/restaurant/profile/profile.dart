import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/models/get_producer_profile_response.dart';
import 'package:choice_app/network/network_provider.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/res/toasts.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/restaurant/profile/profile_provider.dart';
import 'package:choice_app/screens/restaurant/profile/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../common/utils.dart';
import '../../../l18n.dart';
import '../../../userRole/role_provider.dart';
import '../../../userRole/user_role.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, this.isFromSettings = false});

  final bool isFromSettings;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Form controllers
  late final TextEditingController addressController;
  late final TextEditingController passwordController;
  late final TextEditingController websiteController;
  late final TextEditingController instagramController;
  late final TextEditingController twitterController;
  late final TextEditingController facebookController;
  late final TextEditingController descriptionController;

  // Extra controllers for user role
  late final TextEditingController fullNameController;
  late final TextEditingController usernameController;
  late final TextEditingController emailController;

  NetworkProvider networkProvider = NetworkProvider();

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
    websiteController = TextEditingController();
    instagramController = TextEditingController();
    twitterController = TextEditingController();
    facebookController = TextEditingController();
    descriptionController = TextEditingController();

    fullNameController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    //emailController = TextEditingController();

    // Pre-fill email from login
    emailController = TextEditingController(text: PreferenceUtils.email);


    final provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.init(context);

    networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    networkProvider.context = context;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.isFromSettings) {
        provider.getProducerProfile().then((_) {
          if(provider.getProducerProfileResponse != null) {
            _populateFormFields(provider.getProducerProfileResponse!);
          }
        });
      }
    });
  }

  void _populateFormFields(GetProducerProfileResponse response) {
    final producer = response.producer;
    final businessProfile = response.businessProfile;
    final provider = Provider.of<ProfileProvider>(context, listen: false);

    if (producer != null) {
      // Address
      addressController.text = producer.address ?? '';

      //  Website (from producer)
      websiteController.text = producer.website ?? '';

      //  Phone number
      if (producer.phoneNumber != null && producer.phoneNumber!.isNotEmpty) {
        try {
          // debugPrint("Phone Number====> ${PhoneNumber.parse(producer.phoneNumber!)}");
          provider.setPhoneNumber(PhoneNumber.parse(producer.phoneNumber!));
        } catch (e) {
          debugPrint('Error parsing phone number: $e');
        }
      }
    }

    if (businessProfile != null) {
      // Populate business profile fields
      if (websiteController.text.isEmpty) {
        websiteController.text = businessProfile.website ?? '';
      }
      instagramController.text = businessProfile.instagram ?? '';
      twitterController.text = businessProfile.twitter ?? '';
      facebookController.text = businessProfile.facebook ?? '';
      descriptionController.text = businessProfile.description ?? '';

      // Set profile image if available
      if (businessProfile.profileImageUrl != null && businessProfile.profileImageUrl!.isNotEmpty) {
        provider.setProfileImageUrl(businessProfile.profileImageUrl);
        debugPrint('Profile image URL: ${businessProfile.profileImageUrl}');
      }
    }
  }

  Widget _buildProfileImage(ProfileProvider provider) {
    if (provider.profileImage != null) {
      return CircleAvatar(
        radius: getHeight() * .07,
        backgroundColor: AppColors.greyColor,
        backgroundImage: FileImage(provider.profileImage!),
      );
    }
    if (widget.isFromSettings && provider.profileImageUrl != null && provider.profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: getHeight() * .07,
        backgroundColor: AppColors.greyColor,
        child: ClipOval(
          child: Image.network(
            provider.profileImageUrl!,
            width: getHeight() * .14, // 2 * radius
            height: getHeight() * .14, // 2 * radius
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Network image error: $error');
              return SvgPicture.asset(
                Assets.userIcon,
                height: getHeight() * .05,
                colorFilter: ColorFilter.mode(
                  Colors.grey.shade600,
                  BlendMode.srcIn,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: getHeight() * .07,
      backgroundColor: AppColors.greyColor,
      child: SvgPicture.asset(
        Assets.userIcon,
        height: getHeight() * .05,
        colorFilter: ColorFilter.mode(
          Colors.grey.shade600,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    addressController.dispose();
    passwordController.dispose();
    websiteController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    facebookController.dispose();
    descriptionController.dispose();

    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context, listen: true);
    final roleProvider = context.read<RoleProvider>(); // get current role

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
            // --- Header ---
            Row(
              children: [
                if (context.canPop()) ...[
                  CustomBackButton(),
                  SizedBox(width: getWidth() * .02),
                ],
                Expanded(
                  child: CustomText(
                    text: al.profileSetup,
                    fontSize: sizes?.fontSize28,
                    fontFamily: Assets.onsetSemiBold,
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: "Lorem ipsum dolor sit amet consectetur.",
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              giveLinesAsText: true,
            ),
            SizedBox(height: getHeight() * .02),

            // --- Profile Image ---
            Stack(
              alignment: Alignment.bottomRight,
              clipBehavior: Clip.none, // allow overflow
              children: [
                _buildProfileImage(provider),
                Positioned(
                  right: -getWidth() * .017,
                  bottom: -getHeight() * .017,
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor:
                      AppColors.getPrimaryColorFromContext(context),
                    ),
                    onPressed: () async {
                      final selectedImage = await bottomSheet(context);
                      if (selectedImage != null) {
                        provider.setProfileImage(selectedImage);
                      }
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

            // Fields for USER role
            if (roleProvider.role == UserRole.user) ...[
              CustomField(
                textEditingController: fullNameController,
                borderColor: AppColors.greyBordersColor,
                hint: al.fullNamePlaceholder,
                label: al.fullName,
              ),
              SizedBox(height: getHeight() * .02),
              CustomField(
                textEditingController: usernameController,
                borderColor: AppColors.greyBordersColor,
                hint: al.userNamePlaceholder,
                label: al.userName,
              ),
              SizedBox(height: getHeight() * .02),
              CustomField(
                textEditingController: emailController,
                borderColor: AppColors.greyBordersColor,
                hint: al.emailPlaceholder,
                label: al.emailLabel,
                enabled: false,
                bgColor: AppColors.greyColor.withValues(alpha: 0.9),
              ),
              SizedBox(height: getHeight() * .02),

              // Phone
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
                initialValue: provider.phoneNumber ?? PhoneNumber.parse('+33'),
                countrySelectorNavigator:
                const CountrySelectorNavigator.page(),
                onChanged: (phoneNumber) =>
                    provider.setPhoneNumber(phoneNumber),
                decoration: InputDecoration(
                  border:
                  buildOutlineInputBorder(AppColors.greyBordersColor),
                  focusedBorder: buildOutlineInputBorder(
                    AppColors.inputHintColor,
                  ),
                  errorBorder: buildOutlineInputBorder(AppColors.redColor),
                  focusedErrorBorder: buildOutlineInputBorder(AppColors.redColor),
                ),
                validator: PhoneValidator.valid(context), // Automatic validation per country
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

              // Brief Description
              CustomField(
                textEditingController: descriptionController,
                height: getHeight() * .1,
                borderColor: AppColors.greyBordersColor,
                hint: al.writeSomethingBrief,
                label: al.briefDescription,
                maxLines: 3,
              ),
            ]

            // Fields for RESTAURANT/OTHERS
            else ...[
              CustomField(
                textEditingController: addressController,
                borderColor: AppColors.greyBordersColor,
                hint: al.address,
                label: al.address,
              ),
              SizedBox(height: getHeight() * .02),

              // phone
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
                initialValue:
                provider.phoneNumber ?? PhoneNumber.parse('+33'),
                countrySelectorNavigator:
                const CountrySelectorNavigator.page(),
                onChanged: (phoneNumber) =>
                    provider.setPhoneNumber(phoneNumber),
                decoration: InputDecoration(
                  border:
                  buildOutlineInputBorder(AppColors.greyBordersColor),
                  focusedBorder: buildOutlineInputBorder(
                    AppColors.inputHintColor,
                  ),
                  errorBorder: buildOutlineInputBorder(AppColors.redColor),
                  focusedErrorBorder: buildOutlineInputBorder(AppColors.redColor),
                ),
                validator: PhoneValidator.valid(context), // Automatic validation per country
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

              CustomText(
                text: al.links,
                fontSize: sizes!.fontSize14,
                fontFamily: Assets.onsetMedium,
              ),
              SizedBox(height: getHeight() * .01),
              CustomField(
                textEditingController: websiteController,
                borderColor: AppColors.greyBordersColor,
                hint: "yoursite.io",
                prefixIconSvg: Assets.websiteIcon,
              ),
              SizedBox(height: getHeight() * .02),
              CustomField(
                textEditingController: instagramController,
                borderColor: AppColors.greyBordersColor,
                hint: "https://www.instagram.com/@yourhandle",
                prefixIconSvg: Assets.instagramIcon,
              ),
              SizedBox(height: getHeight() * .02),
              CustomField(
                textEditingController: twitterController,
                borderColor: AppColors.greyBordersColor,
                hint: "https://www.twitter.com/@yourhandle",
                prefixIconSvg: Assets.xIcon,
              ),
              SizedBox(height: getHeight() * .02),
              CustomField(
                textEditingController: facebookController,
                borderColor: AppColors.greyBordersColor,
                hint: "https://www.facebook.com/@yourhandle",
                prefixIconSvg: Assets.facebookIcon,
              ),
              SizedBox(height: getHeight() * .02),

              CustomField(
                textEditingController: descriptionController,
                height: getHeight() * .1,
                borderColor: AppColors.greyBordersColor,
                hint: al.writeSomethingBrief,
                label: al.briefDescription,
                maxLines: 3,
              ),
            ],

            SizedBox(height: getHeight() * .02),

            // Buttons
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

                    final role = context.read<RoleProvider>().role;

                    //  Only check links for restaurant / leisure / wellness
                    if (role != UserRole.user) {
                      String website = websiteController.text.trim();
                      String instagram = instagramController.text.trim();
                      String twitter = twitterController.text.trim();
                      String facebook = facebookController.text.trim();

                      //  Automatically prepend "https://" if missing
                      website = normalizeUrl(website);
                      instagram = normalizeUrl(instagram);
                      twitter = normalizeUrl(twitter);
                      facebook = normalizeUrl(facebook);

                      //  Validate links properly
                      if (website.isNotEmpty && !isValidWebsite(website)) {
                        Toasts.getErrorToast(text: "${al.validWebsiteLink} (e.g., https://www.example.com)");
                        return;
                      }
                      if (instagram.isNotEmpty && !isValidInstagram(instagram)) {
                        Toasts.getErrorToast(text: "${al.validInstagramLink} (e.g., https://instagram.com/username)");
                        return;
                      }
                      if (twitter.isNotEmpty && !isValidTwitter(twitter)) {
                        Toasts.getErrorToast(text: "${al.validTwitterLink} (e.g., https://x.com/username)");
                        return;
                      }
                      if (facebook.isNotEmpty && !isValidFacebook(facebook)) {
                        Toasts.getErrorToast(text: "${al.validFacebookLink} (e.g., https://facebook.com/username)");
                        return;
                      }

                      //  Update the controllers back to normalized URLs before upload
                      websiteController.text = website;
                      instagramController.text = instagram;
                      twitterController.text = twitter;
                      facebookController.text = facebook;
                    }


                    String? profileImageUrl;

                    if (provider.profilePhoto != null) {
                      // User selected a new image - upload it
                      final bytes = await provider.profilePhoto!.readAsBytes();
                      profileImageUrl = await networkProvider.getUrlForFileUpload(bytes);
                      if (profileImageUrl == null) {
                        Toasts.getErrorToast(text: al.failedToGetImageUrl);
                        return;
                      }
                    } else if (widget.isFromSettings && provider.profileImageUrl != null) {
                      // From settings and no new image selected - use existing URL
                      profileImageUrl = provider.profileImageUrl;
                    } else {
                      // No image available
                      Toasts.getErrorToast(text: al.selectProfileImage);
                      return;
                    }

                    final success = await provider.updateProfile(
                      address: roleProvider.role == UserRole.user
                          ? ""
                          : addressController.text,
                      password: passwordController.text,
                      website: roleProvider.role == UserRole.user
                          ? ""
                          : websiteController.text,
                      instagram: roleProvider.role == UserRole.user
                          ? ""
                          : instagramController.text,
                      twitter: roleProvider.role == UserRole.user
                          ? ""
                          : twitterController.text,
                      facebook: roleProvider.role == UserRole.user
                          ? ""
                          : facebookController.text,
                      description: descriptionController.text,
                      profileImageUrl: profileImageUrl!,
                    );

                    if (success && context.mounted) {
                      if(widget.isFromSettings) {
                        context.pop();
                        return;
                      }

                      if (role == UserRole.leisure) {
                        context.push(Routes.restaurantBottomTabRoute);
                      } else if(role == UserRole.restaurant) {
                        context.push(Routes.restaurantAddCuisineRoute);
                      } else if(role == UserRole.wellness) {
                        context.push(Routes.wellnessAddServicesRoute);
                      } else {
                        context.push(Routes.customerHomeRoute);
                      }
                    }
                  },
                  buttonWidth: getWidth() * .42,
                  backgroundColor:
                  AppColors.getPrimaryColorFromContext(context),
                  borderColor:
                  AppColors.getPrimaryColorFromContext(context),
                  textColor: AppColors.whiteColor,
                  textFontWeight: FontWeight.w700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  bool isValidWebsite(String url) {
    final pattern = RegExp(r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(\S*)?$');
    return pattern.hasMatch(url);
  }

  bool isValidInstagram(String url) {
    final pattern = RegExp(
        r'^(https?:\/\/)?(www\.)?instagram\.com\/([a-zA-Z0-9._](?:(?:[a-zA-Z0-9._]|(?:\.(?!\.))){0,28}(?:[a-zA-Z0-9._])))?\/?$'
    );
    return pattern.hasMatch(url.trim());
  }

  bool isValidTwitter(String url) {
    final pattern = RegExp(r'^(https?:\/\/)?(www\.)?(twitter\.com|x\.com)\/[A-Za-z0-9._%-]+\/?$');
    return pattern.hasMatch(url);
  }

  bool isValidFacebook(String url) {
    final pattern = RegExp(r'^(https?:\/\/)?(www\.)?facebook\.com\/[A-Za-z0-9._%-]+\/?$');
    return pattern.hasMatch(url);
  }
  String normalizeUrl(String url) {
    if (url.isEmpty) return url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }


}
