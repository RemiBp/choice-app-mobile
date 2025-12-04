import 'package:choice_app/res/strings.dart';
import 'package:choice_app/userRole/user_role.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import '../../../userRole/role_provider.dart';
import '../../restaurant/profile/profile_provider.dart';
import '../../restaurant/profile_menu/profile_menu_widgets.dart';
import '../../restaurant/profile_menu/restaurant_about/restaurant_about_view.dart';
import '../../restaurant/profile_menu/restaurant_choice_view.dart';
import '../../restaurant/profile_menu/restaurant_posts_view.dart';
import '../../restaurant/setting/setting_view.dart';
import '../leisure_about/leisure_about_view.dart';

class LeisureProfileView extends StatefulWidget {
  const LeisureProfileView({super.key});

  @override
  State<LeisureProfileView> createState() => _LeisureProfileViewState();
}

class _LeisureProfileViewState extends State<LeisureProfileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging ||
          _tabController.index != _selectedTabIndex) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color getTabColor(int tabIndex) {
    return _selectedTabIndex == tabIndex
        ? AppColors.getPrimaryColorFromContext(context)
        : AppColors.inputHintColor;
  }

  Color getImageColor(int tabIndex) {
    return _selectedTabIndex == tabIndex
        ? AppColors.getPrimaryColorFromContext(context)
        : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final userName = context.select<ProfileProvider, String>(
      (provider) => provider.getProducerProfileResponse?.producer?.name ?? "",
    );
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: ProfileMenuAppBar(
        userName: userName,
        onSwitchAccount: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return SwitchAccountBottomSheet(context: context);
            },
          );
        },
        onSetting: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingView()),
          );
        },
      ),
      body: Column(
        children: [
          SizedBox(height: getHeight() * 0.02),

          Selector<ProfileProvider, String>(
            selector:
                (context, provider) =>
                    provider.getProducerProfileResponse?.producer?.name ?? "",
            builder: (context, userName, _) {
              return RestaurantProfileHeader(userName: userName);
            },
          ),
          // CustomerProfileHeader(),
          SizedBox(height: getHeight() * 0.01),

          Selector<ProfileProvider, String>(
            selector:
                (context, provider) =>
                    provider
                        .getProducerProfileResponse
                        ?.businessProfile
                        ?.description ??
                    "",
            builder: (context, description, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomText(
                  text: description,
                  textOverflow: TextOverflow.ellipsis,
                  fontSize: sizes?.fontSize16,
                  color: AppColors.primarySlateColor,
                  fontWeight: FontWeight.w400,
                  giveLinesAsText: true,
                ),
              );
            },
          ),
          SizedBox(height: getHeight() * 0.01),
          Container(
            decoration: BoxDecoration(
              color: AppColors.greyColor,
              border: const Border(
                bottom: BorderSide(color: Color(0xFFEFEFEF)),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.getPrimaryColorFromContext(context),
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.getPrimaryColorFromContext(context),
              padding: EdgeInsets.zero,
              tabs: [
                ProfileTabItem(
                  iconPath: Assets.calenderIcon,
                  label: 'Choices',
                  tabIndex: 0,
                  selectedTabIndex: _selectedTabIndex,
                ),
                ProfileTabItem(
                  iconPath: Assets.postIcon,
                  label: al.posts,
                  tabIndex: 1,
                  selectedTabIndex: _selectedTabIndex,
                ),
                ProfileTabItem(
                  iconPath: Assets.aboutIcon,
                  label: al.about,
                  tabIndex: 2,
                  selectedTabIndex: _selectedTabIndex,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const RestaurantChoiceView(enableOnTap: true),
                const RestaurantPostsView(),
                if (roleProvider.role == UserRole.leisure)
                  const LeisureAboutView(),
                if (roleProvider.role == UserRole.restaurant)
                  const RestaurantAboutView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
