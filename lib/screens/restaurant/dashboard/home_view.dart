import 'package:choice_app/providers/producer_provider.dart';
import 'package:choice_app/screens/restaurant/dashboard/rating_by_theme_card.dart';
import 'package:choice_app/screens/restaurant/dashboard/repeat_customers_card.dart';
import 'package:choice_app/screens/restaurant/dashboard/user_origin_map_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../appColors/colors.dart';
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
      context.read<ProducerProvider>().loadDashboard();
      context.read<ProducerProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Consumer<ProducerProvider>(
          builder: (context, provider, _) {
            final overview = provider.dashboardOverview;
            final String Function(String) stat = (key) =>
                overview?[key]?.toString() ?? '—';

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeAppBar(
                    isSeen: provider.notifications.isEmpty,
                    onNotificationTap: () {
                      context.push('/notifications');
                    },
                  ),
                  if (provider.isLoadingDashboard)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  SizedBox(height: getHeightRatio() * 16),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardCard(
                          header: "Profile Views",
                          price: stat('profileViews'),
                        ),
                      ),
                      SizedBox(width: getHeightRatio() * 12),
                      Expanded(
                        child: DashboardCard(
                          header: "Bookmarks",
                          price: stat('bookmarksCount'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getHeightRatio() * 16),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardCard(
                          header: "Choices Made",
                          price: stat('choicesMade'),
                        ),
                      ),
                      SizedBox(width: getHeightRatio() * 12),
                      Expanded(
                        child: DashboardCard(
                          header: "Conversion Rate",
                          price: stat('conversionRate'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getHeightRatio() * 16),
                  DashboardCard(
                    header: "Post Conversion Rate",
                    price: stat('postConversionRate'),
                  ),
                  SizedBox(height: getHeightRatio() * 16),
                  DashboardCard(
                    header: "Favorite choice of the month",
                    price: stat('favoriteChoiceOfMonth'),
                    duration: "This Week",
                  ),
                  SizedBox(height: getHeightRatio() * 16),
                  UserOriginMapCard(),
                  SizedBox(height: getHeightRatio() * 16),
                  const CustomersChartCard(),
                  SizedBox(height: getHeightRatio() * 16),
                  const BookingChartCard(),
                  SizedBox(height: getHeightRatio() * 16),
                  const RepeatCustomersCard(),
                  SizedBox(height: getHeightRatio() * 16),
                  MostChosenDishCard(
                    header: "Most Chosen Dish",
                    price: stat('mostChosenDish'),
                  ),
                  SizedBox(height: getHeightRatio() * 16),
                  const DishDropAlertsCard(),
                  SizedBox(height: getHeightRatio() * 16),
                  const RatingsByThemeCard(),
                  SizedBox(height: getHeight() * 0.025),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
