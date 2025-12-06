import 'package:choice_app/appAssets/app_assets.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/customer/home/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../l18n.dart';
import '../../../userRole/role_provider.dart';
import '../../../userRole/user_role.dart';
import '../../restaurant/home/choice_provider.dart';


class WellnessHome extends StatefulWidget {
  const WellnessHome({super.key});

  @override
  State<WellnessHome> createState() => _WellnessHomeState();
}

class _WellnessHomeState extends State<WellnessHome> {

  ChoiceProvider _choiceProvider = ChoiceProvider();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _choiceProvider = Provider.of<ChoiceProvider>(context, listen: false);
      _choiceProvider.init(context);
      _choiceProvider.getProducerPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    _choiceProvider = Provider.of<ChoiceProvider>(context);
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getWidth() * .05,
            vertical: getHeight() * .07,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: al.welcome,
                        fontSize: sizes?.fontSize14,
                        fontFamily: Assets.onsetMedium,
                      ),
                      CustomText(
                        text: "Liberty Bite Bistro",
                        fontSize: sizes?.fontSize16,
                        fontFamily: Assets.onsetSemiBold,
                        color: AppColors.wellnessPrimaryColor,
                      ),
                    ],
                  ),
                  Spacer(),
                  CustomIconButton(
                    svgString: Assets.chatIcon,
                    onPress: (){
                    },
                  ),
                  SizedBox(width: getWidth() * .02),
                  CustomIconButton(
                    svgString: Assets.notificationIcon,
                    onPress: (){
                    },
                  ),
                  SizedBox(width: getWidth() * .02),
                  CustomIconButton(
                    svgString: Assets.profileIcon,
                    onPress: (){
                      context.push(Routes.wellnessProfileHomeRoute);
                    },
                  ),
                ],
              ),
              SizedBox(height: getHeight() * .02),
              CustomField(
                borderColor: AppColors.greyBordersColor,
                hint: al.searchUserPlaceholder,
                prefixIconSvg: Assets.searchIcon,
              ),
              SizedBox(height: getHeight() * .02),
              Expanded(
                child:_choiceProvider.postsResponse.data?.isNotEmpty == true?
                ListView.builder(
                  padding: EdgeInsets.only(
                      top: getHeight()*.01
                  ),
                  itemCount: _choiceProvider.postsResponse.data?.length??0,
                  itemBuilder: (context, index) {
                    return PostCard(
                      index: index,
                    );
                  },
                ):Center(child: const Text("No Data Available"),),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: AppColors.getPrimaryColorFromContext(context),
          onPressed: () {
            final role = context.read<RoleProvider>().role;
            debugPrint("Current user role: $role");

            if (role == UserRole.user) {
              debugPrint("Navigating to Choice Selection");
              context.push(Routes.choiceSelectionRoute);
            } else {
              debugPrint("Navigating to Restaurant Create Post");
              context.push(Routes.restaurantCreatePostRoute);
            }
          },
          label: Row(
            children: [
              const Icon(Icons.add, color: Colors.white),
              CustomText(
                text: al.createPost,
                fontSize: sizes?.fontSize12,
                fontFamily: Assets.onsetMedium,
                color: Colors.white,
              ),
            ],
          ),
        )

    );
  }
}


