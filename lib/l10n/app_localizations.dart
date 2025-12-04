import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get createAnAccount;

  /// No description provided for @chooseAccountType.
  ///
  /// In en, this message translates to:
  /// **'Choose the type of account you want to create:'**
  String get chooseAccountType;

  /// No description provided for @userAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'User Account'**
  String get userAccountTitle;

  /// No description provided for @provideAReason.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason.'**
  String get provideAReason;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @userAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'To discover restaurants and activities, and follow your favorite providers.'**
  String get userAccountDescription;

  /// No description provided for @restaurantProviderAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Provider Account'**
  String get restaurantProviderAccountTitle;

  /// No description provided for @restaurantProviderAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'To manage your restaurant and promote your offerings.'**
  String get restaurantProviderAccountDescription;

  /// No description provided for @leisureProviderAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Leisure Provider Account'**
  String get leisureProviderAccountTitle;

  /// No description provided for @leisureProviderAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'To manage your leisure activities and attract new clients.'**
  String get leisureProviderAccountDescription;

  /// No description provided for @wellnessProviderAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Wellness Provider Account'**
  String get wellnessProviderAccountTitle;

  /// No description provided for @wellnessProviderAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'To manage your well-being activity and attract new clients.'**
  String get wellnessProviderAccountDescription;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password to signup'**
  String get signupSubtitle;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessName;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNamePlaceholder;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get userName;

  /// No description provided for @userNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get userNamePlaceholder;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailPlaceholder;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @signupAgreement.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to our'**
  String get signupAgreement;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @andLabel.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get andLabel;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @signupWithApple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get signupWithApple;

  /// No description provided for @signupWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get signupWithGoogle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @verificationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6 -digit verification code sent to {email}}'**
  String verificationPrompt(Object email);

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn’t receive code?'**
  String get didNotReceiveCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resendCode;

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// No description provided for @uploadDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get uploadDocumentsTitle;

  /// No description provided for @uploadDocumentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please upload your document to proceed with verification.'**
  String get uploadDocumentsSubtitle;

  /// No description provided for @businessRegistrationDocument.
  ///
  /// In en, this message translates to:
  /// **'Business Registration Document'**
  String get businessRegistrationDocument;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a file'**
  String get chooseFile;

  /// No description provided for @maxFileSizeNote.
  ///
  /// In en, this message translates to:
  /// **'Max file size (PDF): 2MB'**
  String get maxFileSizeNote;

  /// No description provided for @utilityBillOrInvoice.
  ///
  /// In en, this message translates to:
  /// **'Utility Bill or Invoice'**
  String get utilityBillOrInvoice;

  /// No description provided for @submitForReview.
  ///
  /// In en, this message translates to:
  /// **'Submit for Review'**
  String get submitForReview;

  /// No description provided for @loginInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password to log in '**
  String get loginInstruction;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get noAccountPrompt;

  /// No description provided for @forgotPasswordInstruction.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email to receive verification code.'**
  String get forgotPasswordInstruction;

  /// No description provided for @sendOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtpButton;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordNote.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from previous used passwords.'**
  String get resetPasswordNote;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @profileSetup.
  ///
  /// In en, this message translates to:
  /// **'Profile Setup'**
  String get profileSetup;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @briefDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief Description'**
  String get briefDescription;

  /// No description provided for @writeSomethingBrief.
  ///
  /// In en, this message translates to:
  /// **'Write something brief...'**
  String get writeSomethingBrief;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'camera'**
  String get camera;

  /// No description provided for @chooseYourPhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose your photo'**
  String get chooseYourPhoto;

  /// No description provided for @links.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get links;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @choosePreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language to continue'**
  String get choosePreferredLanguage;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @businessHours.
  ///
  /// In en, this message translates to:
  /// **'Business Hours'**
  String get businessHours;

  /// No description provided for @manageSlots.
  ///
  /// In en, this message translates to:
  /// **'Manage Slots'**
  String get manageSlots;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @unavailability.
  ///
  /// In en, this message translates to:
  /// **'Unavailability'**
  String get unavailability;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-In'**
  String get checkIn;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In-Progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @menuCoverage.
  ///
  /// In en, this message translates to:
  /// **'Menu Coverage'**
  String get menuCoverage;

  /// No description provided for @noUpcomingBooking.
  ///
  /// In en, this message translates to:
  /// **'No upcoming booking'**
  String get noUpcomingBooking;

  /// No description provided for @noUpcomingBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'You have no upcoming booking'**
  String get noUpcomingBookingMessage;

  /// No description provided for @bookingInformation.
  ///
  /// In en, this message translates to:
  /// **'Booking Information'**
  String get bookingInformation;

  /// No description provided for @internalNotes.
  ///
  /// In en, this message translates to:
  /// **'Internal Notes'**
  String get internalNotes;

  /// No description provided for @customerInformation.
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customerInformation;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name:'**
  String get customerName;

  /// No description provided for @emailLabel1.
  ///
  /// In en, this message translates to:
  /// **'Email:'**
  String get emailLabel1;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @selectProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Select profile image'**
  String get selectProfileImage;

  /// No description provided for @failedToGetImageUrl.
  ///
  /// In en, this message translates to:
  /// **'Failed to get image url'**
  String get failedToGetImageUrl;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone:'**
  String get phoneLabel;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @validFacebookLink.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Facebook link'**
  String get validFacebookLink;

  /// No description provided for @validInstagramLink.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Instagram link'**
  String get validInstagramLink;

  /// No description provided for @validWebsiteLink.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid website link'**
  String get validWebsiteLink;

  /// No description provided for @validTwitterLink.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Twitter/X link'**
  String get validTwitterLink;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @cuisine.
  ///
  /// In en, this message translates to:
  /// **'Cuisine'**
  String get cuisine;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @reclaimAccount.
  ///
  /// In en, this message translates to:
  /// **'Reclaim Your Account'**
  String get reclaimAccount;

  /// No description provided for @retrieveAccess.
  ///
  /// In en, this message translates to:
  /// **'Retrieve access to your existing profile'**
  String get retrieveAccess;

  /// No description provided for @chooseOption.
  ///
  /// In en, this message translates to:
  /// **'Choose your option'**
  String get chooseOption;

  /// No description provided for @categoryRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get categoryRestaurant;

  /// No description provided for @categoryLeisure.
  ///
  /// In en, this message translates to:
  /// **'Leisure'**
  String get categoryLeisure;

  /// No description provided for @categoryWellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness'**
  String get categoryWellness;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by name...'**
  String get searchPlaceholder;

  /// No description provided for @claimAccount.
  ///
  /// In en, this message translates to:
  /// **'Claim Account'**
  String get claimAccount;

  /// No description provided for @orText.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get orText;

  /// No description provided for @uploadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get uploadDocuments;

  /// No description provided for @uploadDocumentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Please upload your document to proceed with verification.'**
  String get uploadDocumentsDescription;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get thankYou;

  /// No description provided for @underReviewMessage.
  ///
  /// In en, this message translates to:
  /// **'Your profile are now under review. We will get back to you in two business day.'**
  String get underReviewMessage;

  /// No description provided for @documentBusinessRegistration.
  ///
  /// In en, this message translates to:
  /// **'Buisness  Registration Documents'**
  String get documentBusinessRegistration;

  /// No description provided for @documentLeaseContract.
  ///
  /// In en, this message translates to:
  /// **'Commercial Lease Contract'**
  String get documentLeaseContract;

  /// No description provided for @documentUtilityBill.
  ///
  /// In en, this message translates to:
  /// **'Utility Bill'**
  String get documentUtilityBill;

  /// No description provided for @documentSupplierInvoice.
  ///
  /// In en, this message translates to:
  /// **'Supplier Invoice'**
  String get documentSupplierInvoice;

  /// No description provided for @documentInsuranceCertificate.
  ///
  /// In en, this message translates to:
  /// **'Professional Insurance Certificate'**
  String get documentInsuranceCertificate;

  /// No description provided for @documentTax.
  ///
  /// In en, this message translates to:
  /// **'Tax Document'**
  String get documentTax;

  /// No description provided for @documentAuthorizationLetter.
  ///
  /// In en, this message translates to:
  /// **'Signed Authorization Letter'**
  String get documentAuthorizationLetter;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createPost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @fileSupport.
  ///
  /// In en, this message translates to:
  /// **'File supported:'**
  String get fileSupport;

  /// No description provided for @imageLimit.
  ///
  /// In en, this message translates to:
  /// **'Up to 5 images'**
  String get imageLimit;

  /// No description provided for @exampleTitle.
  ///
  /// In en, this message translates to:
  /// **'e.g Sunday Brunch at The Maple House'**
  String get exampleTitle;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @passwordManager.
  ///
  /// In en, this message translates to:
  /// **'Password Manager'**
  String get passwordManager;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @eventTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Event Type'**
  String get eventTypeLabel;

  /// No description provided for @eventTypePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select event type'**
  String get eventTypePlaceholder;

  /// No description provided for @passwordMissing.
  ///
  /// In en, this message translates to:
  /// **'Password is missing'**
  String get passwordMissing;

  /// No description provided for @passwordInvalidCharacters.
  ///
  /// In en, this message translates to:
  /// **'Password contains invalid characters. Only letters, numbers, and !@#\\\$%& are allowed'**
  String get passwordInvalidCharacters;

  /// No description provided for @emailMissing.
  ///
  /// In en, this message translates to:
  /// **'Email is missing'**
  String get emailMissing;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get invalidEmail;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid Password'**
  String get invalidPassword;

  /// No description provided for @passwordMustBeAtLeast8Chars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordMustBeAtLeast8Chars;

  /// No description provided for @passwordCannotContainSpaces.
  ///
  /// In en, this message translates to:
  /// **'Password cannot contain spaces'**
  String get passwordCannotContainSpaces;

  /// No description provided for @passwordMustContainUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter (A-Z)'**
  String get passwordMustContainUppercase;

  /// No description provided for @passwordMustContainLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter (a-z)'**
  String get passwordMustContainLowercase;

  /// No description provided for @passwordMustContainNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number (0-9)'**
  String get passwordMustContainNumber;

  /// No description provided for @passwordMustContainSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character (!@#\\\$%&)'**
  String get passwordMustContainSpecialChar;

  /// No description provided for @interest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get interest;

  /// No description provided for @choices.
  ///
  /// In en, this message translates to:
  /// **'Choices'**
  String get choices;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMore;

  /// No description provided for @eventsNearYou.
  ///
  /// In en, this message translates to:
  /// **'Events near you'**
  String get eventsNearYou;

  /// No description provided for @surpriseMe.
  ///
  /// In en, this message translates to:
  /// **'Surprise me'**
  String get surpriseMe;

  /// No description provided for @seeFullMenu.
  ///
  /// In en, this message translates to:
  /// **'See Full Menu'**
  String get seeFullMenu;

  /// No description provided for @organizer.
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get organizer;

  /// No description provided for @moreEventsLikeThis.
  ///
  /// In en, this message translates to:
  /// **'More Events Like This'**
  String get moreEventsLikeThis;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// No description provided for @ticketPrice.
  ///
  /// In en, this message translates to:
  /// **'Ticket price'**
  String get ticketPrice;

  /// No description provided for @perPerson.
  ///
  /// In en, this message translates to:
  /// **'/per person'**
  String get perPerson;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @browseByCategory.
  ///
  /// In en, this message translates to:
  /// **'Browse by Category'**
  String get browseByCategory;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @ratingsByTheme.
  ///
  /// In en, this message translates to:
  /// **'Ratings by Theme'**
  String get ratingsByTheme;

  /// No description provided for @interestSplitByPriceType.
  ///
  /// In en, this message translates to:
  /// **'Interest Split by Price Type'**
  String get interestSplitByPriceType;

  /// No description provided for @weeklyEvolution.
  ///
  /// In en, this message translates to:
  /// **'Weekly Evolution'**
  String get weeklyEvolution;

  /// No description provided for @criteriaRatings.
  ///
  /// In en, this message translates to:
  /// **'Criteria Ratings'**
  String get criteriaRatings;

  /// No description provided for @cleanliness.
  ///
  /// In en, this message translates to:
  /// **'Cleanliness'**
  String get cleanliness;

  /// No description provided for @staffExpertise.
  ///
  /// In en, this message translates to:
  /// **'Staff Expertise'**
  String get staffExpertise;

  /// No description provided for @ambiance.
  ///
  /// In en, this message translates to:
  /// **'Ambiance'**
  String get ambiance;

  /// No description provided for @numberOfInterests.
  ///
  /// In en, this message translates to:
  /// **'Number of interests'**
  String get numberOfInterests;

  /// No description provided for @expiryDate1Placeholder.
  ///
  /// In en, this message translates to:
  /// **'Please Select Expiry Date 1'**
  String get expiryDate1Placeholder;

  /// No description provided for @businessRegistrationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Please Select Business Registration Document'**
  String get businessRegistrationPlaceholder;

  /// No description provided for @expiryDate2Placeholder.
  ///
  /// In en, this message translates to:
  /// **'Please Select Expiry Date 2'**
  String get expiryDate2Placeholder;

  /// No description provided for @utilityBillPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Please Select Utility Bill or Invoice'**
  String get utilityBillPlaceholder;

  /// No description provided for @businessNameMissing.
  ///
  /// In en, this message translates to:
  /// **'Business Name is Missing'**
  String get businessNameMissing;

  /// No description provided for @businessNameInvalidCharacters.
  ///
  /// In en, this message translates to:
  /// **'Business Name contains invalid characters (no emojis allowed)'**
  String get businessNameInvalidCharacters;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet'**
  String get noInternet;

  /// No description provided for @enterOtpPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Please enter the otp'**
  String get enterOtpPlaceholder;

  /// No description provided for @otpVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Otp Verified Successful'**
  String get otpVerifiedSuccess;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something bad happened,Try again.'**
  String get genericError;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful'**
  String get registrationSuccessful;

  /// No description provided for @eventDescriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe your event...'**
  String get eventDescriptionPlaceholder;

  /// No description provided for @exampleTags.
  ///
  /// In en, this message translates to:
  /// **'e.g: #cozy, #outdoor_seating'**
  String get exampleTags;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @addLocation.
  ///
  /// In en, this message translates to:
  /// **'Add location'**
  String get addLocation;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @errorSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Please Select at least one image'**
  String get errorSelectImage;

  /// No description provided for @errorEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please Enter title'**
  String get errorEnterTitle;

  /// No description provided for @errorEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please Enter description'**
  String get errorEnterDescription;

  /// No description provided for @errorEnterTags.
  ///
  /// In en, this message translates to:
  /// **'Please Enter relative tags'**
  String get errorEnterTags;

  /// No description provided for @errorEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please Enter address'**
  String get errorEnterAddress;

  /// No description provided for @searchUserPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by username or name...'**
  String get searchUserPlaceholder;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @deleteEventConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Event?'**
  String get deleteEventConfirmation;

  /// No description provided for @deleteEventMessage.
  ///
  /// In en, this message translates to:
  /// **'This action will permanently remove the event.'**
  String get deleteEventMessage;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @sampleEventName.
  ///
  /// In en, this message translates to:
  /// **'Wine & Dine Evening'**
  String get sampleEventName;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEvent;

  /// No description provided for @noEvents.
  ///
  /// In en, this message translates to:
  /// **'No Events Yet'**
  String get noEvents;

  /// No description provided for @noEventsMessage.
  ///
  /// In en, this message translates to:
  /// **'You haven’t created any events yet. Start by adding your first one — it only takes a minute!'**
  String get noEventsMessage;

  /// No description provided for @eventDetails.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetails;

  /// No description provided for @exampleDish.
  ///
  /// In en, this message translates to:
  /// **'E.g: Brochette boeuf...'**
  String get exampleDish;

  /// No description provided for @eventName.
  ///
  /// In en, this message translates to:
  /// **'Event Name'**
  String get eventName;

  /// No description provided for @eventGallery.
  ///
  /// In en, this message translates to:
  /// **'Event Gallery'**
  String get eventGallery;

  /// No description provided for @uploadLimit.
  ///
  /// In en, this message translates to:
  /// **'Upload up to 5 images'**
  String get uploadLimit;

  /// No description provided for @uploadEventImages.
  ///
  /// In en, this message translates to:
  /// **'Upload Event Images*'**
  String get uploadEventImages;

  /// No description provided for @restaurantOrVenue.
  ///
  /// In en, this message translates to:
  /// **'Restaurant name or venue'**
  String get restaurantOrVenue;

  /// No description provided for @venueName.
  ///
  /// In en, this message translates to:
  /// **'Venue Name'**
  String get venueName;

  /// No description provided for @venueAddress.
  ///
  /// In en, this message translates to:
  /// **'Address of venue'**
  String get venueAddress;

  /// No description provided for @capacityPricing.
  ///
  /// In en, this message translates to:
  /// **'Capacity & Pricing'**
  String get capacityPricing;

  /// No description provided for @maxPersons.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of persons'**
  String get maxPersons;

  /// No description provided for @maxCapacity.
  ///
  /// In en, this message translates to:
  /// **'Maximum Capacity'**
  String get maxCapacity;

  /// No description provided for @pricePerPerson.
  ///
  /// In en, this message translates to:
  /// **'Price per person'**
  String get pricePerPerson;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Event Date'**
  String get eventDate;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @saveAsDraft.
  ///
  /// In en, this message translates to:
  /// **'Save as Draft'**
  String get saveAsDraft;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload image'**
  String get tapToUpload;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @aboutEvent.
  ///
  /// In en, this message translates to:
  /// **'About Event'**
  String get aboutEvent;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @seeLess.
  ///
  /// In en, this message translates to:
  /// **'See Less'**
  String get seeLess;

  /// No description provided for @socialLinks.
  ///
  /// In en, this message translates to:
  /// **'Social Links'**
  String get socialLinks;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @yourExperience.
  ///
  /// In en, this message translates to:
  /// **'Your Experience'**
  String get yourExperience;

  /// No description provided for @overallRestaurantRating.
  ///
  /// In en, this message translates to:
  /// **'Overall Restaurant Rating'**
  String get overallRestaurantRating;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @portions.
  ///
  /// In en, this message translates to:
  /// **'Portions'**
  String get portions;

  /// No description provided for @dishesAndMenusConsumed.
  ///
  /// In en, this message translates to:
  /// **'Dishes and Menus Consumed'**
  String get dishesAndMenusConsumed;

  /// No description provided for @rateTheSelectedDishes.
  ///
  /// In en, this message translates to:
  /// **'Rate The Selected Dishes'**
  String get rateTheSelectedDishes;

  /// No description provided for @yourRatingForThisDish.
  ///
  /// In en, this message translates to:
  /// **'Your rating for this dish:'**
  String get yourRatingForThisDish;

  /// No description provided for @fileSupported.
  ///
  /// In en, this message translates to:
  /// **'File supported: PNG, JPG'**
  String get fileSupported;

  /// No description provided for @chooseAFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a file'**
  String get chooseAFile;

  /// No description provided for @upTo5Images.
  ///
  /// In en, this message translates to:
  /// **'Up to 5 images'**
  String get upTo5Images;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @whichRestaurantDidYouVisit.
  ///
  /// In en, this message translates to:
  /// **'Which restaurant did you visit?'**
  String get whichRestaurantDidYouVisit;

  /// No description provided for @whichWellnessDidYouVisit.
  ///
  /// In en, this message translates to:
  /// **'Which wellness did you visit?'**
  String get whichWellnessDidYouVisit;

  /// No description provided for @whichLeisureEventDidYouAttend.
  ///
  /// In en, this message translates to:
  /// **'Which leisure event did you attend?'**
  String get whichLeisureEventDidYouAttend;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @dishName.
  ///
  /// In en, this message translates to:
  /// **'Dish Name'**
  String get dishName;

  /// No description provided for @dishRating.
  ///
  /// In en, this message translates to:
  /// **'Dish Rating'**
  String get dishRating;

  /// No description provided for @resetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get resetAll;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @unlockMoreWithPlus.
  ///
  /// In en, this message translates to:
  /// **'Unlock more with Plus'**
  String get unlockMoreWithPlus;

  /// No description provided for @getMoreCapableModels.
  ///
  /// In en, this message translates to:
  /// **'Get our more capable models and features'**
  String get getMoreCapableModels;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @startByAddingPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Start by adding a payment method'**
  String get startByAddingPaymentMethod;

  /// No description provided for @addPaymentMethodInfo.
  ///
  /// In en, this message translates to:
  /// **'Add a payment method to your Google Account to complete your purchase. Your payment information is only visible to Google.'**
  String get addPaymentMethodInfo;

  /// No description provided for @addCreditOrDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Add credit or debit card'**
  String get addCreditOrDebitCard;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @limitedAICopilotQueries.
  ///
  /// In en, this message translates to:
  /// **'Limited AI Copilot Queries'**
  String get limitedAICopilotQueries;

  /// No description provided for @pro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get pro;

  /// No description provided for @blockedList.
  ///
  /// In en, this message translates to:
  /// **'Blocked List'**
  String get blockedList;

  /// No description provided for @bookmarked.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked'**
  String get bookmarked;

  /// No description provided for @createNewProfile.
  ///
  /// In en, this message translates to:
  /// **'Create New Profile'**
  String get createNewProfile;

  /// No description provided for @switchBetweenProfiles.
  ///
  /// In en, this message translates to:
  /// **'Switch between profiles with one login'**
  String get switchBetweenProfiles;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @searchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by name...'**
  String get searchByName;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @switchAccount.
  ///
  /// In en, this message translates to:
  /// **'Switch Account'**
  String get switchAccount;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser;

  /// No description provided for @blockUserDescription.
  ///
  /// In en, this message translates to:
  /// **'Blocking this user will prevent them from interacting with you. You can unblock them anytime from your Account Settings.'**
  String get blockUserDescription;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @whyReport.
  ///
  /// In en, this message translates to:
  /// **'Why do you want to report?'**
  String get whyReport;

  /// No description provided for @spamOrFakeAccount.
  ///
  /// In en, this message translates to:
  /// **'Spam or Fake Account'**
  String get spamOrFakeAccount;

  /// No description provided for @inappropriateContent.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate Content'**
  String get inappropriateContent;

  /// No description provided for @harassmentOrBullying.
  ///
  /// In en, this message translates to:
  /// **'Harassment or Bullying'**
  String get harassmentOrBullying;

  /// No description provided for @hateSpeech.
  ///
  /// In en, this message translates to:
  /// **'Hate Speech'**
  String get hateSpeech;

  /// No description provided for @scamOrFraud.
  ///
  /// In en, this message translates to:
  /// **'Scam or Fraud'**
  String get scamOrFraud;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @unfollow.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @unlimitedAICopilotQueries.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI Copilot Queries'**
  String get unlimitedAICopilotQueries;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @reportUser.
  ///
  /// In en, this message translates to:
  /// **'Report User'**
  String get reportUser;

  /// No description provided for @follower.
  ///
  /// In en, this message translates to:
  /// **'Follower'**
  String get follower;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aestheticCareAndWellBeing.
  ///
  /// In en, this message translates to:
  /// **'Aesthetic Care & Well-Being'**
  String get aestheticCareAndWellBeing;

  /// No description provided for @hairCareAndHairServices.
  ///
  /// In en, this message translates to:
  /// **'Hair Care & Hair Services'**
  String get hairCareAndHairServices;

  /// No description provided for @nailCareAndBodyModifications.
  ///
  /// In en, this message translates to:
  /// **'Nail Care & Body Modifications'**
  String get nailCareAndBodyModifications;

  /// No description provided for @seeFullGallery.
  ///
  /// In en, this message translates to:
  /// **'See Full Gallery'**
  String get seeFullGallery;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @unblockUser.
  ///
  /// In en, this message translates to:
  /// **'Unblock User'**
  String get unblockUser;

  /// No description provided for @unblockConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unblock this user?'**
  String get unblockConfirmation;

  /// No description provided for @badgeAndXP.
  ///
  /// In en, this message translates to:
  /// **'Badge & XP'**
  String get badgeAndXP;

  /// No description provided for @firstBookingMaster.
  ///
  /// In en, this message translates to:
  /// **'First Booking Master'**
  String get firstBookingMaster;

  /// No description provided for @firstBookingMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your very first booking of any kind'**
  String get firstBookingMasterDesc;

  /// No description provided for @choiceCreator.
  ///
  /// In en, this message translates to:
  /// **'Choice Creator'**
  String get choiceCreator;

  /// No description provided for @choiceCreatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your first choice and start exploring options'**
  String get choiceCreatorDesc;

  /// No description provided for @reviewContributor.
  ///
  /// In en, this message translates to:
  /// **'Review Contributor'**
  String get reviewContributor;

  /// No description provided for @reviewContributorDesc.
  ///
  /// In en, this message translates to:
  /// **'Share your experience by posting a new review'**
  String get reviewContributorDesc;

  /// No description provided for @achievementBadges.
  ///
  /// In en, this message translates to:
  /// **'Achievement Badges'**
  String get achievementBadges;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get viewMore;

  /// No description provided for @fillOneFieldToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Please fill at least one field to update your profile'**
  String get fillOneFieldToUpdateProfile;

  /// No description provided for @validBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid business name'**
  String get validBusinessName;

  /// No description provided for @validAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid address (at least 5 characters)'**
  String get validAddress;

  /// No description provided for @validPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get validPhoneNumber;

  /// No description provided for @validDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a meaningful description (at least 10 characters)'**
  String get validDescription;

  /// No description provided for @validWebsiteUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid website URL'**
  String get validWebsiteUrl;

  /// No description provided for @validInstagramUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Instagram URL'**
  String get validInstagramUrl;

  /// No description provided for @validTwitterUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Twitter URL'**
  String get validTwitterUrl;

  /// No description provided for @validFacebookUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Facebook URL'**
  String get validFacebookUrl;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @operationalHoursSaved.
  ///
  /// In en, this message translates to:
  /// **'Operational hours saved successfully'**
  String get operationalHoursSaved;

  /// No description provided for @failedToSaveOperationalHours.
  ///
  /// In en, this message translates to:
  /// **'Failed to save operational hours'**
  String get failedToSaveOperationalHours;

  /// No description provided for @failedToFetchCuisineTypes.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch cuisine types'**
  String get failedToFetchCuisineTypes;

  /// No description provided for @cuisineTypeSetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Cuisine type set successfully'**
  String get cuisineTypeSetSuccessfully;

  /// No description provided for @failedToSetCuisineType.
  ///
  /// In en, this message translates to:
  /// **'Failed to set cuisine type'**
  String get failedToSetCuisineType;

  /// No description provided for @galleryImagesSaved.
  ///
  /// In en, this message translates to:
  /// **'Gallery images saved successfully'**
  String get galleryImagesSaved;

  /// No description provided for @failedToSaveGalleryImages.
  ///
  /// In en, this message translates to:
  /// **'Failed to save gallery images'**
  String get failedToSaveGalleryImages;

  /// No description provided for @failedToAddMenuCategory.
  ///
  /// In en, this message translates to:
  /// **'Failed to add menu category'**
  String get failedToAddMenuCategory;

  /// No description provided for @failedToFetchMenuCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch menu categories'**
  String get failedToFetchMenuCategories;

  /// No description provided for @slotDurationSetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Slot duration set successfully'**
  String get slotDurationSetSuccessfully;

  /// No description provided for @failedToSetSlotDuration.
  ///
  /// In en, this message translates to:
  /// **'Failed to set slot duration'**
  String get failedToSetSlotDuration;

  /// No description provided for @failedToFetchProducerSlots.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch producer slots'**
  String get failedToFetchProducerSlots;

  /// No description provided for @failedToFetchAllServiceTypes.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch all service types'**
  String get failedToFetchAllServiceTypes;

  /// No description provided for @serviceTypeSetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Service type set successfully'**
  String get serviceTypeSetSuccessfully;

  /// No description provided for @failedToSetServiceType.
  ///
  /// In en, this message translates to:
  /// **'Failed to set service type'**
  String get failedToSetServiceType;

  /// No description provided for @failedToFetchProducerProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch producer profile'**
  String get failedToFetchProducerProfile;

  /// No description provided for @failedToAddMenuDish.
  ///
  /// In en, this message translates to:
  /// **'Failed to add menu dish'**
  String get failedToAddMenuDish;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'You don’t have any notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @notificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'You will receive notifications regarding reservations, reviews etc.'**
  String get notificationsDescription;

  /// No description provided for @shareExperienceReview.
  ///
  /// In en, this message translates to:
  /// **'Share your experience by leaving a review at'**
  String get shareExperienceReview;

  /// No description provided for @enterEventName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the event name.'**
  String get enterEventName;

  /// No description provided for @enterEventDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter the event description.'**
  String get enterEventDescription;

  /// No description provided for @enterVenue.
  ///
  /// In en, this message translates to:
  /// **'Please enter the venue.'**
  String get enterVenue;

  /// No description provided for @enterCapacity.
  ///
  /// In en, this message translates to:
  /// **'Please enter the capacity.'**
  String get enterCapacity;

  /// No description provided for @enterValidCapacityNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number for capacity.'**
  String get enterValidCapacityNumber;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter the price.'**
  String get enterPrice;

  /// No description provided for @enterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price.'**
  String get enterValidPrice;

  /// No description provided for @deleteEvent.
  ///
  /// In en, this message translates to:
  /// **'Delete Event?'**
  String get deleteEvent;

  /// No description provided for @deleteEventDescription.
  ///
  /// In en, this message translates to:
  /// **'This action will permanently remove the event.'**
  String get deleteEventDescription;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @week1.
  ///
  /// In en, this message translates to:
  /// **'Week 1'**
  String get week1;

  /// No description provided for @week2.
  ///
  /// In en, this message translates to:
  /// **'Week 2'**
  String get week2;

  /// No description provided for @week3.
  ///
  /// In en, this message translates to:
  /// **'Week 3'**
  String get week3;

  /// No description provided for @week4.
  ///
  /// In en, this message translates to:
  /// **'Week 4'**
  String get week4;

  /// No description provided for @dishRatings.
  ///
  /// In en, this message translates to:
  /// **'Dish Ratings'**
  String get dishRatings;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @otpResentSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully'**
  String get otpResentSuccess;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @monthlyEvolution.
  ///
  /// In en, this message translates to:
  /// **'Monthly Evolution'**
  String get monthlyEvolution;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// No description provided for @pleaseSelectMonth.
  ///
  /// In en, this message translates to:
  /// **'Please select a month'**
  String get pleaseSelectMonth;

  /// No description provided for @profileViews.
  ///
  /// In en, this message translates to:
  /// **'Profile Views'**
  String get profileViews;

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get lastWeek;

  /// No description provided for @chosen.
  ///
  /// In en, this message translates to:
  /// **'Chosen'**
  String get chosen;

  /// No description provided for @timesThisWeek.
  ///
  /// In en, this message translates to:
  /// **'times this week'**
  String get timesThisWeek;

  /// No description provided for @dishDropAlerts.
  ///
  /// In en, this message translates to:
  /// **'Dish Drop Alerts'**
  String get dishDropAlerts;

  /// No description provided for @day1.
  ///
  /// In en, this message translates to:
  /// **'Day 1'**
  String get day1;

  /// No description provided for @day2.
  ///
  /// In en, this message translates to:
  /// **'Day 2'**
  String get day2;

  /// No description provided for @day3.
  ///
  /// In en, this message translates to:
  /// **'Day 3'**
  String get day3;

  /// No description provided for @day4.
  ///
  /// In en, this message translates to:
  /// **'Day 4'**
  String get day4;

  /// No description provided for @day5.
  ///
  /// In en, this message translates to:
  /// **'Day 5'**
  String get day5;

  /// No description provided for @day6.
  ///
  /// In en, this message translates to:
  /// **'Day 6'**
  String get day6;

  /// No description provided for @fourDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'4 days ago'**
  String get fourDaysAgo;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @bookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get bookmark;

  /// No description provided for @choicesMade.
  ///
  /// In en, this message translates to:
  /// **'Choices Made'**
  String get choicesMade;

  /// No description provided for @conversionRate.
  ///
  /// In en, this message translates to:
  /// **'Conversion Rate'**
  String get conversionRate;

  /// No description provided for @postConversionRate.
  ///
  /// In en, this message translates to:
  /// **'Post Conversion Rate'**
  String get postConversionRate;

  /// No description provided for @favoriteChoiceOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Favorite choice of the month'**
  String get favoriteChoiceOfMonth;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @mostChosenDish.
  ///
  /// In en, this message translates to:
  /// **'Most Chosen Dish'**
  String get mostChosenDish;

  /// No description provided for @waitingTimeComplaints.
  ///
  /// In en, this message translates to:
  /// **'Waiting Time Complaints'**
  String get waitingTimeComplaints;

  /// No description provided for @choicesFlaggedLongWait.
  ///
  /// In en, this message translates to:
  /// **'Choices flagged long wait times'**
  String get choicesFlaggedLongWait;

  /// No description provided for @topPerformingEventType.
  ///
  /// In en, this message translates to:
  /// **'Top Performing Event Type'**
  String get topPerformingEventType;

  /// No description provided for @twoXMoreThanLiveMusic.
  ///
  /// In en, this message translates to:
  /// **'2x more than live music'**
  String get twoXMoreThanLiveMusic;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'label'**
  String get label;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'value'**
  String get value;

  /// No description provided for @ratingsByExperienceTheme.
  ///
  /// In en, this message translates to:
  /// **'Ratings by Experience Theme'**
  String get ratingsByExperienceTheme;

  /// No description provided for @notRated.
  ///
  /// In en, this message translates to:
  /// **'Not Rated'**
  String get notRated;

  /// No description provided for @rated.
  ///
  /// In en, this message translates to:
  /// **'Rated'**
  String get rated;

  /// No description provided for @userOriginMap.
  ///
  /// In en, this message translates to:
  /// **'User Origin Map'**
  String get userOriginMap;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @weeklyRatings.
  ///
  /// In en, this message translates to:
  /// **'Weekly Ratings'**
  String get weeklyRatings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @allDay.
  ///
  /// In en, this message translates to:
  /// **'All day'**
  String get allDay;

  /// No description provided for @everyday.
  ///
  /// In en, this message translates to:
  /// **'Everyday'**
  String get everyday;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning (6am–12pm)'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon (12pm–6pm)'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening (6pm–12am)'**
  String get evening;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night (12am–6am)'**
  String get night;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @heatmap.
  ///
  /// In en, this message translates to:
  /// **'Heatmap'**
  String get heatmap;

  /// No description provided for @createOffer.
  ///
  /// In en, this message translates to:
  /// **'Create Offer'**
  String get createOffer;

  /// No description provided for @offerTemplate.
  ///
  /// In en, this message translates to:
  /// **'Offer Template'**
  String get offerTemplate;

  /// No description provided for @noTemplateYet.
  ///
  /// In en, this message translates to:
  /// **'No Template Yet'**
  String get noTemplateYet;

  /// No description provided for @templateInfo.
  ///
  /// In en, this message translates to:
  /// **'Once a template has been published by you, it will be listed here.'**
  String get templateInfo;

  /// No description provided for @targetedNotification.
  ///
  /// In en, this message translates to:
  /// **'Targeted Notification'**
  String get targetedNotification;

  /// No description provided for @step1WriteOffer.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Write your offer'**
  String get step1WriteOffer;

  /// No description provided for @exampleOffer.
  ///
  /// In en, this message translates to:
  /// **'e.g: Come now and enjoy 15% off'**
  String get exampleOffer;

  /// No description provided for @reductionPercent.
  ///
  /// In en, this message translates to:
  /// **'Reduction %'**
  String get reductionPercent;

  /// No description provided for @validateMinutes.
  ///
  /// In en, this message translates to:
  /// **'Validate (minutes)'**
  String get validateMinutes;

  /// No description provided for @numberOfUsers.
  ///
  /// In en, this message translates to:
  /// **'Number of Users'**
  String get numberOfUsers;

  /// No description provided for @step2ChooseTarget.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Choose your target'**
  String get step2ChooseTarget;

  /// No description provided for @allNearbyUsers.
  ///
  /// In en, this message translates to:
  /// **'All nearby users'**
  String get allNearbyUsers;

  /// No description provided for @allActiveUsers.
  ///
  /// In en, this message translates to:
  /// **'All active users (2km radius)'**
  String get allActiveUsers;

  /// No description provided for @estimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated:'**
  String get estimated;

  /// No description provided for @onlineUsers.
  ///
  /// In en, this message translates to:
  /// **'Online Users'**
  String get onlineUsers;

  /// No description provided for @notificationAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance of the Notification'**
  String get notificationAppearance;

  /// No description provided for @saveAsTemplate.
  ///
  /// In en, this message translates to:
  /// **'Save as Template'**
  String get saveAsTemplate;

  /// No description provided for @sendNow.
  ///
  /// In en, this message translates to:
  /// **'Send Now'**
  String get sendNow;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @cuisineType.
  ///
  /// In en, this message translates to:
  /// **'Cuisine Type'**
  String get cuisineType;

  /// No description provided for @selectCuisineType.
  ///
  /// In en, this message translates to:
  /// **'Select cuisine type'**
  String get selectCuisineType;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// No description provided for @mexican.
  ///
  /// In en, this message translates to:
  /// **'Mexican'**
  String get mexican;

  /// No description provided for @indian.
  ///
  /// In en, this message translates to:
  /// **'Indian'**
  String get indian;

  /// No description provided for @massageRelaxation.
  ///
  /// In en, this message translates to:
  /// **'Massage & Relaxation'**
  String get massageRelaxation;

  /// No description provided for @skinTreatmentsFacials.
  ///
  /// In en, this message translates to:
  /// **'Skin Treatments & Facials'**
  String get skinTreatmentsFacials;

  /// No description provided for @makeupBeautyServices.
  ///
  /// In en, this message translates to:
  /// **'Makeup & Beauty Services'**
  String get makeupBeautyServices;

  /// No description provided for @waxingHairRemoval.
  ///
  /// In en, this message translates to:
  /// **'Waxing & Hair Removal'**
  String get waxingHairRemoval;

  /// No description provided for @spaWellnessPackages.
  ///
  /// In en, this message translates to:
  /// **'Spa & Wellness Packages'**
  String get spaWellnessPackages;

  /// No description provided for @laserTreatments.
  ///
  /// In en, this message translates to:
  /// **'Laser Treatments'**
  String get laserTreatments;

  /// No description provided for @tattooPiercingServices.
  ///
  /// In en, this message translates to:
  /// **'Tattoo & Piercing Services'**
  String get tattooPiercingServices;

  /// No description provided for @eyebrowEyelashTreatments.
  ///
  /// In en, this message translates to:
  /// **'Eyebrow & Eyelash Treatments'**
  String get eyebrowEyelashTreatments;

  /// No description provided for @bridalEventPackages.
  ///
  /// In en, this message translates to:
  /// **'Bridal & Event Packages'**
  String get bridalEventPackages;

  /// No description provided for @dermatologyConsultation.
  ///
  /// In en, this message translates to:
  /// **'Dermatology & Skin Care Consultation'**
  String get dermatologyConsultation;

  /// No description provided for @footHandCare.
  ///
  /// In en, this message translates to:
  /// **'Foot & Hand Care'**
  String get footHandCare;

  /// No description provided for @hairTransplantScalpServices.
  ///
  /// In en, this message translates to:
  /// **'Hair Transplant & Scalp Services'**
  String get hairTransplantScalpServices;

  /// No description provided for @servicesType.
  ///
  /// In en, this message translates to:
  /// **'Services Type'**
  String get servicesType;

  /// No description provided for @selectServicesType.
  ///
  /// In en, this message translates to:
  /// **'Select services type'**
  String get selectServicesType;

  /// No description provided for @selectAtLeastOneServiceType.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one service type.'**
  String get selectAtLeastOneServiceType;

  /// No description provided for @pleasePickImage.
  ///
  /// In en, this message translates to:
  /// **'Please pick an image'**
  String get pleasePickImage;

  /// No description provided for @mainImage.
  ///
  /// In en, this message translates to:
  /// **'Main Image'**
  String get mainImage;

  /// No description provided for @addImages.
  ///
  /// In en, this message translates to:
  /// **'Add Images'**
  String get addImages;

  /// No description provided for @allDishesAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'All dishes added successfully'**
  String get allDishesAddedSuccessfully;

  /// No description provided for @noCategoriesAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No categories added yet.'**
  String get noCategoriesAddedYet;

  /// No description provided for @tapAddCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Tap \' + Add Category Title\' to get started.'**
  String get tapAddCategoryTitle;

  /// No description provided for @categoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Category Title'**
  String get categoryTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @editDish.
  ///
  /// In en, this message translates to:
  /// **'Edit Dish'**
  String get editDish;

  /// No description provided for @addDish.
  ///
  /// In en, this message translates to:
  /// **'Add Dish'**
  String get addDish;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @slots.
  ///
  /// In en, this message translates to:
  /// **'slots'**
  String get slots;

  /// No description provided for @slotManagement.
  ///
  /// In en, this message translates to:
  /// **'Slot Management'**
  String get slotManagement;

  /// No description provided for @slotDuration.
  ///
  /// In en, this message translates to:
  /// **'Slot Duration'**
  String get slotDuration;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @selectDuration.
  ///
  /// In en, this message translates to:
  /// **'Select duration'**
  String get selectDuration;

  /// No description provided for @pleaseSelectDuration.
  ///
  /// In en, this message translates to:
  /// **'Please select duration'**
  String get pleaseSelectDuration;

  /// No description provided for @markUnavailableSlots.
  ///
  /// In en, this message translates to:
  /// **'Mark Your Unavailable Time Slots'**
  String get markUnavailableSlots;

  /// No description provided for @unavailableSlotsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the time slots when you\'re not available each day. You can choose individual slots or use Select All to mark the entire day as unavailable. Tap Save Changes to apply your preferences.'**
  String get unavailableSlotsDescription;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @selectDates.
  ///
  /// In en, this message translates to:
  /// **'Select Dates'**
  String get selectDates;

  /// No description provided for @selectTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Select Time Slots'**
  String get selectTimeSlots;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @closingTimeCannotBeMidnight.
  ///
  /// In en, this message translates to:
  /// **'Closing time cannot be 12:00 AM'**
  String get closingTimeCannotBeMidnight;

  /// No description provided for @closingTimeCannotBeAfter1159.
  ///
  /// In en, this message translates to:
  /// **'Closing time cannot be later than 11:59 PM'**
  String get closingTimeCannotBeAfter1159;

  /// No description provided for @closingTimeMustBeAfterOpening.
  ///
  /// In en, this message translates to:
  /// **'Closing time must be after opening time'**
  String get closingTimeMustBeAfterOpening;

  /// No description provided for @setWeeklyAvailability.
  ///
  /// In en, this message translates to:
  /// **'Set weekly Availability'**
  String get setWeeklyAvailability;

  /// No description provided for @weeklyAvailabilityDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the days and times your business operates. This schedule will repeat weekly for the entire year. To mark specific days off, use the unavailability tab.'**
  String get weeklyAvailabilityDescription;

  /// No description provided for @selectForAllDay.
  ///
  /// In en, this message translates to:
  /// **'Select for All day'**
  String get selectForAllDay;

  /// No description provided for @dayOnOff.
  ///
  /// In en, this message translates to:
  /// **'Day On/Off'**
  String get dayOnOff;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @pleaseSelectAtLeastOneDay.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one day'**
  String get pleaseSelectAtLeastOneDay;

  /// No description provided for @setUpTime.
  ///
  /// In en, this message translates to:
  /// **'Set Up Time'**
  String get setUpTime;

  /// No description provided for @noTimeSlotsFound.
  ///
  /// In en, this message translates to:
  /// **'No Time Slots found'**
  String get noTimeSlotsFound;

  /// No description provided for @addCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Category Title'**
  String get addCategoryTitle;

  /// No description provided for @briefDescriptionDish.
  ///
  /// In en, this message translates to:
  /// **'Brief description of the dish...'**
  String get briefDescriptionDish;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @reservationCanceledMessage.
  ///
  /// In en, this message translates to:
  /// **'Your reservation has been canceled due to a delay in arrival or an unforeseen circumstance. We apologize for the inconvenience and appreciate your understanding.'**
  String get reservationCanceledMessage;

  /// No description provided for @bookingId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingId;

  /// No description provided for @numberOfPersons.
  ///
  /// In en, this message translates to:
  /// **'No. of Persons'**
  String get numberOfPersons;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @person.
  ///
  /// In en, this message translates to:
  /// **'person'**
  String get person;

  /// No description provided for @allergyNote.
  ///
  /// In en, this message translates to:
  /// **'Allergic to peanuts. Request outdoor seating.'**
  String get allergyNote;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @cancelBookingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you would like to cancel your booking?'**
  String get cancelBookingConfirmation;

  /// No description provided for @shareReason.
  ///
  /// In en, this message translates to:
  /// **'Share your reason here...'**
  String get shareReason;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @numberOfPersons2.
  ///
  /// In en, this message translates to:
  /// **'Number of Persons'**
  String get numberOfPersons2;

  /// No description provided for @nothingToShow.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show'**
  String get nothingToShow;

  /// No description provided for @participantsList.
  ///
  /// In en, this message translates to:
  /// **'Participants List'**
  String get participantsList;

  /// No description provided for @newGroup.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get newGroup;

  /// No description provided for @suggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get suggested;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// No description provided for @groupChat.
  ///
  /// In en, this message translates to:
  /// **'Group Chat'**
  String get groupChat;

  /// No description provided for @chatWithUpTo50Friends.
  ///
  /// In en, this message translates to:
  /// **'Chat with up to 50 friends'**
  String get chatWithUpTo50Friends;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @outOf.
  ///
  /// In en, this message translates to:
  /// **'out of'**
  String get outOf;

  /// No description provided for @interested.
  ///
  /// In en, this message translates to:
  /// **'Interested'**
  String get interested;

  /// No description provided for @writeAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Write something about yourself...'**
  String get writeAboutYourself;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @mapLocation.
  ///
  /// In en, this message translates to:
  /// **'Map & Location'**
  String get mapLocation;

  /// No description provided for @editTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Edit Time Slot'**
  String get editTimeSlot;

  /// No description provided for @suggestTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Suggest Time Slot'**
  String get suggestTimeSlot;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get pleaseSelectDate;

  /// No description provided for @pleaseSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a time'**
  String get pleaseSelectTime;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @suggestATimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Suggest a Time Slot'**
  String get suggestATimeSlot;

  /// No description provided for @selectFriends.
  ///
  /// In en, this message translates to:
  /// **'Select Friends'**
  String get selectFriends;

  /// No description provided for @sendInvite.
  ///
  /// In en, this message translates to:
  /// **'Send Invite'**
  String get sendInvite;

  /// No description provided for @interestDetails.
  ///
  /// In en, this message translates to:
  /// **'Interest Details'**
  String get interestDetails;

  /// No description provided for @editTime.
  ///
  /// In en, this message translates to:
  /// **'Edit Time'**
  String get editTime;

  /// No description provided for @reserveNow.
  ///
  /// In en, this message translates to:
  /// **'Reserve Now'**
  String get reserveNow;

  /// No description provided for @invitees.
  ///
  /// In en, this message translates to:
  /// **'Invitees'**
  String get invitees;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @declined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get declined;

  /// No description provided for @suggestedDateTime.
  ///
  /// In en, this message translates to:
  /// **'Suggested Date & Time'**
  String get suggestedDateTime;

  /// No description provided for @suggestedTime.
  ///
  /// In en, this message translates to:
  /// **'Suggested Time'**
  String get suggestedTime;

  /// No description provided for @suggestNewTime.
  ///
  /// In en, this message translates to:
  /// **'Suggest New Time'**
  String get suggestNewTime;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @reasonOfDecline.
  ///
  /// In en, this message translates to:
  /// **'Reason of decline'**
  String get reasonOfDecline;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get daysAgo;

  /// No description provided for @createChoice.
  ///
  /// In en, this message translates to:
  /// **'Create Choice'**
  String get createChoice;

  /// No description provided for @overallWellnessRating.
  ///
  /// In en, this message translates to:
  /// **'Overall Wellness Rating'**
  String get overallWellnessRating;

  /// No description provided for @overallLeisureRating.
  ///
  /// In en, this message translates to:
  /// **'Overall Leisure Rating'**
  String get overallLeisureRating;

  /// No description provided for @choiceCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Choice created successfully!'**
  String get choiceCreatedSuccessfully;

  /// No description provided for @anyoneCanSeeFeed.
  ///
  /// In en, this message translates to:
  /// **'Anyone can see the feed'**
  String get anyoneCanSeeFeed;

  /// No description provided for @friendsOnly.
  ///
  /// In en, this message translates to:
  /// **'Friends Only'**
  String get friendsOnly;

  /// No description provided for @yourFriendsOnChoice.
  ///
  /// In en, this message translates to:
  /// **'Your friends on Choice'**
  String get yourFriendsOnChoice;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @onlyMe.
  ///
  /// In en, this message translates to:
  /// **'Only Me'**
  String get onlyMe;

  /// No description provided for @privateLower.
  ///
  /// In en, this message translates to:
  /// **'private'**
  String get privateLower;

  /// No description provided for @friendsOnlyLower.
  ///
  /// In en, this message translates to:
  /// **'friends_only'**
  String get friendsOnlyLower;

  /// No description provided for @publicLower.
  ///
  /// In en, this message translates to:
  /// **'public'**
  String get publicLower;

  /// No description provided for @shareYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience'**
  String get shareYourExperience;

  /// No description provided for @tapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get tapToSelect;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @failedToFetchPlaces.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch places'**
  String get failedToFetchPlaces;

  /// No description provided for @searchForRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Search for a restaurant...'**
  String get searchForRestaurant;

  /// No description provided for @searchForWellness.
  ///
  /// In en, this message translates to:
  /// **'Search for a Wellness...'**
  String get searchForWellness;

  /// No description provided for @searchForLeisure.
  ///
  /// In en, this message translates to:
  /// **'Search for a Leisure...'**
  String get searchForLeisure;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @changeType.
  ///
  /// In en, this message translates to:
  /// **'Change Type'**
  String get changeType;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @whatWouldYouLikeToShare.
  ///
  /// In en, this message translates to:
  /// **'What would you like to share?'**
  String get whatWouldYouLikeToShare;

  /// No description provided for @imageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed'**
  String get imageUploadFailed;

  /// No description provided for @phoneNumberMissing.
  ///
  /// In en, this message translates to:
  /// **'Phone number is Missing'**
  String get phoneNumberMissing;

  /// No description provided for @usernameMissing.
  ///
  /// In en, this message translates to:
  /// **'Username is Missing'**
  String get usernameMissing;

  /// No description provided for @nameMissing.
  ///
  /// In en, this message translates to:
  /// **'Name is Missing'**
  String get nameMissing;

  /// No description provided for @failedToRegisterAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to register account'**
  String get failedToRegisterAccount;

  /// No description provided for @confirmPasswordMissing.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password is missing'**
  String get confirmPasswordMissing;

  /// No description provided for @newAndConfirmPasswordNotMatched.
  ///
  /// In en, this message translates to:
  /// **'new and confirm password not matched'**
  String get newAndConfirmPasswordNotMatched;

  /// No description provided for @completeYourRegistration.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Registration'**
  String get completeYourRegistration;

  /// No description provided for @secureYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Secure your account by adding your email and password'**
  String get secureYourAccount;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get selectType;

  /// No description provided for @searchAPlace.
  ///
  /// In en, this message translates to:
  /// **'Search a place'**
  String get searchAPlace;

  /// No description provided for @documentSelectedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Document selected successfully'**
  String get documentSelectedSuccessfully;

  /// No description provided for @failedToUploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload document'**
  String get failedToUploadDocument;

  /// No description provided for @noPlacesFound.
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get noPlacesFound;

  /// No description provided for @noFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get noFileSelected;

  /// No description provided for @documentSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Document saved successfully'**
  String get documentSavedSuccessfully;

  /// No description provided for @failedToSaveDocument.
  ///
  /// In en, this message translates to:
  /// **'Failed to save document'**
  String get failedToSaveDocument;

  /// No description provided for @unexpectedErrorWhileUploading.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred while uploading'**
  String get unexpectedErrorWhileUploading;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @selectDocument.
  ///
  /// In en, this message translates to:
  /// **'Select Document'**
  String get selectDocument;

  /// No description provided for @pleaseEnterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get pleaseEnterCurrentPassword;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get pleaseEnterNewPassword;

  /// No description provided for @passwordMustInclude.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters and include uppercase, lowercase, number, and special character'**
  String get passwordMustInclude;

  /// No description provided for @confirmPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password is empty'**
  String get confirmPasswordEmpty;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'New Password and Confirm Password do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @newPasswordSameAsCurrent.
  ///
  /// In en, this message translates to:
  /// **'New password cannot be the same as the current password'**
  String get newPasswordSameAsCurrent;

  /// No description provided for @pleaseSelectDocumentFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a document first.'**
  String get pleaseSelectDocumentFirst;

  /// No description provided for @pleaseUploadDocumentFirst.
  ///
  /// In en, this message translates to:
  /// **'Please upload the document first.'**
  String get pleaseUploadDocumentFirst;

  /// No description provided for @documentUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully'**
  String get documentUploadedSuccessfully;

  /// No description provided for @failedToGetUploadUrl.
  ///
  /// In en, this message translates to:
  /// **'Failed to get upload URL'**
  String get failedToGetUploadUrl;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
