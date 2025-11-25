import 'package:choice_app/screens/authentication/accountReclaim/account_registration.dart';
import 'package:choice_app/screens/authentication/accountReclaim/review.dart';
import 'package:choice_app/screens/authentication/authentication.dart';
import 'package:choice_app/screens/authentication/otpVerification/otp_verification.dart';
import 'package:choice_app/screens/authentication/accountReclaim/reclaim_account.dart';
import 'package:choice_app/screens/authentication/signup.dart';
import 'package:choice_app/screens/authentication/upload_docs.dart';
import 'package:choice_app/screens/bookings/bookings_view.dart';
import 'package:choice_app/screens/chatbot/chatbot_home.dart';
import 'package:choice_app/screens/customer/home/choiceWidgets/choice_selection.dart';
import 'package:choice_app/screens/customer/home/create_choice.dart';
import 'package:choice_app/screens/customer/home/customer_home.dart';
import 'package:choice_app/screens/customer/interested/customer_event_invite.dart';
import 'package:choice_app/screens/customer/interested/customer_nonevent_invite.dart';
import 'package:choice_app/screens/customer/interested/interested_details.dart';
import 'package:choice_app/screens/customer/interested/select_friends.dart';
import 'package:choice_app/screens/customer/interested/suggest_event.dart';
import 'package:choice_app/screens/customer/interested/suggest_timeslot.dart';
import 'package:choice_app/screens/languageSelection/language_selection.dart';
import 'package:choice_app/screens/leisure/leisure_profile/leisure_profile_view.dart';
import 'package:choice_app/screens/onboarding/add_cuisine/add_cuisine.dart';
import 'package:choice_app/screens/onboarding/add_services/add_services.dart';
import 'package:choice_app/screens/onboarding/business_hours/edit_business_hours/edit_operational_hours.dart';
import 'package:choice_app/screens/onboarding/day_off/days_off_view.dart';
import 'package:choice_app/screens/onboarding/gallery/gallery_view.dart';
import 'package:choice_app/screens/onboarding/menu/menu_view.dart';
import 'package:choice_app/screens/onboarding/slot_management/slot_management_view.dart';
import 'package:choice_app/screens/producer_maps/heatmap.dart';
import 'package:choice_app/screens/restaurant/event/create_event.dart';
import 'package:choice_app/screens/restaurant/event/event_details.dart';
import 'package:choice_app/screens/restaurant/home/create_post.dart';
import 'package:choice_app/screens/subscription/subscribe_screen.dart';
import 'package:choice_app/screens/wellness/wellness_profile/wellness_profile_view.dart';
import 'package:go_router/go_router.dart';

import '../screens/authentication/accountReclaim/upload_reclaim_docs.dart';
import '../screens/authentication/login.dart';
import '../screens/authentication/passwordManagement/forgot_password.dart';
import '../screens/authentication/passwordManagement/reset_password.dart';
import '../screens/authentication/user_Signup.dart';
import '../screens/customer/home/choiceWidgets/sub_choice_selection.dart';
import '../screens/restaurant/bottomTab/bottom_tab.dart';
import '../screens/restaurant/event/events.dart';
import '../screens/restaurant/profile/profile.dart';
import '../screens/splash/splash.dart';
import '../screens/wellness/home/welness_home.dart';

class Routes {
  static const String initialRoute = '/';
  static const String languageSelectionRoute = '/language_selection';
  static const String authRoute = '/auth';
  static const String reClaimAccountRoute = '/re_claim_account';
  static const String uploadReclaimDocsRoute = '/upload_reclaim_docs';
  static const String reviewRoute = '/review';
  static const String signupRoute = '/signup';
  static const String userSignupRoute = '/userSignup';
  static const String otpVerificationRoute = '/otp_verification';
  static const String uploadDocsRoute = '/upload_docs';
  static const String loginRoute = '/login';
  static const String forgotPasswordRoute = '/forgot_password';
  static const String resetPasswordRoute = '/reset_password';
  static const String editOperationHoursRoute = '/edit_operation_hours';
  static const String galleryViewRoute = '/gallery_view';
  static const String bookingViewRoute = '/bookings_view';
  static const String slotManagementViewRoute = '/slot_management_view';

  // restaurant
  static const String restaurantProfileRoute = '/restaurant_profile';
  static const String restaurantEventsRoute = '/restaurant_events';
  static const String restaurantCreateEventRoute = '/restaurant_create_events';
  static const String restaurantEventDetailsRoute = '/restaurant_event_details';
  static const String restaurantBottomTabRoute = '/restaurant_bottom_tab';
  static const String restaurantCreatePostRoute = '/restaurant_create_post';
  static const String restaurantAddCuisineRoute = '/restaurant_add_cuisine';
  static const String restaurantMenuViewRoute = '/restaurant_menu_view';
  static const String selectFriendsRoute = '/select_friends';
  static const String suggestTimeSlotRoute = '/suggest_timeslot';
  static const String suggestEventRoute = '/suggest_event';
  static const String customerNonEventInviteRoute = '/customer_nonevent_invite';
  static const String customerEventInviteRoute = '/customer_event_invite';
  static const String interestedDetailsRoute = '/interested_details';
  static const String chatbotHomeRoute = '/chatbot_home';
  static const String subscribeRoute = '/subscribe_screen';
  static const String heatmapRoute = '/heatmap';
  static const String registrationRoute = '/account_registration';
  static const String daysOffRoute = '/days_off';
  static const String restaurantProfileHomeRoute = '/leisure_profile_view';
  static const String wellnessProfileHomeRoute = '/wellness_profile_view';
  static const String leisureProfileHomeRoute = '/leisure_profile_view';













