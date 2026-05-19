import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../appAssets/app_assets.dart';
import '../../customWidgets/custom_text.dart';
import '../../l18n.dart';
import '../../res/res.dart';

class AuthSelectionCard extends StatelessWidget {
  const AuthSelectionCard({
    super.key,
    required this.bgColorCode,
    required this.iconBgColorCode,
    required this.borderColorCode,
    required this.title,
    required this.description,
    required this.svgString,
    required this.onTap,
  });

  final String bgColorCode;
  final String iconBgColorCode;
  final String borderColorCode;
  final String title;
  final String description;
  final String svgString;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: HexColor.fromHex(bgColorCode),
          border: Border.all(color: HexColor.fromHex(borderColorCode)),
        ),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: HexColor.fromHex(iconBgColorCode),
              ),
              padding: EdgeInsets.all(8),
              child: SvgPicture.asset(svgString),
            ),
            SizedBox(width: getWidth() * .03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: sizes?.fontSize16,
                    fontFamily: Assets.onsetSemiBold,
                    giveLinesAsText: true,
                  ),
                  SizedBox(height: getHeight() * .005),
                  CustomText(
                    text: description,
                    fontSize: sizes?.fontSize14,
                    giveLinesAsText: true,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.buttonLabel, this.onPress, required this.svgString});

  final String buttonLabel;
  final String svgString;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.black
        )
        ),
        fixedSize: const Size(150, 48),
      ),
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(svgString),
          SizedBox(width: getWidth() * .02),
          CustomText(text: buttonLabel, fontSize: sizes?.fontSize16),
        ],
      ),
    );
  }
}
