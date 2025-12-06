import 'package:choice_app/res/res.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../appAssets/app_assets.dart';
import '../userRole/role_provider.dart';
import '../userRole/user_role.dart';

class Loader {

  // Select correct loader JSON based on user role
  String _getLoader(BuildContext context) {
    final role = context.read<RoleProvider>().role;

    switch (role) {
      case UserRole.user:
        return Assets.userLoader;
      case UserRole.restaurant:
        return Assets.restaurantLoader;
      case UserRole.leisure:
        return Assets.leisureLoader;
      case UserRole.wellness:
        return Assets.wellnessLoader;
    }
  }

  showLoader({BuildContext? context}) {
    if (context == null) return;

    final loaderPath = _getLoader(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Material(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: SizedBox(
              height: getHeight() * 0.50,
              width: getWidth() * 0.50,
              child: Lottie.asset(loaderPath),
            ),
          ),
        );
      },
    );
  }

  hideLoader(BuildContext context) {
    if (context.mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loaderPath = Loader()._getLoader(context);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: SizedBox(
          height: getHeight() * 0.50,
          width: getWidth() * 0.50,
          child: Lottie.asset(loaderPath),
        ),
      ),
    );
  }
}
