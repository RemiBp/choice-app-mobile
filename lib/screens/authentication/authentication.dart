import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/authentication/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:choice_app/userRole/user_role.dart';
import '../../appAssets/app_assets.dart';
import '../../customWidgets/custom_text.dart';
import '../../l18n.dart';
import '../../routes/routes.dart';
import '../../userRole/role_provider.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    AppTranslations.init(context);
    final roleProvider = context.read<RoleProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: getHeight() * .1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: al.createAnAccount,
              fontSize: sizes?.fontSize28,
              fontFamily: Assets.onsetSemiBold,
            ),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.chooseAccountType,
              fontSize: sizes?.fontSize16,
              giveLinesAsText: true,
            ),
            AuthSelectionCard(
              bgColorCode: "#E6F5FB",
              iconBgColorCode: "#CCECF6",
              borderColorCode: "#009ED4",
              title: al.userAccountTitle,
              description: al.userAccountDescription,
              svgString: Assets.userIcon,
              onTap: () {
                roleProvider.setRole(UserRole.user);
                context.push(Routes.signupRoute);
                // context.push(Routes.customerHomeRoute);
              },
            ),

            AuthSelectionCard(
              bgColorCode: "#FEF5E7",
              borderColorCode: "#F49E10",
              iconBgColorCode: "#FDECCF",
              title: al.restaurantProviderAccountTitle,
              description: al.restaurantProviderAccountDescription,
              svgString: Assets.knifeForkIcon,
              onTap: () {
                roleProvider.setRole(UserRole.restaurant);
                context.push(Routes.signupRoute);
              },
            ),
            AuthSelectionCard(
              bgColorCode: "#F4E9F6",
              borderColorCode: "#8F2DA3",
              iconBgColorCode: "#E9D5EC",
              title: al.leisureProviderAccountTitle,
              description: al.leisureProviderAccountDescription,
              svgString: Assets.leisureIcon,
              onTap: () {
                roleProvider.setRole(UserRole.leisure);
                context.push(Routes.signupRoute);
              },
            ),
            AuthSelectionCard(
              bgColorCode: "#EDF7EE",
              borderColorCode: "#4FAD53",
              iconBgColorCode: "#DCEEDC",
              title: al.wellnessProviderAccountTitle,
              description: al.wellnessProviderAccountDescription,
              svgString: Assets.wellnessIcon,
              onTap: () {
                roleProvider.setRole(UserRole.wellness);
                context.push(Routes.restaurantBottomTabRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
