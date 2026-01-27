import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/animations/bouncing_wrapper.dart';
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
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  String selectedLanguage = 'English';

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
    selectedLanguage = provider.selectedLocal == "en" ? "English" : "French";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageSelectionProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.isFromProfile == true 
          ? AppBar(
              title: CustomText(text: al.selectLanguage, fontFamily: Assets.onsetSemiBold),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getWidth() * .05,
            vertical: getHeight() * .05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               if(widget.isFromProfile != true) ...[
                 SizedBox(height: getHeight() * 0.05),
                 CustomText(
                  text: al.selectLanguage,
                  fontSize: sizes?.fontSize28,
                  fontFamily: Assets.onsetBold,
                ),
                SizedBox(height: 10),
                CustomText(
                  text: al.choosePreferredLanguage,
                  fontSize: sizes?.fontSize16,
                  color: AppColors.textGreyColor,
                  giveLinesAsText: true,
                ),
                SizedBox(height: 40),
               ],
              
              Row(
                children: [
                  Expanded(
                    child: _buildLanguageCard('English', Assets.ukFlagIcon),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildLanguageCard('French', Assets.franceFlagIcon),
                  ),
                ],
              ),
              
              Spacer(),
              
              widget.isFromProfile == true
                  ? Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            buttonText: 'Cancel',
                            onTap: () => Navigator.pop(context),
                            backgroundColor: Colors.grey.shade100,
                            textColor: Colors.black,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            buttonText: 'Save',
                            onTap: () {
                               _save(provider);
                               Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    )
                  : CustomButton(
                      buttonText: al.update,
                      onTap: () {
                        _save(provider);
                        context.go(Routes.signupRoute);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _save(LanguageSelectionProvider provider) {
      final locale = selectedLanguage == "English" ? "en" : "fr";
      provider.changeLocale(locale);
  }

  Widget _buildLanguageCard(String label, String flagPath) {
    bool isSelected = selectedLanguage == label;
    return BouncingWrapper(
      onTap: () => selectLanguage(label),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.userPrimaryColor.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.userPrimaryColor : AppColors.greyBordersColor,
            width: 2,
          ),
          boxShadow: isSelected 
              ? [BoxShadow(color: AppColors.userPrimaryColor.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 4))] 
              : [],
        ),
        child: Column(
          children: [
            SvgPicture.asset(flagPath, height: 40),
            SizedBox(height: 16),
            CustomText(
              text: label,
              fontSize: sizes?.fontSize16,
              fontFamily: isSelected ? Assets.onsetBold : Assets.onsetMedium,
              color: isSelected ? AppColors.userPrimaryColor : Colors.black,
            ),
            SizedBox(height: 8),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.userPrimaryColor : AppColors.greyBordersColor,
            ),
          ],
        ),
      ),
    );
  }
}
