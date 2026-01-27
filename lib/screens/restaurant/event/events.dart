import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/restaurant/event/event_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import 'event_provider.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().fetchMyEvents();
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
      appBar: AppBar(
        title: CustomText(
          text: "Events",
          fontSize: sizes?.fontSize18,
          fontFamily: Assets.onsetSemiBold,
        ),
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.myEvents.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.myEvents.isEmpty) {
            return buildEmptyState();
          }

          final events = provider.myEvents;
          final activeEvents = events.where((e) => e['status'] == 'active').toList();
          final draftEvents = events.where((e) => e['status'] == 'draft').toList();
          final completedEvents = events.where((e) => e['status'] == 'completed').toList();

          return Column(
            children: [
              TabBar(
                controller: _tabController,
                indicatorColor:AppColors.getPrimaryColorFromContext(context),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor:AppColors.getPrimaryColorFromContext(context),
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: sizes?.fontSize14,
                  fontFamily: Assets.onsetMedium,
                ),
                tabs: [
                  Tab(text: 'Active (${activeEvents.length})'),
                  Tab(text: 'Draft (${draftEvents.length})'),
                  Tab(text: 'Completed (${completedEvents.length})'),
                ],
              ),

              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildEventList(activeEvents),
                    _buildEventList(draftEvents),
                    _buildEventList(completedEvents),
                  ],
                ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: AppColors.getPrimaryColorFromContext(context),
        onPressed: () {
          context.push(Routes.restaurantCreateEventRoute);
        },
        label: Row(
          children: [
            Icon(Icons.add, color: Colors.white),
            CustomText(
              text: "Create Event",
              fontSize: sizes?.fontSize12,
              fontFamily: Assets.onsetMedium,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(20),
              child: Icon(
                Icons.calendar_month,
                size: 48,
                color: Colors.orangeAccent,
              ),
            ),
            SizedBox(height: 24),

            // Title
            Text(
              "No Events Yet",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12),

            // Subtitle
            Text(
              "You haven’t created any events yet. Start by adding your first one — it only takes a minute!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),

            // Create Event Button
            ElevatedButton(
              onPressed: () {
                context.push(Routes.restaurantCreateEventRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Create Event",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(List<dynamic> events) {
    if (events.isEmpty) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(text: "No events found"),
        ],
      ));
    }
    return ListView.builder(
      itemCount: events.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(event: event); 
      },
    );
  }
}
