import 'package:choice_app/customWidgets/common_app_bar.dart';
import 'package:choice_app/screens/customer/chat/user_chat/user_chat_view.dart';
import 'package:choice_app/screens/customer/interested/interestedWidgets/interested_widgets.dart';
import 'package:choice_app/screens/customer/profile/customer_profile/customer_profile_provider.dart';
import 'package:choice_app/screens/customer/profile/customer_profile/customer_profile_widget.dart';
import 'package:choice_app/screens/restaurant/profile_menu/follower/follower_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/following/following_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/profile_menu_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/no_item_found.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';

class OtherUserProfileView extends StatefulWidget {
  const OtherUserProfileView({super.key, required this.userId});

  final int userId;

  @override
  State<OtherUserProfileView> createState() => _OtherUserProfileViewState();
}

class _OtherUserProfileViewState extends State<OtherUserProfileView>
    with SingleTickerProviderStateMixin {
  CustomerProfileProvider _profileProvider = CustomerProfileProvider();
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging ||
          _tabController.index != _selectedTabIndex) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileProvider = Provider.of<CustomerProfileProvider>(
        context,
        listen: false,
      );
      _profileProvider.init(context);
      _profileProvider.getUserDetails(userId: widget.userId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color getTabColor(int tabIndex) {
    return _selectedTabIndex == tabIndex
        ? AppColors.getPrimaryColorFromContext(context)
        : AppColors.inputHintColor;
  }

  Color getImageColor(int tabIndex) {
    return _selectedTabIndex == tabIndex
        ? AppColors.getPrimaryColorFromContext(context)
        : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CustomerProfileProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title:
            _profileProvider.getUserDetailResponse?.data?.fullName ??
            'Unknown user',
        showMenuButton: true,
        onReport: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return const OtherUserReportBottomSheet();
            },
          );
        },
        onBlock: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return const OtherUserBlockBottomSheet();
            },
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getHeight() * 0.02),
          OtherUserProfileHeader(),
          SizedBox(height: getHeight() * 0.01),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomText(
              text:
                  _profileProvider.getUserDetailResponse?.data?.bio ??
                  "Unknown bio",
              textOverflow: TextOverflow.ellipsis,
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              fontWeight: FontWeight.w400,
              giveLinesAsText: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sizes!.pagePadding,
              vertical: getHeight() * 0.02,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CardButton(
                    height: 32,
                    buttonText: al.follow,
                    onTap: () {},
                    textColor: Colors.white,
                    textFontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: getWidth() * 0.03),
                Expanded(
                  child: CardButton(
                    height: 32,
                    buttonText: al.message,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserChatView()),
                      );
                    },
                    backgroundColor: AppColors.greyColor,
                    textColor: AppColors.blackColor,
                    textFontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.greyColor,
              border: const Border(
                bottom: BorderSide(color: Color(0xFFEFEFEF)),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.getPrimaryColorFromContext(context),
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.getPrimaryColorFromContext(context),
              padding: EdgeInsets.zero,
              tabs: [
                ProfileTabItem(
                  iconPath: Assets.postIcon,
                  label: al.choices,
                  tabIndex: 0,
                  selectedTabIndex: _selectedTabIndex,
                ),
                ProfileTabItem(
                  iconPath: Assets.interestIcon,
                  label: al.interest,
                  tabIndex: 1,
                  selectedTabIndex: _selectedTabIndex,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [OtherUserChoice(), CustomerInterestView()],
            ),
          ),
        ],
      ),
    );
  }
}

class OtherUserBlockBottomSheet extends StatelessWidget {
  const OtherUserBlockBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
            mainAxisSize: MainAxisSize.min,
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
                    child: Icon(
                      Icons.close,
                      color: AppColors.primarySlateColor,
                    ),
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
                      onTap: () {
                        final provider = Provider.of<CustomerProfileProvider>(
                          context,
                          listen: false,
                        );
                        provider.blockUser(
                          userId: provider
                                  .getUserDetailResponse?.data?.id ??
                              0,
                          userName: provider
                                  .getUserDetailResponse?.data?.fullName ??
                              'Unknown',
                        );
                      },
                      backgroundColor:
                          AppColors.getPrimaryColorFromContext(context),
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


class OtherUserReportBottomSheet extends StatefulWidget {
  const OtherUserReportBottomSheet({super.key});

