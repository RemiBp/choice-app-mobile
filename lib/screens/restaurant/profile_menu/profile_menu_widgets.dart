import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/common/utils.dart';
import 'package:choice_app/res/strings.dart';
import 'package:choice_app/screens/restaurant/profile_menu/follower/follower_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/following/following_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/icon_svg.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import '../../customer/profile/customer_profile/customer_profile_provider.dart';

class ProfileMenuAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Function onSetting;
  final Function onSwitchAccount;

  const ProfileMenuAppBar({
    super.key,
    required this.onSetting,
    required this.onSwitchAccount,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: GestureDetector(
        onTap: ()=> onSwitchAccount(),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: sizes!.pagePadding),
              child: CustomText(
                text: PreferenceUtils.getString(Strings.name)??"",
                fontWeight: FontWeight.w600,
                fontSize: sizes?.fontSize18,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(width: getWidth() * 0.02),
            Icon(Icons.keyboard_arrow_down_sharp, color: AppColors.blackColor,)
          ],
        ),
      ),
      foregroundColor: AppColors.whiteColor,
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      actions: [
        GestureDetector(
          onTap: ()=> onSetting(),
          child: Padding(
            padding: EdgeInsets.only(right: sizes!.pagePadding),
            child: Image.asset(Assets.settingIcon, height: getHeight() * 0.04,),
          ),
        )
      ],
      shape: const Border(
        bottom: BorderSide(
          color: AppColors.greyBordersColor,
          width: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class RestaurantProfileHeader extends StatelessWidget {
  const RestaurantProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
      child: Row(
        children: [
          // Profile Picture
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              "https://i.imgur.com/QCNbOAo.png", // Replace with restaurant image URL
            ),
          ),
          SizedBox(width: getWidth() * 0.02),

          // Name + Stats Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Name
                CustomText(
                  text: "The Wholesome Fork",
                  textOverflow: TextOverflow.ellipsis,
                  fontSize: sizes?.fontSize16,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),

                SizedBox(height: 8),

                // Stats Row (Choices | Followers | Following)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem("0", "Choices"),
                    Image.asset(
                        Assets.verticalLine, height: getHeight() * 0.03),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FollowerView()),
                        );
                      },
                      child: _buildStatItem("0", al.follower),
                    ),
                    Image.asset(
                        Assets.verticalLine, height: getHeight() * 0.03),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FollowingView()),
                        );
                      },
                      child: _buildStatItem("0",al.following),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        CustomText(
          text: value,
          textOverflow: TextOverflow.ellipsis,
          fontSize: sizes?.fontSize16,
          color: AppColors.blackColor,
          fontWeight: FontWeight.w600,
        ),
        CustomText(
          text: label,
          textOverflow: TextOverflow.ellipsis,
          fontSize: sizes?.fontSize12,
          color: AppColors.blackColor,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}

class ProfileTabItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final int tabIndex;
  final int selectedTabIndex;

  const ProfileTabItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.tabIndex,
    required this.selectedTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = tabIndex == selectedTabIndex;
    final Color activeColor = AppColors.getPrimaryColorFromContext(context);
    final Color textColor = isSelected ? activeColor : AppColors.inputHintColor;
    final Color iconColor = isSelected ? activeColor : Colors.grey;

    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: getWidth() * 0.04,
            color: iconColor,
          ),
          SizedBox(width: getWidth() * 0.01),
          CustomText(
            text: label,
            textOverflow: TextOverflow.ellipsis,
            fontSize: sizes?.fontSize14,
            color: textColor,
            fontWeight: FontWeight.w500,
            giveLinesAsText: true,
          ),
        ],
      ),
    );
  }
}



class OperatingHourItem extends StatelessWidget {
  const OperatingHourItem({super.key,
    required this.day,
    required this.time,
  });

