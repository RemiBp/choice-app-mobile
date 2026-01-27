import 'package:choice_app/appColors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// import 'package:go_router/go_router.dart';

import '../appAssets/app_assets.dart';
import '../res/res.dart';
import 'custom_text.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // if (context.canPop()) {
        //   context.pop();
        // }
        if (Navigator.of(context).canPop()) {
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.getPrimaryColorFromContext(context),
        ),
        padding: EdgeInsets.all(10),
        child: Icon(Icons.arrow_back, color: Colors.white),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonText,
    this.buttonWidth,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.textFontFamily,
    this.textFontWeight,
    this.textFontSize,
    this.isLoading,
    this.onTap,
  });

  final String buttonText;
  final bool? isLoading;
  final Function()? onTap;
  final double? height;
  final double? buttonWidth;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? textFontSize;
  final FontWeight? textFontWeight;
  final String? textFontFamily;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? getHeightRatio() * 44,
        width: buttonWidth ?? width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor ?? Colors.transparent),
          color: backgroundColor ?? AppColors.getPrimaryColorFromContext(context),
        ),
        child: Center(
          child: (isLoading ?? false)
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: textColor ?? Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : CustomText(
                  text: buttonText,
                  fontSize: textFontSize ?? sizes?.fontSize16,
                  fontFamily: textFontFamily ?? Assets.onsetSemiBold,
                  color: textColor ?? Colors.white,
                ),
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.buttonText,
    this.buttonWidth,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.textFontFamily,
    this.textFontWeight,
    this.textFontSize,
    this.onTap,
  });

  final String buttonText;
  final Function()? onTap;
  final double? height;
  final double? buttonWidth;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? textFontSize;
  final FontWeight? textFontWeight;
  final String? textFontFamily;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? getHeightRatio() * 36,
        width: buttonWidth ?? width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor ?? Colors.transparent),
          color: backgroundColor ?? AppColors.getPrimaryColorFromContext(context),
        ),
        child: Center(
          child: CustomText(
            text: buttonText,
            fontSize: textFontSize ?? sizes?.fontSize14,
            fontWeight: FontWeight.w400,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key, this.borderRadius, required this.svgString, this.onPress, this.color});

  final double? borderRadius;
  final String svgString;
  final VoidCallback? onPress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            side: BorderSide(
              color: AppColors.greyBordersColor,
            )
          )
      ),
      onPressed: onPress, icon: SvgPicture.asset(svgString, color: color),
    );
  }
}


