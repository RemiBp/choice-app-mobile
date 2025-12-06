import 'package:flutter/material.dart';
import '../appAssets/app_assets.dart';
import '../appColors/colors.dart';
import '../l18n.dart';
import '../res/res.dart';
import 'custom_text.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackArrow;
  final bool? showEditButton;
  final bool? hideBottomBorder;
  final Function? onEdit;
  final bool showMenuButton;
  final VoidCallback? onReport;
  final VoidCallback? onBlock;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackArrow = true,
    this.showEditButton,
    this.hideBottomBorder,
    this.onEdit,
    this.showMenuButton = false,
    this.onReport,
    this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          if (showBackArrow)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.only(right: getWidth() * 0.02),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.blackColor,
                ),
              ),
            ),
          // IconButton(
          //   icon: const Icon(Icons.arrow_back, color: AppColors.blackColor,),
          //   onPressed: () => Navigator.pop(context),
          // ),
          Expanded(
            child: CustomText(
              text: title,
              fontWeight: FontWeight.w600,
              fontSize: sizes?.fontSize18,
            ),
          ),
        ],
      ),
      foregroundColor: AppColors.whiteColor,
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      actions: [
        if (showEditButton ?? false)
          TextButton.icon(
            onPressed: () {
              if (onEdit != null) {
                onEdit!();
              }
            },
            icon: Image.asset(
              Assets.editIcon, // update with your actual asset path
              height: getHeightRatio() * 15,
              width: getWidthRatio() * 15,
              color: AppColors.getPrimaryColorFromContext(
                context,
              ), // optional: tint if needed
            ),
            label: CustomText(
              text: al.edit,
              fontWeight: FontWeight.w500,
              fontSize: sizes?.fontSize16,
              color: AppColors.getPrimaryColorFromContext(context),
            ),
          ),
        if (showMenuButton)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.blackColor),
            color: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'report',
                child: Row(
                  children: [
                    const Icon(Icons.flag, size: 18, color: Colors.red),
                    const SizedBox(width: 8),
                    CustomText(
                      text: al.report,
                      fontSize: sizes?.fontSize14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'block',
                child: Row(
                  children: [
                    const Icon(Icons.block, size: 18, color: Colors.red),
                    const SizedBox(width: 8),
                    CustomText(
                      text: al.block,
                      fontSize: sizes?.fontSize14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (String value) {
              if (value == 'report' && onReport != null) {
                onReport?.call();
              } else if (value == 'block' && onBlock != null) {
                onBlock?.call();
              }
            },
          ),
      ],
      shape:
          hideBottomBorder ?? false
              ? Border()
              : const Border(
                bottom: BorderSide(color: AppColors.greyBordersColor, width: 1),
              ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
