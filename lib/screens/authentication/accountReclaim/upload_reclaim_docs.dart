import 'dart:io';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/authentication/accountReclaim/reclaim_account_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import '../../../res/loader.dart';
import '../../../res/toasts.dart';
import '../../../utilities/extensions.dart';

class UploadReclaimDocs extends StatefulWidget {
  const UploadReclaimDocs({super.key});

  @override
  State<UploadReclaimDocs> createState() => _UploadReclaimDocsState();
}

class _UploadReclaimDocsState extends State<UploadReclaimDocs> {
  String? selectedDocTitle;
  final Loader _loader = Loader();

  @override
  void initState() {
    super.initState();
    Provider.of<ReclaimAccountProvider>(context, listen: false).init(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReclaimAccountProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: al.uploadDocumentsTitle,
              fontSize: sizes?.fontSize26,
              fontFamily: Assets.onsetSemiBold,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidth() * .05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: al.uploadDocumentsDescription,
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              giveLinesAsText: true,
            ),
            SizedBox(height: getHeight() * .03),

            // Document * label
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: al.document,
                  fontSize: sizes?.fontSize14,
                  fontFamily: Assets.onsetMedium,
                  color: AppColors.blackColor,
                ),
                CustomText(
                  text: " *",
                  fontSize: sizes?.fontSize14,
                  fontFamily: Assets.onsetMedium,
                  color: AppColors.redColor,
                ),
              ],
            ),
            SizedBox(height: getHeight() * .008),

            // Dropdown Field
            SizedBox(
              height: 56,
              child: DropdownButtonFormField<String>(
                value: selectedDocTitle,
                hint: CustomText(
                  text: al.selectDocument,
                  fontSize: 14,
                  fontFamily: Assets.onsetMedium,
                  color: AppColors.primarySlateColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    BorderSide(color: AppColors.greyBordersColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    BorderSide(color: AppColors.greyBordersColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: AppColors.primarySlateColor, width: 1.2),
                  ),
                ),
                dropdownColor: AppColors.whiteColor,
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppColors.blackColor,
                  fontFamily: Assets.onsetMedium,
                ),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: provider.docs.map((doc) {
                  return DropdownMenuItem<String>(
                    value: doc,
                    child: CustomText(
                      text: doc,
                      fontSize: 13.5,
                      fontFamily: Assets.onsetMedium,
                      color: AppColors.blackColor,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDocTitle = value;
                  });
                },
              ),
            ),

            SizedBox(height: getHeight() * .03),

            // Upload section only after selecting document
            if (selectedDocTitle != null) ...[
              CustomText(
                text: selectedDocTitle ?? "",
                fontSize: sizes?.fontSize18,
                fontFamily: Assets.onsetSemiBold,
              ),
              SizedBox(height: getHeight() * .015),
              CustomText(
                text: al.uploadDocuments,
                fontSize: sizes?.fontSize14,
                fontFamily: Assets.onsetMedium,
              ),
              SizedBox(height: getHeight() * .02),

              InkWell(
                onTap: () async {
                  await provider.uploadAndSubmitDocuments();
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: DottedBorder(
                    options: RectDottedBorderOptions(
                      padding: const EdgeInsets.all(22),
                      dashPattern: [10, 10],
                      color: AppColors.inputHintColor,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: getWidth(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //  Show progress if uploading
                          if (provider.isUploading && provider.uploadProgress < 1) ...[
                            CircleAvatar(
                              backgroundColor: HexColor.fromHex("#FEF5E7"),
                              child: SvgPicture.asset(Assets.pdfIcon),
                            ),
                            SizedBox(height: getHeight() * .01),
                            LinearProgressIndicator(
                              value: provider.uploadProgress,
                              backgroundColor: AppColors.greyBordersColor,
                              color: AppColors.primarySlateColor,
                              minHeight: 6,
                            ),
                            SizedBox(height: getHeight() * .01),
                            CustomText(
                              text:
                              "${(provider.uploadProgress * 100).toStringAsFixed(0)}% uploaded",
                              fontSize: sizes!.fontSize12,
                              color: AppColors.primarySlateColor,
                            ),
                          ]

                          //  Show file info only AFTER upload finishes
                          else if (provider.selectedFile != null &&
                              provider.uploadProgress >= 1) ...[
                            CircleAvatar(
                              backgroundColor: HexColor.fromHex("#FEF5E7"),
                              child: SvgPicture.asset(Assets.pdfIcon),
                            ),
                            SizedBox(height: getHeight() * .01),
                            CustomText(
                              text: provider.selectedFile!.name,
                              fontSize: sizes!.fontSize14,
                              fontFamily: Assets.onsetMedium,
                            ),
                            CustomText(
                              text: "Uploaded successfully",
                              fontSize: sizes!.fontSize12,
                              color: AppColors.primarySlateColor,
                            ),
                          ]

                          //  Default: before file selection
                          else ...[
                              CircleAvatar(
                                backgroundColor: HexColor.fromHex("#FEF5E7"),

                                child: SvgPicture.asset(Assets.pdfIcon),
                              ),
                              SizedBox(height: getHeight() * .01),
                              CustomText(
                                text: al.chooseFile,
                                fontSize: sizes!.fontSize14,
                                fontFamily: Assets.onsetMedium,
                              ),
                              CustomText(
                                text: al.maxFileSizeNote,
                                fontSize: sizes!.fontSize12,
                                color: AppColors.primarySlateColor,
                              ),
                            ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],

            const Spacer(),

            CustomButton(
              buttonText: "Submit & Review",
              onTap: () {
                context.push(Routes.restaurantProfileRoute);
              },
            ),

            SizedBox(height: getHeight() * .05),
          ],
        ),
      ),
    );
  }
}
