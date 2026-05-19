import 'package:choice_app/providers/customer_provider.dart';
import 'package:choice_app/providers/producer_provider.dart';
import 'package:choice_app/screens/authentication/auth_provider.dart';
import 'package:choice_app/screens/authentication/passwordManagement/password_provider.dart';
import 'package:choice_app/screens/languageSelection/language_selection_provider.dart';
import 'package:choice_app/screens/restaurant/profile/profile_provider.dart';
import 'package:provider/provider.dart';

import '../userRole/role_provider.dart';

final multiProviders = [
  ChangeNotifierProvider<LanguageSelectionProvider>(
    create: (_) => LanguageSelectionProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<ProfileProvider>(
    create: (_) => ProfileProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<AuthProvider>(
    create: (_) => AuthProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<PasswordProvider>(
    create: (_) => PasswordProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<RoleProvider>(
    create: (_) => RoleProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<ProducerProvider>(
    create: (_) => ProducerProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<CustomerProvider>(
    create: (_) => CustomerProvider(),
    lazy: true,
  ),
];
