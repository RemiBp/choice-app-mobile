import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/l10n/app_localizations.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/authentication/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:choice_app/userRole/user_role.dart';
import '../../appAssets/app_assets.dart';
import '../../customWidgets/custom_text.dart';
import '../../customWidgets/animations/fade_in_up.dart';
import '../../l10n/app_localizations_en.dart';
import 'package:choice_app/l18n.dart';
import '../../routes/routes.dart';
import '../../userRole/role_provider.dart';

class Authentication extends StatefulWidget {
  Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkLocalization();
  }

  void _checkLocalization() {
    var loc = AppLocalizations.of(context);
    debugPrint("DEBUG: Authentication didChangeDependencies. loc is $loc");
    if (loc != null) {
      AppTranslations.init(context);
      if (!_isInitialized) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Try one more time in build just in case
      var loc = AppLocalizations.of(context);
      if (loc != null) {
         AppTranslations.init(context);
         _isInitialized = true;
      } else {
        // Fallback: Force English if context lookup fails to prevent infinite loading
        debugPrint("DEBUG: Force-loading English localization as fallback.");
        al = AppLocalizationsEn(); // Use the setter
        _isInitialized = true;

    }
  }

    final roleProvider = context.read<RoleProvider>();
    
    final col = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildChildren(context, roleProvider),
    );

    final scroll = SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: getWidth() * .05,
        vertical: getHeight() * .05,
      ),
      child: col,
    );

    final safe = SafeArea(child: scroll);

    return Scaffold(
      backgroundColor: Colors.white,
      body: safe,
    );
  }

  List<Widget> _buildChildren(BuildContext context, RoleProvider roleProvider) {
    return [
              FadeInUp(
                 delay: Duration(milliseconds: 100),
                 child: CustomText(
                  text: al.createAnAccount,
                  fontSize: sizes?.fontSize28,
                  fontFamily: Assets.onsetBold,
                ),
              ),
              SizedBox(height: 10),
              FadeInUp(
                delay: Duration(milliseconds: 200),
                child: CustomText(
                  text: al.chooseAccountType,
                  fontSize: sizes?.fontSize16,
                  color: AppColors.textGreyColor,
                  giveLinesAsText: true,
                ),
              ),
              SizedBox(height: 40),
              
              FadeInUp(
                delay: Duration(milliseconds: 300),
                child: AuthSelectionCard(
                  bgColorCode: "#E6F5FB",
                  iconBgColorCode: "#CCECF6",
                  borderColorCode: "#009ED4",
                  title: al.userAccountTitle,
                  description: al.userAccountDescription,
                  svgString: Assets.userIcon,
                  onTap: () {
                    roleProvider.setRole(UserRole.user);
                    context.push(Routes.signupRoute);
                  },
                ),
              ),

              FadeInUp(
                delay: Duration(milliseconds: 400),
                child: AuthSelectionCard(
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
              ),
              
              FadeInUp(
                delay: Duration(milliseconds: 500),
                child: AuthSelectionCard(
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
              ),
              
              FadeInUp(
                delay: Duration(milliseconds: 600),
                child: AuthSelectionCard(
                  bgColorCode: "#EDF7EE",
                  borderColorCode: "#4FAD53",
                  iconBgColorCode: "#DCEEDC",
                  title: al.wellnessProviderAccountTitle,
                  description: al.wellnessProviderAccountDescription,
                  svgString: Assets.wellnessIcon,
                  onTap: () {
                    roleProvider.setRole(UserRole.wellness);
                    context.push(Routes.signupRoute);
                  },
                ),
              ),
    ];
  }
}
