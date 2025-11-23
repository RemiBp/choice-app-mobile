import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:choice_app/screens/bookings/bookings_view.dart';
import 'package:choice_app/screens/customer/home/customer_home.dart';
import 'package:choice_app/screens/customer/maps/customer_maps/customer_maps_view.dart';
import 'package:choice_app/screens/leisure/home/leisure_home.dart';
import 'package:choice_app/screens/producer_maps/heatmap.dart';
import 'package:choice_app/screens/restaurant/dashboard/home_view.dart';
import 'package:choice_app/screens/restaurant/event/events.dart';
import 'package:choice_app/screens/restaurant/home/restaurant_home.dart';
import 'package:choice_app/screens/wellness/home/welness_home.dart';
import 'package:choice_app/userRole/role_provider.dart';
import 'package:choice_app/userRole/user_role.dart';
import 'package:choice_app/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import '../../customer/explore/customer_explore/explore_view.dart';
import '../../customer/profile/customer_profile/customer_profile_view.dart';

class RestaurantBottomTab extends StatefulWidget {
  const RestaurantBottomTab({super.key});

  @override
  State<RestaurantBottomTab> createState() => _RestaurantBottomTabState();
}

class _RestaurantBottomTabState extends State<RestaurantBottomTab>
    with TickerProviderStateMixin {
  var _bottomNavIndex = 0;

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;
  UserRole role = UserRole.restaurant;

  late List<String> labels;
  late List<String> iconList;
  late List<String> activeIconList;

  List<Widget> widgets = [

  ];

  @override
  void initState() {
    super.initState();
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    role = roleProvider.role;
    if (role == UserRole.user) {
      // USER
      labels = [al.home, al.map, al.explore, al.bookings, al.profile];
      iconList = [
        Assets.homeIcon,
        Assets.mapIcon,
        Assets.exploreIcon,
        Assets.bookingIcon,
        Assets.profileIcon
      ];
      activeIconList = [
        Assets.homeActiveIcon,
        Assets.mapIcon,
        Assets.exploreActiveIcon,
        Assets.bookingActiveIcon,
        Assets.profileActiveIcon
      ];
      widgets = [
        CustomerHome(),
        CustomerMapsView(),
        ExploreView(),
        BookingsView(),
        CustomerProfileView()
      ];
    }
    else {
      // PRODUCER (restaurant / leisure / wellness)
      if (role == UserRole.wellness) {
        // WELLNESS → NO EVENTS TAB
        labels = [
          al.home,
          al.dashboard,
          al.map,
          al.bookings
        ];

        iconList = [
          Assets.homeIcon,
          Assets.dashboardIcon,
          Assets.mapIcon,
          Assets.bookingIcon,
        ];

        activeIconList = [
          Assets.homeActiveIcon,
          Assets.dashboardActiveIcon,
          Assets.mapIcon,
          Assets.bookingActiveIcon,
        ];

        widgets = [
          WellnessHome(),
          HomeView(),        // dashboard
          HeatmapScreen(),   // map
          BookingsView(),
        ];

      } else {
        // RESTAURANT & LEISURE → EVENTS VISIBLE
        labels = [
          al.home,
          al.dashboard,
          al.map,
          al.events,
          al.bookings
        ];

        iconList = [
          Assets.homeIcon,
          Assets.dashboardIcon,
          Assets.mapIcon,
          Assets.eventsIcon,
          Assets.bookingIcon,
        ];

        activeIconList = [
          Assets.homeActiveIcon,
          Assets.dashboardActiveIcon,
          Assets.mapIcon,
          Assets.eventActiveIcon,
          Assets.bookingActiveIcon,
        ];

        widgets = [
          if (role == UserRole.restaurant) RestaurantHome(),
          if (role == UserRole.leisure) LeisureHome(),
          HomeView(),        // dashboard
          HeatmapScreen(),   // map
          Events(),          // ONLY restaurant & leisure
          BookingsView(),
        ];
      }
    }
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
    borderRadiusAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(borderRadiusCurve);

    _hideBottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      const Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      const Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          _fabAnimationController.forward(from: 0);
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          _fabAnimationController.reverse(from: 1);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomInset: false,
      body: NavigationScreen(widgets[_bottomNavIndex]),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                isActive ? activeIconList[index] : iconList[index],
                colorFilter: isActive
                    ? ColorFilter.mode(
                    AppColors.getPrimaryColorFromContext(context),
                    BlendMode.srcIn
                )
                    : null,
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FittedBox(
                  child: Text(
                    labels[index],
                    maxLines: 1,
                    style: TextStyle(
                      color:
                          isActive
                              ? AppColors.getPrimaryColorFromContext(context)
                              : HexColor.fromHex("#818397"),
                      fontSize: sizes?.fontSize12,
                      fontFamily: Assets.onsetMedium,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        backgroundColor: AppColors.whiteColor,
        height: getHeight() * .1,
        activeIndex: _bottomNavIndex,
        splashColor: AppColors.getPrimaryColorFromContext(context),
        notchAndCornersAnimation: borderRadiusAnimation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.none,
        // leftCornerRadius: 32,
        // rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        // shadow: BoxShadow(
        //   offset: const Offset(0, 1),
        //   blurRadius: 12,
        //   spreadRadius: 0.5,
        //   color: colors.activeNavigationBarColor,
        // ),
      ),
    );
  }
}

class NavigationScreen extends StatelessWidget {
  final Widget widget;

  const NavigationScreen(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: widget);
  }
}
