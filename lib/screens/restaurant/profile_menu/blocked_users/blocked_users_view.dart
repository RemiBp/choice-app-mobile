import 'package:choice_app/screens/restaurant/profile_menu/profile_menu_provider.dart';
import 'package:choice_app/screens/restaurant/profile_menu/profile_menu_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/blurry_back_ground.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../customWidgets/no_item_found.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';

class BlockedUsersView extends StatefulWidget {
  const BlockedUsersView({super.key});

  @override
  State<BlockedUsersView> createState() => _BlockedUsersViewState();
}

class _BlockedUsersViewState extends State<BlockedUsersView> {
  late ProfileMenuProvider profileMenuProvider;

  @override
  void initState() {
    super.initState();

    profileMenuProvider = Provider.of<ProfileMenuProvider>(
      context,
      listen: false,
    );
    profileMenuProvider.context = context;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileMenuProvider.getMyBlocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileMenuProvider>(context);
    final blocks = profileMenuProvider.getMyBlocksResponse?.data ?? [];
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: al.blockedList),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
        child: Column(
          children: [
            SizedBox(height: getHeight() * 0.02),
            Expanded(
              child:
                  blocks.isEmpty
                      ? Center(
                        child: NoItemFound(
                            image: Assets.noNotificationIcon,
                            title: 'No Blocked Users',
                            subTitle: 'You haven\'t blocked any users yet.',
                            margin: EdgeInsets.zero,
                          ),
                      )
                      : ListView.separated(
                        itemCount: blocks.length,
                        separatorBuilder:
                            (_, __) => Divider(height: getHeight() * 0.025),
                        itemBuilder: (context, index) {
                          final blockItem = blocks[index];
                          final blockedUser = blockItem.blockedUser;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: UserTile(
                                  name:
                                      blockedUser?.fullName ??
                                      blockedUser?.userName ??
                                      'Unknown',
                                  username: blockedUser?.userName ?? '',
                                  imageUrl: blockedUser?.profileImageUrl ?? '',
                                  btnText: al.unblock,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showUnblockConfirmationAlert(
                                    context: context,
                                    id: blockedUser?.id ?? 0,
                                    onUnblock: () async {
                                      final success = await profileMenuProvider.unblockUser(
                                        id: blockedUser?.id ?? 0,
                                      );
                                      if(success) {
                                        profileMenuProvider.getMyBlocks();
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  height: getHeight() * 0.03,
                                  // ~75px
                                  width: getWidth() * 0.2,
                                  //
                                  decoration: BoxDecoration(
                                    color: AppColors.greyColor,
                                    borderRadius: BorderRadius.circular(
                                      getWidth() * 0.02,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: CustomText(
                                    text: al.unblock,
                                    color: AppColors.blackColor,
                                    fontSize: sizes?.fontSize12,
                                    fontFamily: Assets.onsetRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void showUnblockConfirmationAlert({
    required BuildContext context,
    required int id,
    required VoidCallback onUnblock,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlurryBackground(
          child: unblockConfirmationAlert(
            context: context,
            onConfirm: onUnblock,
          ),
        );
      },
    );
  }

  Widget unblockConfirmationAlert({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      insetPadding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: al.unblockUser,
                  fontWeight: FontWeight.w600,
                  fontSize: sizes?.fontSize16,
                  color: AppColors.blackColor,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close_outlined,
                    color: AppColors.primarySlateColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: getHeightRatio() * 16),

            /// Message
            CustomText(
              text: al.unblockConfirmation,
              fontWeight: FontWeight.w400,
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              giveLinesAsText: true,
            ),

            SizedBox(height: getHeightRatio() * 24),

            /// Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  buttonText: al.cancel,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  buttonWidth: getWidth() * .38,
                  height: getHeight() * 0.06,
                  backgroundColor: Colors.transparent,
                  borderColor: AppColors.blackColor,
                  textColor: AppColors.blackColor,
                  textFontWeight: FontWeight.w700,
                ),
                CustomButton(
                  buttonText: al.unblock,
                  onTap: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  buttonWidth: getWidth() * .38,
                  height: getHeight() * 0.06,
                  backgroundColor: AppColors.getPrimaryColorFromContext(
                    context,
                  ),
                  borderColor: Colors.transparent,
                  textColor: Colors.white,
                  textFontWeight: FontWeight.w700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> users = const [
    {
      'name': 'Emelie',
      'username': 'emelie645',
      'image':
          'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?fit=crop&w=200&q=80',
    },
    {
      'name': 'Olivia',
      'username': 'olivia223',
      'image':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fit=crop&w=200&q=80',
    },
    {
      'name': 'Sophia',
      'username': 'sophia007',
      'image':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=200&q=80',
    },
  ];
}
