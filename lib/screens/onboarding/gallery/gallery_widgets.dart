import 'package:choice_app/appAssets/app_assets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../res/res.dart';

class GalleryCard extends StatelessWidget {
  final bool? isMainImage;
  final String? imageFile;
  final int imageId;
  final Function(int) onRemoveImage;
  final Function(int) onSetMainImage;
  const GalleryCard({
    super.key, this.isMainImage,
    required this.imageFile,
    required this.imageId,
    required this.onRemoveImage,
    required this.onSetMainImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> onSetMainImage(imageId),
      child: Padding(
        padding:  EdgeInsets.only(right: getWidth() * 0.02, bottom: getHeight() * 0.015),
        child: Stack(
          children: [
            Container(
              height: getHeight() * 0.12,
              width: getWidth() * 0.26,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: isMainImage ?? false
                    ? Border.all(width: 2, color: AppColors.blueColor)
                    : null,
              ),
              clipBehavior: Clip.hardEdge, // ensures the image respects borderRadius
              child: Image.network(
                imageFile??"",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.getPrimaryColorFromContext(context),
                  child: Center(child: Icon(Icons.broken_image, color: Colors.white,)),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            if(isMainImage??false)
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.blueColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.02, vertical: getHeight() * 0.01),
                  child: CustomText(
                    text: "Main Image",
                    fontWeight: FontWeight.w600,
                    fontSize: sizes?.fontSize8,
                  ),
                ),
              ),
            Positioned(
              right: getWidth() * 0.02,
              top: getHeight() * 0.008,
              child: GestureDetector(
                onTap: ()=> onRemoveImage(imageId),
                child: const Icon(Icons.clear, color: AppColors.whiteColor,),
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
                  text: "Add Images",
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