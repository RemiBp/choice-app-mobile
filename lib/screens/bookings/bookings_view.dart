import 'package:choice_app/providers/producer_provider.dart';
import 'package:choice_app/screens/bookings/cancelled_bookings.dart';
import 'package:choice_app/screens/bookings/completed_bookings.dart';
import 'package:choice_app/screens/bookings/in_progress_bookings.dart';
import 'package:choice_app/screens/bookings/upcoming_bookings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../appAssets/app_assets.dart';
import '../../appColors/colors.dart';
import '../../customWidgets/common_app_bar.dart';
import '../../res/res.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({super.key});

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProducerProvider>().loadBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: "Bookings",
        showBackArrow: false,
        hideBottomBorder: true,
      ),
      body: Column(
        children: [
          Container(
            height: getHeightRatio() * 40,
            padding: EdgeInsets.symmetric(vertical: getHeightRatio() * 6),
            child: TabBar(
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.getPrimaryColorFromContext(context),
              indicatorPadding: EdgeInsets.zero,
              unselectedLabelColor: AppColors.greyBordersColor,
              indicatorColor: AppColors.getPrimaryColorFromContext(context),
              indicatorWeight: 1.0,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: sizes?.fontSize14,
                fontFamily: Assets.onsetMedium,
                color: AppColors.whiteColor,
              ),
              // labelPadding: EdgeInsets.only(left: 0),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'In-Progress'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
          Expanded(
            // height: 400, // Adjust this height based on expected TabBarView content
            child: TabBarView(
              controller: _tabController,
              children: const [
                UpcomingBookings(),
                InProgressBookings(),
                CompletedBookings(),
                CancelledBookings(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
