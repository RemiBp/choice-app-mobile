// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get createAnAccount => 'Create an Account';

  @override
  String get chooseAccountType =>
      'Choose the type of account you want to create:';

  @override
  String get userAccountTitle => 'User Account';

  @override
  String get provideAReason => 'Please provide a reason.';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get userAccountDescription =>
      'To discover restaurants and activities, and follow your favorite providers.';

  @override
  String get restaurantProviderAccountTitle => 'Restaurant Provider Account';

  @override
  String get restaurantProviderAccountDescription =>
      'To manage your restaurant and promote your offerings.';

  @override
  String get leisureProviderAccountTitle => 'Leisure Provider Account';

  @override
  String get leisureProviderAccountDescription =>
      'To manage your leisure activities and attract new clients.';

  @override
  String get wellnessProviderAccountTitle => 'Wellness Provider Account';

  @override
  String get wellnessProviderAccountDescription =>
      'To manage your well-being activity and attract new clients.';

  @override
  String get signupTitle => 'Signup';

  @override
  String get signupSubtitle => 'Enter your email and password to signup';

  @override
  String get businessName => 'Business Name';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNamePlaceholder => 'Full Name';

  @override
  String get userName => 'Username';

  @override
  String get userNamePlaceholder => 'Username';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailPlaceholder => 'Email address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signupAgreement => 'By signing up, you agree to our';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get andLabel => 'and';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get signupWithApple => 'Apple';

  @override
  String get signupWithGoogle => 'Google';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginButton => 'Login';

  @override
  String get otpVerification => 'OTP Verification';

  @override
  String verificationPrompt(Object email) {
    return 'Enter the 6 -digit verification code sent to $email';
  }

  @override
  String get didNotReceiveCode => 'Didn’t receive code?';

  @override
  String get resendCode => 'Resend';

  @override
  String get verifyButton => 'Verify';

  @override
  String get uploadDocumentsTitle => 'Upload Documents';

  @override
  String get uploadDocumentsSubtitle =>
      'Please upload your document to proceed with verification.';

  @override
  String get businessRegistrationDocument => 'Business Registration Document';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get selectDate => 'Select Date';

  @override
  String get chooseFile => 'Choose a file';

  @override
  String get maxFileSizeNote => 'Max file size (PDF): 2MB';

  @override
  String get utilityBillOrInvoice => 'Utility Bill or Invoice';

  @override
  String get submitForReview => 'Submit for Review';

  @override
  String get loginInstruction => 'Enter your email and password to log in ';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get noAccountPrompt => 'Don’t have an account?';

  @override
  String get forgotPasswordInstruction =>
      'Please enter your email to receive verification code.';

  @override
  String get sendOtpButton => 'Send OTP';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordNote =>
      'Your new password must be different from previous used passwords.';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get profileSetup => 'Profile Setup';

  @override
  String get address => 'Address';

  @override
  String get briefDescription => 'Brief Description';

  @override
  String get writeSomethingBrief => 'Write something brief...';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'camera';

  @override
  String get chooseYourPhoto => 'Choose your photo';

  @override
  String get links => 'Links';

  @override
  String get next => 'Next';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get choosePreferredLanguage =>
      'Choose your preferred language to continue';

  @override
  String get continueText => 'Continue';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get setting => 'Setting';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get documents => 'Documents';

  @override
  String get businessHours => 'Business Hours';

  @override
  String get manageSlots => 'Manage Slots';

  @override
  String get menu => 'Menu';

  @override
  String get unavailability => 'Unavailability';

  @override
  String get modify => 'Modify';

  @override
  String get checkIn => 'Check-In';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get inProgress => 'In-Progress';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get menuCoverage => 'Menu Coverage';

  @override
  String get noUpcomingBooking => 'No upcoming booking';

  @override
  String get noUpcomingBookingMessage => 'You have no upcoming booking';

  @override
  String get bookingInformation => 'Booking Information';

  @override
  String get internalNotes => 'Internal Notes';

  @override
  String get customerInformation => 'Customer Information';

  @override
  String get customerName => 'Customer Name:';

  @override
  String get emailLabel1 => 'Email:';

  @override
  String get bookings => 'Bookings';

  @override
  String get selectProfileImage => 'Select profile image';

  @override
  String get failedToGetImageUrl => 'Failed to get image url';

  @override
  String get phoneLabel => 'Phone:';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get language => 'Language';

  @override
  String get validFacebookLink => 'Please enter a valid Facebook link';

  @override
  String get validInstagramLink => 'Please enter a valid Instagram link';

  @override
  String get validWebsiteLink => 'Please enter a valid website link';

  @override
  String get validTwitterLink => 'Please enter a valid Twitter/X link';

  @override
  String get logout => 'Logout';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get cuisine => 'Cuisine';

  @override
  String get services => 'Services';

  @override
  String get update => 'Update';

  @override
  String get reclaimAccount => 'Reclaim Your Account';

  @override
  String get retrieveAccess => 'Retrieve access to your existing profile';

  @override
  String get chooseOption => 'Choose your option';

  @override
  String get categoryRestaurant => 'Restaurant';

  @override
  String get categoryLeisure => 'Leisure';

  @override
  String get categoryWellness => 'Wellness';

  @override
  String get searchPlaceholder => 'Search by name...';

  @override
  String get claimAccount => 'Claim Account';

  @override
  String get orText => 'Or';

  @override
  String get uploadDocuments => 'Upload Documents';

  @override
  String get uploadDocumentsDescription =>
      'Please upload your document to proceed with verification.';

  @override
  String get backButton => 'Back';

  @override
  String get thankYou => 'Thank you!';

  @override
  String get underReviewMessage =>
      'Your profile are now under review. We will get back to you in two business day.';

  @override
  String get documentBusinessRegistration => 'Buisness  Registration Documents';

  @override
  String get documentLeaseContract => 'Commercial Lease Contract';

  @override
  String get documentUtilityBill => 'Utility Bill';

  @override
  String get documentSupplierInvoice => 'Supplier Invoice';

  @override
  String get documentInsuranceCertificate =>
      'Professional Insurance Certificate';

  @override
  String get documentTax => 'Tax Document';

  @override
  String get documentAuthorizationLetter => 'Signed Authorization Letter';

  @override
  String get create => 'Create';

  @override
  String get createPost => 'Create Post';

  @override
  String get photos => 'Photos';

  @override
  String get fileSupport => 'File supported:';

  @override
  String get imageLimit => 'Up to 5 images';

  @override
  String get exampleTitle => 'e.g Sunday Brunch at The Maple House';

  @override
  String get title => 'Title';

  @override
  String get passwordManager => 'Password Manager';

  @override
  String get currentPassword => 'Current password';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get eventTypeLabel => 'Event Type';

  @override
  String get eventTypePlaceholder => 'Select event type';

  @override
  String get passwordMissing => 'Password is missing';

  @override
  String get passwordInvalidCharacters =>
      'Password contains invalid characters. Only letters, numbers, and !@#\\\$%& are allowed';

  @override
  String get emailMissing => 'Email is missing';

  @override
  String get invalidEmail => 'Invalid Email';

  @override
  String get invalidPassword => 'Invalid Password';

  @override
  String get passwordMustBeAtLeast8Chars =>
      'Password must be at least 8 characters long';

  @override
  String get passwordCannotContainSpaces => 'Password cannot contain spaces';

  @override
  String get passwordMustContainUppercase =>
      'Password must contain at least one uppercase letter (A-Z)';

  @override
  String get passwordMustContainLowercase =>
      'Password must contain at least one lowercase letter (a-z)';

  @override
  String get passwordMustContainNumber =>
      'Password must contain at least one number (0-9)';

  @override
  String get passwordMustContainSpecialChar =>
      'Password must contain at least one special character (!@#\\\$%&)';

  @override
  String get interest => 'Interest';

  @override
  String get choices => 'Choices';

  @override
  String get seeMore => 'See more';

  @override
  String get eventsNearYou => 'Events near you';

  @override
  String get surpriseMe => 'Surprise me';

  @override
  String get seeFullMenu => 'See Full Menu';

  @override
  String get organizer => 'Organizer';

  @override
  String get moreEventsLikeThis => 'More Events Like This';

  @override
  String get showAll => 'Show All';

  @override
  String get ticketPrice => 'Ticket price';

  @override
  String get perPerson => '/per person';

  @override
  String get bookNow => 'Book Now';

  @override
  String get browseByCategory => 'Browse by Category';

  @override
  String get welcome => 'Welcome';

  @override
  String get sound => 'Sound';

  @override
  String get length => 'Length';

  @override
  String get ratingsByTheme => 'Ratings by Theme';

  @override
  String get interestSplitByPriceType => 'Interest Split by Price Type';

  @override
  String get weeklyEvolution => 'Weekly Evolution';

  @override
  String get criteriaRatings => 'Criteria Ratings';

  @override
  String get cleanliness => 'Cleanliness';

  @override
  String get staffExpertise => 'Staff Expertise';

  @override
  String get ambiance => 'Ambiance';

  @override
  String get numberOfInterests => 'Number of interests';

  @override
  String get expiryDate1Placeholder => 'Please Select Expiry Date 1';

  @override
  String get businessRegistrationPlaceholder =>
      'Please Select Business Registration Document';

  @override
  String get expiryDate2Placeholder => 'Please Select Expiry Date 2';

  @override
  String get utilityBillPlaceholder => 'Please Select Utility Bill or Invoice';

  @override
  String get businessNameMissing => 'Business Name is Missing';

  @override
  String get businessNameInvalidCharacters =>
      'Business Name contains invalid characters (no emojis allowed)';

  @override
  String get noInternet => 'No internet';

  @override
  String get enterOtpPlaceholder => 'Please enter the otp';

  @override
  String get otpVerifiedSuccess => 'Otp Verified Successful';

  @override
  String get genericError => 'Something bad happened,Try again.';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get success => 'Success';

  @override
  String get registrationSuccessful => 'Registration Successful';

  @override
  String get eventDescriptionPlaceholder => 'Describe your event...';

  @override
  String get exampleTags => 'e.g: #cozy, #outdoor_seating';

  @override
  String get tags => 'Tags';

  @override
  String get addLocation => 'Add location';

  @override
  String get location => 'Location';

  @override
  String get cancel => 'Cancel';

  @override
  String get publish => 'Publish';

  @override
  String get errorSelectImage => 'Please Select at least one image';

  @override
  String get errorEnterTitle => 'Please Enter title';

  @override
  String get errorEnterDescription => 'Please Enter description';

  @override
  String get errorEnterTags => 'Please Enter relative tags';

  @override
  String get errorEnterAddress => 'Please Enter address';

  @override
  String get searchUserPlaceholder => 'Search by username or name...';

  @override
  String get description => 'Description';

  @override
  String get deleteEventConfirmation => 'Delete Event?';

  @override
  String get deleteEventMessage =>
      'This action will permanently remove the event.';

  @override
  String get events => 'Events';

  @override
  String get sampleEventName => 'Wine & Dine Evening';

  @override
  String get statusActive => 'Active';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get createEvent => 'Create Event';

  @override
  String get noEvents => 'No Events Yet';

  @override
  String get noEventsMessage =>
      'You haven’t created any events yet. Start by adding your first one — it only takes a minute!';

  @override
  String get eventDetails => 'Event Details';

  @override
  String get exampleDish => 'E.g: Brochette boeuf...';

  @override
  String get eventName => 'Event Name';

  @override
  String get eventGallery => 'Event Gallery';

  @override
  String get uploadLimit => 'Upload up to 5 images';

  @override
  String get uploadEventImages => 'Upload Event Images*';

  @override
  String get restaurantOrVenue => 'Restaurant name or venue';

  @override
  String get venueName => 'Venue Name';

  @override
  String get venueAddress => 'Address of venue';

  @override
  String get capacityPricing => 'Capacity & Pricing';

  @override
  String get maxPersons => 'Maximum number of persons';

  @override
  String get maxCapacity => 'Maximum Capacity';

  @override
  String get pricePerPerson => 'Price per person';

  @override
  String get schedule => 'Schedule';

  @override
  String get eventDate => 'Event Date';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get saveAsDraft => 'Save as Draft';

  @override
  String get tapToUpload => 'Tap to upload image';

  @override
  String get event => 'Event';

  @override
  String get participants => 'Participants';

  @override
  String get aboutEvent => 'About Event';

  @override
  String get readMore => 'Read More';

  @override
  String get seeLess => 'See Less';

  @override
  String get socialLinks => 'Social Links';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get yourExperience => 'Your Experience';

  @override
  String get overallRestaurantRating => 'Overall Restaurant Rating';

  @override
  String get service => 'Service';

  @override
  String get price => 'Price';

  @override
  String get portions => 'Portions';

  @override
  String get dishesAndMenusConsumed => 'Dishes and Menus Consumed';

  @override
  String get rateTheSelectedDishes => 'Rate The Selected Dishes';

  @override
  String get yourRatingForThisDish => 'Your rating for this dish:';

  @override
  String get fileSupported => 'File supported: PNG, JPG';

  @override
  String get chooseAFile => 'Choose a file';

  @override
  String get upTo5Images => 'Up to 5 images';

  @override
  String get remove => 'Remove';

  @override
  String get whichRestaurantDidYouVisit => 'Which restaurant did you visit?';

  @override
  String get whichWellnessDidYouVisit => 'Which wellness did you visit?';

  @override
  String get whichLeisureEventDidYouAttend =>
      'Which leisure event did you attend?';

  @override
  String get filters => 'Filters';

  @override
  String get distance => 'Distance';

  @override
  String get place => 'Place';

  @override
  String get dishName => 'Dish Name';

  @override
  String get dishRating => 'Dish Rating';

  @override
  String get resetAll => 'Reset All';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get any => 'Any';

  @override
  String get unlockMoreWithPlus => 'Unlock more with Plus';

  @override
  String get getMoreCapableModels => 'Get our more capable models and features';

  @override
  String get subscription => 'Subscription';

  @override
  String get startByAddingPaymentMethod => 'Start by adding a payment method';

  @override
  String get addPaymentMethodInfo =>
      'Add a payment method to your Google Account to complete your purchase. Your payment information is only visible to Google.';

  @override
  String get addCreditOrDebitCard => 'Add credit or debit card';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get free => 'Free';

  @override
  String get limitedAICopilotQueries => 'Limited AI Copilot Queries';

  @override
  String get pro => 'Pro';

  @override
  String get blockedList => 'Blocked List';

  @override
  String get bookmarked => 'Bookmarked';

  @override
  String get createNewProfile => 'Create New Profile';

  @override
  String get switchBetweenProfiles => 'Switch between profiles with one login';

  @override
  String get chat => 'Chat';

  @override
  String get searchByName => 'Search by name...';

  @override
  String get following => 'Following';

  @override
  String get report => 'Report';

  @override
  String get block => 'Block';

  @override
  String get switchAccount => 'Switch Account';

  @override
  String get blockUser => 'Block User';

  @override
  String get blockUserDescription =>
      'Blocking this user will prevent them from interacting with you. You can unblock them anytime from your Account Settings.';

  @override
  String get public => 'Public';

  @override
  String get whyReport => 'Why do you want to report?';

  @override
  String get spamOrFakeAccount => 'Spam or Fake Account';

  @override
  String get inappropriateContent => 'Inappropriate Content';

  @override
  String get harassmentOrBullying => 'Harassment or Bullying';

  @override
  String get hateSpeech => 'Hate Speech';

  @override
  String get scamOrFraud => 'Scam or Fraud';

  @override
  String get submit => 'Submit';

  @override
  String get unfollow => 'Unfollow';

  @override
  String get follow => 'Follow';

  @override
  String get unlimitedAICopilotQueries => 'Unlimited AI Copilot Queries';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get progress => 'Progress';

  @override
  String get reportUser => 'Report User';

  @override
  String get follower => 'Follower';

  @override
  String get message => 'Message';

  @override
  String get posts => 'Posts';

  @override
  String get about => 'About';

  @override
  String get aestheticCareAndWellBeing => 'Aesthetic Care & Well-Being';

  @override
  String get hairCareAndHairServices => 'Hair Care & Hair Services';

  @override
  String get nailCareAndBodyModifications => 'Nail Care & Body Modifications';

  @override
  String get seeFullGallery => 'See Full Gallery';

  @override
  String get unblock => 'Unblock';

  @override
  String get unblockUser => 'Unblock User';

  @override
  String get unblockConfirmation =>
      'Are you sure you want to unblock this user?';

  @override
  String get badgeAndXP => 'Badge & XP';

  @override
  String get firstBookingMaster => 'First Booking Master';

  @override
  String get firstBookingMasterDesc =>
      'Complete your very first booking of any kind';

  @override
  String get choiceCreator => 'Choice Creator';

  @override
  String get choiceCreatorDesc =>
      'Create your first choice and start exploring options';

  @override
  String get reviewContributor => 'Review Contributor';

  @override
  String get reviewContributorDesc =>
      'Share your experience by posting a new review';

  @override
  String get achievementBadges => 'Achievement Badges';

  @override
  String get viewMore => 'View More';

  @override
  String get fillOneFieldToUpdateProfile =>
      'Please fill at least one field to update your profile';

  @override
  String get validBusinessName => 'Please enter a valid business name';

  @override
  String get validAddress =>
      'Please enter a valid address (at least 5 characters)';

  @override
  String get validPhoneNumber => 'Please enter a valid phone number';

  @override
  String get validDescription =>
      'Please enter a meaningful description (at least 10 characters)';

  @override
  String get validWebsiteUrl => 'Please enter a valid website URL';

  @override
  String get validInstagramUrl => 'Please enter a valid Instagram URL';

  @override
  String get validTwitterUrl => 'Please enter a valid Twitter URL';

  @override
  String get validFacebookUrl => 'Please enter a valid Facebook URL';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get operationalHoursSaved => 'Operational hours saved successfully';

  @override
  String get failedToSaveOperationalHours => 'Failed to save operational hours';

  @override
  String get failedToFetchCuisineTypes => 'Failed to fetch cuisine types';

  @override
  String get cuisineTypeSetSuccessfully => 'Cuisine type set successfully';

  @override
  String get failedToSetCuisineType => 'Failed to set cuisine type';

  @override
  String get galleryImagesSaved => 'Gallery images saved successfully';

  @override
  String get failedToSaveGalleryImages => 'Failed to save gallery images';

  @override
  String get failedToAddMenuCategory => 'Failed to add menu category';

  @override
  String get failedToFetchMenuCategories => 'Failed to fetch menu categories';

  @override
  String get slotDurationSetSuccessfully => 'Slot duration set successfully';

  @override
  String get failedToSetSlotDuration => 'Failed to set slot duration';

  @override
  String get failedToFetchProducerSlots => 'Failed to fetch producer slots';

  @override
  String get failedToFetchAllServiceTypes =>
      'Failed to fetch all service types';

  @override
  String get serviceTypeSetSuccessfully => 'Service type set successfully';

  @override
  String get failedToSetServiceType => 'Failed to set service type';

  @override
  String get failedToFetchProducerProfile => 'Failed to fetch producer profile';

  @override
  String get failedToAddMenuDish => 'Failed to add menu dish';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotificationsYet => 'You don’t have any notifications yet';

  @override
  String get notificationsDescription =>
      'You will receive notifications regarding reservations, reviews etc.';

  @override
  String get shareExperienceReview =>
      'Share your experience by leaving a review at';

  @override
  String get enterEventName => 'Please enter the event name.';

  @override
  String get enterEventDescription => 'Please enter the event description.';

  @override
  String get enterVenue => 'Please enter the venue.';

  @override
  String get enterCapacity => 'Please enter the capacity.';

  @override
  String get enterValidCapacityNumber =>
      'Please enter a valid number for capacity.';

  @override
  String get enterPrice => 'Please enter the price.';

  @override
  String get enterValidPrice => 'Please enter a valid price.';

  @override
  String get deleteEvent => 'Delete Event?';

  @override
  String get deleteEventDescription =>
      'This action will permanently remove the event.';

  @override
  String get category => 'Category';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get week1 => 'Week 1';

  @override
  String get week2 => 'Week 2';

  @override
  String get week3 => 'Week 3';

  @override
  String get week4 => 'Week 4';

  @override
  String get dishRatings => 'Dish Ratings';

  @override
  String get january => 'January';

  @override
  String get otpResentSuccess => 'OTP resent successfully';

  @override
  String get selectTime => 'Select Time';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get monthlyEvolution => 'Monthly Evolution';

  @override
  String get selectMonth => 'Select Month';

  @override
  String get pleaseSelectMonth => 'Please select a month';

  @override
  String get profileViews => 'Profile Views';

  @override
  String get lastWeek => 'Last Week';

  @override
  String get chosen => 'Chosen';

  @override
  String get timesThisWeek => 'times this week';

  @override
  String get dishDropAlerts => 'Dish Drop Alerts';

  @override
  String get day1 => 'Day 1';

  @override
  String get day2 => 'Day 2';

  @override
  String get day3 => 'Day 3';

  @override
  String get day4 => 'Day 4';

  @override
  String get day5 => 'Day 5';

  @override
  String get day6 => 'Day 6';

  @override
  String get fourDaysAgo => '4 days ago';

  @override
  String get rating => 'Rating';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get bookmark => 'Bookmark';

  @override
  String get choicesMade => 'Choices Made';

  @override
  String get conversionRate => 'Conversion Rate';

  @override
  String get postConversionRate => 'Post Conversion Rate';

  @override
  String get favoriteChoiceOfMonth => 'Favorite choice of the month';

  @override
  String get thisWeek => 'This Week';

  @override
  String get mostChosenDish => 'Most Chosen Dish';

  @override
  String get waitingTimeComplaints => 'Waiting Time Complaints';

  @override
  String get choicesFlaggedLongWait => 'Choices flagged long wait times';

  @override
  String get topPerformingEventType => 'Top Performing Event Type';

  @override
  String get twoXMoreThanLiveMusic => '2x more than live music';

  @override
  String get label => 'label';

  @override
  String get value => 'value';

  @override
  String get ratingsByExperienceTheme => 'Ratings by Experience Theme';

  @override
  String get notRated => 'Not Rated';

  @override
  String get rated => 'Rated';

  @override
  String get userOriginMap => 'User Origin Map';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get weeklyRatings => 'Weekly Ratings';

  @override
  String get home => 'Home';

  @override
  String get map => 'Map';

  @override
  String get explore => 'Explore';

  @override
  String get profile => 'Profile';

  @override
  String get allDay => 'All day';

  @override
  String get everyday => 'Everyday';

  @override
  String get morning => 'Morning (6am–12pm)';

  @override
  String get afternoon => 'Afternoon (12pm–6pm)';

  @override
  String get evening => 'Evening (6pm–12am)';

  @override
  String get night => 'Night (12am–6am)';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get heatmap => 'Heatmap';

  @override
  String get createOffer => 'Create Offer';

  @override
  String get offerTemplate => 'Offer Template';

  @override
  String get noTemplateYet => 'No Template Yet';

  @override
  String get templateInfo =>
      'Once a template has been published by you, it will be listed here.';

  @override
  String get targetedNotification => 'Targeted Notification';

  @override
  String get step1WriteOffer => 'Step 1: Write your offer';

  @override
  String get exampleOffer => 'e.g: Come now and enjoy 15% off';

  @override
  String get reductionPercent => 'Reduction %';

  @override
  String get validateMinutes => 'Validate (minutes)';

  @override
  String get numberOfUsers => 'Number of Users';

  @override
  String get step2ChooseTarget => 'Step 2: Choose your target';

  @override
  String get allNearbyUsers => 'All nearby users';

  @override
  String get allActiveUsers => 'All active users (2km radius)';

  @override
  String get estimated => 'Estimated:';

  @override
  String get onlineUsers => 'Online Users';

  @override
  String get notificationAppearance => 'Appearance of the Notification';

  @override
  String get saveAsTemplate => 'Save as Template';

  @override
  String get sendNow => 'Send Now';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get cuisineType => 'Cuisine Type';

  @override
  String get selectCuisineType => 'Select cuisine type';

  @override
  String get italian => 'Italian';

  @override
  String get chinese => 'Chinese';

  @override
  String get mexican => 'Mexican';

  @override
  String get indian => 'Indian';

  @override
  String get massageRelaxation => 'Massage & Relaxation';

  @override
  String get skinTreatmentsFacials => 'Skin Treatments & Facials';

  @override
  String get makeupBeautyServices => 'Makeup & Beauty Services';

  @override
  String get waxingHairRemoval => 'Waxing & Hair Removal';

  @override
  String get spaWellnessPackages => 'Spa & Wellness Packages';

  @override
  String get laserTreatments => 'Laser Treatments';

  @override
  String get tattooPiercingServices => 'Tattoo & Piercing Services';

  @override
  String get eyebrowEyelashTreatments => 'Eyebrow & Eyelash Treatments';

  @override
  String get bridalEventPackages => 'Bridal & Event Packages';

  @override
  String get dermatologyConsultation => 'Dermatology & Skin Care Consultation';

  @override
  String get footHandCare => 'Foot & Hand Care';

  @override
  String get hairTransplantScalpServices => 'Hair Transplant & Scalp Services';

  @override
  String get servicesType => 'Services Type';

  @override
  String get selectServicesType => 'Select services type';

  @override
  String get selectAtLeastOneServiceType =>
      'Please select at least one service type.';

  @override
  String get pleasePickImage => 'Please pick an image';

  @override
  String get mainImage => 'Main Image';

  @override
  String get addImages => 'Add Images';

  @override
  String get allDishesAddedSuccessfully => 'All dishes added successfully';

  @override
  String get noCategoriesAddedYet => 'No categories added yet.';

  @override
  String get tapAddCategoryTitle =>
      'Tap \' + Add Category Title\' to get started.';

  @override
  String get categoryTitle => 'Category Title';

  @override
  String get save => 'Save';

  @override
  String get editDish => 'Edit Dish';

  @override
  String get addDish => 'Add Dish';

  @override
  String get day => 'day';

  @override
  String get slots => 'slots';

  @override
  String get slotManagement => 'Slot Management';

  @override
  String get slotDuration => 'Slot Duration';

  @override
  String get hour => 'hour';

  @override
  String get selectDuration => 'Select duration';

  @override
  String get pleaseSelectDuration => 'Please select duration';

  @override
  String get markUnavailableSlots => 'Mark Your Unavailable Time Slots';

  @override
  String get unavailableSlotsDescription =>
      'Select the time slots when you\'re not available each day. You can choose individual slots or use Select All to mark the entire day as unavailable. Tap Save Changes to apply your preferences.';

  @override
  String get selectAll => 'Select All';

  @override
  String get date => 'Date';

  @override
  String get selectDates => 'Select Dates';

  @override
  String get selectTimeSlots => 'Select Time Slots';

  @override
  String get descriptionOptional => 'Description (Optional)';

  @override
  String get password => 'Password';

  @override
  String get closingTimeCannotBeMidnight => 'Closing time cannot be 12:00 AM';

  @override
  String get closingTimeCannotBeAfter1159 =>
      'Closing time cannot be later than 11:59 PM';

  @override
  String get closingTimeMustBeAfterOpening =>
      'Closing time must be after opening time';

  @override
  String get setWeeklyAvailability => 'Set weekly Availability';

  @override
  String get weeklyAvailabilityDescription =>
      'Select the days and times your business operates. This schedule will repeat weekly for the entire year. To mark specific days off, use the unavailability tab.';

  @override
  String get selectForAllDay => 'Select for All day';

  @override
  String get dayOnOff => 'Day On/Off';

  @override
  String get closed => 'Closed';

  @override
  String get pleaseSelectAtLeastOneDay => 'Please select at least one day';

  @override
  String get setUpTime => 'Set Up Time';

  @override
  String get noTimeSlotsFound => 'No Time Slots found';

  @override
  String get addCategoryTitle => 'Add Category Title';

  @override
  String get briefDescriptionDish => 'Brief description of the dish...';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get reason => 'Reason';

  @override
  String get reservationCanceledMessage =>
      'Your reservation has been canceled due to a delay in arrival or an unforeseen circumstance. We apologize for the inconvenience and appreciate your understanding.';

  @override
  String get bookingId => 'Booking ID';

  @override
  String get numberOfPersons => 'No. of Persons';

  @override
  String get time => 'Time';

  @override
  String get amount => 'Amount';

  @override
  String get person => 'person';

  @override
  String get allergyNote => 'Allergic to peanuts. Request outdoor seating.';

  @override
  String get guests => 'Guests';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get cancelBookingConfirmation =>
      'Are you sure you would like to cancel your booking?';

  @override
  String get shareReason => 'Share your reason here...';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get numberOfPersons2 => 'Number of Persons';

  @override
  String get nothingToShow => 'Nothing to show';

  @override
  String get participantsList => 'Participants List';

  @override
  String get newGroup => 'New Group';

  @override
  String get suggested => 'Suggested';

  @override
  String get newChat => 'New Chat';

  @override
  String get groupChat => 'Group Chat';

  @override
  String get chatWithUpTo50Friends => 'Chat with up to 50 friends';

  @override
  String get read => 'Read';

  @override
  String get members => 'Members';

  @override
  String get outOf => 'out of';

  @override
  String get interested => 'Interested';

  @override
  String get writeAboutYourself => 'Write something about yourself...';

  @override
  String get bio => 'Bio';

  @override
  String get showMore => 'Show more';

  @override
  String get friends => 'Friends';

  @override
  String get all => 'All';

  @override
  String get mapLocation => 'Map & Location';

  @override
  String get editTimeSlot => 'Edit Time Slot';

  @override
  String get suggestTimeSlot => 'Suggest Time Slot';

  @override
  String get confirm => 'Confirm';

  @override
  String get pleaseSelectDate => 'Please select a date';

  @override
  String get pleaseSelectTime => 'Please select a time';

  @override
  String get selected => 'Selected';

  @override
  String get suggestATimeSlot => 'Suggest a Time Slot';

  @override
  String get selectFriends => 'Select Friends';

  @override
  String get sendInvite => 'Send Invite';

  @override
  String get interestDetails => 'Interest Details';

  @override
  String get editTime => 'Edit Time';

  @override
  String get reserveNow => 'Reserve Now';

  @override
  String get invitees => 'Invitees';

  @override
  String get joined => 'Joined';

  @override
  String get declined => 'Declined';

  @override
  String get suggestedDateTime => 'Suggested Date & Time';

  @override
  String get suggestedTime => 'Suggested Time';

  @override
  String get suggestNewTime => 'Suggest New Time';

  @override
  String get decline => 'Decline';

  @override
  String get viewDetails => 'View Details';

  @override
  String get reasonOfDecline => 'Reason of decline';

  @override
  String get daysAgo => 'days ago';

  @override
  String get createChoice => 'Create Choice';

  @override
  String get overallWellnessRating => 'Overall Wellness Rating';

  @override
  String get overallLeisureRating => 'Overall Leisure Rating';

  @override
  String get choiceCreatedSuccessfully => 'Choice created successfully!';

  @override
  String get anyoneCanSeeFeed => 'Anyone can see the feed';

  @override
  String get friendsOnly => 'Friends Only';

  @override
  String get yourFriendsOnChoice => 'Your friends on Choice';

  @override
  String get private => 'Private';

  @override
  String get onlyMe => 'Only Me';

  @override
  String get privateLower => 'private';

  @override
  String get friendsOnlyLower => 'friends_only';

  @override
  String get publicLower => 'public';

  @override
  String get shareYourExperience => 'Share your experience';

  @override
  String get tapToSelect => 'Tap to select';

  @override
  String get select => 'Select';

  @override
  String get failedToFetchPlaces => 'Failed to fetch places';

  @override
  String get searchForRestaurant => 'Search for a restaurant...';

  @override
  String get searchForWellness => 'Search for a Wellness...';

  @override
  String get searchForLeisure => 'Search for a Leisure...';

  @override
  String get back => 'Back';

  @override
  String get changeType => 'Change Type';

  @override
  String get search => 'Search...';

  @override
  String get whatWouldYouLikeToShare => 'What would you like to share?';

  @override
  String get imageUploadFailed => 'Image upload failed';

  @override
  String get phoneNumberMissing => 'Phone number is Missing';

  @override
  String get usernameMissing => 'Username is Missing';

  @override
  String get nameMissing => 'Name is Missing';

  @override
  String get failedToRegisterAccount => 'Failed to register account';

  @override
  String get confirmPasswordMissing => 'Confirm Password is missing';

  @override
  String get newAndConfirmPasswordNotMatched =>
      'new and confirm password not matched';

  @override
  String get completeYourRegistration => 'Complete Your Registration';

  @override
  String get secureYourAccount =>
      'Secure your account by adding your email and password';

  @override
  String get selectType => 'Select type';

  @override
  String get searchAPlace => 'Search a place';

  @override
  String get documentSelectedSuccessfully => 'Document selected successfully';

  @override
  String get failedToUploadDocument => 'Failed to upload document';

  @override
  String get noPlacesFound => 'No places found';

  @override
  String get noFileSelected => 'No file selected';

  @override
  String get documentSavedSuccessfully => 'Document saved successfully';

  @override
  String get failedToSaveDocument => 'Failed to save document';

  @override
  String get unexpectedErrorWhileUploading =>
      'Unexpected error occurred while uploading';

  @override
  String get document => 'Document';

  @override
  String get selectDocument => 'Select Document';

  @override
  String get pleaseEnterCurrentPassword => 'Please enter your current password';

  @override
  String get pleaseEnterNewPassword => 'Please enter a new password';

  @override
  String get passwordMustInclude =>
      'Password must be at least 8 characters and include uppercase, lowercase, number, and special character';

  @override
  String get confirmPasswordEmpty => 'Confirm Password is empty';

  @override
  String get passwordsDoNotMatch =>
      'New Password and Confirm Password do not match';

  @override
  String get newPasswordSameAsCurrent =>
      'New password cannot be the same as the current password';

  @override
  String get pleaseSelectDocumentFirst => 'Please select a document first.';

  @override
  String get pleaseUploadDocumentFirst => 'Please upload the document first.';

  @override
  String get documentUploadedSuccessfully => 'Document uploaded successfully';

  @override
  String get failedToGetUploadUrl => 'Failed to get upload URL';
}
