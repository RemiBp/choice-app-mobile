import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:choice_app/providers/multi_providers.dart';
import 'package:choice_app/res/constant.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/languageSelection/language_selection_provider.dart';
import 'package:choice_app/store_config.dart';
import 'package:choice_app/utilities/timezone_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'common/utils.dart';
import 'l10n/app_localizations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  TimezoneHelper.initialize();
  await PreferenceUtils.init();

  // if (Platform.isIOS || Platform.isMacOS) {
  //   StoreConfig(store: Store.appStore, apiKey: appleApiKey);
  // } else if (Platform.isAndroid) {
  //   StoreConfig(store: Store.playStore, apiKey: googleApiKey);
  // }
  //
  // await Purchases.setLogLevel(LogLevel.debug);
  //
  // PurchasesConfiguration configuration =
  // PurchasesConfiguration(StoreConfig.instance.apiKey)
  //   ..appUserID = null
  //   ..purchasesAreCompletedBy =
  //   const PurchasesAreCompletedByRevenueCat();
  //
  // await Purchases.configure(configuration);

  runApp(MultiProvider(providers: multiProviders, child: const MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    initializeResources(context: context);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Consumer<LanguageSelectionProvider>(
      builder: (context, state, child) {
        debugPrint("Consumer Called");
        return MaterialApp.router(
          key: UniqueKey(),
          title: 'Choice App',
          builder: BotToastInit(),
          locale: Locale(state.selectedLocal),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
        );
      },
    );
  }
}
