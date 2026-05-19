import 'package:choice_app/screens/authentication/authentication.dart';
import 'package:choice_app/screens/authentication/otpVerification/otp_verification.dart';
import 'package:choice_app/screens/authentication/signup.dart';
import 'package:choice_app/screens/authentication/upload_docs.dart';
import 'package:choice_app/screens/bookings/booking_details.dart';
import 'package:choice_app/screens/onboarding/add_cuisine/add_cuisine.dart';
import 'package:choice_app/screens/onboarding/add_services/add_services.dart';
import 'package:choice_app/screens/onboarding/business_hours/edit_business_hours/edit_operational_hours.dart';
import 'package:choice_app/screens/onboarding/day_off/days_off_view.dart';
import 'package:choice_app/screens/onboarding/gallery/gallery_view.dart';
import 'package:choice_app/screens/onboarding/menu/menu_view.dart';
import 'package:choice_app/screens/onboarding/slot_management/slot_management_view.dart';
import 'package:choice_app/screens/restaurant/notifications/notifications_view.dart';
import 'package:choice_app/screens/customer/chat/messages_view/messages_view.dart';
import 'package:choice_app/screens/customer/chat/new_group/new_group_view.dart';
import 'package:choice_app/screens/customer/chat/user_chat/user_chat_view.dart';
import 'package:choice_app/screens/customer/chat/user_new_chat/user_new_chat_view.dart';
import 'package:choice_app/screens/customer/profile/customer_profile_tab_bar/customer_profile_tab_bar.dart';
import 'package:choice_app/screens/leisure/leisure_profile_tab_bar/leisure_profile_tab_bar.dart';
import 'package:choice_app/screens/restaurant/profile_menu/chat_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/follower/follower_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/following/following_view.dart';
import 'package:choice_app/screens/restaurant/setting/setting_view.dart';
import 'package:choice_app/screens/wellness/wellness_profile_tab_bar/wellness_Profile_tab_bar.dart';
import 'package:choice_app/screens/restaurant/profile_menu/badges/badges_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/blocked_users/blocked_users_view.dart';
import 'package:choice_app/screens/restaurant/profile_menu/bookmarked/bookmarked_view.dart';
import 'package:choice_app/screens/customer/explore/book_now/book_now_view.dart';
import 'package:choice_app/screens/customer/explore/customer_gallery/customer_gallery_screen.dart';
import 'package:choice_app/screens/customer/explore/full_menu/full_menu_view.dart';
import 'package:choice_app/screens/customer/explore/participants/participants_screen.dart';
import 'package:choice_app/screens/customer/explore/restaurant_explore_details/restaurant_explore_details.dart';
import 'package:choice_app/screens/customer/home/choiceWidgets/choice_selection.dart';
import 'package:choice_app/screens/customer/home/create_choice.dart';
import 'package:choice_app/screens/customer/home/customer_home.dart';
import 'package:choice_app/screens/customer/maps/customer_maps/customer_maps_view.dart';
import 'package:choice_app/screens/languageSelection/language_selection.dart';
import 'package:choice_app/screens/restaurant/event/create_event.dart';
import 'package:choice_app/screens/restaurant/event/event_details.dart';
import 'package:choice_app/screens/restaurant/home/create_post.dart';
import 'package:go_router/go_router.dart';

