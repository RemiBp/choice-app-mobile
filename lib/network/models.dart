import 'package:choice_app/models/auth_ressponse.dart';
import 'package:choice_app/models/customer_all_posts_response.dart';
import 'package:choice_app/models/customer_profile_response.dart';
import 'package:choice_app/models/get_all_events_near_me_response.dart';
import 'package:choice_app/models/get_all_events_response.dart';
import 'package:choice_app/models/get_all_service_types_response.dart';
import 'package:choice_app/models/get_cuisine_types_response.dart';
import 'package:choice_app/models/get_document_response.dart';
import 'package:choice_app/models/get_event_booking_details_response.dart';
import 'package:choice_app/models/get_event_types_response.dart';
import 'package:choice_app/models/get_events_details_response.dart';
import 'package:choice_app/models/get_gallery_image_response.dart';
import 'package:choice_app/models/get_menu_categories_response.dart';
import 'package:choice_app/models/get_menu_response.dart';
import 'package:choice_app/models/get_non_events_details_response.dart';
import 'package:choice_app/models/get_normal_booking_details_response.dart';
import 'package:choice_app/models/get_producer_booking_slots_response.dart';
import 'package:choice_app/models/get_producer_operational_hours_response.dart';
import 'package:choice_app/models/get_producer_places.dart';
import 'package:choice_app/models/get_producer_profile_response.dart';

import 'package:choice_app/models/get_producer_slots_response.dart';
import 'package:choice_app/models/get_user_bookings_response.dart';
import 'package:choice_app/models/more_events_by_producer_response.dart';
import 'package:choice_app/models/producer_delete_document_response.dart';
import 'package:choice_app/models/producer_delete_gallery_images_response.dart';
import 'package:choice_app/models/producer_posts_response.dart';
import 'package:choice_app/models/producer_update_document_response.dart';
import 'package:choice_app/models/restaurant_update_profile_response.dart';
import '../models/error_model.dart';
import '../models/get_producers_places_claim_response.dart';
import '../models/near_by_producers_response.dart';

class Models {
  static const String errorModel = "ERROR_MODEL";
  static const String authModel = "REGISTRATION_MODEL";
  static const String eventsModel = "Events_MODEL";
  static const String restaurantUpdateProfileModel =
      "RESTAURANT_UPDATE_PROFILE_MODEL";
  static const String restaurantGetCuisineTypesModel =
      "RESTAURANT_GET_CUISINE_TYPES_MODEL";
  static const String restaurantGetMenuCategoriesModel =
      "RESTAURANT_GET_MENU_CATEGORIES_MODEL";
  static const String customerProfileModel = "CUSTOMER_PROFILE_MODEL";
  static const String customerAllPostsModel = "CUSTOMER_ALL_POSTS_MODEL";
  static const String producerPostsModel = "PRODUCER_ALL_POSTS_MODEL";
  static const String producerPlacesModel = "PRODUCER_PLACES_MODEL";

  // static const String customerProfileModel = "CUSTOMER_PROFILE_MODEL";
  // static const String customerAllPostsModel = "CUSTOMER_ALL_POSTS_MODEL";
  static const String claimProducerPlacesModel = "CLAIM_PRODUCER_PLACES_MODEL";
  static const String getProducerSlotsModel = "GET_PRODUCER_SLOTS_MODEL";
  static const String getAllServiceTypesModel = "GET_ALL_SERVICE_TYPES_MODEL";
  static const String getProducerProfileModel = "GET_PRODUCER_PROFILE_MODEL";
  static const String getProducerOperationalHoursModel =
      "GET_PRODUCER_OPERATIONAL_HOURS_MODEL";
  static const String restaurantGetMenuModel = "RESTAURANT_GET_MENU_MODEL";
  static const String producerGetGalleryImagesModel =
      "PRODUCER_GET_GALLERY_IMAGES_MODEL";
  static const String getProducerDocumentModel = "GET_DOCUMENT_MODEL";
  static const String producerUpdateDocumentModel =
      "PRODUCER_UPDATE_DOCUMENT_MODEL";
  static const String producerDeleteDocumentModel =
      "PRODUCER_DELETE_DOCUMENT_MODEL";
  static const String producerDeleteGalleryImageModel =
      "PRODUCER_DELETE_GALLERY_IMAGE_MODEL";
  static const String getEventsNearMeModel = "GET_ALL_EVENTS_NEAR_ME_MODEL";
  static const String getEventsTypeModel = "GET_EVENTS_TYPE_MODEL";
  static const String getNearByProducersModel = "NEAR_BY_PRODUCERS_MODEL";
  static const String getBookingsModel = "GET_BOOKINGS_MODEL";
  static const String getEventsDetailsModel = "GET_EVENTS_DETAILS_MODEL";
  static const String getMoreEventsByProducersModel = "MORE_EVENTS_BY_PRODUCER_MODEL";
  static const String getNonEventsDetailsModel = "GET_NON_EVENTS_DETAILS_MODEL";
  static const String getProducerBookingSlotsModel = "GET_PRODUCER_BOOKING_SLOTS_MODEL";
  static const String getEventBookingDetailsModel = "GET_EVENT_BOOKING_DETAILS_MODEL";
  static const String getSimpleBookingDetailsModel = "GET_NORMAL_BOOKING_DETAILS_MODEL";








