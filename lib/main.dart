import 'package:bot_toast/bot_toast.dart';
import 'package:choice_app/providers/multi_providers.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/languageSelection/language_selection_provider.dart';
import 'package:choice_app/utilities/timezone_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'common/utils.dart';
import 'l10n/app_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TimezoneHelper.initialize();
  await PreferenceUtils.init();
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
    final provider = Provider.of<LanguageSelectionProvider>(context);
    provider.getLocale();
    return Consumer(builder: (context, state, child){
      return MaterialApp.router(
        key: ValueKey(provider.hashCode),
        title: 'Choice App',
        builder:BotToastInit(),
        locale: Locale(provider.selectedLocal),
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      );
    });


  }
}