  @override
  State<OtherUserReportBottomSheet> createState() =>
      _OtherUserReportBottomSheetState();
}

class _OtherUserReportBottomSheetState
    extends State<OtherUserReportBottomSheet> {
  String _selectedOption = al.spamOrFakeAccount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
            mainAxisSize: MainAxisSize.min,
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
                    child: Icon(
                      Icons.close,
                      color: AppColors.primarySlateColor,
                    ),
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
                text:
                    'Help us keep the community safe. Please tell us why you\'re reporting this profile. Your report is anonymous, and we\'ll review it as soon as possible.',
                fontSize: sizes?.fontSize16,
                fontWeight: FontWeight.w400,
                color: AppColors.primarySlateColor,
                giveLinesAsText: true,
              ),
              SizedBox(height: getHeight() * 0.03),
              _buildRadio(al.spamOrFakeAccount),
              _buildRadio(al.inappropriateContent),
              _buildRadio(al.harassmentOrBullying),
              _buildRadio(al.hateSpeech),
              _buildRadio(al.scamOrFraud),
              SizedBox(height: getHeight() * 0.02),
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
                      onTap: () {
                        final provider = Provider.of<CustomerProfileProvider>(
                          context,
                          listen: false,
                        );
                        provider.reportUser(
                          userId: provider
                                  .getUserDetailResponse?.data?.id ??
                              0,
                          userName: provider
                                  .getUserDetailResponse?.data?.fullName ??
                              'Unknown',
                          reason: _selectedOption,
                        );
                      },
                      backgroundColor:
                          AppColors.getPrimaryColorFromContext(context),
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

  Widget _buildRadio(String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomText(
        text: value,
        fontSize: sizes?.fontSize14,
      ),
      trailing: Radio(
        value: value,
        groupValue: _selectedOption,
        activeColor: AppColors.getPrimaryColorFromContext(context),
        onChanged: (val) {
          setState(() {
            _selectedOption = val!;
          });
        },
      ),
    );
  }
}


class OtherUserChoice extends StatelessWidget {
  const OtherUserChoice({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProfileProvider>(context);
    final posts = provider.getUserDetailResponse?.data?.posts ?? [];
    return posts.isNotEmpty
        ? ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
          itemCount: provider.getUserDetailResponse?.data?.posts?.length ?? 0,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: CustomerPostCard(index: index, showOtherUserDetails: true),
            );
          },
        )
        : Center(
          child: NoItemFound(
            image: Assets.noNotificationIcon,
            title: 'No Choices Yet',
            subTitle: 'This user hasn\'t shared any choices yet.',
            margin: EdgeInsets.zero,
          ),
        );
  }
}

class OtherUserProfileHeader extends StatelessWidget {
  const OtherUserProfileHeader({super.key});

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
              provider.getUserDetailResponse?.data?.profileImageUrl != null
                  ? provider.getUserDetailResponse!.data!.profileImageUrl!
                  : "https://naushkinskoe-r81.gosweb.gosuslugi.ru/netcat_files/154/1671/image_3_0.jpg",
            ),
          ),
          SizedBox(width: getWidth() * 0.02),
          Expanded(
            // Ensures the right side takes remaining space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: provider.getUserDetailResponse?.data?.fullName ?? "",
                  textOverflow: TextOverflow.ellipsis,
                  fontSize: sizes?.fontSize16,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem(
                      "${provider.getUserDetailResponse?.data?.posts?.length ?? 0}",
                      "Choices",
                    ),
                    Image.asset(
                      Assets.verticalLine,
                      height: getHeight() * 0.03,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FollowerView(),
                          ),
                        );
                      },
                      child: _buildStatItem(
                        "${provider.getUserDetailResponse?.data?.followersCount ?? 0}",
                        al.follower,
                      ),
                    ),
                    Image.asset(
                      Assets.verticalLine,
                      height: getHeight() * 0.03,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FollowingView(),
                          ),
                        );
                      },
                      child: _buildStatItem(
                        "${provider.getUserDetailResponse?.data?.followingCount ?? 0}",
                        al.following,
                      ),
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
