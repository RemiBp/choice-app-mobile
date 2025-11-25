const String baseUrl = "http://choice-app-prod-env.eba-wqrm9be2.eu-west-3.elasticbeanstalk.com";//production url
const String imageBaseUrl = "https://elasticbeanstalk-us-west-1-841019700848.s3.us-west-1.amazonaws.com/";//image base url


const String loginApiUrl = "$baseUrl/api/producer/auth/login";
const String userLoginApiUrl = "$baseUrl/api/app/auth/login";
const String signUpApiUrl = "$baseUrl/api/producer/auth/register";
const String userSignUpApiUrl = "$baseUrl/api/app/auth/register";
const String verifySignupOtpApiUrl = "$baseUrl/api/producer/auth/verifyOtp";
const String verifyUserSignupOtpApiUrl = "$baseUrl/api/app/auth/verifyOtp";
const String resendSignupOtpApiUrl = "$baseUrl/api/producer/auth/resendSignUpOtp";
const String resendUserSignupOtpApiUrl = "$baseUrl/api/app/auth/resendSignUpOtp";
const String verifyFgOtpApiUrl = "$baseUrl/api/producer/auth/verifyForgotPasswordOtp";
const String verifyUserFgOtpApiUrl = "$baseUrl/api/app/auth/verifyForgotPasswordOtp";
const String resendFgOtpApiUrl = "$baseUrl/api/producer/auth/resendForgotPasswordOtp";
const String resendUserFgOtpApiUrl = "$baseUrl/api/app/auth/resendForgotPasswordOtp";
const String forgotPasswordApiUrl = "$baseUrl/api/producer/auth/forgotPassword";
const String forgotUserPasswordApiUrl = "$baseUrl/api/app/auth/forgotPassword";
const String resetPasswordApiUrl = "$baseUrl/api/producer/auth/resetPassword";
const String resetUserPasswordApiUrl = "$baseUrl/api/app/auth/resetPassword";
const String submitDocsApiUrl = "$baseUrl/api/producer/auth/submitDocuments";
const String preSignedFileUploadApiUrl = "$baseUrl/api/producer/auth/getPreSignedUrl";
const String createUserPostApiUrl = "$baseUrl/api/producer/post/createUserPost";
const String createEventPostApiUrl = "$baseUrl/api/producer/event/createEvent";
const String getAllEventsApiUrl = "$baseUrl/api/producer/event/getAllEvents";
const String updateProfileApiUrl = "$baseUrl/api/producer/profile/updateProfile";
const String setOperationalHoursApiUrl = "$baseUrl/api/producer/profile/setOperationalHours";
const String getCuisineTypesApiUrl = "$baseUrl/api/producer/profile/getCuisineTypes";
const String setCuisineTypeApiUrl = "$baseUrl/api/producer/profile/setCuisineType";
const String setGalleryImagesApiUrl = "$baseUrl/api/producer/profile/setGalleryImages";
const String addMenuCategoryApiUrl = "$baseUrl/api/producer/profile/addMenuCategory";
const String addMenuDishApiUrl = "$baseUrl/api/producer/profile/addMenuDish";
const String getMenuCategoriesApiUrl = "$baseUrl/api/producer/profile/getMenuCategories";
const String userProfileApiUrl = "$baseUrl/api/app/profile/getProfile";
const String userUpdateProfileApiUrl = "$baseUrl/api/app/profile/updateProfile";
const String userPostsApiUrl = "$baseUrl/api/producer/post/getMyPosts";
const String getMenuApiUrl = "$baseUrl/api/producer/profile/getMenu";
const String getProducerGalleryApiUrl = "$baseUrl/api/producer/profile/getGalleryImages";
const String getProducerDocumentApiUrl = "$baseUrl/api/producer/auth/getProducerDocuments";
const String submitProducerDocumentApiUrl = "$baseUrl/api/producer/auth/submitDocuments";
const String getProducerPostsApiUrl = "$baseUrl/api/producer/post/getPostsByProducer";
const String getProducerPostsByIdApiUrl = "$baseUrl/api/producer/post/getProducerPostById";
const String deleteGalleryImagesApiUrl = "$baseUrl/api/producer/profile/deleteGalleryImages";
const String getEventsNearMeApiUrl = "$baseUrl/api/producer/event/getAllEvents";
const String getEventsTypeApiUrl = "$baseUrl/api/producer/event/getEventTypes";
const String nearByProducersApiUrl = "$baseUrl/api/producer/event/findNearbyProducer";
const String getEventsByIdApiUrl = "$baseUrl/api/producer/event/getEventById";
const String getEventsByProducerApiUrl = "$baseUrl/api/producer/event/getEventsByProducerId";
const String deleteUserAccountApiUrl = "$baseUrl/api/app/profile/deleteProfile";
const String deleteProducerAccountApiUrl = "$baseUrl/api/producer/profile/deleteProfile";
const String getNonEventsByIdApiUrl = "$baseUrl/api/producer/event/getProfileById";











