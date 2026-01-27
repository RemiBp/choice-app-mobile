import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/screens/customer/home/choiceWidgets/share_experience.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:choice_app/customWidgets/animations/bouncing_wrapper.dart';
import 'package:go_router/go_router.dart';

import '../../../appAssets/app_assets.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../res/res.dart';
import '../../../utilities/extensions.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/rating_model.dart';
import '../../../providers/post_provider.dart';
import 'package:provider/provider.dart';

class CreateChoice extends StatefulWidget {
  const CreateChoice({super.key});

  @override
  _CreateChoiceState createState() => _CreateChoiceState();
}

class _CreateChoiceState extends State<CreateChoice> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Cache data from extra
  Map<String, dynamic>? _data;
  String get selectedChoice => _data?['title'] ?? 'Restaurant';
  int? get producerId => _data?['producerId'];

  // Form Data
  double serviceRating = 0;
  double ambianceRating = 0;
  double priceRating = 0;
  double portionsRating = 0;
  String selectedDish = '';
  String visibility = 'Public';
  List<String> selectedTags = [];
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      if (extra?['producerId'] != null) {
        context.read<PostProvider>().fetchProducerMenu(extra!['producerId']);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _handlePublish();
    }
  }

  Future<void> _handlePublish() async {
    final postProvider = context.read<PostProvider>();
    final data = GoRouterState.of(context).extra as Map<String, dynamic>?;

    // 1. Prepare Ratings
    List<RatingModel> ratings = [];
    if (selectedChoice == "Restaurant") {
      ratings = [
        RatingModel(criteria: 'service', rating: serviceRating / 2),
        RatingModel(criteria: 'place', rating: ambianceRating / 2),
        RatingModel(criteria: 'portions', rating: portionsRating / 2),
        RatingModel(criteria: 'ambiance', rating: (priceRating) / 2),
      ];
    } else if (selectedChoice == "Wellness") {
      ratings = [
        RatingModel(criteria: 'careQuality', rating: serviceRating / 2),
        RatingModel(criteria: 'cleanliness', rating: ambianceRating / 2),
        RatingModel(criteria: 'welcome', rating: portionsRating / 2),
        RatingModel(criteria: 'atmosphere', rating: priceRating / 2),
      ];
    }

    // 2. Prepare Post
    final post = PostModel(
      type: selectedChoice.toUpperCase(),
      description: _captionController.text,
      producerId: producerId, 
      tags: selectedTags,
      images: [], 
    );

    final success = await postProvider.createChoice(
      post: post,
      ratings: ratings,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Choice published successfully!")),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${postProvider.error}")),
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _data = GoRouterState.of(context).extra as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Story Progress Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05, vertical: 10),
              child: Row(
                children: List.generate(_totalSteps, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: index <= _currentStep
                            ? AppColors.userPrimaryColor
                            : AppColors.greyColor,
                      ),
                    ),
                  );
                }),
              ),
            ),

            // 2. Header (Navigation & Title)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05, vertical: 0),
              child: Row(
                children: [
                  BouncingWrapper(
                    onTap: _prevStep,
                    child: Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  Spacer(),
                  CustomText(
                    text: _getStepTitle(_currentStep),
                    fontSize: sizes?.fontSize18,
                    fontFamily: Assets.onsetSemiBold,
                  ),
                  Spacer(),
                  SizedBox(width: 20), // Balance left icon
                ],
              ),
            ),

            // 3. Main Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe to enforce flow
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  _buildRatingStep(_data),
                  _buildDishStep(),
                  _buildPhotoStep(),
                  _buildFinalizeStep(),
                ],
              ),
            ),

            // 4. Bottom Action Bar
            Padding(
              padding: EdgeInsets.all(getWidth() * 0.05),
              child: CustomButton(
                buttonText: _currentStep == _totalSteps - 1 ? "Publish" : "Next",
                onTap: _nextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0: return "Rate Experience";
      case 1: return "Review Dishes";
      case 2: return "Add Photos";
      case 3: return "Finalize";
      default: return "Create Choice";
    }
  }

  // --- Step 1: Overall Ratings ---
  Widget _buildRatingStep(Map<String, dynamic>? data) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(getWidth() * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVenueHeader(data),
          SizedBox(height: 30),
          CustomText(
            text: "How was it?",
            fontSize: sizes?.fontSize24,
            fontFamily: Assets.onsetBold,
          ),
          SizedBox(height: 5),
          CustomText(
            text: "Rate specific aspects to help others.",
            fontSize: sizes?.fontSize14,
            color: AppColors.textGreyColor,
          ),
          SizedBox(height: 30),
          _buildSliderRating("Service", serviceRating, (val) => setState(() => serviceRating = val)),
          _buildSliderRating("Ambiance", ambianceRating, (val) => setState(() => ambianceRating = val)),
          _buildSliderRating("Food Quality", priceRating, (val) => setState(() => priceRating = val)), // Reused price var for now
          _buildSliderRating("Value", portionsRating, (val) => setState(() => portionsRating = val)),
        ],
      ),
    );
  }

  Widget _buildVenueHeader(Map<String, dynamic>? data) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.greyColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(data?["icon"] ?? Assets.knifeForkIcon, width: 24),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: data?["producerName"] ?? "Unknown Venue",
                fontFamily: Assets.onsetSemiBold,
                fontSize: sizes?.fontSize16,
              ),
              CustomText(
                text: "Beauvais, France",
                fontSize: sizes?.fontSize12,
                color: AppColors.textGreyColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRating(String label, double value, Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: label, fontSize: sizes?.fontSize16, fontFamily: Assets.onsetMedium),
              CustomText(text: "${value.toInt()}/10", fontSize: sizes?.fontSize16, fontFamily: Assets.onsetBold, color: AppColors.userPrimaryColor),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.userPrimaryColor,
              inactiveTrackColor: AppColors.greyColor,
              thumbColor: AppColors.userPrimaryColor,
              overlayColor: AppColors.userPrimaryColor.withOpacity(0.2),
              trackHeight: 6,
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 2: Dishes ---
  Widget _buildDishStep() {
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        final menu = provider.producerMenu;

        return SingleChildScrollView(
          padding: EdgeInsets.all(getWidth() * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "What did you eat?",
                fontSize: sizes?.fontSize24,
                fontFamily: Assets.onsetBold,
              ),
               SizedBox(height: 5),
              CustomText(
                text: "Select dishes from the menu to review them.",
                fontSize: sizes?.fontSize14,
                color: AppColors.textGreyColor,
              ),
              SizedBox(height: 20),
              if (provider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (menu.isEmpty)
                const Center(child: CustomText(text: "No menu available for this venue", color: Colors.grey))
              else
                ...menu.map((dish) => _buildDishOption(
                  dish['name'] ?? "Unknown Dish", 
                  dish['description'] ?? "", 
                  "${dish['price'] ?? ''} €"
                )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDishOption(String name, String desc, String price) {
    bool isSelected = selectedDish == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDish = name;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.userPrimaryColor.withOpacity(0.05) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.userPrimaryColor : AppColors.greyBordersColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: name, fontFamily: Assets.onsetSemiBold, fontSize: sizes?.fontSize16),
                  SizedBox(height: 4),
                  CustomText(text: desc, fontSize: sizes?.fontSize12, color: AppColors.textGreyColor),
                  SizedBox(height: 4),
                   CustomText(text: price, fontFamily: Assets.onsetMedium, fontSize: sizes?.fontSize14, color: AppColors.blackColor),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.userPrimaryColor : AppColors.greyBordersColor,
            ),
          ],
        ),
      ),
    );
  }

  // --- Step 3: Photos ---
  Widget _buildPhotoStep() {
    return Padding(
      padding: EdgeInsets.all(getWidth() * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Capture the moment",
            fontSize: sizes?.fontSize24,
            fontFamily: Assets.onsetBold,
          ),
          SizedBox(height: 20),
          Container(
                    height: getHeight() * .25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.greyColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.greyBordersColor,
                          style: BorderStyle.solid,
                        )
                    ),
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, size: 40, color: AppColors.textGreyColor),
                            SizedBox(height: 10),
                            CustomText(
                              text: "Tap to upload photos",
                              fontFamily: Assets.onsetMedium,
                              fontSize: sizes?.fontSize14,
                              color: AppColors.textGreyColor,
                            ),
                          ],
                        )
                    ),
                  ),
        ],
      ),
    );
  }

  // --- Step 4: Finalize ---
  Widget _buildFinalizeStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(getWidth() * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Almost done!",
            fontSize: sizes?.fontSize24,
            fontFamily: Assets.onsetBold,
          ),
          SizedBox(height: 20),
          CustomField(
            controller: _captionController,
            label: "Add a caption",
            hint: "Write about your experience...",
            maxLines: 4,
            borderColor: AppColors.greyBordersColor,
          ),
          SizedBox(height: 20),
          CustomText(text: "Visibility", fontFamily: Assets.onsetSemiBold),
          SizedBox(height: 10),
          _buildVisibilityOption("Public", "Everyone can see this"),
          _buildVisibilityOption("Friends Only", "Only your followers"),
          SizedBox(height: 20),
           CustomText(text: "Tags", fontFamily: Assets.onsetSemiBold),
           SizedBox(height: 10),
           Wrap(
             spacing: 8,
             children: ["#Cozy", "#DateNight", "#GoodFood", "#LiveMusic"]
                 .map((tag) => Chip(
               label: Text(tag),
               backgroundColor: AppColors.userPrimaryColor.withOpacity(0.1),
               labelStyle: TextStyle(color: AppColors.userPrimaryColor),
               side: BorderSide.none,
             )).toList(),
           )
        ],
      ),
    );
  }

  Widget _buildVisibilityOption(String label, String sub) {
    bool isSelected = visibility == label;
    return GestureDetector(
      onTap: () => setState(() => visibility = label),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.userPrimaryColor : AppColors.greyBordersColor),
          color: isSelected ? AppColors.userPrimaryColor.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(label == "Public" ? Icons.public : Icons.people, color: AppColors.primarySlateColor),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: label, fontFamily: Assets.onsetMedium),
                  CustomText(text: sub, fontSize: sizes?.fontSize12, color: AppColors.textGreyColor),
                ],
              ),
            ),
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? AppColors.userPrimaryColor : AppColors.greyColor),
          ],
        ),
      ),
    );
  }
}
