import 'package:choice_app/l18n.dart';
import 'package:choice_app/providers/producer_provider.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/services/auth_service.dart';
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

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProducerProvider>().loadProfile();
    });
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) context.go(Routes.authRoute);
  }

  @override
  Widget build(BuildContext context) {
    AppTranslations.init(context);
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => BookingsView()),
                    // );
                  },
                ),
                if(role == UserRole.user)
                  ProfileOptionButton(
                    title: "Badge & XP",
                    leadingAssetPath: Assets.badgeIcon,
                    onTap: () {
                      context.push('/badges');
                    },
                  ),
                if(role == UserRole.user)
                  ProfileOptionButton(
                    title: "Bookmarked",
                    leadingAssetPath: Assets.bookmarkIcon,
                    onTap: () {
                      context.push('/bookmarked');
                    },
                  ),
                if(role == UserRole.user)
                  ProfileOptionButton(
                    title: "Blocked List",
                    leadingAssetPath: Assets.blockUserIcon,
                    onTap: () {
                      context.push('/blocked_users');
                    },
                  ),
                if(!(role == UserRole.user))
                ProfileOptionButton(
                  title: al.documents,
                  leadingAssetPath: Assets.documentsIcon,
                  onTap: () {},
                ),
                if(role == UserRole.restaurant || role == UserRole.wellness)
                ProfileOptionButton(
                  title: al.businessHours,
                  leadingAssetPath: Assets.businessHourIcon,
                  onTap: () {
                    context.push('/edit_business_hours');
                  },
                ),
                if(role == UserRole.restaurant || role == UserRole.wellness)
                ProfileOptionButton(
                  title: al.manageSlots,
                  leadingAssetPath: Assets.slotsIcon,
                  onTap: () {
                    context.push('/slot_management');
                  },
                ),
                if(role == UserRole.restaurant)
                ProfileOptionButton(
                  title: al.menu,
                  leadingAssetPath: Assets.menuIcon,
                  onTap: () {
                    context.push('/menu');
                  },
                ),
                if(role == UserRole.wellness)
                ProfileOptionButton(
                  title: al.services,
                  leadingAssetPath: Assets.businessHourIcon,
                  onTap: () {
                    context.push('/add_services');
                  },
                ),
                if(role == UserRole.restaurant || role == UserRole.wellness)
                ProfileOptionButton(
                  title: "Gallery",
                  leadingAssetPath: Assets.galleryIcon,
                  onTap: () {
                    context.push('/gallery');
                  },
                ),
                if(role == UserRole.restaurant || role == UserRole.wellness)
                ProfileOptionButton(
                  title: al.unavailability,
                  leadingAssetPath: Assets.unavailabilityIcon,
                  onTap: () {
                    context.push('/days_off');
                  },
                ),
                if(role == UserRole.restaurant)
                ProfileOptionButton(
                  title: al.cuisine,
                  leadingAssetPath: Assets.businessHourIcon,
                  onTap: () {
                    context.push('/add_cuisine');
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
                  onTap: _logout,
                ),
                CustomButton(
                  buttonText: al.deleteAccount,
                  onTap: () {

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
