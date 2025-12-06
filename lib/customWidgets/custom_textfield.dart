import 'package:choice_app/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../appAssets/app_assets.dart';
import '../appColors/colors.dart';
import '../res/res.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    this.textEditingController,
    this.onTap,
    this.hint,
    this.textInputType,
    this.width,
    this.hidePassword = false,
    this.clickIcon,
    this.validate,
    this.borderColor,
    this.bgColor,
    this.hintColor,
    this.hintFontFamily,
    this.labelFontSize,
    this.inputFormatters,
    this.obscure = false,
    this.label,
    this.hintFontSize,
    this.labelFontFamily,
    this.enabled = true,
    this.maxLines,
    this.onChanged,
    this.height,
    this.borderRadius,
    this.suffixIcon,
    this.prefixIconSvg,
    this.suffixIconSvg,
    // this.validator,

  });

  final TextEditingController? textEditingController;
  final String? hint;
  final String? label;
  final TextInputType? textInputType;
  final double? width;
  final double? height;
  final bool hidePassword;
  final Function()? onTap; // NEW
  final bool obscure;
  final Function? clickIcon;
  final String? Function(String?)? validate;
  final Color? borderColor;
  final Color? bgColor;
  final double? labelFontSize;
  final double? hintFontSize;
  final String? hintFontFamily;
  final String? labelFontFamily;
  final Color? hintColor;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final Function(String)? onChanged;
  final double? borderRadius;
  final IconData? suffixIcon;
  final String? prefixIconSvg;
  final String? suffixIconSvg;
  // final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          SizedBox(height: getHeight() * .006),
          RichText(
            text: TextSpan(
              text: label!,
              style: TextStyle(
                fontSize: sizes!.fontSize14,
                fontFamily: Assets.onsetMedium,
                color: AppColors.blackColor, // or your normal label color
              ),
              children: const [
                TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: AppColors.redColor,
                    fontSize: 14, // same as label font size
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getHeight() * .01),
        ],
        Container(
          height: height ?? getHeight() * .07,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 15),
            color: bgColor ?? Colors.transparent,
          ),
          child: TextFormField(
            validator: validate,
            inputFormatters: inputFormatters,
            textAlignVertical: TextAlignVertical.center,
            expands: maxLines != null ? false : true,
            controller: textEditingController,
            obscureText: hidePassword,

            obscuringCharacter: "●",
            cursorHeight: getHeight() * .025,
            keyboardType: textInputType ?? TextInputType.text,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontSize: sizes!.fontSize15),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              constraints:
                  width != null ? BoxConstraints(maxWidth: width!) : null,
              filled: true,
              fillColor: bgColor ?? Colors.transparent,
              border:
                  borderColor != null
                      ? buildOutlineInputBorder(borderColor)
                      : InputBorder.none,
              focusedBorder:
                  borderColor != null
                      ? buildOutlineInputBorder(AppColors.inputHintColor)
                      : InputBorder.none,
              errorBorder: buildOutlineInputBorder(AppColors.inputHintColor),
              focusedErrorBorder: buildOutlineInputBorder(AppColors.inputHintColor),
              prefixIcon:
                  prefixIconSvg != null
                      ? SvgPicture.asset(prefixIconSvg!)
                      : null,
              prefixIconConstraints: BoxConstraints(
                maxHeight: getHeight() * .03,
                minHeight: getHeight() * .02,
                minWidth: getWidth() * .1,
              ),

              enabled: enabled,
              contentPadding: EdgeInsets.only(
                left: getWidth() * .05,
                right: getWidth() * .02,
                bottom: getHeight() * .01,
                top: obscure ? getHeight() * .038 : getHeight() * .01,
              ),
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: hintFontSize ?? sizes!.fontSize15,
                color: hintColor ?? AppColors.inputHintColor,
              ),
              suffix: suffixIconSvg!=null?SvgPicture.asset(suffixIconSvg!):null,
              suffixIcon:
                  obscure
                      ? InkWell(
                        child:
                            hidePassword
                                ? Icon(
                                  suffixIcon ?? Icons.visibility_off_rounded,
                                  size: getHeight() * .026,
                              color: HexColor.fromHex("#818397"),
                                )
                                : Icon(
                                  suffixIcon ?? Icons.visibility_rounded,
                                  color: HexColor.fromHex("#818397"),
                                  size: getHeight() * .026,
                                ),
                        onTap: () {
                          if (clickIcon != null) {
                            clickIcon?.call();
                          }
                        },
                      )
                      : null,
            ),

            maxLines: maxLines,
            onChanged: onChanged,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String? label;
  final String? hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final Color? borderColor;
  final double? height;
  final double? borderRadius;

  const CustomDropdownField({
    super.key,
    this.label,
    this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.borderColor,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          SizedBox(height: getHeight() * .006),
          RichText(
            text: TextSpan(
              text: label!,
              style: TextStyle(
                fontSize: sizes!.fontSize14,
                fontFamily: Assets.onsetMedium,
                color: AppColors.blackColor,
              ),
              children: const [
                TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: AppColors.redColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getHeight() * .01),
        ],

        // Match TextFormField container style
        Container(
          height: height ?? getHeight() * .07,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? AppColors.inputHintColor),
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: getWidth() * .05,
              right: getWidth() * .02,
              top: getHeight() * .01,
              bottom: getHeight() * .01,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                hint: Text(
                  hint ?? "",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: sizes!.fontSize15,
                    color: AppColors.inputHintColor,
                  ),
                ),
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),

                // ✅ Force dropdown menu background to white
                dropdownColor: Colors.white,

                items: items.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(
                      type,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: sizes!.fontSize15,
                        color: AppColors.blackColor,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class CustomField2 extends StatelessWidget {
  const CustomField2({
    super.key,
    this.textEditingController,
    this.hint,
    this.textInputType,
    this.width,
    this.hidePassword = false,
    this.clickIcon,
    this.validate,
    this.borderColor,
    this.bgColor,
    this.hintColor,
    this.hintFontFamily,
    this.labelFontSize,
    this.inputFormatters,
    this.obscure = false,
    this.label,
    this.hintFontSize,
    this.labelFontFamily,
    this.enabled = true,
    this.maxLines,
    this.onChanged,
    this.height,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
  });

  final TextEditingController? textEditingController;
  final String? hint;
  final String? label;
  final TextInputType? textInputType;
  final double? width;
  final double? height;
  final bool hidePassword;
  final bool obscure;
  final Function? clickIcon;
  final String? Function(String?)? validate;
  final Color? borderColor;
  final Color? bgColor;
  final double? labelFontSize;
  final double? hintFontSize;
  final String? hintFontFamily;
  final String? labelFontFamily;
  final Color? hintColor;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final Function(String)? onChanged;
  final double? borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? getHeight() * .07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 15),
        color: bgColor ?? Colors.transparent,
      ),
      child: TextFormField(
        validator: validate,
        inputFormatters: inputFormatters,
        textAlignVertical: TextAlignVertical.center,
        expands: maxLines != null ? false : true,
        controller: textEditingController,
        obscureText: hidePassword,
        obscuringCharacter: "●",

        cursorHeight: getHeight() * .025,
        keyboardType: textInputType ?? TextInputType.text,
        style: Theme.of(
          context,
        ).textTheme.displaySmall?.copyWith(fontSize: sizes!.fontSize15),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          constraints: width != null ? BoxConstraints(maxWidth: width!) : null,
          filled: false,
          border:
              borderColor != null
                  ? buildOutlineInputBorder(borderColor)
                  : InputBorder.none,
          focusedBorder:
              borderColor != null
                  ? buildOutlineInputBorder(borderColor)
                  : InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          prefixIcon: prefixIcon,
          prefixIconConstraints: BoxConstraints(
            maxHeight: getHeight() * .03,
            minHeight: getHeight() * .02,
            minWidth: getWidth() * .1,
          ),

          enabled: enabled,
          contentPadding: EdgeInsets.only(
            left: getWidth() * .05,
            right: getWidth() * .02,
            bottom: getHeight() * .01,
            top: obscure ? getHeight() * .02 : getHeight() * .01,
          ),
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: hintFontSize ?? sizes!.fontSize15,
            color: hintColor ?? AppColors.inputHintColor,
          ),
          suffixIcon: suffixIcon,
          suffixIconConstraints: BoxConstraints(
            maxHeight: getHeight() * .03,
            minHeight: getHeight() * .02,
            minWidth: getWidth() * .1,
          ),
        ),

        maxLines: maxLines,
        onChanged: onChanged,
      ),
    );
  }
}