  final String day;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getHeight() *  0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: "$day:",
            fontSize: sizes?.fontSize14,
            fontWeight: FontWeight.w400,
            color: AppColors.primarySlateColor,
          ),
          CustomText(
            text: time,
            fontSize: sizes?.fontSize14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class CustomerProfileHeader extends StatelessWidget {
  const CustomerProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProfileProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
      child: Row(
        children: [
           CircleAvatar(
            radius: 30,
             backgroundImage: NetworkImage(
                 provider.user?.profileImageUrl != null
                     ? provider.user!.profileImageUrl!
                     : "https://naushkinskoe-r81.gosweb.gosuslugi.ru/netcat_files/154/1671/image_3_0.jpg"),
          ),
          SizedBox(width: getWidth() * 0.02),
          Expanded( // Ensures the right side takes remaining space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text:provider.user?.fullName??"" ,
                  textOverflow: TextOverflow.ellipsis,
                  fontSize: sizes?.fontSize16,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem("0", "Choices"),
                    Image.asset(Assets.verticalLine, height: getHeight() * 0.03),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FollowerView()),
                        );
                      },
                      child: _buildStatItem("${provider.user?.followersCount}", al.follower),
                    ),
                    Image.asset(Assets.verticalLine, height: getHeight() * 0.03),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FollowingView()),
                        );
                      },
                      child: _buildStatItem("${provider.user?.followersCount}", al.following),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        CustomText(
          text: value,
          textOverflow: TextOverflow.ellipsis,
          fontSize: sizes?.fontSize16,
          color: AppColors.blackColor,
          fontWeight: FontWeight.w600,
        ),
        CustomText(
          text: label,
          textOverflow: TextOverflow.ellipsis,
          fontSize: sizes?.fontSize12,
          color: AppColors.blackColor,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}

class ProfileMenuDetailAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Function onReport;
  final Function onBlock;
  final Function onSwitchAccount;

  const ProfileMenuDetailAppBar({
    super.key,
    required this.onReport,
    required this.onBlock,
    required this.onSwitchAccount,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(left: sizes!.pagePadding),
              child: Icon(Icons.arrow_back_ios, color: AppColors.blackColor,),
            ),
          ),
          GestureDetector(
            onTap: ()=> onSwitchAccount(),
            child: Padding(
              padding: EdgeInsets.only(left: getWidth() * 0.02),
              child: CustomText(
                text: "The Wholesome Fork",
                fontWeight: FontWeight.w600,
                fontSize: sizes?.fontSize18,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(width: getWidth() * 0.02),
          Icon(Icons.keyboard_arrow_down_sharp, color: AppColors.blackColor)
        ],
      ),
      foregroundColor: AppColors.whiteColor,
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      actions: [
        PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.more_vert, color: AppColors.blackColor,),
          color: AppColors.whiteColor,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: al.report,
              onTap: ()=> onReport(),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.reportUserIcon,
                    width: getWidth() * .03,
                  ),
                  SizedBox(width: getWidth() * 0.015),
                  CustomText(
                    text: al.report,
                    fontSize: sizes?.fontSize14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.redColor,
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: al.block,
              onTap: ()=> onBlock(),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.blockUser,
                    width: getWidth() * .03,
                  ),
                  SizedBox(width: getWidth() * 0.015),
                  CustomText(
                    text: al.block,
                    fontSize: sizes?.fontSize14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.redColor,
                  ),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == al.edit) {
              // handle edit
            } else if (value == al.delete) {
              // handle delete
            }
          },
        )
      ],
      shape: const Border(
        bottom: BorderSide(
          color: AppColors.greyBordersColor,
          width: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SwitchAccountBottomSheet extends StatelessWidget {
  const SwitchAccountBottomSheet({super.key, required BuildContext context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: sizes!.pagePadding,
          vertical: getHeight() * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap height to content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: getWidth() * 0.25,
                  height: getHeight() * 0.006,
                  decoration: BoxDecoration(
                    color: AppColors.greyBordersColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: getHeight() * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: al.switchAccount,
                    fontSize: sizes?.fontSize18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: AppColors.primarySlateColor),
                  ),
                ],
              ),
              SizedBox(height: getHeight() * 0.03),
              Container(
        padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.025, vertical: getHeight() * 0.02),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withAlpha(20),
              blurRadius: 24,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: getHeight() * .03,
                    backgroundColor: AppColors.greyColor,
                    // backgroundImage:
                    // provider.profileImage != null
                    //     ? FileImage(provider.profileImage!)
                    //     : null,
                    child:
                    // provider.profileImage == null?
                    SvgPicture.asset(
                      Assets.userIcon,
                      height: getHeight() * .02,
                      color: Colors.grey.shade600,
                    )
                  // : null,
                ),
                SizedBox(width: getWidth() * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "The Wholesome Fork",
                        fontSize: sizes?.fontSize14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                      CustomText(
                        text: "example@thewholesomefork.com",
                        fontSize: sizes?.fontSize12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inputHintColor,
                      )
                    ],
                  ),
                ),
                SizedBox(width: getWidth() * 0.02),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: AppColors.getPrimaryColorFromContext(context),
                      shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Icon(Icons.check, color: AppColors.whiteColor,),
                  ),
                )
              ],
            ),
            Divider(color: AppColors.greyBordersColor, height: getHeight() * 0.03),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: AppColors.getPrimaryColorFromContext(context).withAlpha(40),
                      shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Icon(Icons.add, color: AppColors.getPrimaryColorFromContext(context),),
                  ),
                ),
                SizedBox(width: getWidth() * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: al.switchAccount,
                        fontSize: sizes?.fontSize14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                      CustomText(
                        text: al.switchBetweenProfiles,
                        fontSize: sizes?.fontSize12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inputHintColor,
                      )
                    ],
                  ),
                ),
                SizedBox(width: getWidth() * 0.02),
              ],
            ),
          ],
        ),
      ),
            ],
          ),
        ),
      ),
    );
  }
}


