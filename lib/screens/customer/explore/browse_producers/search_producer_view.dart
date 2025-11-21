import 'package:choice_app/appAssets/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../appColors/colors.dart';
import '../../../../common/utils.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../models/near_by_producers_response.dart';
import '../../../../res/res.dart';
import '../customer_explore/customer_explore_view_provider.dart';

class SearchProducersScreen extends StatefulWidget {
  const SearchProducersScreen({Key? key}) : super(key: key);

  @override
  State<SearchProducersScreen> createState() => _SearchProducersScreenState();
}

class _SearchProducersScreenState extends State<SearchProducersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProducerItem> searchResults = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    setState(() => isLoading = true);

    try {
      final provider = Provider.of<ExploreViewProvider>(context, listen: false);

      // get user's stored location
      final latString = PreferenceUtils.getString("latitude");
      final lngString = PreferenceUtils.getString("longitude");
      double lat = double.tryParse(latString ?? "") ?? 31.470404754490897;
      double lng = double.tryParse(lngString ?? "") ?? 74.38929248891314;

      final response = await provider.findNearbyProducers(
        latitude: lat,
        longitude: lng,
        keyword: query,
        radius: 20000,
      );


      setState(() {
        searchResults = response?.data?.producers ?? [];
      });
    } catch (e) {
      debugPrint("❌ Error searching producers: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTyping = _searchController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            buildSearchBar(context),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : searchResults.isEmpty && !isTyping
                    ? const Center(
                  child: CustomText(
                    text: "No recent searches",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: Assets.onsetMedium,
                  ),
                )
                    : searchResults.isEmpty && isTyping
                    ? const Center(
                  child: CustomText(
                    text: "No results found",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: Assets.onsetMedium,
                  ),
                )
                    : ListView.builder(
                  padding: EdgeInsets.only(top: getHeight() * 0.015),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final item = searchResults[index];
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.profileImage != null
                                    ? "https://elasticbeanstalk-eu-west-3-838155148197.s3.eu-west-3.amazonaws.com/${item.profileImage}"
                                    : "https://via.placeholder.com/300",
                                width: getWidth() * 0.15,
                                height: getWidth() * 0.15,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: getWidth() * 0.15,
                                    height: getWidth() * 0.15,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.broken_image, color: Colors.grey),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: getWidth() * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: item.name ?? "Unknown Producer",
                                    fontSize: sizes?.fontSize16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  SizedBox(height: getHeight() * 0.003),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: AppColors.userPrimaryColor,
                                        size: 14,
                                      ),
                                      SizedBox(width: getWidth() * 0.01),
                                      Expanded(
                                        child: Text(
                                          item.address ?? "No address available",
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: getHeight() * 0.02),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar(BuildContext context) {
    final isTyping = _searchController.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: getHeight() * 0.02,
            left: sizes!.pagePadding,
            right: sizes!.pagePadding,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, size: 26),
              ),
              SizedBox(width: getWidth() * 0.03),
              Expanded(
                child: Container(
                  height: getHeight() * 0.067,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.greyBordersColor,
                      width: 1,
                    ),
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
                            setState(() {});
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
        ),
        Padding(
          padding: EdgeInsets.only(top: getHeight() * 0.015),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColors.inputHintColor,
          ),
        ),
      ],
    );
  }
}
