import 'package:choice_app/screens/restaurant/profile_menu/profile_menu_widgets.dart';
import 'package:choice_app/screens/restaurant/profile_menu/restaurant_choice_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/restaurant_posts_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../res/res.dart';

class CustomerProfileTabBar extends StatefulWidget {
  const CustomerProfileTabBar({super.key});

  @override
  State<CustomerProfileTabBar> createState() => _CustomerProfileTabBarState();
}

class _CustomerProfileTabBarState extends State<CustomerProfileTabBar> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.index != _selectedTabIndex) {
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
      appBar: ProfileMenuDetailAppBar(
        onSwitchAccount: (){
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return SwitchAccountBottomSheet(context: context);
            },
          );
        },
        onBlock: (){
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return BlockUserBottomSheet(context: context);
            },
          );
        },
        onReport: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return ReportBottomSheet(context: context);
            },
          );
        },
      ),
      body: Column(
        children: [
          SizedBox(height: getHeight() * 0.02),
          CustomerProfileHeader(),
          SizedBox(height: getHeight() * 0.01),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomText(
              text: 'Lorem ipsum dolor sit amet consectetur. Nunc aliquam eu risus nibh quis consectetur.',
              textOverflow: TextOverflow.ellipsis,
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              fontWeight: FontWeight.w400,
              giveLinesAsText: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding, vertical: getHeight() * 0.02),
            child: Row(
              children: [
                Expanded(
                  child: CardButton(
                    buttonText: 'Follow',
                    onTap: () {

                    },
                    textColor: Colors.white,
                    textFontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: getWidth() * 0.03),
                Expanded(
                  child: CardButton(
                    buttonText: 'Message',
                    onTap: () {
                      context.push('/user_chat');
                    },
                    backgroundColor: AppColors.greyColor,
                    textColor: AppColors.blackColor,
                    textFontWeight: FontWeight.w700,
                  ),
                ),
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
                  iconPath: Assets.priceIcon,
                  label: 'Interest',
                  tabIndex: 1,
                  selectedTabIndex: _selectedTabIndex,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                RestaurantChoiceView(),
                RestaurantPostsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
