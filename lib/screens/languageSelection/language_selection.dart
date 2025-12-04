import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/l18n.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/languageSelection/language_selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../appAssets/app_assets.dart';
import '../../customWidgets/custom_button.dart';
import '../../routes/routes.dart';

class LanguageSelection extends StatefulWidget {
  final bool? isFromProfile;
  const LanguageSelection({super.key, this.isFromProfile});

  @override
  LanguageSelectionState createState() => LanguageSelectionState();
}

class LanguageSelectionState extends State<LanguageSelection> {
  String selectedLanguage = al.english;

  void selectLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<LanguageSelectionProvider>(
      context,
      listen: false,
    );
    selectedLanguage = provider.selectedLocal == "en" ? al.english : al.french;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageSelectionProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: widget.isFromProfile == true
          ? AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: CustomText(
          text: al.language,
          fontSize: sizes?.fontSize18,
          fontFamily: Assets.onsetSemiBold,
          color: AppColors.blackColor,
        ),
      )
          : null,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: widget.isFromProfile == true
              ? getHeight() * .02 // Reduced vertical padding when AppBar exists
              : getHeight() * .1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Only show this title if NOT from profile (no AppBar)
            if (widget.isFromProfile != true) ...[
              CustomText(
                text: al.selectLanguage,
                fontSize: sizes?.fontSize28,
                fontFamily: Assets.onsetSemiBold,
              ),
              SizedBox(height: getHeight() * .01),
              CustomText(
                text: al.choosePreferredLanguage,
                fontSize: sizes?.fontSize16,
                giveLinesAsText: true,
              ),
              SizedBox(height: getHeight() * .03),
            ] else ...[
              // Add some spacing when coming from profile
              SizedBox(height: getHeight() * .02),
            ],

            languageOption(label: al.english, flagPath: Assets.ukFlagIcon),

            const SizedBox(height: 12),

            languageOption(label: al.french, flagPath: Assets.franceFlagIcon),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: getHeight() * .02,
        ),
        child: widget.isFromProfile == true
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
              buttonText: al.cancel,
              onTap: () {
                Navigator.pop(context);
              },
              buttonWidth: getWidth() * .42,
              backgroundColor: Colors.transparent,
              borderColor: AppColors.blackColor,
              textColor: AppColors.blackColor,
              textFontWeight: FontWeight.w700,
            ),
            CustomButton(
              buttonText: al.saveChanges,
              onTap: () async {
                final locale =
                selectedLanguage == al.english ? "en" : "fr";
                provider.changeLocale(locale);
                context.pop();
                context.pop();
              },
              buttonWidth: getWidth() * .42,
              backgroundColor:
              AppColors.getPrimaryColorFromContext(context),
              borderColor: AppColors.getPrimaryColorFromContext(context),
              textColor: AppColors.whiteColor,
              textFontWeight: FontWeight.w700,
            ),
          ],
        )
            : SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final locale =
              selectedLanguage == al.english ? "en" : "fr";
              provider.changeLocale(locale);
              context.push(Routes.authRoute).then((_) => setState(() {}));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
              AppColors.getPrimaryColorFromContext(context),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: CustomText(
              text: al.continueText,
              fontSize: sizes?.fontSize16,
              fontFamily: Assets.onsetSemiBold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget languageOption({required String label, required String flagPath}) {
    bool isSelected = selectedLanguage == label;

    return InkWell(
      onTap: () => selectLanguage(label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.getPrimaryColorFromContext(context).withAlpha(20)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColors.getPrimaryColorFromContext(context)
                : AppColors.greyBordersColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(flagPath, height: getHeight() * .02),
            const SizedBox(width: 12),
            CustomText(
              text: label,
              fontSize: sizes?.fontSize16,
              fontFamily: Assets.onsetMedium,
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: AppColors.getPrimaryColorFromContext(context),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}