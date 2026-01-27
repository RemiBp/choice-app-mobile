import 'package:choice_app/providers/multi_providers.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/languageSelection/language_selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'common/utils.dart';
import 'l10n/app_localizations.dart';
import 'package:choice_app/l18n.dart';

import 'package:choice_app/data/services/api_service.dart';
// ... rest of imports ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  
  // Set token if already logged in
  final token = PreferenceUtils.token;
  if (token.isNotEmpty) {
    ApiService().setAuthToken(token);
  }
  
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    final provider = Provider.of<LanguageSelectionProvider>(context);
    var selected = provider.getLocale();
    debugPrint("DEBUG: MyApp build. Selected locale: '$selected'");
    return Consumer<LanguageSelectionProvider>(builder: (context, state, child){
      debugPrint("DEBUG: MaterialApp locale: '${provider.selectedLocal}'");
      return MaterialApp.router(
        key: ValueKey(provider.hashCode),
        title: 'Choice App',
        builder: (context, child) {
          initializeResources(context: context);
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        locale: Locale(provider.selectedLocal.isEmpty ? 'en' : provider.selectedLocal),
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: Colors.white, // Enforce Global White Theme
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent, // Remove M3 header tint
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
      );
    });


  }
}
