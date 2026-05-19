import 'package:choice_app/providers/producer_provider.dart';
import 'package:choice_app/screens/leisure/leisure_about/leisure_about_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/restaurant_about/restaurant_about_view.dart';
import 'package:choice_app/userRole/user_role.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../res/res.dart';
import '../../../userRole/role_provider.dart';
import '../../restaurant/event/event_widgets.dart';
import '../../restaurant/profile_menu/profile_menu_widgets.dart';
import '../../restaurant/profile_menu/restaurant_choice_view.dart';
import '../../restaurant/profile_menu/restaurant_posts_view.dart';

class LeisureProfileTabBar extends StatefulWidget {
  const LeisureProfileTabBar({super.key});

  @override
  State<LeisureProfileTabBar> createState() => _LeisureProfileTabBarState();
}

class _LeisureProfileTabBarState extends State<LeisureProfileTabBar> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
    final role = context.read<RoleProvider>().role;
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
          Consumer<ProducerProvider>(
            builder: (context, producer, _) {
              final desc = producer.profile?['details'] as String? ??
                  producer.profile?['description'] as String? ??
                  '';
              if (desc.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomText(
                  text: desc,
                  textOverflow: TextOverflow.ellipsis,
                  fontSize: sizes?.fontSize16,
                  color: AppColors.primarySlateColor,
                  fontWeight: FontWeight.w400,
                  giveLinesAsText: true,
                ),
              );
            },
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
                      context.push('/chat');
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
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              labelColor: AppColors.getPrimaryColorFromContext(context),
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              indicatorColor: AppColors.getPrimaryColorFromContext(context),
              padding: EdgeInsets.zero,
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
                    label: 'Posts',
                    tabIndex: 1,
                    selectedTabIndex: _selectedTabIndex,
                  ),
                ),
                SizedBox(
                  width: getWidth() * 0.2,
                  child: ProfileTabItem(
                    iconPath: Assets.eventPngIcon,
                    label: 'Event',
                    tabIndex: 2,
                    selectedTabIndex: _selectedTabIndex,
                  ),
                ),
                SizedBox(
                  width: getWidth() * 0.2,
                  child: ProfileTabItem(
                    iconPath: Assets.aboutIcon,
                    label: 'About',
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
              children:  [
                RestaurantChoiceView(enableOnTap: true,),
                RestaurantPostsView(),
                ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return EventCard();
                  },
                ),
                role == UserRole.restaurant? RestaurantAboutView():LeisureAboutView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