const String getProducerPlacesApiUrl = "$baseUrl/api/producer/post/getProducerPlaces";
const String saveResRatingApiUrl = "$baseUrl/api/producer/post/saveRatings";
const String createProducerPostApiUrl = "$baseUrl/api/producer/post/createProducerPost";
const String saveDocumentApiUrl = "$baseUrl/api/producer/auth/saveDocument";
const String updatePasswordApiUrl = "$baseUrl/api/producer/profile/updatePassword";
const String deleteProducerDocumentApiUrl = "$baseUrl/api/producer/auth/deleteDocument";
const String updateProducerDocumentApiUrl = "$baseUrl/api/producer/auth/updateDocuments";


const String setSlotDurationApiUrl = "$baseUrl/api/producer/profile/setSlotDuration";
const String getProducerSlotsApiUrl = "$baseUrl/api/producer/profile/getProducerSlots";
const String getAllServiceTypesApiUrl = "$baseUrl/api/producer/profile/getAllServiceType";
const String setServiceTypesApiUrl = "$baseUrl/api/producer/profile/setServiceType";
const String getProducerProfileApiUrl = "$baseUrl/api/producer/profile/getProfile";
const String getProducerOperationalHoursApiUrl = "$baseUrl/api/producer/profile/getOperationalHours";
const String addUnavailableSlotsApiUrl = "$baseUrl/api/producer/profile/addUnavailableSlot";
const String updateRestaurantSlotsApiUrl = "$baseUrl/api/producer/profile/updateRestaurantSlots";

const String getUserBookingsApiUrl = "$baseUrl/api/producer/booking/getUserBookings";
const String userCancelBookingApiUrl = "$baseUrl/api/producer/booking/cancelBooking";
const String producerCancelBookingApiUrl = "$baseUrl/api/app/booking/cancel";
const String checkInBookingApiUrl = "$baseUrl/api/producer/booking/checkIn";
const String checkInSimpleBookingApiUrl = "$baseUrl/api/app/booking/checkin";
const String createEventBookingApiUrl = "$baseUrl/api/producer/booking/createBooking";
const String createNonEventBookingApiUrl = "$baseUrl/api/app/booking/createBooking";
const String getProducerBookingSlotsApiUrl = "$baseUrl/api/app/booking/getRestaurantSlots";
const String updateBookingsApiUrl = "$baseUrl/api/app/booking/updateBooking";
const String getEventBookingDetailsApiUrl = "$baseUrl/api/producer/booking/booking";
const String getSimpleBookingDetailsApiUrl = "$baseUrl/api/app/booking/getBooking";

const String deleteEventApiUrl = "$baseUrl/api/producer/event/deleteEvent/";
const String updateEventApiUrl = "$baseUrl/api/producer/event/updateEvent/";
const String getMyEventsApiUrl = "$baseUrl/api/producer/event/getMyEvents";



