import 'package:choice_app/screens/authentication/authentication.dart';
import 'package:choice_app/screens/authentication/otpVerification/otp_verification.dart';
import 'package:choice_app/screens/authentication/signup.dart';
import 'package:choice_app/screens/authentication/upload_docs.dart';
import 'package:choice_app/screens/customer/home/choiceWidgets/choice_selection.dart';
import 'package:choice_app/screens/customer/home/create_choice.dart';
import 'package:choice_app/screens/customer/home/customer_home.dart';
import 'package:choice_app/screens/languageSelection/language_selection.dart';
import 'package:choice_app/screens/restaurant/event/create_event.dart';
import 'package:choice_app/screens/restaurant/event/event_details.dart';
import 'package:choice_app/screens/restaurant/home/create_post.dart';
import 'package:choice_app/screens/restaurant/maps/producer_map_screen.dart';
import 'package:go_router/go_router.dart';
import '../screens/onboarding/add_cuisine/add_cuisine.dart';
import '../screens/onboarding/add_services/add_services.dart';
import '../screens/onboarding/business_hours/edit_business_hours/edit_operational_hours.dart';
import '../screens/onboarding/day_off/days_off_view.dart';
import '../screens/onboarding/gallery/gallery_view.dart';
import '../screens/onboarding/menu/menu_view.dart';
import '../screens/onboarding/slot_management/slot_management_view.dart';
import '../screens/restaurant/profile_menu/badges/badges_view.dart';
import '../screens/restaurant/profile_menu/blocked_users/blocked_users_view.dart';
import '../screens/restaurant/profile_menu/bookmarked/bookmarked_view.dart';

import '../screens/authentication/login.dart';
import '../screens/authentication/passwordManagement/forgot_password.dart';
import '../screens/authentication/passwordManagement/reset_password.dart';
import '../screens/customer/home/choiceWidgets/sub_choice_selection.dart';
import '../screens/onboarding/payment_methods/payment_methods_view.dart';
import '../screens/restaurant/bottomTab/bottom_tab.dart';
import '../screens/restaurant/event/events.dart';
import '../screens/restaurant/profile/profile.dart';
import '../screens/splash/splash.dart';
import '../screens/wellness/home/welness_home.dart';
import '../screens/customer/chat/user_chat/user_chat_view.dart';
import '../screens/restaurant/notifications/notifications_view.dart';
import '../screens/customer/bottomTab/customer_bottom_tab.dart';

class Routes {
  static const String initialRoute = '/';
  static const String languageSelectionRoute = '/language_selection';
  static const String authRoute = '/auth';
  static const String signupRoute = '/signup';
  static const String otpVerificationRoute = '/otp_verification';
  static const String uploadDocsRoute = '/upload_docs';
  static const String loginRoute = '/login';
  static const String forgotPasswordRoute = '/forgot_password';
  static const String resetPasswordRoute = '/reset_password';
  static const String restaurantProfileRoute = '/restaurant_profile';
  static const String restaurantEventsRoute = '/restaurant_events';
  static const String restaurantCreateEventRoute = '/restaurant_create_events';
  static const String restaurantEventDetailsRoute = '/restaurant_event_details';
  static const String restaurantBottomTabRoute = '/restaurant_bottom_tab';
  static const String restaurantCreatePostRoute = '/restaurant_create_post';
  static const String restaurantProducerMapRoute = '/restaurant_producer_map';
  static const String restaurantPaymentMethodsRoute = '/restaurant_payment_methods';

  //Customer
  static const String customerHomeRoute = '/customer_home';
  static const String chatRoute = '/chat';
  static const String notificationsRoute = '/notifications';
  static const String choiceSelectionRoute = '/choice_selection';
  static const String subChoiceSelectionRoute = '/sub_choice_selection';
  static const String createChoiceRoute = '/create_choice';

  //wellness
  static const String wellnessHomeRoute = '/wellness_home';

