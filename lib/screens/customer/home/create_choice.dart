import 'dart:io';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/common_app_bar.dart';
import 'package:choice_app/network/network_provider.dart';
import 'package:choice_app/screens/customer/home/choice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import '../../../res/toasts.dart';
import '../../../utilities/extensions.dart';

class CreateChoice extends StatefulWidget {
  const CreateChoice({super.key});

  @override
  _CreateChoiceState createState() => _CreateChoiceState();
}

class _CreateChoiceState extends State<CreateChoice> {
  String selectedDish = '';
  String visibility = 'Public';
  String? selectedEvent;
  Map<String, double> ratings = {};

  List<XFile> images = [];
  List<String> imageUrls = [];
  final ImagePicker _picker = ImagePicker();

  String _selectedOption = 'public';
  final TextEditingController shareExpController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  // --- Dynamic Criteria Mappings ---
  final Map<String, List<String>> leisureCriteriaByType = {
    "Theatre Play": ["Stage Direction", "Actor Performance", "Text Quality", "Scenography"],
    "Contemporary Theater": ["Stage Direction", "Actor Performance", "Text Quality", "Originality", "Message"],
    "Comedy Show": ["Humor", "Stage Presence", "Text Quality", "Interaction", "Rhythm"],
    "Concert Night": ["Performance", "Repertoire", "Sound", "Atmosphere"],
    "Festival": ["Lineup Quality", "Organization", "Atmosphere", "Venue Access", "Value For Money"],
  };

  final Map<String, List<String>> wellnessCriteriaByType = {
    "Beauty Institute": ["Care Quality", "Cleanliness", "Welcome", "Value For Money", "Atmosphere", "Staff Expertise"],
    "Spa": ["Care Quality", "Cleanliness", "Welcome", "Value For Money", "Atmosphere", "Staff Expertise"],
    "Massage Salon": ["Care Quality", "Cleanliness", "Welcome", "Value For Money", "Atmosphere", "Staff Expertise"],
    "Hair Salon": ["Haircut Quality", "Expectation Respect", "Advice", "Products Used", "Pricing", "Punctuality"],
    "Barber Shop": ["Haircut Quality", "Expectation Respect", "Advice", "Products Used", "Pricing", "Punctuality"],
    "Nail Salon": ["Precision", "Hygiene", "Creativity", "Durability", "Advice", "Pain Experience"],
    "Tattoo Shop": ["Precision", "Hygiene", "Creativity", "Durability", "Advice", "Pain Experience"],
  };

  /// Default general ratings per category
  List<Map<String, dynamic>> getRatingCategories(String? title) {
    if (title == "Leisure") {
      return [
        {"label": "Stage Direction", "rating": 1.0},
        {"label": "Actor Performance", "rating": 1.0},
        {"label": "Text Quality", "rating": 1.0},
        {"label": "Scenography", "rating": 1.0},
      ];
    } else if (title == "Wellness") {
      return [
        {"label": "Care Quality", "rating": 1.0},
        {"label": "Cleanliness", "rating": 1.0},
        {"label": "Welcome", "rating": 1.0},
        {"label": "Value For Money", "rating": 1.0},
        {"label": "Atmosphere", "rating": 1.0},
        {"label": "Staff Experience", "rating": 1.0},
      ];
    } else {
      return [
        {"label": al.service, "rating": 1.0},
        {"label": al.place, "rating": 1.0},
        {"label": al.portions, "rating": 1.0},
        {"label": al.ambiance, "rating": 1.0},
      ];
    }
  }

