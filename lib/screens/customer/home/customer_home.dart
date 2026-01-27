import 'package:choice_app/appAssets/app_assets.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/customer/home/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:choice_app/providers/post_provider.dart';
import 'package:provider/provider.dart';
import '../../onboarding/onboarding_provider.dart';
import '../../restaurant/dashboard/dashboard_provider.dart';

import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../customWidgets/animations/bouncing_wrapper.dart';
import '../../../customWidgets/glass/glass_container.dart';
import '../../../customWidgets/animations/fade_in_up.dart';
import '../chat/copilot_view.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  @override
  void initState() {
    super.initState();
    // Fetch feed on arrival
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false, // Bottom tab handles this
        child: Consumer<PostProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.feed.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final posts = provider.feed;
            final itemCount = posts.isEmpty ? 1 : posts.length; // Show search even if empty

            return RefreshIndicator(
              onRefresh: () => provider.fetchFeed(),
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: 100, // Space for Bottom Tab
                ),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildHeaderSection(context, posts.isNotEmpty ? posts[0] : null);
                  }
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * (index > 3 ? 3 : index)),
                    child: PostCard(post: posts[index]),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, dynamic firstPost) {
    return Column(
      children: [
        SizedBox(height: 16), // Reduced top spacing
        // Search Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ]),
                  child: CustomField(
                    borderColor: Colors.transparent,
                    hint: "Search places, dishes...",
                    prefixIcon: Icon(Icons.search, color: AppColors.textGreyColor),
                    bgColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(width: 12),
               // Notification Icon (moved from header)
              _buildHeaderIcon(Assets.notificationIcon, () => context.push(Routes.notificationsRoute)),
            ],
          ),
        ),
        if (firstPost != null) ...[
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: FadeInUp(
              delay: Duration(milliseconds: 100),
              child: PostCard(post: firstPost),
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildHeaderIcon(String icon, VoidCallback onTap) {
    return BouncingWrapper(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: CustomIconButton(svgString: icon, color: Colors.black, height: 20),
      ),
    );
  }
}
