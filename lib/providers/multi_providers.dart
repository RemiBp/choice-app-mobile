
import 'package:choice_app/screens/bookings/booking_provider.dart';
import 'package:choice_app/screens/customer/home/interest_provider.dart';
import 'package:choice_app/screens/customer/chat/chat_provider.dart';
import 'package:choice_app/screens/customer/home/customer_provider.dart';
import 'package:choice_app/screens/languageSelection/language_selection_provider.dart';
import 'package:choice_app/screens/onboarding/onboarding_provider.dart';
import 'package:choice_app/screens/restaurant/dashboard/dashboard_provider.dart';
import 'package:choice_app/screens/restaurant/event/event_provider.dart';
import 'package:choice_app/screens/restaurant/home/producer_post_provider.dart';
import 'package:choice_app/screens/restaurant/profile/profile_provider.dart';
import 'package:choice_app/userRole/role_provider.dart';
import 'package:choice_app/providers/post_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../screens/authentication/auth_provider.dart';

final List<SingleChildWidget> multiProviders = [
  ChangeNotifierProvider(create: (_) => RoleProvider()),
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(create: (_) => LanguageSelectionProvider()),
  ChangeNotifierProvider(create: (_) => DashboardProvider()),
  ChangeNotifierProvider(create: (_) => OnboardingProvider()),
  ChangeNotifierProvider(create: (_) => EventProvider()),
  ChangeNotifierProvider(create: (_) => CustomerProvider()),
  ChangeNotifierProvider(create: (_) => ProducerPostProvider()),
  ChangeNotifierProvider(create: (_) => ChatProvider()),
  ChangeNotifierProvider(create: (_) => BookingProvider()),
  ChangeNotifierProvider(create: (_) => ProfileProvider()),
  ChangeNotifierProvider(create: (_) => InterestProvider()),
  ChangeNotifierProvider(create: (_) => PostProvider()),
];