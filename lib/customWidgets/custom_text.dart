import 'package:flutter/material.dart';

import '../appAssets/app_assets.dart';
import '../appColors/colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final bool isExpanded;
  final FontWeight? fontWeight;
  final Color? color;
  final String? fontFamily;
  final Alignment? alignment;
  final TextOverflow? textOverflow;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final int? lines;
  final bool? giveLinesAsText;
  final Color? decorationColor;
  final double? height;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.alignment,
    this.isExpanded = false,
    this.fontFamily,
    this.textOverflow,
    this.textAlign = TextAlign.start,
    this.textDecoration = TextDecoration.none,
    this.lines,
    this.giveLinesAsText, 
    this.decorationColor,
    this.height,
    this.shadows,
  });

  final List<Shadow>? shadows;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: isExpanded ? MediaQuery.of(context).size.width : null,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          height: height,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color ?? Colors.black,
          fontFamily: fontFamily ?? _resolveFontFamily(),
          decoration: textDecoration,
          decorationColor:decorationColor?? AppColors.restaurantPrimaryColor,
          shadows: shadows,
        ),
        overflow:
            giveLinesAsText == true
                ? null
                : textOverflow ?? TextOverflow.ellipsis,
        maxLines: lines,
      ),
    );
  }


  String _resolveFontFamily() {
    if (fontFamily != null) return fontFamily!;

    switch (fontWeight) {
      case FontWeight.w100:
        return Assets.onestThin;
      case FontWeight.w200:
        return Assets.onestExtraLight;
      case FontWeight.w300:
        return Assets.onestLight;
      case FontWeight.w400:
        return Assets.onsetRegular;
      case FontWeight.w500:
        return Assets.onsetMedium;
      case FontWeight.w600:
        return Assets.onsetSemiBold;
      case FontWeight.w700:
        return Assets.onsetBold;
      case FontWeight.w800:
        return Assets.onestExtraBold;
      case FontWeight.w900:
        return Assets.onestBlack;
      default:
        return Assets.onsetRegular; // fallback
    }
  }
}
