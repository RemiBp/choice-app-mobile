import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';
import '../../../restaurant/profile_menu/profile_menu_widgets.dart';
import '../customer_explore/customer_explore_view_provider.dart';
import '../restaurant_explore_details/restaurant_explore_details.dart';

class BrowseProducersScreen extends StatefulWidget {
  final String categoryType;

  const BrowseProducersScreen({
    super.key,
    required this.categoryType,
  });

  @override
  State<BrowseProducersScreen> createState() => _BrowseProducersScreenState();
}

class _BrowseProducersScreenState extends State<BrowseProducersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider =
    Provider.of<ExploreViewProvider>(context, listen: false);

    // Fetch producers based on the selected category
    Future.microtask(() {
      provider.getNearbyProducers(
        producerType: widget.categoryType.toLowerCase(),
      );
    });

    _searchController.addListener(() {
      setState(() {}); // rebuild to update search results
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExploreViewProvider>(context);
    final searchText = _searchController.text.toLowerCase();

    // Filter producers based on search input
    final filteredProducers = provider.nearbyProducers.where((producer) {
      return producer.name.toLowerCase().contains(searchText) ||
          (producer.type?.toLowerCase().contains(searchText) ?? false) ||
          producer.address.toLowerCase().contains(searchText);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSearchBar(),
            Divider(
              thickness: 1,
              height: 1,
              color: AppColors.inputHintColor,
            ),
            SizedBox(height: getHeight() * 0.02),

            // Results count
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
              child: CustomText(
                text: "${filteredProducers.length} results",
                fontSize: sizes!.fontSize16,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: getHeight() * 0.01),

            // Producers List
            Expanded(
              child: provider.isProducersLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredProducers.isEmpty
                  ? const Center(child: Text("No producers found"))
                  : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: filteredProducers.length,
                itemBuilder: (context, index) {
                  final producer = filteredProducers[index];
                  final type = _capitalize(producer.type ?? "Restaurant");

                  return FavouriteRestaurantCard(
                    imageUrl: producer.profileImage != null
                        ? "https://elasticbeanstalk-eu-west-3-838155148197.s3.eu-west-3.amazonaws.com/${producer.profileImage}"
                        : "https://via.placeholder.com/300",
                    restaurantName: producer.name,
                    address: producer.address.isNotEmpty
                        ? producer.address
                        : "No address available",
                    isFavourite: false,
                    chipText: type,
                    chipColor: _getChipColor(type),
                    onRestaurantTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         RestaurantExploreDetails(tag: type),
                      //   ),
                      // );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Search Bar Widget
  Widget buildSearchBar() {
    final isTyping = _searchController.text.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sizes!.pagePadding,
        vertical: getHeight() * 0.015,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
          ),
          SizedBox(width: getWidth() * 0.02),
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.greyBordersColor),
                color: AppColors.whiteColor,
              ),
              child: Row(
                children: [
                  SizedBox(width: getWidth() * 0.03),
                  const Icon(Icons.search,
                      color: AppColors.inputHintColor, size: 22),
                  SizedBox(width: getWidth() * 0.02),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontSize: sizes!.fontSize15),
                      cursorHeight: getHeight() * 0.025,
                      decoration: InputDecoration(
                        hintText: al.search,
                        hintStyle: TextStyle(
                          color: AppColors.inputHintColor,
                          fontSize: sizes!.fontSize15,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (isTyping)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: getWidth() * 0.03),
                        child: const Icon(Icons.close,
                            color: Colors.grey, size: 20),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Capitalize first letter
  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Chip color based on type
  Color _getChipColor(String type) {
    switch (type.toLowerCase()) {
      case "restaurant":
        return AppColors.restaurantPrimaryColor;
      case "wellness":
        return AppColors.wellnessPrimaryColor;
      case "leisure":
        return AppColors.leisurePrimaryColor;
      default:
        return AppColors.userPrimaryColor;
    }
  }
}
