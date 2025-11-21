import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/restaurant/event/event_provider.dart';
import 'package:choice_app/screens/restaurant/event/event_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../l18n.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  EventProvider _eventProvider = EventProvider();


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_){
      _eventProvider = Provider.of<EventProvider>(context, listen: false);
      _eventProvider.init(context);
    });



  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<EventProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: CustomText(
          text:al.events,
          fontSize: sizes?.fontSize18,
          fontFamily: Assets.onsetSemiBold,
        ),
        //titleSpacing: 0,
      ),
      body: Column(
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
              Tab(text: al.statusActive,),
              Tab(text: al.statusDraft,),
              Tab(text: al.statusCompleted,),
            ],
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: _eventProvider.getAllEventsResponse.data?.length??0,
                  itemBuilder: (context, index) {
                    return EventCard(
                      eventsResponse: _eventProvider.getAllEventsResponse.data?[index],
                    );
                  },
                ),

                ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return EventCard(isDraft: true);
                  },
                ),
                ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return EventCard();
                  },
                ),
              ],
            ),
          ),
        ],
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
              text: al.createEvent,
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
                color: Colors.orange.withValues(alpha: 0.1),
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
              al.noEvents,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12),

            // Subtitle
            Text(
              al.noEventsMessage,
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
                al.createEvent,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