class BlockUserBottomSheet extends StatelessWidget {
  const BlockUserBottomSheet({super.key, required BuildContext context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: sizes!.pagePadding,
          vertical: getHeight() * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap height to content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: getWidth() * 0.25,
                  height: getHeight() * 0.006,
                  decoration: BoxDecoration(
                    color: AppColors.greyBordersColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: getHeight() * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: al.blockUser,
                    fontSize: sizes?.fontSize18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: AppColors.primarySlateColor),
                  ),
                ],
              ),
              SizedBox(height: getHeight() * 0.03),
              CustomText(
                text: al.blockUserDescription,
                fontSize: sizes?.fontSize16,
                fontWeight: FontWeight.w400,
                color: AppColors.primarySlateColor,
                giveLinesAsText: true,
              ),
              SizedBox(height: getHeight() * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      buttonText: al.cancel,
                      onTap: () => Navigator.pop(context),
                      backgroundColor: Colors.transparent,
                      borderColor: AppColors.blackColor,
                      textColor: AppColors.blackColor,
                      textFontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: getWidth() * 0.03),
                  Expanded(
                    child: CustomButton(
                      buttonText: al.block,
                      onTap: () {},
                      backgroundColor: AppColors.getPrimaryColorFromContext(context),
                      borderColor: Colors.transparent,
                      textColor: Colors.white,
                      textFontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportBottomSheet extends StatefulWidget {
  const ReportBottomSheet({super.key, required BuildContext context});

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  String _selectedOption = al.public;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: sizes!.pagePadding,
          vertical: getHeight() * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap height to content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: getWidth() * 0.25,
                  height: getHeight() * 0.006,
                  decoration: BoxDecoration(
                    color: AppColors.greyBordersColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: getHeight() * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: al.reportUser,
                    fontSize: sizes?.fontSize18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: AppColors.primarySlateColor),
                  ),
                ],
              ),
              SizedBox(height: getHeight() * 0.03),
              CustomText(
                text: al.whyReport,
                fontSize: sizes?.fontSize18,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
                giveLinesAsText: true,
              ),
              SizedBox(height: getHeight() * 0.01),
              CustomText(
                text: al.blockUserDescription,
                fontSize: sizes?.fontSize16,
                fontWeight: FontWeight.w400,
                color: AppColors.primarySlateColor,
                giveLinesAsText: true,
              ),
              SizedBox(height: getHeight() * 0.03),
              buildRadio(al.spamOrFakeAccount, al.spamOrFakeAccount),
              buildRadio(al.inappropriateContent, al.inappropriateContent),
              buildRadio(al.harassmentOrBullying, al.harassmentOrBullying),
              buildRadio(al.hateSpeech, al.hateSpeech),
              buildRadio(al.scamOrFraud, al.scamOrFraud),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      buttonText: al.cancel,
                      onTap: () => Navigator.pop(context),
                      backgroundColor: Colors.transparent,
                      borderColor: AppColors.blackColor,
                      textColor: AppColors.blackColor,
                      textFontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: getWidth() * 0.03),
                  Expanded(
                    child: CustomButton(
                      buttonText: al.submit,
                      onTap: () {},
                      backgroundColor: AppColors.getPrimaryColorFromContext(context),
                      borderColor: Colors.transparent,
                      textColor: Colors.white,
                      textFontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRadio(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title:  CustomText(
        text: title,
        fontSize: sizes?.fontSize14,
      ),
      // subtitle:CustomText(
      //   text: subtitle,
      //   fontSize: sizes?.fontSize12,
      // ),
      trailing: Radio(
        value: value,
        groupValue: _selectedOption,
        activeColor: AppColors.getPrimaryColorFromContext(context), // Blue ring
        onChanged: (val) {
          setState(() {
            _selectedOption = val!;
          });
        },
      ),
    );
  }
}