OutlineInputBorder buildOutlineInputBorder(Color? borderColor, {double radius = 15}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
      width: 1,
      color: borderColor ?? AppColors.greyBordersColor,
    ),
  );
}


class CustomGooglePlacesField extends StatelessWidget {
  const CustomGooglePlacesField({
    super.key,
    required this.textEditingController,
    required this.googleAPIKey,
    this.hint,
    this.label,
    this.borderColor,
    this.bgColor,
    this.hintColor,
    this.hintFontSize,
    this.labelFontSize,
    this.labelFontFamily,
    this.hintFontFamily,
    this.width,
    this.height,
    this.borderRadius,
    this.countries,
    this.onPlaceSelected,
    this.enabled = true,
  });

  final TextEditingController textEditingController;
  final String googleAPIKey;
  final String? hint;
  final String? label;
  final Color? borderColor;
  final Color? bgColor;
  final Color? hintColor;
  final double? hintFontSize;
  final double? labelFontSize;
  final String? labelFontFamily;
  final String? hintFontFamily;
  final double? width;
  final double? height;
  final double? borderRadius;
  final List<String>? countries;
  final Function(Prediction)? onPlaceSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final double fieldHeight = height ?? getHeight() * .07;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // LABEL (Same as CustomField)
        if (label != null) ...[
          SizedBox(height: getHeight() * .006),
          RichText(
            text: TextSpan(
              text: label!,
              style: TextStyle(
                fontSize: labelFontSize ?? sizes!.fontSize14,
                fontFamily: labelFontFamily ?? Assets.onsetMedium,
                color: AppColors.blackColor,
              ),
              children: const [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: AppColors.redColor, fontSize: 14),
                ),
              ],
            ),
          ),
          SizedBox(height: getHeight() * .01),
        ],

        // FIELD BOX (Matches CustomField EXACTLY)
        Container(
          height: fieldHeight,
          decoration: BoxDecoration(
            color: bgColor ?? AppColors.whiteColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 15),
            border: Border.all(
              color: borderColor ?? AppColors.greyBordersColor,
              width: 1,

            ),
          ),

          child: Center(
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: textEditingController,
              googleAPIKey: googleAPIKey,

              // MATCH CustomField Padding
              inputDecoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: bgColor ?? Colors.transparent,

                // REMOVE inner borders completely
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 15),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 15),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 15),
                  borderSide: BorderSide.none,
                ),

                contentPadding: EdgeInsets.only(
                  left: getWidth() * .05,
                  right: getWidth() * .02,
                  bottom: getHeight() * .01,
                  top: getHeight() * .01,
                ),

                hintStyle: TextStyle(
                  fontSize: hintFontSize ?? sizes!.fontSize15,
                  color: hintColor ?? AppColors.inputHintColor,
                ),
              ),

              // MATCH text style of CustomField
              textStyle: TextStyle(
                fontSize: sizes!.fontSize15,
                color: AppColors.blackColor,
              ),

              // Remove "x" button
              isCrossBtnShown: false,

              // Delay searching
              debounceTime: 600,

              countries: countries ?? ["pk", "fr"],
              isLatLngRequired: true,

              getPlaceDetailWithLatLng: (prediction) {
                if (onPlaceSelected != null) {
                  onPlaceSelected!(prediction);
                }
              },

              itemClick: (prediction) {
                textEditingController.text = prediction.description ?? "";
                textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: prediction.description?.length ?? 0),
                );
              },

              seperatedBuilder: Divider(
                height: 1,
                color: AppColors.greyBordersColor,
              ),

              containerHorizontalPadding: getWidth() * .03,

              // Suggestion row
              itemBuilder: (context, index, prediction) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: getHeight() * .015,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.getPrimaryColorFromContext(context),
                      ),
                      SizedBox(width: getWidth() * .03),
                      Expanded(
                        child: Text(
                          prediction.description ?? "",
                          style: TextStyle(
                            fontSize: sizes?.fontSize14,
                            color: AppColors.blackColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
