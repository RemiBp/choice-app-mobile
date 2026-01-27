import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../appAssets/app_assets.dart';
import '../../customWidgets/animations/fade_in_up.dart';
import 'package:choice_app/l18n.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation Setup
    _controller = AnimationController(
			  vsync: this,
			  duration: const Duration(seconds: 2),
			)..repeat(reverse: true);
			
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Navigation logic
    Future.delayed(const Duration(seconds: 3), () {
      context.pushReplacement(Routes.authRoute);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppTranslations.init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFF0F4F8), // Very light blue/grey
            ],
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeInUp(
               duration: Duration(milliseconds: 1000),
               child: Image.asset(Assets.splashImage, height: getHeight() * .3),
            ),
          ),
        ),
      ),
    );
  }
}