  // Settings & Profile Menu
  static const String badgesRoute = '/badges';
  static const String bookmarkedRoute = '/bookmarked';
  static const String blockedUsersRoute = '/blocked_users';
  static const String restaurantEditBusinessHoursRoute = '/restaurant_edit_business_hours';
  static const String restaurantSlotManagementRoute = '/restaurant_slot_management';
  static const String restaurantMenuRoute = '/restaurant_menu';
  static const String restaurantServicesRoute = '/restaurant_services';
  static const String restaurantGalleryRoute = '/restaurant_gallery';
  static const String restaurantUnavailabilityRoute = '/restaurant_unavailability';
  static const String restaurantCuisineRoute = '/restaurant_cuisine';
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Splash()),
    GoRoute(path: '/language_selection', builder: (context, state) => const LanguageSelection()),
    GoRoute(path: '/auth', builder: (context, state) => Authentication()),
    GoRoute(path: '/signup', builder: (context, state) => const Signup()),
    GoRoute(
      path: '/otp_verification',
      builder: (context, state) => const OtpVerification(),
    ),
    GoRoute(
      path: '/upload_docs',
      builder: (context, state) => const UploadDocs(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPassword(),
    ),
    GoRoute(
      path: '/reset_password',
      builder: (context, state) => const ResetPassword(),
    ),
    GoRoute(
      path: '/restaurant_profile',
      builder: (context, state) => const Profile(),
    ),
    GoRoute(
      path: '/restaurant_events',
      builder: (context, state) => const Events(),
    ),
    GoRoute(
      path: '/restaurant_create_events',
      builder: (context, state) => const CreateEvent(),
    ),
    GoRoute(
      path: '/restaurant_event_details',
      builder: (context, state) => const EventDetails(),
    ),
    GoRoute(
      path: '/restaurant_bottom_tab',
      builder: (context, state) => const RestaurantBottomTab(),
    ),
    GoRoute(
      path: '/restaurant_create_post',
      builder: (context, state) => const CreatePost(),
    ),
    GoRoute(
      path: '/restaurant_producer_map',
      builder: (context, state) => const ProducerMapScreen(),
    ),
    GoRoute(
      path: '/restaurant_payment_methods',
      builder: (context, state) => const PaymentMethodsView(),
    ),

    //Customer
    GoRoute(
      path: '/customer_home',
      builder: (context, state) => const CustomerBottomTab(), 
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const UserChatView(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsView(),
    ),
    GoRoute(
      path: '/choice_selection',
      builder: (context, state) => const ChoiceSelection(),
    ),
    // GoRoute(
    //   path: '/sub_choice_selection',
    //   builder: (context, state) => const SubChoiceSelection(),
    // ),
    GoRoute(
      path: '/sub_choice_selection',
      builder: (context, state) {
        final selectedChoice = state.uri.queryParameters['selectedChoice'] ?? 'Default';
        return SubChoiceSelection(selectedChoice: selectedChoice);
      },
    ),
    GoRoute(
      path: '/create_choice',
      builder: (context, state) => const CreateChoice(),
    ),

    GoRoute(path: '/wellness_home', builder: (context, state) => const WellnessHome()),

    // Settings & Profile Menu
    GoRoute(path: '/badges', builder: (context, state) => const BadgesView()),
    GoRoute(path: '/bookmarked', builder: (context, state) => const BookmarkedView()),
    GoRoute(path: '/blocked_users', builder: (context, state) => const BlockedUsersView()),
    GoRoute(path: '/restaurant_edit_business_hours', builder: (context, state) => const EditOperationalHours()),
    GoRoute(path: '/restaurant_slot_management', builder: (context, state) => const SlotManagementView()),
    GoRoute(path: '/restaurant_menu', builder: (context, state) => const MenuView()),
    GoRoute(path: '/restaurant_services', builder: (context, state) => const AddServices()),
    GoRoute(path: '/restaurant_gallery', builder: (context, state) => const GalleryView()),
    GoRoute(path: '/restaurant_unavailability', builder: (context, state) => const DaysOffView()),
    GoRoute(path: '/restaurant_cuisine', builder: (context, state) => const AddCuisine()),

  ],
);
