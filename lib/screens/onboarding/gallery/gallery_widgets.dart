import 'package:choice_app/appAssets/app_assets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';

class GalleryCard extends StatelessWidget {
  final bool? isMainImage;
  final String? imageFile;
  final Future<void> Function()? onRemoveImage;
  final VoidCallback? onSetMainImage;

  const GalleryCard({
    super.key,
    this.isMainImage,
    required this.imageFile,
    required this.onRemoveImage,
    required this.onSetMainImage,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = imageFile ?? Assets.galleryImage;

    // detect source
    final bool isNetworkImage = imagePath.startsWith('http');
    final bool isLocalFile = File(imagePath).existsSync();

    ImageProvider imageProvider;
    if (isNetworkImage) {
      imageProvider = NetworkImage(imagePath);
    } else if (isLocalFile) {
      imageProvider = FileImage(File(imagePath));
    } else {
      imageProvider = AssetImage(Assets.galleryImage);
    }

    return GestureDetector(
      onTap: onSetMainImage,
      child: Padding(
        padding: EdgeInsets.only(
          right: getWidth() * 0.02,
          bottom: getHeight() * 0.015,
        ),
        child: Stack(
          children: [
            Container(
              height: getHeight() * 0.12,
              width: getWidth() * 0.26,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: (isMainImage ?? false)
                    ? Border.all(width: 2, color: AppColors.blueColor)
                    : null,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isMainImage ?? false)
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.blueColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: getWidth() * 0.02,
                    vertical: getHeight() * 0.01,
                  ),
                  child: CustomText(
                    text: al.mainImage,
                    fontWeight: FontWeight.w600,
                    fontSize: sizes?.fontSize8,
                  ),
                ),
              ),
            Positioned(
              right: getWidth() * 0.02,
              top: getHeight() * 0.008,
              child: GestureDetector(
                onTap: () async {
                  if (onRemoveImage != null) {
                    await onRemoveImage!(); // await async function
                  }
                },
                child: const Icon(Icons.clear, color: AppColors.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddImageCard extends StatelessWidget {
  final Function onAddImages;
  const AddImageCard({super.key, required this.onAddImages});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> onAddImages(),
      child: Padding(
        padding:  EdgeInsets.only(right: getWidth() * 0.02, bottom: getHeight() * 0.015),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            strokeWidth: 2,
            dashPattern: [5, 5],
            radius: Radius.circular(8),
            color: Colors.grey,
          ),
          child: Container(
            height: getHeight() * 0.11,
            width: getWidth() * 0.25,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  text: "+",
                  fontWeight: FontWeight.w500,
                  fontSize: sizes?.fontSize24,
                  color: AppColors.greyBordersColor,
                ),
                // SizedBox(height: getHeight() * 0.005),
                CustomText(
                  text: al.addImages,
                  fontWeight: FontWeight.w500,
                  fontSize: sizes?.fontSize12,
                  color: AppColors.greyBordersColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}