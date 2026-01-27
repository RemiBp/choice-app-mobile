import 'package:flutter/material.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../res/res.dart';
import 'customer_maps_widgets.dart';

class RestaurantBottomSheet extends StatefulWidget {
  const RestaurantBottomSheet({super.key});

  @override
  State<RestaurantBottomSheet> createState() => _RestaurantBottomSheetState();
}

class _RestaurantBottomSheetState extends State<RestaurantBottomSheet> {
  double distance = 20;
  List<String> cuisines = ["Asian", "Italian", "Vegan"];
  List<String> selectedCuisines = ["Asian"]; // ✅ multiple selection

  // Ratings
  int ambianceRating = 0;
  int serviceRating = 0;
  int portionsRating = 0;
  int placeRating = 0;
  int dishRating = 0;

  // Dishes
  List<String> dishes = [
    "Truffle Mushroom Risotto",
    "Ratatouille",
    "Pad Thai",
    "Biryani",
    "Korean Bibimbap",
    "Tacos al Pastor",
  ];
  List<String> selectedDishes = ["Truffle Mushroom Risotto", "Pad Thai"];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Filters",
                    color: AppColors.blackColor,
                    fontSize: sizes?.fontSize18,
                    fontWeight: FontWeight.w600,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: AppColors.blackColor,
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),

              // Content
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  controller: scrollController,
                  children: [
                    const CustomSectionTitle(title: "Distance"),
                    Row(
                      children: [
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: getHeightRatio() * 10,
                              activeTrackColor: AppColors.userPrimaryColor,
                              inactiveTrackColor: AppColors.greyColor,
                              thumbColor: AppColors.whiteColor,
                              overlayColor: AppColors.userPrimaryColor.withAlpha(40),
                              valueIndicatorColor: AppColors.userPrimaryColor,
                            ),
                            child: Slider(
                              value: distance,
                              min: 10,
                              max: 100,
                              divisions: 5,
                              label: "${distance.round()} km",
                              onChanged: (val) => setState(() => distance = val),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const CustomSectionTitle(title: "Cuisine"),
                    Column(
                      children: cuisines.map((c) {
                        final selected = selectedCuisines.contains(c);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: CustomMultiSelectOption(
                            label: c,
                            selected: selected,
                            onTap: () {
                              setState(() {
                                if (selected) {
                                  selectedCuisines.remove(c);
                                } else {
                                  selectedCuisines.add(c);
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: getHeight() * 0.01),
                    _buildRatingRow("Ambiance", ambianceRating, (r) => setState(() => ambianceRating = r)),
                    SizedBox(height: getHeight() * 0.01),
                    _buildRatingRow("Service", serviceRating, (r) => setState(() => serviceRating = r)),
                    SizedBox(height: getHeight() * 0.01),
                    _buildRatingRow("Portions", portionsRating, (r) => setState(() => portionsRating = r)),
                    SizedBox(height: getHeight() * 0.01),
                    _buildRatingRow("Place", placeRating, (r) => setState(() => placeRating = r)),
                    SizedBox(height: getHeight() * 0.01),

                    const CustomSectionTitle(title: "Dish Name"),
                    CustomField(
                      controller: _searchController,
                      borderColor: AppColors.greyBordersColor,
                      hint: "Search by username or name...",
                      prefixIconSvg: Assets.searchIcon,
                      height: getHeightRatio() * 44,
                    ),
                    SizedBox(height: getHeight() * 0.01),

                    // ✅ dishes selection (multi-select same as cuisine)
                    Column(
                      children: dishes.map((d) {
                        final selected = selectedDishes.contains(d);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: CustomMultiSelectOption(
                            label: d,
                            selected: selected,
                            onTap: () {
                              setState(() {
                                if (selected) {
                                  selectedDishes.remove(d);
                                } else {
                                  selectedDishes.add(d);
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: "Show more",
                          color: AppColors.inputHintColor,
                          fontSize: sizes?.fontSize14,
                          fontWeight: FontWeight.w500,
                        ),
                        Icon(Icons.keyboard_arrow_down_sharp, color: AppColors.inputHintColor,)
                      ],
                    ),
                    SizedBox(height: getHeight() * 0.01),
                    _buildRatingRow("Dish Rating", dishRating, (r) => setState(() => dishRating = r)),
                    SizedBox(height: getHeight() * 0.02),
                  ],
                ),
              ),

              // Footer buttons
              SizedBox(height: getHeight() * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    buttonText: 'Reset All',
                    onTap: () {
                      Navigator.pop(context);
                    },
                    buttonWidth: getWidth() * .43,
                    backgroundColor: Colors.transparent,
                    borderColor: AppColors.blackColor,
                    textColor: AppColors.blackColor,
                    textFontWeight: FontWeight.w700,
                  ),
                  CustomButton(
                    buttonText: 'Apply Filters',
                    onTap: () {

                    },
                    buttonWidth: getWidth() * .43,
                    backgroundColor: AppColors.userPrimaryColor,
                    borderColor: Colors.transparent,
                    textColor: Colors.white,
                    textFontWeight: FontWeight.w700,
                  ),
                ],
              ),
              // SizedBox(height: getHeightRatio() * 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingRow(String title, int selected, Function(int) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSectionTitle(title: title),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyBordersColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(6, (index) {
              bool isSelected = selected == index;

              // "Any" button
              if (index == 0) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onSelected(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.userPrimaryColor : Colors.transparent,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                      ),
                      child: CustomText(
                        text: "Any",
                        color: isSelected ? Colors.white : AppColors.inputHintColor,
                        fontSize: sizes?.fontSize14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }

              // Star rating buttons
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelected(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.userPrimaryColor : Colors.transparent,
                      border: Border(
                        left: BorderSide(color: AppColors.greyBordersColor),
                      ),
                      borderRadius: index == 5
                          ? const BorderRadius.horizontal(right: Radius.circular(8))
                          : BorderRadius.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.orange),
                        const SizedBox(width: 4),
                        CustomText(
                          text: "$index",
                          color: isSelected ? Colors.white : AppColors.inputHintColor,
                          fontSize: sizes?.fontSize14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }


// Ratings row stays similar, you can also refactor text into CustomText
  // Widget _buildRatingRow(String title, int selected, Function(int) onSelected) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CustomSectionTitle(title: title),
  //       Row(
  //         children: List.generate(
  //           6,
  //               (index) {
  //             if (index == 0) {
  //               return GestureDetector(
  //                 onTap: () => onSelected(0),
  //                 child: Container(
  //                   margin: const EdgeInsets.only(right: 8),
  //                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  //                   decoration: BoxDecoration(
  //                     color: selected == 0 ? AppColors.userPrimaryColor : AppColors.greyColor.withOpacity(0.2),
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   child: CustomText(
  //                     text: "Any",
  //                     color: AppColors.whiteColor,
  //                     fontSize: sizes?.fontSize14,
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                 ),
  //               );
  //             }
  //             return GestureDetector(
  //               onTap: () => onSelected(index),
  //               child: Container(
  //                 margin: const EdgeInsets.only(right: 8),
  //                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  //                 decoration: BoxDecoration(
  //                   color: selected == index ? AppColors.userPrimaryColor : AppColors.greyColor.withOpacity(0.2),
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     const Icon(Icons.star, size: 16, color: Colors.yellow),
  //                     const SizedBox(width: 2),
  //                     CustomText(
  //                       text: "$index",
  //                       color: AppColors.inputHintColor,
  //                       fontSize: sizes?.fontSize14,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       )
  //     ],
  //   );
  // }
}
