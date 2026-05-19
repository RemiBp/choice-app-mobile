import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../res/res.dart';
import '../../restaurant/profile_menu/profile_menu_widgets.dart';
import '../../restaurant/profile_menu/restaurant_choice_view.dart';
import '../../restaurant/profile_menu/restaurant_posts_view.dart';
import '../wellness_about/wellness_about_view.dart';

class WellnessProfileView extends StatefulWidget {
  const WellnessProfileView({super.key});

  @override
  State<WellnessProfileView> createState() => _WellnessProfileViewState();
}

class _WellnessProfileViewState extends State<WellnessProfileView> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!mounted) return;
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
      appBar: ProfileMenuAppBar(
        onSwitchAccount: (){
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return SwitchAccountBottomSheet(context: context);
            },
          );
        },
        onSetting: () {
          context.push('/setting');
        },
      ),
      body: Column(
        children: [
          SizedBox(height: getHeight() * 0.02),
          RestaurantProfileHeader(),
          // CustomerProfileHeader(),
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
                  iconPath: Assets.choiceIcon,
                  label: 'Choices',
                  tabIndex: 0,
                  selectedTabIndex: _selectedTabIndex,
                ),
                ProfileTabItem(
                  iconPath: Assets.postIcon,
                  label: 'Posts',
                  tabIndex: 1,
                  selectedTabIndex: _selectedTabIndex,
                ),
                ProfileTabItem(
                  iconPath: Assets.aboutIcon,
                  label: 'About',
                  tabIndex: 2,
                  selectedTabIndex: _selectedTabIndex,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                RestaurantChoiceView(enableOnTap: true,),
                RestaurantPostsView(),
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