import '../screens/authentication/login.dart';
import '../screens/authentication/passwordManagement/forgot_password.dart';
import '../screens/authentication/passwordManagement/reset_password.dart';
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

  //Customer
  static const String customerHomeRoute = '/customer_home';
  static const String customerMapsRoute = '/customer_maps';
  static const String eventDetailsRoute = '/event_details';
  static const String choiceSelectionRoute = '/choice_selection';
  static const String subChoiceSelectionRoute = '/sub_choice_selection';
  static const String createChoiceRoute = '/create_choice';

  //wellness
  static const String wellnessHomeRoute = '/wellness_home';

}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Splash()),
    GoRoute(path: '/language_selection', builder: (context, state) => const LanguageSelection()),
    GoRoute(path: '/auth', builder: (context, state) => const Authentication()),
    GoRoute(path: '/signup', builder: (context, state) => const Signup()),
    GoRoute(
      path: '/otp_verification',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return OtpVerification(
          isResetPassFlow: extra['isResetPassFlow'] as bool? ?? false,
        );
      },
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
      builder: (context, state) {
        final existingEvent = state.extra as Map<String, dynamic>?;
        return CreateEvent(existingEvent: existingEvent);
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

    // Customer maps
    GoRoute(
      path: '/customer_maps',
      builder: (context, state) => CustomerMapsView(),
    ),
    // Explore event details
    GoRoute(
      path: '/event_details',
      builder: (context, state) {
        final tag = state.extra as String? ?? 'Restaurant';
        return RestaurantExploreDetails(tag: tag);
      },
    ),
    // Book now
    GoRoute(
      path: '/book_now',
      builder: (context, state) => const BookNowScreen(),
    ),
    // Customer gallery
    GoRoute(
      path: '/customer_gallery',
      builder: (context, state) {
        final id = state.extra as String? ?? '0';
        return ImageGalleryScreen(restaurantId: id);
      },
    ),
    // Fullscreen image viewer
    GoRoute(
      path: '/image_viewer',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final images = (extra['images'] as List?)
                ?.map((e) => e as String)
                .toList() ??
            <String>[];
        final idx = extra['initialIndex'] as int? ?? 0;
        return FullscreenImageViewer(images: images, initialIndex: idx);
      },
    ),
    // Participants screen
    GoRoute(
      path: '/participants',
      builder: (context, state) => const ParticipantsScreen(),
    ),
    // Full menu
    GoRoute(
      path: '/full_menu',
      builder: (context, state) => const FullMenuView(),
    ),
    // Booking details
    GoRoute(
      path: '/booking_details',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return BookingDetails(
          booking: extra['booking'] as Map<String, dynamic>?,
          isCancelled: extra['isCancelled'] as bool? ?? false,
        );
      },
    ),
    // Notifications
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsView(),
    ),
    // Social
    GoRoute(
      path: '/followers',
      builder: (context, state) => const FollowerView(),
    ),
    GoRoute(
      path: '/following',
      builder: (context, state) => const FollowingView(),
    ),
    // Settings
    GoRoute(
      path: '/setting',
      builder: (context, state) => const SettingView(),
    ),
    // Chat
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatView(),
    ),
    GoRoute(
      path: '/user_chat',
      builder: (context, state) => const UserChatView(),
    ),
    GoRoute(
      path: '/new_chat',
      builder: (context, state) => const UserNewChatView(),
    ),
    GoRoute(
      path: '/new_group',
      builder: (context, state) => const NewGroupView(),
    ),
    GoRoute(
      path: '/messages',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return MessagesView(
          chatId: extra['chatId'] as int? ?? 0,
          chatName: extra['chatName'] as String? ?? '',
          avatarUrl: extra['avatarUrl'] as String? ?? '',
        );
      },
    ),
    // Profile tab bars
    GoRoute(
      path: '/customer_profile_tab',
      builder: (context, state) => const CustomerProfileTabBar(),
    ),
    GoRoute(
      path: '/leisure_profile_tab',
      builder: (context, state) => const LeisureProfileTabBar(),
    ),
    GoRoute(
      path: '/wellness_profile_tab',
      builder: (context, state) => const WellnessProfileTabBar(),
    ),
    // Settings sub-screens
    GoRoute(
      path: '/badges',
      builder: (context, state) => const BadgesView(),
    ),
    GoRoute(
      path: '/bookmarked',
      builder: (context, state) => const BookmarkedView(),
    ),
    GoRoute(
      path: '/blocked_users',
      builder: (context, state) => const BlockedUsersView(),
    ),
    GoRoute(
      path: '/edit_business_hours',
      builder: (context, state) =>
          const EditOperationalHours(operationalHoursList: []),
    ),
    GoRoute(
      path: '/slot_management',
      builder: (context, state) =>
          const SlotManagementView(isHomeFlow: false, isEdit: true),
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuView(),
    ),
    GoRoute(
      path: '/add_services',
      builder: (context, state) => const AddServices(),
    ),
    GoRoute(
      path: '/gallery',
      builder: (context, state) => const GalleryView(),
    ),
    GoRoute(
      path: '/days_off',
      builder: (context, state) => const DaysOffView(),
    ),
    GoRoute(
      path: '/add_cuisine',
      builder: (context, state) => const AddCuisine(),
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

  ],
);
