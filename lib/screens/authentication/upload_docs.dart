import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/utilities/extensions.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';

class UploadDocs extends StatefulWidget {
  const UploadDocs({super.key});

  @override
  State<UploadDocs> createState() => _UploadDocsState();
}

class _UploadDocsState extends State<UploadDocs> {
  bool _isSubmitting = false;

  Future<void> _onSubmit() async {
    setState(() => _isSubmitting = true);
    // S3 upload not yet configured — navigate directly to dashboard
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    context.go(Routes.restaurantBottomTabRoute);
  }

  Widget _uploadBox() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: DottedBorder(
        options: RectDottedBorderOptions(
          padding: const EdgeInsets.all(22),
          dashPattern: const [10, 10],
          color: AppColors.inputHintColor,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
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
          ),
        ),
      ),
    );
  }

  Widget _datePicker() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.greyBordersColor),
      ),
      padding: EdgeInsets.all(getHeight() * .017),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: al.selectDate,
            fontSize: sizes!.fontSize16,
            color: AppColors.inputHintColor,
          ),
          Icon(Icons.calendar_month, color: AppColors.inputHintColor),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppTranslations.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: getHeight() * .1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (context.canPop()) ...[
                  CustomBackButton(),
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
            CustomText(
              text: al.businessRegistrationDocument,
              fontSize: sizes?.fontSize18,
              fontFamily: Assets.onsetSemiBold,
              giveLinesAsText: true,
            ),
            SizedBox(height: getHeight() * .015),
            CustomText(
              text: al.expiryDate,
              fontSize: sizes!.fontSize14,
              fontFamily: Assets.onsetMedium,
            ),
            SizedBox(height: getHeight() * .02),
            _datePicker(),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.uploadDocumentsTitle,
              fontSize: sizes!.fontSize14,
              fontFamily: Assets.onsetMedium,
            ),
            SizedBox(height: getHeight() * .02),
            _uploadBox(),
            SizedBox(height: getHeight() * .03),
            CustomText(
              text: al.utilityBillOrInvoice,
              fontSize: sizes?.fontSize18,
              fontFamily: Assets.onsetSemiBold,
            ),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.expiryDate,
              fontSize: sizes!.fontSize14,
              fontFamily: Assets.onsetMedium,
            ),
            SizedBox(height: getHeight() * .02),
            _datePicker(),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.uploadDocumentsTitle,
              fontSize: sizes!.fontSize14,
              fontFamily: Assets.onsetMedium,
            ),
            SizedBox(height: getHeight() * .02),
            _uploadBox(),
            SizedBox(height: getHeight() * .05),
            CustomButton(
              buttonText: _isSubmitting ? '...' : al.submitForReview,
              onTap: _isSubmitting ? null : _onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
