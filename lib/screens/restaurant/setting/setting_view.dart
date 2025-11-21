import 'package:choice_app/l18n.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/passwordManagement/change_password.dart';
import 'package:choice_app/screens/customer/profile/customer_profile/customer_edit_profile.dart';
import 'package:choice_app/screens/languageSelection/language_selection.dart';
import 'package:choice_app/screens/onboarding/add_cuisine/add_cuisine.dart';
import 'package:choice_app/screens/onboarding/add_services/add_services.dart';
import 'package:choice_app/screens/onboarding/day_off/days_off_view.dart';
import 'package:choice_app/screens/onboarding/gallery/gallery_view.dart';
import 'package:choice_app/screens/onboarding/slot_management/slot_management_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/blocked_users/blocked_users_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/bookmarked/bookmarked_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/documents/view_documents.dart';
import 'package:choice_app/screens/restaurant/setting/setting_widgets.dart';
import 'package:choice_app/userRole/user_role.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../res/res.dart';
import '../../../userRole/role_provider.dart';
import '../../authentication/auth_provider.dart';
import '../../onboarding/business_hours/edit_business_hours/edit_operational_hours.dart';
import '../../onboarding/menu/menu_view.dart';

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
      appBar: CommonAppBar(title: al.setting),
      body: Column(
        children: [
          Expanded(
            child:
            // child: provider.isDetailsFetched && provider.isProfileFetched?
            ListView(
              padding: EdgeInsets.symmetric(
                horizontal: sizes!.pagePadding,
                vertical: getHeightRatio() * 20,
              ),
              children: [
                SettingHeader(),
                SizedBox(height: getHeight() * 0.02),
                ProfileOptionButton(
                  title: al.editProfile,
                  leadingAssetPath: Assets.editProfileIcon,
                  onTap: () {
                    if (role == UserRole.user) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerEditProfile(),
                        ),
                      );
                    } else {
                      context.push(Routes.restaurantProfileRoute, extra: true);
                    }
                  },
                ),
                ProfileOptionButton(
                  title: al.changePassword,
                  leadingAssetPath: Assets.passwordManagerIcon,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePassword()),
                    );
                  },
                ),
                ProfileOptionButton(
                  title: al.subscription,
                  leadingAssetPath: Assets.subscriptionIcon, // your custom icon
                  trailingText: 'Free Plan',
                  onTap: () {
                    context.push(Routes.subscribeRoute);
                  },
                ),
                // if(role == UserRole.user)
                //   ProfileOptionButton(
                //     title: "Badge & XP",
                //     leadingAssetPath: Assets.badgeIcon,
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => BadgesView()),
                //       );
                //     },
                //   ),
                if (role == UserRole.user)
                  ProfileOptionButton(
                    title: al.location,
                    leadingAssetPath: Assets.locationIcon,
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => BadgesView()),
                      // );
                    },
                  ),
                if (role == UserRole.user)
                  ProfileOptionButton(
                    title: al.bookmarked,
                    leadingAssetPath: Assets.bookmarkIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookmarkedView(),
                        ),
                      );
                    },
                  ),
                if (role == UserRole.user)
                  ProfileOptionButton(
                    title: al.blockedList,
                    leadingAssetPath: Assets.blockUserIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlockedUsersView(),
                        ),
                      );
                    },
                  ),
                if (!(role == UserRole.user))
                  ProfileOptionButton(
                    title: al.documents,
                    leadingAssetPath: Assets.documentsIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DocumentsScreen()),
                      );
                    },
                  ),
                if (role == UserRole.restaurant || role == UserRole.wellness)
                  ProfileOptionButton(
                    title: al.businessHours,
                    leadingAssetPath: Assets.businessHourIcon,
                    onTap: () {
                      context.push(Routes.editOperationHoursRoute, extra: true);
                    },
                  ),
                if (role == UserRole.restaurant || role == UserRole.wellness)
                  ProfileOptionButton(
                    title: al.manageSlots,
                    leadingAssetPath: Assets.slotsIcon,
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => SlotManagementView(
                      //     isHomeFlow: false,
                      //     isEdit: true,
                      //   )),
                      // );
                      context.push(
                        Routes.slotManagementViewRoute,
                        extra: {'isHomeFlow': false, 'isEdit': true},
                      );
                    },
                  ),
                if (role == UserRole.restaurant)
                  ProfileOptionButton(
                    title: al.menu,
                    leadingAssetPath: Assets.menuIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuView()),
                      );
                    },
                  ),
                if (role == UserRole.wellness)
                  ProfileOptionButton(
                    title: al.services,
                    leadingAssetPath: Assets.businessHourIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddServices()),
                      );
                    },
                  ),
                if (role == UserRole.restaurant || role == UserRole.wellness)
                  ProfileOptionButton(
                    title: al.gallery,
                    leadingAssetPath: Assets.galleryIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GalleryView()),
                      );
                    },
                  ),
                if (role == UserRole.restaurant || role == UserRole.wellness)
                  ProfileOptionButton(
                    title: al.unavailability,
                    leadingAssetPath: Assets.unavailabilityIcon,
                    onTap: () {
                      context.push(Routes.daysOffRoute);
                    },
                  ),
                // if (role == UserRole.restaurant)
                //   ProfileOptionButton(
                //     title: al.cuisine,
                //     leadingAssetPath: Assets.businessHourIcon,
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => AddCuisine()),
                //       );
                //     },
                //   ),
                ProfileOptionButton(
                  title: al.language,
                  leadingAssetPath: Assets.languageIcon,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => LanguageSelection(isFromProfile: true),
                      ),
                    ).then((e){setState(() {});});
                  },
                ),
                ProfileOptionButton(
                  title: al.logout,
                  leadingAssetPath: Assets.logoutIcon,
                  onTap: () {
                    final authProvider = context.read<AuthProvider>();
                    authProvider.logout(context);
                  },
                ),
                CustomButton(
                  buttonText: al.deleteAccount,
                  onTap: () {},
                  backgroundColor: Colors.transparent,
                  borderColor: AppColors.redColor,
                  textColor: AppColors.redColor,
                  textFontWeight: FontWeight.w700,
                ),
              ],
            ),
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
