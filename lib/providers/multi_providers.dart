import 'package:choice_app/network/network_provider.dart';
import 'package:choice_app/screens/authentication/accountReclaim/reclaim_account_provider.dart';
import 'package:choice_app/screens/authentication/auth_provider.dart';
import 'package:choice_app/screens/authentication/otpVerification/otp_provider.dart';
import 'package:choice_app/screens/authentication/passwordManagement/password_provider.dart';
import 'package:choice_app/screens/bookings/bookings_provider.dart';
import 'package:choice_app/screens/customer/explore/book_now/create_booking_provider.dart';
import 'package:choice_app/screens/customer/explore/customer_explore/customer_explore_view_provider.dart';
import 'package:choice_app/screens/customer/profile/customer_profile/customer_profile_provider.dart';
import 'package:choice_app/screens/languageSelection/language_selection_provider.dart';
import 'package:choice_app/screens/producer_maps/offer_provider.dart';
import 'package:choice_app/screens/restaurant/event/event_provider.dart';
import 'package:choice_app/screens/restaurant/home/choice_provider.dart';
import 'package:choice_app/screens/restaurant/profile/profile_provider.dart';
import 'package:provider/provider.dart';

import '../screens/customer/explore/restaurant_explore_details/event_details_provider.dart';
import '../screens/customer/explore/restaurant_explore_details/non_event_details_provider.dart';
import '../screens/customer/home/choice_provider.dart';
import '../screens/producer_maps/producer_heatmap_provider.dart';
import '../screens/subscription/subscriber_provider.dart';
import '../userRole/role_provider.dart';

final multiProviders = [
  ChangeNotifierProvider<LanguageSelectionProvider>(
    create: (_) => LanguageSelectionProvider(),
    lazy: true,
  ), ChangeNotifierProvider<ProfileProvider>(
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
  ChangeNotifierProvider<OtpProvider>(
    create: (_) => OtpProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<TemplateProvider>(
    create: (_) => TemplateProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<ReclaimAccountProvider>(
    create: (_) => ReclaimAccountProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<NetworkProvider>(
    create: (_) => NetworkProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<ChoiceProvider>(
    create: (_) => ChoiceProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<EventProvider>(
    create: (_) => EventProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<CustomerProfileProvider>(
    create: (_) => CustomerProfileProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<CustomerChoiceProvider>(
    create: (_) => CustomerChoiceProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<ExploreViewProvider>(
    create: (context) => ExploreViewProvider(context: context),
    lazy: true,
  ),
  ChangeNotifierProvider<BookingsProvider>(
    create: (context) => BookingsProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<EventDetailsProvider>(
    create: (context) => EventDetailsProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<NonEventDetailsProvider>(
    create: (context) => NonEventDetailsProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<CreateBookingProvider>(
    create: (context) => CreateBookingProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<ProducerHeatmapProvider>(
    create: (context) => ProducerHeatmapProvider(),
    lazy: true,
  ),
  ChangeNotifierProvider<SubscriberProvider>(
    create: (context) => SubscriberProvider(),
    lazy: true,
  ),

];