class ChatTile extends StatelessWidget {
  final String name;
  final String username;
  final String imageUrl;
  final String? btnText;

  const ChatTile({
    super.key,
    required this.name,
    this.btnText,
    required this.username,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: getHeight() * 0.03,
          backgroundImage: NetworkImage(imageUrl),
        ),
        SizedBox(width: getWidth() * 0.02),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: name,
                fontWeight: FontWeight.w500,
                fontSize: sizes?.fontSize14,
                color: AppColors.blackColor,
              ),
              CustomText(
                text: username,
                fontWeight: FontWeight.w400,
                fontSize: sizes?.fontSize12,
                color: AppColors.primarySlateColor,
              ),
            ],
          ),
        ),
        CustomText(
          text: "23 min",
          fontWeight: FontWeight.w400,
          fontSize: sizes?.fontSize14,
          color: AppColors.primarySlateColor,
        )
      ],
    );
  }
}


class UserTile extends StatelessWidget {
  final String name;
  final String username;
  final String imageUrl;
  final String? btnText;
  final bool? hideButton;

  const UserTile({
    super.key,
    required this.name,
    this.btnText,
    required this.username,
    required this.imageUrl,
    this.hideButton
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: getHeight() * 0.03,
          backgroundImage: NetworkImage(imageUrl),
        ),
        SizedBox(width: getWidth() * 0.02),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: name,
                fontWeight: FontWeight.w500,
                fontSize: sizes?.fontSize14,
                color: AppColors.blackColor,
              ),
              CustomText(
                text: username,
                fontWeight: FontWeight.w400,
                fontSize: sizes?.fontSize12,
                color: AppColors.primarySlateColor,
              ),
            ],
          ),
        ),
        if(hideButton == false)
        Container(
          padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.03, vertical: getHeight() * 0.01),
          decoration: BoxDecoration(
            color: AppColors.greyColor,
            borderRadius: BorderRadius.circular(10)
          ),
          child: CustomText(
            text: btnText??"Message",
            fontWeight: FontWeight.w400,
            fontSize: sizes?.fontSize12,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }
}

