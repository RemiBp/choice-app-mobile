import 'package:choice_app/providers/multi_providers.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/languageSelection/language_selection_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'common/utils.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  runApp(MultiProvider(providers: multiProviders, child: const MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MobileFrame extends StatelessWidget {
  final Widget child;
  const _MobileFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    const phoneW = 390.0;
    final phoneH = screenH.clamp(700.0, 900.0);

    return Container(
      color: const Color(0xFF1a1a2e),
      child: Center(
        child: SizedBox(
          width: phoneW,
          height: phoneH,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(100),
                    blurRadius: 40,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}



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
        builder: (context, child) {
          Widget content = MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
          if (kIsWeb) {
            content = _MobileFrame(child: content);
          }
          return content;
        },
        locale: Locale(provider.selectedLocal),
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      );
    });


  }
}
