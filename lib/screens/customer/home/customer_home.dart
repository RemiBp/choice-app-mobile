import 'package:choice_app/appAssets/app_assets.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/customer/home/home_widgets.dart';
import 'package:choice_app/screens/restaurant/home/choice_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../l18n.dart';
import '../../../userRole/role_provider.dart';
import '../../../userRole/user_role.dart';
import '../../producer_maps/offer_provider.dart';
import '../Search/social_search_customer.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  final GlobalKey feedsKey = GlobalKey();
  final GlobalKey liveOfferKey = GlobalKey();
  double indicatorLeft = 0;
  double indicatorWidth = 0;

  List<Map<String, dynamic>> liveOffers = [];
  bool isLoadingLiveOffers = false;

  int selectedTab = 0;

  // List<Map<String, dynamic>> dummyOffers = [
  //   {
  //     "producerName": "Liberty Bite Bistro",
  //     "title": "Flash Offer",
  //     "discount": "15%",
  //     "timeLeft": "45:06",
  //     "description": "Come now and enjoy 15% off",
  //   },
  //   {
  //     "producerName": "The Wholesome Fork",
  //     "title": "Splash Offer",
  //     "discount": "15%",
  //     "timeLeft": "45:06",
  //     "description": "Come now and enjoy 15% off",
  //   }
  // ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ChoiceProvider>(context, listen: false);
    provider.init(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLiveOffers();
      updateIndicator();
    });
  }

  // Format expiresAt into HH:mm:ss
  String formatExpiry(String isoDate) {
    try {
      final expiryDate = DateTime.parse(isoDate).toLocal();
      final now = DateTime.now();
      final difference = expiryDate.difference(now);

      if (difference.isNegative) return "Expired";

      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      final seconds = difference.inSeconds % 60;

      return "${hours.toString().padLeft(2,'0')}:${minutes.toString().padLeft(2,'0')}:${seconds.toString().padLeft(2,'0')}";
    } catch (e) {
      return "00:00:00";
    }
  }

  // Fetch live offers from provider
  Future<void> fetchLiveOffers() async {
    setState(() => isLoadingLiveOffers = true);

    try {
      final provider = Provider.of<TemplateProvider>(context, listen: false);
      final response = await provider.getUserLiveOffers(context: context);

      if (response != null) {
        if (response.data.isNotEmpty) {
          liveOffers = response.data.map((offer) {
            return {
              "producerName": offer.producerName,
              "producerImage": offer.producerImage,
              "title": offer.title,
              "discount": "${offer.discountPercent}%",
              "description": offer.message,
              "timeLeft": formatExpiry(offer.expiresAt),
            };
          }).toList();
        } else {
          liveOffers = []; // ensure it becomes empty
        }
      }
    } catch (e) {
      debugPrint("❌ fetchLiveOffers error: $e");
    } finally {
      setState(() => isLoadingLiveOffers = false);
    }
  }

  void updateIndicator() {
    RenderBox box;
    Offset position;

    if (selectedTab == 0) {
      box = feedsKey.currentContext!.findRenderObject() as RenderBox;
    } else {
      box = liveOfferKey.currentContext!.findRenderObject() as RenderBox;
    }

    position = box.localToGlobal(Offset.zero);

    setState(() {
      indicatorLeft = position.dx - (getWidth() * .05); // adjust padding
      indicatorWidth = box.size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: getHeight() * .07,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CustomText(
                  text: "Choice",
                  fontSize: sizes?.fontSize28,
                  fontFamily: Assets.onsetSemiBold,
                ),
                const Spacer(),
                CustomIconButton(svgString: Assets.mapIcon),
                SizedBox(width: getWidth() * .02),
                CustomIconButton(svgString: Assets.chatIcon),
                SizedBox(width: getWidth() * .02),
                CustomIconButton(svgString: Assets.notificationIcon),
              ],
            ),

            SizedBox(height: getHeight() * .02),

            CustomField(
              borderColor: AppColors.greyBordersColor,
              hint: al.searchUserPlaceholder,
              prefixIconSvg: Assets.searchIcon,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },

            ),

            SizedBox(height: getHeight() * .02),

            // Tabs
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _tabButton("Feeds", 0, feedsKey),
                    _tabButton("Live Offer", 1, liveOfferKey),
                  ],
                ),
                SizedBox(height: getHeight() * 0.008),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 2,
                      width: double.infinity,
                      color: AppColors.greyColor,
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      left: indicatorLeft,
                      child: Container(
                        height: 4,
                        width: indicatorWidth,
                        decoration: BoxDecoration(
                          color: AppColors.getPrimaryColorFromContext(context),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: getHeight() * .01),

            Expanded(
              child: selectedTab == 0
                  ? _buildFeedsTab()
                  : _buildLiveOffersTab(),
            ),
          ],
        ),
      ),

      // Floating Button
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: AppColors.getPrimaryColorFromContext(context),
        onPressed: () {
          final role = context.read<RoleProvider>().role;

          if (role == UserRole.user) {
            context.push(Routes.choiceSelectionRoute);
          } else {
            context.push(Routes.restaurantCreatePostRoute);
          }
        },
        label: Row(
          children: [
            const Icon(Icons.add, color: Colors.white),
            CustomText(
              text: al.create,
              fontSize: sizes?.fontSize12,
              fontFamily: Assets.onsetMedium,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // Tab Button
  Widget _tabButton(String text, int index, GlobalKey key) {
    return InkWell(
      key: key,
      onTap: () {
        setState(() => selectedTab = index);
        WidgetsBinding.instance.addPostFrameCallback((_) => updateIndicator());
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * 0.04,
          vertical: getHeight() * 0.002,
        ),
        child: CustomText(
          text: text,
          fontSize: sizes?.fontSize14,
          fontWeight: FontWeight.w500,
          fontFamily: Assets.onsetMedium,
          color: selectedTab == index
              ? AppColors.getPrimaryColorFromContext(context)
              : AppColors.blackColor.withValues(alpha: .4),
        ),
      ),
    );
  }

  // FEEDS TAB
  Widget _buildFeedsTab() {
    return ListView.builder(
      padding: EdgeInsets.only(top: getHeight() * .01),
      itemCount: 0,
      itemBuilder: (context, index) => PostCard(index: index),
    );
  }

  // LIVE OFFERS TAB
  Widget _buildLiveOffersTab() {
    if (isLoadingLiveOffers) {
      return Center(child: CircularProgressIndicator());
    }

    if (liveOffers.isEmpty) {
      return Center(
        child: CustomText(
          text: "No Offers Available",
          fontSize: sizes?.fontSize16,
          fontFamily: Assets.onsetMedium,
          color: Colors.black54,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: getHeight() * .01),
      itemCount: liveOffers.length,
      itemBuilder: (context, index) {
        final offer = liveOffers[index];

        return Container(
          margin: EdgeInsets.only(bottom: getHeight() * .02),
          padding: EdgeInsets.all(getWidth() * .04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      offer["producerImage"] ?? "",
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          Assets.restaurantImage,
                          width: 32,
                          height: 32,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  CustomText(
                    text: offer["producerName"],
                    fontSize: sizes?.fontSize16,
                    fontFamily: Assets.onsetMedium,
                  ),
                ],
              ),
              SizedBox(height: getHeight() * .015),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(getWidth() * .04),
                decoration: BoxDecoration(
                  color: const Color(0xff0B0D24),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: offer["discount"],
                            fontSize: sizes?.fontSize22,
                            fontFamily: Assets.onsetSemiBold,
                            color: AppColors.whiteColor,
                          ),
                          CustomText(
                            text: offer["title"],
                            fontSize: sizes?.fontSize14,
                            fontFamily: Assets.onsetMedium,
                            color: AppColors.whiteColor,
                          ),
                          SizedBox(height: 6),
                          CustomText(
                            text: offer["description"],
                            fontSize: sizes?.fontSize12,
                            fontFamily: Assets.onsetRegular,
                            color: AppColors.whiteColor,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: getWidth() * 0.03,
                        vertical: getHeight() * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.redColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomText(
                        text: offer["timeLeft"],
                        color: AppColors.whiteColor,
                        fontSize: sizes?.fontSize12,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