class FollowUnFollowTile extends StatefulWidget {
  final String name;
  final String username;
  final String imageUrl;

  const FollowUnFollowTile({
    super.key,
    required this.name,
    required this.username,
    required this.imageUrl,
  });

  @override
  State<FollowUnFollowTile> createState() => _FollowUnFollowTileState();
}

class _FollowUnFollowTileState extends State<FollowUnFollowTile> {
  bool isFollowing = false;

  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: getHeight() * 0.03,
          backgroundImage: NetworkImage(widget.imageUrl),
        ),
        SizedBox(width: getWidth() * 0.02),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: widget.name,
                fontWeight: FontWeight.w500,
                fontSize: sizes?.fontSize14,
                color: AppColors.blackColor,
              ),
              CustomText(
                text: widget.username,
                fontWeight: FontWeight.w400,
                fontSize: sizes?.fontSize12,
                color: AppColors.primarySlateColor,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: toggleFollow,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: getWidth() * 0.03,
              vertical: getHeight() * 0.01,
            ),
            decoration: BoxDecoration(
              color: isFollowing ? AppColors.greyColor : AppColors.userPrimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomText(
              text: isFollowing ? al.unfollow : al.follow,
              fontWeight: FontWeight.w400,
              fontSize: sizes?.fontSize12,
              color: isFollowing ?  AppColors.blackColor: AppColors.whiteColor,
            ),
          ),
        ),
      ],
    );
  }
}

class BookmarkRestaurantCard extends StatelessWidget {
  final String imageUrl;
  final String address;
  final double rating;
  final String tag; // e.g. "Wellness"
  final bool isBookmarked;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onCardTap;

  const BookmarkRestaurantCard({
    super.key,
    required this.imageUrl,
    required this.address,
    required this.rating,
    required this.tag,
    this.isBookmarked = false,
    this.onBookmarkTap,
    this.onCardTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        height: getHeightRatio() * 210,
        margin: margin ??
            EdgeInsets.symmetric(
              horizontal: sizes!.pagePadding,
              vertical: getHeight() * 0.015,
            ),
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * 0.025,
          vertical: getHeight() * 0.015,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withAlpha(20),
              offset: const Offset(0, 0),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + Bookmark + Tag
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      Assets.galleryImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Bookmark icon (top-right)
                  Positioned(
                    top: getHeight() * 0.015,
                    right: getWidth() * 0.04,
                    child: GestureDetector(
                      onTap: onBookmarkTap,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: AppColors.redColor, // 🔴 red again
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Tag chip (top-left)
                  Positioned(
                    top: getHeight() * 0.015,
                    left: getWidth() * 0.04,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: getWidth() * 0.025,
                        vertical: getHeight() * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors
                            .getPrimaryColorFromContext(context)
                            .withAlpha(90),
                      ),
                      child: CustomText(
                        text: tag,
                        color: AppColors.whiteColor,
                        fontSize: sizes?.fontSize12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: getHeight() * 0.01),

            // ⭐ Rating Row
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: getWidth() * 0.01),
                CustomText(
                  text: rating.toStringAsFixed(1), // e.g. 4.3
                  fontSize: sizes?.fontSize12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor,
                ),
              ],
            ),
            SizedBox(height: getHeight() * 0.005),

            // Address only
            CustomText(
              text: address,
              fontSize: sizes?.fontSize12,
              fontWeight: FontWeight.w500,
              lines: 2,
              textOverflow: TextOverflow.ellipsis,
              color: AppColors.primarySlateColor,
            ),
          ],
        ),
      ),
    );
  }
}



class FavouriteRestaurantCard extends StatefulWidget {
  final String imageUrl;
  final String restaurantName;
  final String address;
  final bool isFavourite;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onRestaurantTap;
  final String? chipText;
  final Color? chipColor;

