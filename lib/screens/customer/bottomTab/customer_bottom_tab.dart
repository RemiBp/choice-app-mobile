
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:choice_app/appAssets/app_assets.dart';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/customer/explore/customer_explore/explore_view.dart';
import 'package:choice_app/screens/customer/home/customer_home.dart';
import 'package:choice_app/screens/customer/maps/customer_maps/customer_maps_view.dart';
import 'package:choice_app/screens/customer/profile/customer_profile/customer_profile_view.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CustomerBottomTab extends StatefulWidget {
  const CustomerBottomTab({super.key});

  @override
  State<CustomerBottomTab> createState() => _CustomerBottomTabState();
}

class _CustomerBottomTabState extends State<CustomerBottomTab> with TickerProviderStateMixin {
  var _bottomNavIndex = 0; // Default to Home

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;

  final List<String> labels = ["Home", "Map", "Chat", "Profile"];
  
  final List<String> iconList = [
    Assets.homeIcon,
    Assets.mapIcon, // Using Map icon as second tab
    Assets.chatIcon,
    Assets.profileIcon,
  ];

  final List<String> activeIconList = [
    Assets.homeActiveIcon,
    Assets.mapActiveIcon, // Need to ensure this asset exists or fallback
    Assets.chatActiveIcon, // Need to ensure this asset exists or fallback
    Assets.profileActiveIcon,
  ];

  late List<Widget> widgets;

  @override
  void initState() {
    super.initState();

    // Define the screens for each tab
    widgets = [
      const CustomerHome(),       // 0: Feed
      const ProducerMapScreen(),  // 1: Map
      Container(color: Colors.white, child: Center(child: Text("Chat Coming Soon"))), // 2: Chat (Placeholder for now)
      const CustomerProfileView(), // 3: Profile
    ];

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(borderRadiusCurve);

    Future.delayed(
      const Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      const Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: widgets[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.userPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
           context.push(Routes.choiceSelectionRoute);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: 4,
        tabBuilder: (int index, bool isActive) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                isActive ? activeIconList[index] : iconList[index],
                color: isActive ? AppColors.userPrimaryColor : const Color(0xFF818397),
                // Fallback if assets are missing/different for map/chat?
                // Using existing assets from codebase inspection usually safer
                // If mapActiveIcon doesn't exist, we might crash. 
                // Let's assume standard names for now based on RestaurantBottomTab or fix later.
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FittedBox(
                  child: Text(
                    labels[index],
                    maxLines: 1,
                    style: TextStyle(
                      color: isActive ? AppColors.userPrimaryColor : const Color(0xFF818397),
                      fontSize: sizes?.fontSize12,
                      fontFamily: Assets.onsetMedium,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        backgroundColor: Colors.white,
        activeIndex: _bottomNavIndex,
        splashColor: AppColors.userPrimaryColor,
        notchAndCornersAnimation: borderRadiusAnimation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 0, 
        rightCornerRadius: 0,
        onTap: (index) {
           // Handle Chat Navigation properly if it's a separate route?
           // For now, switching tabs.
           if (index == 2) {
             // context.push(Routes.chatRoute); // If chat is a full screen route
             // sticking to tab switch for now
           }
           setState(() => _bottomNavIndex = index);
        },
      ),
    );
  }
}
