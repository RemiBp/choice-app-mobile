import 'package:choice_app/screens/customer/explore/book_now/book_producer_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:choice_app/appAssets/app_assets.dart';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/screens/customer/explore/customer_gallery/customer_gallery_screen.dart';
import 'package:choice_app/screens/customer/explore/full_menu/full_menu_view.dart';
import 'package:choice_app/screens/customer/explore/restaurant_explore_details/restaurant_explore_widgets.dart';
import 'package:choice_app/screens/onboarding/menu/menu_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';

import '../../../../customWidgets/shadow_icon.dart';
import '../../../../l18n.dart';
import '../../../../network/api_url.dart' as ApiUrl;
import '../../../../res/toasts.dart';
import '../book_now/book_now_view.dart';

import 'non_event_details_provider.dart';
import '../../../../models/get_non_events_details_response.dart' hide Dish;

class NonEventDetailsScreen extends StatefulWidget {
  final String producerId;
  final String type; // "restaurant" or "wellness"

  const NonEventDetailsScreen({
    super.key,
    required this.producerId,
    required this.type,
  });

  @override
  State<NonEventDetailsScreen> createState() => _NonEventDetailsScreenState();
}

class _NonEventDetailsScreenState extends State<NonEventDetailsScreen> {
  late PageController _pageController;
  int _currentImageIndex = 0;
  List<int> selectedServiceIndexes = [];