  const FavouriteRestaurantCard({
    super.key,
    required this.imageUrl,
    required this.restaurantName,
    required this.address,
    this.isFavourite = false,
    this.onRestaurantTap,
    this.margin,
    this.chipText,
    this.chipColor,
  });

  @override
  State<FavouriteRestaurantCard> createState() => _FavouriteRestaurantCardState();
}

class _FavouriteRestaurantCardState extends State<FavouriteRestaurantCard> {
  late bool _isFavourite;

  @override
  void initState() {
    super.initState();
    _isFavourite = widget.isFavourite;
  }

  void _toggleFavourite() {
    setState(() {
      _isFavourite = !_isFavourite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onRestaurantTap,
      child: Container(
        height: getHeightRatio() * 210,
        margin: widget.margin ?? EdgeInsets.symmetric(
            horizontal: sizes!.pagePadding, vertical: getHeight() * 0.015),
        padding: EdgeInsets.symmetric(
            horizontal: getWidth() * 0.025, vertical: getHeight() * 0.015),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withAlpha(20),
              offset: const Offset(0, 0),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: getHeight() * 0.015,
                    right: getWidth() * 0.04,
                    child: GestureDetector(
                      onTap: _toggleFavourite,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavourite ? AppColors.redColor : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  if (widget.chipText != null)
                    Positioned(
                      top: getHeight() * 0.015,
                      left: getWidth() * 0.015,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: getWidth() * 0.035,
                          vertical: getHeight() * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: (widget.chipColor ?? Colors.grey).withAlpha(40),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: CustomText(
                          text: widget.chipText!,
                          fontSize: sizes?.fontSize12,
                          fontWeight: FontWeight.w500,
                          color: widget.chipColor ?? Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: getHeight() * 0.01),
            CustomText(
              text: widget.restaurantName,
              fontSize: sizes?.fontSize14,
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgIcon(
                  Assets.restaurantLocationIcon,
                  height: getHeight() * 0.02,
                  color: AppColors.getPrimaryColorFromContext(context),
                ),
                SizedBox(width: getWidth() * 0.01),
                Expanded(
                  child: CustomText(
                    text: widget.address,
                    fontSize: sizes?.fontSize12,
                    fontWeight: FontWeight.w500,
                    lines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    color: AppColors.primarySlateColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class XPCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String xp;
  final Color xpColor;
  final int? progress; // Optional
  final int? total;    // Optional

  const XPCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.xp,
    required this.xpColor,
    this.progress,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    final hasProgress = progress != null && total != null;

    return Container(
      height: hasProgress? null: getHeight() * 0.1,
      margin: EdgeInsets.symmetric(horizontal: sizes!.pagePadding, vertical: getHeight() * 0.01),
      padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.03, vertical: hasProgress? getHeight() * 0.015:0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withAlpha(20),
            offset: Offset(0, 0),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              // Title & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontSize: sizes?.fontSize14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: getHeight() * 0.005),
                    CustomText(
                      text: subtitle,
                      fontSize: sizes?.fontSize12,
                      fontWeight: FontWeight.w200,
                      color: AppColors.inputHintColor,
                      giveLinesAsText: true,
                    ),
                  ],
                ),
              ),
              SizedBox(width: getWidth() * 0.015),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: xpColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  text: xp,
                  fontSize: sizes?.fontSize12,
                  fontWeight: FontWeight.w500,
                  color: xpColor,
                  giveLinesAsText: true,
                ),
              ),
            ],
          ),
          // Progress section
          if (hasProgress) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Progress",
                  fontSize: sizes?.fontSize12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primarySlateColor,
                  giveLinesAsText: true,
                ),
                CustomText(
                  text: "$progress/$total",
                  fontSize: sizes?.fontSize12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primarySlateColor,
                  giveLinesAsText: true,
                ),
              ],
            ),
            LinearProgressIndicator(
              value: progress! / total!,
              backgroundColor: xpColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(xpColor),
            ),
          ]
        ],
      ),
    );
  }
}