  // --- Image Picker
  Future<void> _pickImages() async {
    if (images.length >= 5) return;
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => images.add(pickedFile));
    }
  }

  void _removeImage(int index) {
    setState(() => images.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final data = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final categoryTitle = data?["title"];
    final placeId = data?["placeId"];
    final ratingCategories = getRatingCategories(categoryTitle);

    // initialize general ratings
    for (var item in ratingCategories) {
      ratings.putIfAbsent("general_${item["label"]}", () => item["rating"]);
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: al.createChoice),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: getWidth() * .05, vertical: getHeight() * .02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Overall Rating (General)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: categoryTitle == "Wellness"
                        ? al.overallWellnessRating
                        : categoryTitle == "Leisure"
                        ? al.overallLeisureRating
                        : al.overallRestaurantRating,
                    fontFamily: Assets.onsetMedium,
                    fontSize: sizes?.fontSize16,
                  ),
                  SizedBox(height: getHeight() * .01),
                  Column(
                    children: List.generate(ratingCategories.length, (index) {
                      final item = ratingCategories[index];
                      return buildRatingRow(
                        "general_${item["label"]}",
                        ratings["general_${item["label"]}"] ?? item["rating"],
                        displayTitle: item["label"],
                        isLast: index == ratingCategories.length - 1,
                      );
                    }),
                  ),
                ],
              ),
            ),

            //  Event Dropdown for Wellness/Leisure
            if (categoryTitle == "Wellness" || categoryTitle == "Leisure") ...[
              SizedBox(height: getHeight() * .02),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "${al.select} ${categoryTitle == "Leisure" ? "Leisure Event" : "Service Type"}",
                      fontFamily: Assets.onsetMedium,
                      fontSize: sizes?.fontSize16,
                    ),
                    SizedBox(height: getHeight() * .01),
                    DropdownButtonFormField<String>(
                      value: selectedEvent,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: getWidth() * .04, vertical: getHeight() * .014),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.greyBordersColor),
                        ),
                      ),
                      hint: CustomText(
                        text: al.tapToSelect,
                        fontSize: sizes?.fontSize14,
                        color: AppColors.inputHintColor,
                      ),
                      items: (categoryTitle == "Leisure"
                          ? leisureCriteriaByType.keys.toList()
                          : wellnessCriteriaByType.keys.toList())
                          .map((event) => DropdownMenuItem(
                        value: event,
                        child: CustomText(text: event, fontSize: sizes?.fontSize14),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedEvent = value;
                          // clear event ratings before adding new
                          ratings.removeWhere((key, _) => key.startsWith("event_"));
                          final criteria = categoryTitle == "Leisure"
                              ? leisureCriteriaByType[value]!
                              : wellnessCriteriaByType[value]!;
                          for (var c in criteria) {
                            ratings["event_$c"] = 1.0;
                          }
                        });
                      },
                    ),
                    SizedBox(height: getHeight() * .02),
                    if (selectedEvent != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: selectedEvent!,
                              fontFamily: Assets.onsetSemiBold,
                              fontSize: sizes?.fontSize16,
                            ),
                            SizedBox(height: getHeight() * .015),
                            Column(
                              children: List.generate(
                                (categoryTitle == "Leisure"
                                    ? leisureCriteriaByType[selectedEvent]!
                                    : wellnessCriteriaByType[selectedEvent]!)
                                    .length,
                                    (index) {
                                  final label = categoryTitle == "Leisure"
                                      ? leisureCriteriaByType[selectedEvent]![index]
                                      : wellnessCriteriaByType[selectedEvent]![index];
                                  return buildRatingRow(
                                    "event_$label",
                                    ratings["event_$label"] ?? 1.0,
                                    displayTitle: label,
                                    isLast: index ==
                                        (categoryTitle == "Leisure"
                                            ? leisureCriteriaByType[selectedEvent]!.length
                                            : wellnessCriteriaByType[selectedEvent]!.length) -
                                            1,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],

            SizedBox(height: getHeight() * .02),

            // Photos Picker
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: al.photos,
                    fontFamily: Assets.onsetMedium,
                    fontSize: sizes?.fontSize16,
                  ),
                  SizedBox(height: getHeight() * .01),
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      height: getHeight() * 0.23,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.greyBordersColor),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              text: al.chooseAFile,
                              fontFamily: Assets.onsetMedium,
                              fontSize: sizes?.fontSize14,
                            ),
                            SizedBox(height: 4),
                            CustomText(
                              text: al.upTo5Images,
                              fontSize: sizes?.fontSize12,
                              color: HexColor.fromHex("#686A82"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(images.length, (index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(images[index].path),
                          width: 100, height: 100, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => _removeImage(index),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.close, size: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),

            SizedBox(height: getHeight() * .02),

            // --- Tags
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
              ),
              padding: const EdgeInsets.all(15),
              child: CustomField(
                textEditingController: tagsController,
                borderColor: AppColors.greyBordersColor,
                hint: "e.g: #cozy, #outdoor_seating",
                label: al.tags,
              ),
            ),

            SizedBox(height: getHeight() * .02),

            // Share Experience
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: al.shareYourExperience,
                    fontFamily: Assets.onsetMedium,
                    fontSize: sizes?.fontSize16,
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: getWidth() * 0.80, // ~302px on a 375px width screen
                    height: getHeight() * 0.15, // ~120px on a 812px height screen
                    padding: EdgeInsets.symmetric(
                      horizontal: getWidth() * 0.03,
                      vertical: getHeight() * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.inputHintColor,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: shareExpController,
                      maxLines: null, // allows expansion if user types more
                      decoration: InputDecoration.collapsed(
                        hintText: '${al.shareYourExperience}...',
                        hintStyle: const TextStyle(
                          color: AppColors.inputHintColor,
                        ),
                      ),

                    ),
                  ),

                  SizedBox(height: 19),
                  buildRadio(al.public, al.anyoneCanSeeFeed, al.publicLower),
                  buildRadio(al.friendsOnly, al.yourFriendsOnChoice, al.friendsOnlyLower),
                  buildRadio(al.private, al.onlyMe, al.privateLower),
                ],
              ),
            ),

            SizedBox(height: getHeight() * .03),

            // --- Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: al.cancel,
                    backgroundColor: Colors.transparent,
                    textColor: AppColors.blackColor,
                    borderColor: AppColors.blackColor,
                    onTap: () => Navigator.pop(context),

                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    buttonText: al.publish,
                    backgroundColor: AppColors.userPrimaryColor,
                    textColor: Colors.white,
                    onTap: () {
                      debugPrint("ratings: $ratings, producer type : ${categoryTitle.toLowerCase()}");
                      onPublishTap(placeId, categoryTitle.toLowerCase());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onPublishTap(int placeId, String producerType) async {
    final provider = context.read<NetworkProvider>();
    final choiceProvider = context.read<CustomerChoiceProvider>();
    provider.context = context;

    final description = shareExpController.text.trim();
    final tags = tagsController.text.trim();

    if (images.isEmpty) {
      Toasts.getErrorToast(text: al.errorSelectImage);
      return;
    }
    if (description.isEmpty) {
      Toasts.getErrorToast(text: al.errorEnterDescription);
      return;
    }
    if (tags.isEmpty) {
      Toasts.getErrorToast(text: al.errorEnterTags);
      return;
    }

    // Upload images
    for (var i in images) {
      final bytes = await i.readAsBytes();
      final fileUrl = await provider.getUrlForFileUpload(bytes);
      debugPrint("file url is : $fileUrl");
      if (fileUrl != null) imageUrls.add(fileUrl);
    }

    if (imageUrls.isEmpty) {
      Toasts.getErrorToast(text: al.imageUploadFailed);
      return;
    }

    //  Separate general & event ratings before sending
    final Map<String, double> generalRatings = {};
    final Map<String, double> eventRatings = {};

    ratings.forEach((key, value) {
      if (key.startsWith("general_")) {
        generalRatings[key.replaceFirst("general_", "")] = value;
      } else if (key.startsWith("event_")) {
        eventRatings[key.replaceFirst("event_", "")] = value;
      }
    });

    final payloadRatings = {
      "general": generalRatings,
      "event": eventRatings,
    };


    debugPrint("🟢 Final Ratings Payload: $payloadRatings");

    await choiceProvider.createChoice(
      producerType: producerType,
      placeId: placeId,
      status: _selectedOption.toLowerCase(),
      description: description,
      tags: tags.split(",").map((t) => t.trim()).toList(),
      imageUrls: imageUrls,
      rating: payloadRatings,
    );

    Toasts.getSuccessToast(text: al.choiceCreatedSuccessfully);
    Navigator.pop(context);
    Navigator.pop(context);
  }


  Widget buildRadio(String title, String subtitle, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomText(text: title, fontSize: sizes?.fontSize14),
      subtitle: CustomText(text: subtitle, fontSize: sizes?.fontSize12),
      trailing: Radio(
        value: value,
        groupValue: _selectedOption,
        activeColor: AppColors.getPrimaryColorFromContext(context),
        onChanged: (val) => setState(() => _selectedOption = val!),
      ),
    );
  }

  Widget buildRatingRow(String key, double rating,
      {required String displayTitle, bool isLast = false}) {
    final Color activeColor =
    rating == 0 ? AppColors.inputHintColor : Colors.orange;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: displayTitle,
          fontSize: sizes?.fontSize16,
          fontFamily: Assets.onsetMedium,
        ),
        SizedBox(height: getHeight() * .01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: List.generate(
                5,
                    (index) => GestureDetector(
                  onTap: () => setState(() => ratings[key] = (index + 1).toDouble()),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.star,
                      size: 28,
                      color: index < (ratings[key] ?? rating)
                          ? Colors.amber
                          : AppColors.greyColor,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: getWidth() * 0.12,
              height: getHeight() * 0.045,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: activeColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomText(
                text: (ratings[key] ?? rating).toStringAsFixed(1),
                fontSize: sizes?.fontSize14,
                fontFamily: Assets.onsetMedium,
                color: activeColor,
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          SizedBox(height: getHeight() * .015),
          Divider(height: 1, color: AppColors.greyBordersColor),
          SizedBox(height: getHeight() * .015),
        ],
      ],
    );
  }
}
