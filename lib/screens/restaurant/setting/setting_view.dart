import 'package:choice_app/l18n.dart';
import 'package:choice_app/screens/languageSelection/language_selection.dart';
import 'package:choice_app/screens/onboarding/add_cuisine/add_cuisine.dart';
import 'package:choice_app/screens/onboarding/add_services/add_services.dart';
import 'package:choice_app/screens/onboarding/day_off/days_off_view.dart';
import 'package:choice_app/screens/onboarding/gallery/gallery_view.dart';
import 'package:choice_app/screens/onboarding/slot_management/slot_management_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/blocked_users/blocked_users_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/bookmarked/bookmarked_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/chat_view.dart';
import 'package:choice_app/screens/restaurant/setting/setting_widgets.dart';
import 'package:choice_app/userRole/user_role.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/routes.dart';
import '../profile/profile_provider.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../res/res.dart';
import '../../../userRole/role_provider.dart';
import '../../onboarding/business_hours/edit_business_hours/edit_operational_hours.dart';
import '../../onboarding/menu/menu_view.dart';
import '../profile/profile.dart';
import '../profile_menu/badges/badges_view.dart';
import '../profile_menu/profile_menu_widgets.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    final role = context.read<RoleProvider>().role;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: al.setting,
      ),
      body: Column(
        children: [
          Expanded(
            child:
            // child: provider.isDetailsFetched && provider.isProfileFetched?
            ListView(
              padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding, vertical: getHeightRatio() * 20),
              children: [
                SettingHeader(),
                SizedBox(height: getHeight() * 0.02),
                ProfileOptionButton(
                  title: al.editProfile,
                  leadingAssetPath: Assets.editProfileIcon,
                  onTap: () {
                    context.push(Routes.restaurantProfileRoute);
                  },
                ),
                ProfileOptionButton(
                  title: al.changePassword,
                  leadingAssetPath: Assets.passwordManagerIcon,
                  onTap: () {
                    context.push(Routes.resetPasswordRoute);
                  },
                ),
                if(role == UserRole.user)
                  ProfileOptionButton(
                    title: "Badge & XP",
                    leadingAssetPath: Assets.badgeIcon,
                    onTap: () {
                      context.push(Routes.badgesRoute);
                    },
                  ),
                if(role == UserRole.user)
                  ProfileOptionButton(
                    title: "Bookmarked",
                    leadingAssetPath: Assets.bookmarkIcon,
                    onTap: () {
                      context.push(Routes.bookmarkedRoute);
                    },
                  ),
                if(role == UserRole.user)
                  ProfileOptionButton(
                    title: "Blocked List",
                    leadingAssetPath: Assets.blockUserIcon,
                    onTap: () {
                      context.push(Routes.blockedUsersRoute);
                    },
                  ),
// ...
                if(role == UserRole.restaurant || role == UserRole.wellness)
                ProfileOptionButton(
                  title: al.businessHours,
                  leadingAssetPath: Assets.businessHourIcon,
                  onTap: () {
                    context.push(Routes.restaurantEditBusinessHoursRoute);
                  },
                ),
                if(role == UserRole.restaurant || role == UserRole.wellness)
                ProfileOptionButton(
                  title: al.manageSlots,
                  leadingAssetPath: Assets.slotsIcon,
                  onTap: () {
                    context.push(Routes.restaurantSlotManagementRoute);
                  },
                ),
                if(role == UserRole.restaurant)
                ProfileOptionButton(
                  title: al.menu,
                  leadingAssetPath: Assets.menuIcon,
                  onTap: () {
                    context.push(Routes.restaurantMenuRoute);
                  },
                ),
                if(role == UserRole.wellness)
                ProfileOptionButton(
                  title: al.services,
                  leadingAssetPath: Assets.businessHourIcon,
                  onTap: () {
                    context.push(Routes.restaurantServicesRoute);
                  },
                ),
                if(role == UserRole.restaurant || role == UserRole.wellness)
                ProfileOptionButton(
                  title: "Gallery",
                  leadingAssetPath: Assets.galleryIcon,
                  onTap: () {
                    context.push(Routes.restaurantGalleryRoute);
                  },
                ),
                if(role == UserRole.restaurant || role == UserRole.wellness)
                ProfileOptionButton(
                  title: al.unavailability,
                  leadingAssetPath: Assets.unavailabilityIcon,
                  onTap: () {
                    context.push(Routes.restaurantUnavailabilityRoute);
                  },
                ),
                if(role == UserRole.restaurant)
                ProfileOptionButton(
                  title: "Payment Methods", // Localize later
                  leadingAssetPath: Assets.menuIcon, // Ideally use a payment icon
                  onTap: () {
                    context.push(Routes.restaurantPaymentMethodsRoute);
                  },
                ),
                if(role == UserRole.restaurant)
                ProfileOptionButton(
                  title: al.cuisine,
                  leadingAssetPath: Assets.businessHourIcon,
                  onTap: () {
                    context.push(Routes.restaurantCuisineRoute);
                  },
                ),
                ProfileOptionButton(
                  title: al.language,
                  leadingAssetPath: Assets.languageIcon,
                  onTap: () {
                    context.push(Routes.languageSelectionRoute);
                  },
                ),
                ProfileOptionButton(
                  title: al.logout,
                  leadingAssetPath: Assets.logoutIcon,
                  onTap: () {
                    // TODO: Clear Token from Storage
                    // final storage = const FlutterSecureStorage();
                    // await storage.deleteAll();
                    context.go(Routes.loginRoute);
                  },
                ),
                  CustomButton(
                    buttonText: al.deleteAccount,
                    onTap: () async {
                       // Confirm dialog could be good, but for now wire the API
                       final provider = context.read<ProfileProvider>();
                       final success = await provider.deleteAccount();
                       if (success && context.mounted) {
                          context.go(Routes.signupRoute);
                       } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text("Failed to delete account")),
                          );
                       }
                    },
                    backgroundColor: Colors.transparent,
                  borderColor: AppColors.redColor,
                  textColor: AppColors.redColor,
                  textFontWeight: FontWeight.w700,
                ),
              ],
            )
        // :
        //     const Center(
        //       child: CircularProgressIndicator(),
        //     ),
          ),
        ],
      ),
    );
  }
}