  //Customer
  static const String customerHomeRoute = '/customer_home';
  static const String choiceSelectionRoute = '/choice_selection';
  static const String subChoiceSelectionRoute = '/sub_choice_selection';
  static const String createChoiceRoute = '/create_choice';

  //wellness
  static const String wellnessHomeRoute = '/wellness_home';
  static const String wellnessAddServicesRoute = '/wellness_add_services';

}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Splash()),
    GoRoute(path: '/language_selection', builder: (context, state) => const LanguageSelection()),
    GoRoute(path: '/re_claim_account', builder: (context, state) => const ReclaimAccount()),
    GoRoute(path: '/auth', builder: (context, state) => const Authentication()),
    GoRoute(path: '/signup', builder: (context, state) => const Signup()),
    GoRoute(path: '/userSignup', builder: (context, state) => const UserSignup()),
    GoRoute(
      path: '/otp_verification',
      builder: (context, state) => const OtpVerification(),
    ),
    GoRoute(
      path: '/upload_docs',
      builder: (context, state) => const UploadDocs(),
    ),
    GoRoute(
      path: '/upload_reclaim_docs',
      builder: (context, state) => const UploadReclaimDocs(),
    ),
    GoRoute(
      path: '/review',
      builder: (context, state) => const Review(),
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
      path: Routes.editOperationHoursRoute,
      builder: (context, state) {
        final fromSettings = state.extra as bool? ?? false;
        return EditOperationalHours(fromSettings: fromSettings);
      },
    ),
    GoRoute(
      path: Routes.registrationRoute,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final claimProducerId = args?["claimProducerId"];
        return RegistrationScreen(claimProducerId: claimProducerId as int?);
      },
    ),
    GoRoute(
      path: Routes.galleryViewRoute,
      builder: (context, state) => const GalleryView(),
    ),
    GoRoute(
      path: Routes.restaurantProfileHomeRoute,
      builder: (context, state) => const LeisureProfileView(),
    ),
    GoRoute(
      path: Routes.leisureProfileHomeRoute,
      builder: (context, state) => const LeisureProfileView(),
    ),
    GoRoute(
      path: Routes.wellnessProfileHomeRoute,
      builder: (context, state) => const WellnessProfileView(),
    ),
    GoRoute(
      path: Routes.slotManagementViewRoute,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final isEditable = args?['isEdit'] as bool? ?? false;
        final isHomeFlow = args?['isHomeFlow'] as bool? ?? true;
        return SlotManagementView(isEdit: isEditable, isHomeFlow: isHomeFlow);
      },
    ),
    GoRoute(
      path: Routes.daysOffRoute,
      builder: (context, state) => const DaysOffView(),
    ),

    // restaurant
    GoRoute(
      path: Routes.restaurantProfileRoute,
      builder: (context, state) {
        final isFromSettings = state.extra as bool? ?? false;
        return Profile(isFromSettings: isFromSettings);
      },
    ),
    GoRoute(
      path: '/restaurant_events',
      builder: (context, state) => const Events(),
    ),
    GoRoute(
      path: '/restaurant_create_events',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final isEdit = args?['isEdit'] as bool? ?? false;
        final eventData = args?['eventData'];
        return CreateEvent(isEdit: isEdit, event: eventData);
      },
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
      path: Routes.restaurantAddCuisineRoute,
      builder: (context, state) => const AddCuisine(),
    ),
    GoRoute(
      path: Routes.restaurantMenuViewRoute,
      builder: (context, state) => const MenuView(),
    ),
    GoRoute(
      path: Routes.selectFriendsRoute,
      builder: (context, state) => const SelectFriendsScreen(),
    ),
    GoRoute(
      path: Routes.suggestTimeSlotRoute,
      builder: (context, state) {
        final mode = state.extra as TimeSlotMode? ?? TimeSlotMode.suggest; // default to suggest
        return SuggestTimeSlotScreen(mode: mode);
      },
    ),
    GoRoute(
      path: Routes.suggestEventRoute,
      builder: (context, state) => const SuggestEventScreen(),
    ),

    GoRoute(
      path: Routes.customerNonEventInviteRoute,
      builder: (context, state) => const CustomerNonEventInvite(),
    ),
    GoRoute(
      path: Routes.customerEventInviteRoute,
      builder: (context, state) => const CustomerEventInvite(),
    ),
    GoRoute(
      path: Routes.interestedDetailsRoute,
      builder: (context, state) => const InterestDetailsScreen(),
    ),
    GoRoute(
      path: Routes.chatbotHomeRoute,
      builder: (context, state) => const ChatBotHome(),
    ),
    GoRoute(
      path: Routes.subscribeRoute,
      builder: (context, state) => const SubscribeScreen(),
    ),
    GoRoute(
      path: Routes.bookingViewRoute,
      builder: (context, state) => const BookingsView(),
    ),
    GoRoute(
      path: Routes.heatmapRoute,
      builder: (context, state) => const HeatmapScreen(),
    ),
    //Customer
    GoRoute(
      path: '/customer_home',
      builder: (context, state) => const CustomerHome(),
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

    //wellness
    GoRoute(
      path: '/wellness_home',
      builder: (context, state) => const WellnessHome(),
    ),
    GoRoute(
      path: Routes.wellnessAddServicesRoute,
      builder: (context, state) => const AddServices(),
    ),
  ],
);
