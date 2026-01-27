import 'package:choice_app/screens/restaurant/dashboard/dashboard_provider.dart';
import 'package:choice_app/screens/restaurant/dashboard/rating_by_theme_card.dart';
import 'package:choice_app/screens/restaurant/dashboard/repeat_customers_card.dart';
import 'package:choice_app/screens/restaurant/dashboard/user_origin_map_card.dart';
import 'package:choice_app/screens/restaurant/notifications/notifications_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/animations/fade_in_up.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../res/res.dart';
import 'booking_chart_card.dart';
import 'customers_chart_card.dart';
import 'dashboard_card.dart';
import 'dish_drop_alert_cart.dart';
import 'home_app_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<DashboardProvider>().fetchDashboardData(),
          color: AppColors.restaurantPrimaryColor,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Consumer<DashboardProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.overview == null) {
                  return SizedBox(
                    height: getHeight() * 0.8,
                    child: Center(child: CircularProgressIndicator(color: AppColors.restaurantPrimaryColor)),
                  );
                }

                if (provider.errorMessage != null && provider.overview == null) {
                  return SizedBox(
                    height: getHeight() * 0.8,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red),
                          SizedBox(height: 16),
                          CustomText(text: "Failed to load dashboard data"),
                          TextButton(
                            onPressed: () => provider.fetchDashboardData(),
                            child: Text("Retry"),
                          )
                        ],
                      ),
                    ),
                  );
                }

                final ov = provider.overview;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      delay: Duration(milliseconds: 0),
                      child: HomeAppBar(
                        isSeen: false,
                        onNotificationTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NotificationsView()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: getHeightRatio() * 20),
                    
                    FadeInUp(
                      delay: Duration(milliseconds: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DashboardCard(
                            width: getWidth() * 0.44,
                            header: "Total Posts",
                            price: ov?['totalPosts']?.toString() ?? "0",
                          ),
                          DashboardCard(
                            width: getWidth() * 0.44,
                            header: "Followers",
                            price: ov?['totalFollowers']?.toString() ?? "0",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    FadeInUp(
                      delay: Duration(milliseconds: 200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DashboardCard(
                            width: getWidth() * 0.44,
                            header: "Bookings",
                            price: ov?['totalBookings']?.toString() ?? "0",
                          ),
                          DashboardCard(
                            width: getWidth() * 0.44,
                            header: "Avg Rating",
                            price: ov?['averageRating']?.toString() ?? "0.0",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Trends Section
                    CustomText(
                      text: "User Origins",
                      fontSize: sizes?.fontSize18,
                      fontFamily: Assets.onsetSemiBold,
                    ),
                    SizedBox(height: 12),
                    FadeInUp(
                      delay: Duration(milliseconds: 300),
                      child: UserOriginMapCard(),
                    ),
                    SizedBox(height: 24),
                    
                    FadeInUp(delay: Duration(milliseconds: 400), child: const CustomersChartCard()),
                    SizedBox(height: 16),
                    FadeInUp(delay: Duration(milliseconds: 500), child: const BookingChartCard()),
                    SizedBox(height: 16),
                    FadeInUp(delay: Duration(milliseconds: 600), child: const RepeatCustomersCard()),
                    SizedBox(height: 16),
                    
                    FadeInUp(
                      delay: Duration(milliseconds: 700),
                      child: MostChosenDishCard(
                        header: "Favorite of the month",
                        price: "Crème Brûlée",
                        percentage: "85",
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    FadeInUp(delay: Duration(milliseconds: 800), child: const DishDropAlertsCard()),
                    SizedBox(height: 16),
                    FadeInUp(delay: Duration(milliseconds: 900), child: const RatingsByThemeCard()),
                    SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
