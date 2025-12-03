import 'package:choice_app/screens/wellness/wellness_about/wellness_about_view.dart';
import 'package:flutter/material.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import '../../restaurant/event/event_widgets.dart';
import '../../restaurant/profile_menu/chat_view.dart';
import '../../restaurant/profile_menu/profile_menu_widgets.dart';
import '../../restaurant/profile_menu/restaurant_choice_view.dart';
import '../../restaurant/profile_menu/restaurant_posts_view.dart';
import '../../restaurant/setting/setting_view.dart';

class WellnessProfileTabBar extends StatefulWidget {
  const WellnessProfileTabBar({super.key});

  @override
  State<WellnessProfileTabBar> createState() => _WellnessProfileTabBarState();
}

class _WellnessProfileTabBarState extends State<WellnessProfileTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!mounted) return;
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
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: ProfileMenuAppBar(
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
          RestaurantProfileHeader(),
          SizedBox(height: getHeight() * 0.01),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomText(
              text:
                  'Lorem ipsum dolor sit amet consectetur. Nunc aliquam eu risus nibh quis consectetur.',
              textOverflow: TextOverflow.ellipsis,
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              fontWeight: FontWeight.w400,
              giveLinesAsText: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sizes!.pagePadding,
              vertical: getHeight() * 0.02,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CardButton(
                    buttonText: al.follow,
                    onTap: () {},
                    textColor: Colors.white,
                    textFontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: getWidth() * 0.03),
                Expanded(
                  child: CardButton(
                    buttonText: al.message,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatView()),
                      );
                    },
                    backgroundColor: AppColors.greyColor,
                    textColor: AppColors.blackColor,
                    textFontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: getWidth() * 0.03),
                // Expanded(
                //   child: CardButton(
                //     buttonText: 'Call',
                //     onTap: () {
                //     },
                //     backgroundColor: AppColors.greyColor,
                //     textColor: AppColors.blackColor,
                //     textFontWeight: FontWeight.w700,
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.greyColor,
              border: const Border(
                bottom: BorderSide(color: Color(0xFFEFEFEF)),
              ),
            ),
            child: TabBar(
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              labelColor: AppColors.getPrimaryColorFromContext(context),
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.getPrimaryColorFromContext(context),
              padding: EdgeInsets.zero,
              isScrollable: true,
              indicatorWeight: 1.0,
              tabs: [
                SizedBox(
                  width: getWidth() * 0.2,
                  child: ProfileTabItem(
                    iconPath: Assets.choiceIcon,
                    label: 'Choices',
                    tabIndex: 0,
                    selectedTabIndex: _selectedTabIndex,
                  ),
                ),
                SizedBox(
                  width: getWidth() * 0.2,
                  child: ProfileTabItem(
                    iconPath: Assets.postIcon,
                    label: al.posts,
                    tabIndex: 1,
                    selectedTabIndex: _selectedTabIndex,
                  ),
                ),
                SizedBox(
                  width: getWidth() * 0.2,
                  child: ProfileTabItem(
                    iconPath: Assets.eventPngIcon,
                    label: al.event,
                    tabIndex: 2,
                    selectedTabIndex: _selectedTabIndex,
                  ),
                ),
                SizedBox(
                  width: getWidth() * 0.2,
                  child: ProfileTabItem(
                    iconPath: Assets.aboutIcon,
                    label: al.about,
                    tabIndex: 3,
                    selectedTabIndex: _selectedTabIndex,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RestaurantChoiceView(),
                RestaurantPostsView(),
                ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return EventCard();
                  },
                ),
                WellnessAboutView(),
                // RestaurantAboutView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