  static Future<dynamic> getModelObject(
    String modelName,
    Map<String, dynamic> json,
  ) async {
    switch (modelName) {
      case errorModel:
        return ErrorResponse.fromJson(json);
      case authModel:
        return AuthResponse.fromJson(json);
      case eventsModel:
        return GetAllEventsResponse.fromJson(json);
      case restaurantUpdateProfileModel:
        return RestaurantUpdateProfileResponse.fromJson(json);
      case customerProfileModel:
        return CustomerProfileResponse.fromJson(json);
      case customerAllPostsModel:
        return CustomerAllPostsResponse.fromJson(json);
      case restaurantGetCuisineTypesModel:
        return GetCuisineTypesResponse.fromJson(json);
      case restaurantGetMenuCategoriesModel:
        return GetMenuCategoriesResponse.fromJson(json);
      case producerPlacesModel:
        return ProducerPlacesResponse.fromJson(json);
      case getProducerSlotsModel:
        return GetProducerSlotsResponse.fromJson(json);
      case getAllServiceTypesModel:
        return GetAllServiceTypesResponse.fromJson(json);
      case claimProducerPlacesModel:
        return ClaimProducerPlacesResponse.fromJson(json);
      case getProducerProfileModel:
        return GetProducerProfileResponse.fromJson(json);
      case getProducerOperationalHoursModel:
        return GetProducerOperationalHoursResponse.fromJson(json);
      case restaurantGetMenuModel:
        return GetMenuResponse.fromJson(json);
      case producerGetGalleryImagesModel:
        return GetGalleryImagesResponse.fromJson(json);
      case getProducerDocumentModel:
        return GetDocumentsResponse.fromJson(json);
      case producerUpdateDocumentModel:
        return ProducerUpdateDocumentResponse.fromJson(json);
      case producerDeleteDocumentModel:
        return ProducerDeleteDocumentResponse.fromJson(json);
      case producerPostsModel:
        return ProducerPostsResponse.fromJson(json);
      case producerDeleteGalleryImageModel:
        return DeleteGalleryImageResponse.fromJson(json);
      case getEventsNearMeModel:
        return GetEventsNearMeResponse.fromJson(json);
      case getBookingsModel:
        return GetUserBookingsResponse.fromJson(json);
      case getEventsTypeModel:
        return GetEventTypesResponse.fromJson(json);
      case getNearByProducersModel:
        return NearbyProducersResponse.fromJson(json);
      case getMoreEventsByProducersModel:
        return MoreEventsByProducerResponse.fromJson(json);
      case getEventsDetailsModel:
        return EventDetailsResponse.fromJson(json);
      case getNonEventsDetailsModel:
        return NonEventDetailsResponse.fromJson(json);
      case getProducerBookingSlotsModel:
        return ProducerBookingSlotsResponse.fromJson(json);
      case getEventBookingDetailsModel:
        return EventBookingDetailsResponse.fromJson(json);
      case getSimpleBookingDetailsModel:
        return SimpleBookingDetailsResponse.fromJson(json);
    }
  }
}