  bool get isRestaurant => widget.type.toLowerCase() == "restaurant";
  bool get isWellness => widget.type.toLowerCase() == "wellness";

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // provider created in build via ChangeNotifierProvider.create
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Divider(color: AppColors.greyColor),
  );

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomText(
        text: title,
        fontSize: 18,
        fontFamily: Assets.onsetSemiBold,
      ),
    );
  }

  String _formatTime(String? t) {
    if (t == null) return "";
    // backend returns "10:00:00" trim seconds for display
    if (t.contains(":")) {
      final parts = t.split(':');
      if (parts.length >= 2) {
        return "${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}";
      }
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NonEventDetailsProvider>(
      create: (_) => NonEventDetailsProvider()..getNonEventDetails(widget.producerId),
      child: Consumer<NonEventDetailsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final Producer? producer = provider.producer;

          if (producer == null) {
            return const Scaffold(
              body: Center(child: Text("No data found")),
            );
          }

          final photos = provider.photos;
          final menu = provider.menu;
          final hours = provider.businessHours;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  IMAGE HEADER
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImageGalleryScreen(
                            restaurantId: producer.id?.toString() ?? '0',
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 280,
                      child: Stack(
                        children: [
                          // PageView or placeholder if no images
                          if (photos.isNotEmpty)
                            PageView.builder(
                              controller: _pageController,
                              itemCount: photos.length,
                              onPageChanged: (index) {
                                setState(() => _currentImageIndex = index);
                              },
                              itemBuilder: (_, index) {
                                final String url = "${ApiUrl.baseUrl}/${photos[index].url ?? ''}";
                                return Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  loadingBuilder: (c, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (c, e, s) {
                                    // fallback placeholder
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: Center(child: Icon(Icons.image, size: 48, color: Colors.grey[600])),
                                    );
                                  },
                                );
                              },
                            )
                          else
                          // no images - show asset
                            Image.asset(
                              Assets.mapImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),

                          // IMAGE COUNT (1 / total)
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.blackColor.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CustomText(
                                text:
                                "${photos.isEmpty ? 0 : (_currentImageIndex + 1)} / ${photos.isEmpty ? 0 : photos.length}",
                                color: AppColors.whiteColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TITLE + CHAT ICON
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            text: producer.name ?? (isRestaurant ? "Restaurant" : "Wellness"),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: Assets.onsetSemiBold,
                          ),
                        ),
                        SvgPicture.asset(
                          Assets.messagesIcon,
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                            AppColors.getPrimaryColorFromContext(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ADDRESS / ICON
                  IconTextWidget(
                    text: producer.address ?? "No address provided",
                    subText: producer.address ?? "",
                    icon: Assets.restaurantLocationIcon,
                    color: AppColors.getPrimaryColorFromContext(context),
                  ),

                  divider(),

                  //  MENU (Restaurant)
                  if (producer.type == "restaurant")
                    menu.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: MenuGroupWidget(
                                                menuGroup: MenuGroup(
                          title: menu[0].name ?? "",
                          dishes: menu[0].dishes
                              ?.map((d) => Dish(
                            name: d.name ?? "",
                            description: d.description ?? "",
                            price: (d.price != null) ? d.price!.toDouble() : 0.0,
                          ))
                              .toList() ??
                              [],
                                                ),
                                                header: al.menu,
                                                optionText: al.seeFullMenu,
                                                hideBorder: true,
                                                onAddDish: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => FullMenuView()),
                          );
                                                },
                                              ),
                        )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle("Menu"),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomText(text: "No menu added", fontSize: 14),
                        ),
                      ],
                    ),

                  // SERVICES (Wellness)
                  if (producer.type == "wellness")
                    provider.wellness != null && provider.wellness!.selectedServices.isNotEmpty
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle("Services"), // already has horizontal padding
                        const SizedBox(height: 10),
                        ...provider.wellness!.selectedServices.map<Widget>((s) {
                          final serviceName = s["serviceType"]?["name"] ?? "Unknown";
                          final int idx = provider.wellness!.selectedServices.indexOf(s);
                          final isSelected = selectedServiceIndexes.contains(idx);
                          return Padding(
                            padding: const EdgeInsets.only(left: 20), // optional, for alignment
                            child: WellnessServiceTile(
                              title: serviceName,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedServiceIndexes.remove(idx);
                                  } else {
                                    selectedServiceIndexes.add(idx);
                                  }
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    )
                        : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Services"),
                          const SizedBox(height: 8),
                          CustomText(text: "No services added", fontSize: 14),
                        ],
                      ),
                    ),



                  const SizedBox(height: 20),
                  divider(),

                  //  ABOUT
                  sectionTitle("About"),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ReadMoreText(
                      producer.details ?? "No description available for this business.",
                      trimLines: 2,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: "Read More",
                      trimExpandedText: "See Less",
                      style: const TextStyle(fontSize: 14),
                      moreStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.getPrimaryColorFromContext(context),
                      ),
                      lessStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.getPrimaryColorFromContext(context),
                      ),
                    ),
                  ),

                  divider(),

                  //  LOCATION MAP
                  sectionTitle("Location"),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.locationIcon,
                          height: 18,
                          colorFilter: ColorFilter.mode(
                            AppColors.getPrimaryColorFromContext(context),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomText(
                            text: producer.address ?? "",
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      Assets.mapImage,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),

                  divider(),

                  //  BUSINESS HOURS
                  sectionTitle("Business Hours"),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: (hours.isNotEmpty
                          ? hours
                          : // fallback: create empty days list if none available
                      [
                        BusinessHour(day: "Monday", startTime: null, endTime: null, isClosed: true),
                        BusinessHour(day: "Tuesday", startTime: null, endTime: null, isClosed: true),
                        BusinessHour(day: "Wednesday", startTime: null, endTime: null, isClosed: true),
                        BusinessHour(day: "Thursday", startTime: null, endTime: null, isClosed: true),
                        BusinessHour(day: "Friday", startTime: null, endTime: null, isClosed: true),
                        BusinessHour(day: "Saturday", startTime: null, endTime: null, isClosed: true),
                        BusinessHour(day: "Sunday", startTime: null, endTime: null, isClosed: true),
                      ])
                          .map((e) {
                        final openText = (e.isClosed == true || (e.startTime == null && e.endTime == null))
                            ? "Closed"
                            : "${_formatTime(e.startTime)} - ${_formatTime(e.endTime)}";
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(text: e.day ?? "", fontSize: 14),
                              CustomText(text: openText, fontSize: 14, fontFamily: Assets.onsetMedium),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  divider(),

                  //  SOCIAL LINKS (only show existing ones)
                  sectionTitle("Social Links"),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        if (producer.website != null && producer.website!.trim().isNotEmpty)
                          GestureDetector(
                            onTap: () async {
                              final url = producer.website!;
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(url);
                              } else {
                                Toasts.getErrorToast(text:"Could not open link");
                              }
                            },
                            child: ShadowIcon(icon: Assets.websiteIcon, color: AppColors.getPrimaryColorFromContext(context)),
                          ),
                        if (producer.instagram != null && producer.instagram!.trim().isNotEmpty) ...[
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () async {
                              final url = producer.instagram!;
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(url);
                              } else {
                                Toasts.getErrorToast(text:"Could not open link");
                              }
                            },
                            child: ShadowIcon(icon: Assets.instagramIcon, color: AppColors.getPrimaryColorFromContext(context)),
                          ),
                        ],
                        if (producer.twitter != null && producer.twitter!.trim().isNotEmpty) ...[
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () async {
                              final url = producer.twitter!;
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(url);
                              } else {
                                Toasts.getErrorToast(text:"Could not open link");
                              }
                            },
                            child: ShadowIcon(icon: Assets.xIcon, color: AppColors.getPrimaryColorFromContext(context)),
                          ),
                        ],
                        if (producer.facebook != null && producer.facebook!.trim().isNotEmpty) ...[
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () async {
                              final url = producer.facebook!;
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(url);
                              } else {
                                Toasts.getErrorToast(text:"Could not open link");
                              }
                            },
                            child: ShadowIcon(icon: Assets.facebookIcon, color: AppColors.getPrimaryColorFromContext(context)),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // BOTTOM BUTTON
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(height: 1, color: AppColors.greyColor),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomButton(
                    buttonText: "Book A Reservation",
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                          builder: (_) => BookProducerView(
                            producerId: producer.id.toString(),   //  pass it
                          )
                      )
                      );
                    },
                    backgroundColor: AppColors.userPrimaryColor,
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
