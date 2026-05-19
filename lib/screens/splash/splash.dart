import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../appAssets/app_assets.dart';
import '../../l18n.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    String? token;
    try {
      token = await StorageService.getAccessToken();
    } catch (_) {
      token = null;
    }
    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      context.go(Routes.restaurantBottomTabRoute);
    } else {
      context.go(Routes.authRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppTranslations.init(context);
    return Scaffold(
      body: Center(
        child: Image.asset(Assets.splashImage, height: getHeight() * .3),
      ),
    );
  }
}
