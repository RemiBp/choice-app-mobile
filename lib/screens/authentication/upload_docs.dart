import 'dart:io';
import 'package:choice_app/utilities/extensions.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import 'package:choice_app/l18n.dart';
import '../../../res/res.dart';
import '../onboarding/onboarding_provider.dart';
import '../../../userRole/role_provider.dart';
import '../../../userRole/user_role.dart';


class UploadDocs extends StatefulWidget {
  const UploadDocs({super.key});

  @override
  State<UploadDocs> createState() => _UploadDocsState();
}

class _UploadDocsState extends State<UploadDocs> {
  File? _hospitalityDoc;
  File? _tourismDoc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().fetchOnBoardingDetail();
    });
  }

  Future<void> _pickFile(bool isHospitality) async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      setState(() {
        if (isHospitality) {
          _hospitalityDoc = File(xFile.path);
        } else {
          _tourismDoc = File(xFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          if (provider.isDocsUploaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.check_circle, color: AppColors.wellnessPrimaryColor, size: 64),
                   SizedBox(height: 16),
                   CustomText(
                    text: "Documents Uploaded",
                    fontSize: sizes?.fontSize20,
                    fontWeight: FontWeight.bold,
                   ),
                   SizedBox(height: 8),
                   CustomText(
                    text: "Your documents have been submitted and are under review.",
                    fontSize: sizes?.fontSize14,
                    color: AppColors.primarySlateColor,
                    textAlign: TextAlign.center,
                   ),
                   SizedBox(height: 24),
                   CustomButton(
                     buttonText: "Back",
                     buttonWidth: getWidth() * 0.4,
                     onTap: () {
                       if (Navigator.canPop(context)) Navigator.pop(context);
                     },
                   )
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: getWidth() * .05,
              vertical: getHeight() * .1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                   children: [
                    if (Navigator.canPop(context)) ...[
                      const CustomBackButton(),
                      SizedBox(width: getWidth() * .02),
                    ],
                    CustomText(
                      text: al.uploadDocumentsTitle,
                      fontSize: sizes?.fontSize28,
                      fontFamily: Assets.onsetSemiBold,
                    ),
                  ],
                ),
                SizedBox(height: getHeight() * .02),
                CustomText(
                  text: al.uploadDocumentsSubtitle,
                  fontSize: sizes?.fontSize16,
                  color: AppColors.primarySlateColor,
                  giveLinesAsText: true,
                ),
                SizedBox(height: getHeight() * .03),

                // Hospitality Doc
                CustomText(
                  text: al.businessRegistrationDocument,
                  fontSize: sizes?.fontSize18,
                  fontFamily: Assets.onsetSemiBold,
                  giveLinesAsText: true,
                ),
                SizedBox(height: getHeight() * .015),
                GestureDetector(
                  onTap: () => _pickFile(true),
                  child: _buildUploadBox(context, _hospitalityDoc),
                ),
                
                SizedBox(height: getHeight() * .02),
                
                // Tourism Doc
                CustomText(
                  text: al.utilityBillOrInvoice, // Using this key as placeholder or correct one
                  fontSize: sizes?.fontSize18,
                  fontFamily: Assets.onsetSemiBold,
                ),
                SizedBox(height: getHeight() * .02),
                GestureDetector(
                  onTap: () => _pickFile(false),
                  child: _buildUploadBox(context, _tourismDoc),
                ),

                SizedBox(height: getHeight() * .05),
                CustomButton(
                  buttonText: al.submitForReview,
                  isLoading: provider.isLoading,
                  backgroundColor: (_hospitalityDoc != null && _tourismDoc != null) 
                      ? AppColors.restaurantPrimaryColor 
                      : AppColors.greyColor,
                  onTap: () async {
                    if (_hospitalityDoc != null && _tourismDoc != null) {
                       final success = await provider.uploadDocuments(_hospitalityDoc!, _tourismDoc!);
                       if (success && context.mounted) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text("Documents submitted successfully")),
                         );
                       }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadBox(BuildContext context, File? file) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: DottedBorder(
        options: RectDottedBorderOptions(
          padding: EdgeInsets.all(22),
          dashPattern: [10, 10],
          color: AppColors.inputHintColor,
        ),
        child: SizedBox(
          width: getWidth(),
          child: Column(
            children: [
              if (file != null) ...[
                Icon(Icons.description, size: 40, color: AppColors.restaurantPrimaryColor),
                SizedBox(height: 8),
                CustomText(
                  text: file.path.split('/').last,
                  fontSize: sizes!.fontSize14,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 4),
                CustomText(
                  text: "Tap to change",
                  fontSize: sizes!.fontSize12,
                  color: AppColors.primarySlateColor,
                ),
              ] else ...[
                 CircleAvatar(
                  backgroundColor: _getIconBgColor(context),
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
              ]
            ],
          ),
        )
      ),
    );
  }

  Color _getIconBgColor(BuildContext context) {
    final role = context.read<RoleProvider>().role;
    switch (role) {
      case UserRole.user:
        return HexColor.fromHex("#CCECF6");
      case UserRole.restaurant:
        return HexColor.fromHex("#FDECCF");
      case UserRole.leisure:
        return HexColor.fromHex("#E9D5EC");
      case UserRole.wellness:
        return HexColor.fromHex("#DCEEDC");
    }
  }
}
