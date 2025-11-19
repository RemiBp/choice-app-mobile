// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get helloWorld => 'Bonjour le monde!';

  @override
  String get createAnAccount => 'Créer un compte';

  @override
  String get chooseAccountType =>
      'Choisissez le type de compte que vous souhaitez créer :';

  @override
  String get userAccountTitle => 'Compte utilisateur';

  @override
  String get provideAReason => 'Veuillez fournir une raison.';

  @override
  String get somethingWentWrong => 'Quelque chose s\'est mal passé';

  @override
  String get userAccountDescription =>
      'Pour découvrir des restaurants et des activités, et suivre vos prestataires favoris.';

  @override
  String get restaurantProviderAccountTitle => 'Compte restaurateur';

  @override
  String get restaurantProviderAccountDescription =>
      'Pour gérer votre restaurant et promouvoir vos offres.';

  @override
  String get leisureProviderAccountTitle => 'Compte prestataire de loisirs';

  @override
  String get leisureProviderAccountDescription =>
      'Pour gérer vos activités de loisirs et attirer de nouveaux clients.';

  @override
  String get wellnessProviderAccountTitle => 'Compte prestataire de bien-être';

  @override
  String get wellnessProviderAccountDescription =>
      'Pour gérer vos activités de bien-être et attirer de nouveaux clients.';

  @override
  String get signupTitle => 'Inscription';

  @override
  String get signupSubtitle =>
      'Entrez votre email et mot de passe pour vous inscrire';

  @override
  String get businessName => 'Nom de l\'entreprise';

  @override
  String get fullName => 'Nom complet';

  @override
  String get fullNamePlaceholder => 'Nom et prénom';

  @override
  String get userName => 'Nom d\'utilisateur';

  @override
  String get userNamePlaceholder => 'Nom d\'utilisateur';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailPlaceholder => 'Adresse e-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get signupAgreement => 'En vous inscrivant, vous acceptez nos';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get andLabel => 'et';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get signupWithApple => 'Apple';

  @override
  String get signupWithGoogle => 'Google';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get loginButton => 'Connexion';

  @override
  String get otpVerification => 'Vérification OTP';

  @override
  String verificationPrompt(Object email) {
    return 'Entrez le code de vérification à 6 chiffres envoyé à dummy@example.com';
  }

  @override
  String get didNotReceiveCode => 'Vous n\'avez pas reçu le code ?';

  @override
  String get resendCode => 'Renvoyer';

  @override
  String get verifyButton => 'Vérifier';

  @override
  String get uploadDocumentsTitle => 'Télécharger les documents';

  @override
  String get uploadDocumentsSubtitle =>
      'Veuillez télécharger vos documents pour continuer la vérification.';

  @override
  String get businessRegistrationDocument =>
      'Document d\'enregistrement de l\'entreprise';

  @override
  String get expiryDate => 'Date d\'expiration';

  @override
  String get selectDate => 'Sélectionner la date';

  @override
  String get chooseFile => 'Choisir un fichier';

  @override
  String get maxFileSizeNote => 'Taille maximale du fichier (PDF) : 2 Mo';

  @override
  String get utilityBillOrInvoice => 'Facture de services publics ou facture';

  @override
  String get submitForReview => 'Soumettre pour révision';

  @override
  String get loginInstruction =>
      'Entrez votre email et mot de passe pour vous connecter';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get noAccountPrompt => 'Vous n’avez pas de compte ?';

  @override
  String get forgotPasswordInstruction =>
      'Veuillez entrer votre email pour recevoir un code de vérification.';

  @override
  String get sendOtpButton => 'Envoyer le code';

  @override
  String get resetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordNote =>
      'Votre nouveau mot de passe doit être différent des mots de passe précédemment utilisés.';

  @override
  String get newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get confirmPasswordLabel => 'Confirmez le mot de passe';

  @override
  String get profileSetup => 'Configuration du profil';

  @override
  String get address => 'Adresse';

  @override
  String get briefDescription => 'Brève description';

  @override
  String get writeSomethingBrief => 'Écrivez quelque chose de bref...';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'caméra';

  @override
  String get chooseYourPhoto => 'Choisissez votre photo';

  @override
  String get links => 'Liens';

  @override
  String get next => 'Suivant';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get choosePreferredLanguage =>
      'Choisissez votre langue préférée pour continuer';

  @override
  String get continueText => 'Continuer';

  @override
  String get phoneNumber => 'Numéro de téléphone';

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
  String get unavailability => 'Indisponibilité';

  @override
  String get modify => 'Modifier';

  @override
  String get checkIn => 'Enregistrement';

  @override
  String get upcoming => 'À venir';

  @override
  String get inProgress => 'En cours';

  @override
  String get completed => 'Terminé';

  @override
  String get cancelled => 'Annulé';

  @override
  String get menuCoverage => 'Couverture du menu';

  @override
  String get noUpcomingBooking => 'Aucune réservation à venir';

  @override
  String get noUpcomingBookingMessage =>
      'Vous n’avez aucune réservation à venir';

  @override
  String get bookingInformation => 'Informations sur la réservation';

  @override
  String get internalNotes => 'Notes internes';

  @override
  String get customerInformation => 'Informations client';

  @override
  String get customerName => 'Nom du client :';

  @override
  String get emailLabel1 => 'Email :';

  @override
  String get bookings => 'Réservations';

  @override
  String get selectProfileImage => 'Sélectionner l’image de profil';

  @override
  String get failedToGetImageUrl =>
      'Échec de la récupération de l’URL de l’image';

  @override
  String get phoneLabel => 'Téléphone :';

  @override
  String get bookingDetails => 'Détails de la réservation';

  @override
  String get language => 'Language';

  @override
  String get validFacebookLink => 'Veuillez entrer un lien Facebook valide';

  @override
  String get validInstagramLink => 'Veuillez entrer un lien Instagram valide';

  @override
  String get validWebsiteLink => 'Veuillez entrer un lien de site Web valide';

  @override
  String get validTwitterLink => 'Veuillez entrer un lien Twitter/X valide';

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
  String get reclaimAccount => 'Récupérez votre compte';

  @override
  String get retrieveAccess => 'Récupérez l\'accès à votre profil existant';

  @override
  String get chooseOption => 'Choisissez votre option';

  @override
  String get categoryRestaurant => 'Restaurant';

  @override
  String get categoryLeisure => 'Loisir';

  @override
  String get categoryWellness => 'Bien-être';

  @override
  String get searchPlaceholder => 'Rechercher par nom...';

  @override
  String get claimAccount => 'Réclamer le compte';

  @override
  String get orText => 'Ou';

  @override
  String get uploadDocuments => 'Télécharger des documents';

  @override
  String get uploadDocumentsDescription =>
      'Veuillez télécharger votre document pour continuer la vérification.';

  @override
  String get backButton => 'Retour';

  @override
  String get thankYou => 'Merci !';

  @override
  String get underReviewMessage =>
      'Votre profil est maintenant en cours d\'examen. Nous vous répondrons dans deux jours ouvrables.';

  @override
  String get documentBusinessRegistration =>
      'Documents d\'enregistrement de l\'entreprise';

  @override
  String get documentLeaseContract => 'Contrat de bail commercial';

  @override
  String get documentUtilityBill => 'Facture de services publics';

  @override
  String get documentSupplierInvoice => 'Facture fournisseur';

  @override
  String get documentInsuranceCertificate =>
      'Attestation d\'assurance professionnelle';

  @override
  String get documentTax => 'Document fiscal';

  @override
  String get documentAuthorizationLetter => 'Lettre d\'autorisation signée';

  @override
  String get create => 'Créer';

  @override
  String get createPost => 'Créer une publication';

  @override
  String get photos => 'Photos';

  @override
  String get fileSupport => 'Fichier pris en charge :';

  @override
  String get imageLimit => 'Jusqu\'à 5 images';

  @override
  String get exampleTitle => 'ex. Brunch du dimanche à The Maple House';

  @override
  String get title => 'Titre';

  @override
  String get passwordManager => 'Gestionnaire de mots de passe';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get eventTypeLabel => 'Type d\'événement';

  @override
  String get eventTypePlaceholder => 'Sélectionner le type d\'événement';

  @override
  String get passwordMissing => 'Mot de passe manquant';

  @override
  String get passwordInvalidCharacters =>
      'Le mot de passe contient des caractères invalides (pas d’emojis autorisés)';

  @override
  String get emailMissing => 'Email manquant';

  @override
  String get invalidEmail => 'Email invalide';

  @override
  String get invalidPassword => 'Mot de passe invalide';

  @override
  String get interest => 'Intérêt';

  @override
  String get choices => 'Choix';

  @override
  String get seeMore => 'Voir plus';

  @override
  String get eventsNearYou => 'Événements près de chez vous';

  @override
  String get surpriseMe => 'Surprenez-moi';

  @override
  String get seeFullMenu => 'Voir le menu complet';

  @override
  String get organizer => 'Organisateur';

  @override
  String get moreEventsLikeThis => 'Plus d’événements comme celui-ci';

  @override
  String get showAll => 'Tout afficher';

  @override
  String get ticketPrice => 'Prix du billet';

  @override
  String get perPerson => '/par personne';

  @override
  String get bookNow => 'Réserver maintenant';

  @override
  String get browseByCategory => 'Parcourir par catégorie';

  @override
  String get expiryDate1Placeholder =>
      'Veuillez sélectionner la date d’expiration 1';

  @override
  String get businessRegistrationPlaceholder =>
      'Veuillez sélectionner le document d’enregistrement de l’entreprise';

  @override
  String get expiryDate2Placeholder =>
      'Veuillez sélectionner la date d’expiration 2';

  @override
  String get utilityBillPlaceholder =>
      'Veuillez sélectionner une facture de services publics ou une facture';

  @override
  String get businessNameMissing => 'Le nom de l’entreprise est manquant';

  @override
  String get businessNameInvalidCharacters =>
      'Le nom de l’entreprise contient des caractères invalides (pas d’emojis autorisés)';

  @override
  String get noInternet => 'Pas d’internet';

  @override
  String get enterOtpPlaceholder => 'Veuillez entrer l’OTP';

  @override
  String get otpVerifiedSuccess => 'OTP vérifié avec succès';

  @override
  String get genericError => 'Une erreur est survenue, réessayez.';

  @override
  String get noInternetConnection => 'Pas de connexion Internet';

  @override
  String get success => 'Succès';

  @override
  String get registrationSuccessful => 'Inscription réussie';

  @override
  String get eventDescriptionPlaceholder => 'Décrivez votre événement...';

  @override
  String get exampleTags => 'ex. : #chaleureux, #terrasse';

  @override
  String get tags => 'Tags';

  @override
  String get addLocation => 'Ajouter un lieu';

  @override
  String get location => 'Lieu';

  @override
  String get cancel => 'Annuler';

  @override
  String get publish => 'Publier';

  @override
  String get errorSelectImage => 'Veuillez sélectionner au moins une image';

  @override
  String get errorEnterTitle => 'Veuillez entrer un titre';

  @override
  String get errorEnterDescription => 'Veuillez entrer une description';

  @override
  String get errorEnterTags => 'Veuillez entrer des tags pertinents';

  @override
  String get errorEnterAddress => 'Veuillez entrer une adresse';

  @override
  String get searchUserPlaceholder =>
      'Rechercher par nom d’utilisateur ou par nom...';

  @override
  String get description => 'Description';

  @override
  String get deleteEventConfirmation => 'Supprimer l’événement ?';

  @override
  String get deleteEventMessage =>
      'Cette action supprimera définitivement l’événement.';

  @override
  String get events => 'Événements';

  @override
  String get sampleEventName => 'Soirée Vin & Dîner';

  @override
  String get statusActive => 'Actif';

  @override
  String get statusDraft => 'Brouillon';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get createEvent => 'Créer un événement';

  @override
  String get noEvents => 'Aucun événement pour l’instant';

  @override
  String get noEventsMessage =>
      'Vous n’avez encore créé aucun événement. Commencez par ajouter votre premier — cela ne prend qu’une minute !';

  @override
  String get eventDetails => 'Détails de l’événement';

  @override
  String get exampleDish => 'Ex. : Brochette de bœuf...';

  @override
  String get eventName => 'Nom de l’événement';

  @override
  String get eventGallery => 'Galerie de l’événement';

  @override
  String get uploadLimit => 'Téléchargez jusqu’à 5 images';

  @override
  String get uploadEventImages => 'Télécharger les images de l’événement*';

  @override
  String get restaurantOrVenue => 'Nom du restaurant ou du lieu';

  @override
  String get venueName => 'Nom du lieu';

  @override
  String get venueAddress => 'Adresse du lieu';

  @override
  String get capacityPricing => 'Capacité & Tarification';

  @override
  String get maxPersons => 'Nombre maximum de personnes';

  @override
  String get maxCapacity => 'Capacité maximale';

  @override
  String get pricePerPerson => 'Prix par personne';

  @override
  String get schedule => 'Programme';

  @override
  String get eventDate => 'Date de l’événement';

  @override
  String get startTime => 'Heure de début';

  @override
  String get endTime => 'Heure de fin';

  @override
  String get saveAsDraft => 'Enregistrer comme brouillon';

  @override
  String get tapToUpload => 'Appuyez pour télécharger une image';

  @override
  String get event => 'Événement';

  @override
  String get participants => 'Participants';

  @override
  String get aboutEvent => 'À propos de l’événement';

  @override
  String get readMore => 'Lire plus';

  @override
  String get seeLess => 'Voir moins';

  @override
  String get socialLinks => 'Liens sociaux';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get yourExperience => 'Votre exprience';

  @override
  String get overallRestaurantRating => 'Note globale du restaurant';

  @override
  String get service => 'Service';

  @override
  String get price => 'Prix';

  @override
  String get portions => 'Portions';

  @override
  String get ambiance => 'Ambiance';

  @override
  String get dishesAndMenusConsumed => 'Plats et menus consommés';

  @override
  String get rateTheSelectedDishes => 'Évaluer les plats sélectionnés';

  @override
  String get yourRatingForThisDish => 'Votre note pour ce plat :';

  @override
  String get fileSupported => 'Formats pris en charge : PNG, JPG';

  @override
  String get chooseAFile => 'Choisir un fichier';

  @override
  String get upTo5Images => 'Jusqu\'à 5 images';

  @override
  String get remove => 'Supprimer';

  @override
  String get whichRestaurantDidYouVisit => 'Quel restaurant avez-vous visité ?';

  @override
  String get whichWellnessDidYouVisit =>
      'Quel centre de bien-être avez-vous visité ?';

  @override
  String get whichLeisureEventDidYouAttend =>
      'À quel événement de loisirs avez-vous assisté ?';

  @override
  String get filters => 'Filtres';

  @override
  String get distance => 'Distance';

  @override
  String get place => 'Lieu';

  @override
  String get dishName => 'Nom du plat';

  @override
  String get dishRating => 'Note du plat';

  @override
  String get resetAll => 'Réinitialiser tout';

  @override
  String get applyFilters => 'Appliquer les filtres';

  @override
  String get any => 'N\'importe lequel';

  @override
  String get unlockMoreWithPlus => 'Débloquez plus avec Plus';

  @override
  String get getMoreCapableModels =>
      'Obtenez nos modèles et fonctionnalités les plus performants';

  @override
  String get subscription => 'Abonnement';

  @override
  String get startByAddingPaymentMethod =>
      'Commencez par ajouter un mode de paiement';

  @override
  String get addPaymentMethodInfo =>
      'Ajoutez un mode de paiement à votre compte Google pour finaliser votre achat. Vos informations de paiement ne sont visibles que par Google.';

  @override
  String get addCreditOrDebitCard => 'Ajouter une carte de crédit ou de débit';

  @override
  String get currentPlan => 'Forfait actuel';

  @override
  String get free => 'Gratuit';

  @override
  String get limitedAICopilotQueries => 'Requêtes AI Copilot limitées';

  @override
  String get pro => 'Pro';

  @override
  String get blockedList => 'Liste bloquée';

  @override
  String get bookmarked => 'Enregistré';

  @override
  String get createNewProfile => 'Créer un nouveau profil';

  @override
  String get switchBetweenProfiles =>
      'Basculez entre les profils avec une seule connexion';

  @override
  String get chat => 'Discussion';

  @override
  String get searchByName => 'Rechercher par nom...';

  @override
  String get following => 'Abonnements';

  @override
  String get report => 'Signaler';

  @override
  String get block => 'Bloquer';

  @override
  String get switchAccount => 'Changer de compte';

  @override
  String get blockUser => 'Bloquer l’utilisateur';

  @override
  String get blockUserDescription =>
      'Bloquer cet utilisateur l’empêchera d’interagir avec vous. Vous pouvez le débloquer à tout moment dans vos paramètres de compte.';

  @override
  String get public => 'Public';

  @override
  String get whyReport => 'Pourquoi voulez-vous signaler ?';

  @override
  String get spamOrFakeAccount => 'Spam ou faux compte';

  @override
  String get inappropriateContent => 'Contenu inapproprié';

  @override
  String get harassmentOrBullying => 'Harcèlement ou intimidation';

  @override
  String get hateSpeech => 'Discours de haine';

  @override
  String get scamOrFraud => 'Arnaque ou fraude';

  @override
  String get submit => 'Soumettre';

  @override
  String get unfollow => 'Se désabonner';

  @override
  String get follow => 'Suivre';

  @override
  String get unlimitedAICopilotQueries => 'Requêtes Copilot IA illimitées';

  @override
  String get subscribe => 'S’abonner';

  @override
  String get progress => 'Progression';

  @override
  String get reportUser => 'Signaler l’utilisateur';

  @override
  String get follower => 'Abonné';

  @override
  String get message => 'Message';

  @override
  String get posts => 'Publications';

  @override
  String get about => 'À propos';

  @override
  String get aestheticCareAndWellBeing => 'Soins esthétiques et bien-être';

  @override
  String get hairCareAndHairServices => 'Soins et services capillaires';

  @override
  String get nailCareAndBodyModifications =>
      'Soins des ongles et modifications corporelles';

  @override
  String get seeFullGallery => 'Voir la galerie complète';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get unblock => 'Débloquer';

  @override
  String get unblockUser => 'Débloquer l’utilisateur';

  @override
  String get unblockConfirmation =>
      'Êtes-vous sûr de vouloir débloquer cet utilisateur ?';

  @override
  String get badgeAndXP => 'Badge et XP';

  @override
  String get firstBookingMaster => 'Maître de la première réservation';

  @override
  String get firstBookingMasterDesc =>
      'Effectuez votre toute première réservation, quelle qu’elle soit';

  @override
  String get choiceCreator => 'Créateur de choix';

  @override
  String get choiceCreatorDesc =>
      'Créez votre premier choix et commencez à explorer les options';

  @override
  String get reviewContributor => 'Contributeur d’avis';

  @override
  String get reviewContributorDesc =>
      'Partagez votre expérience en publiant un nouvel avis';

  @override
  String get achievementBadges => 'Badges de réussite';

  @override
  String get viewMore => 'Voir plus';

  @override
  String get fillOneFieldToUpdateProfile =>
      'Veuillez remplir au moins un champ pour mettre à jour votre profil';

  @override
  String get validBusinessName => 'Veuillez entrer un nom d’entreprise valide';

  @override
  String get validAddress =>
      'Veuillez entrer une adresse valide (au moins 5 caractères)';

  @override
  String get validPhoneNumber =>
      'Veuillez entrer un numéro de téléphone valide';

  @override
  String get validDescription =>
      'Veuillez entrer une description significative (au moins 10 caractères)';

  @override
  String get validWebsiteUrl => 'Veuillez entrer une URL de site Web valide';

  @override
  String get validInstagramUrl => 'Veuillez entrer une URL Instagram valide';

  @override
  String get validTwitterUrl => 'Veuillez entrer une URL Twitter valide';

  @override
  String get validFacebookUrl => 'Veuillez entrer une URL Facebook valide';

  @override
  String get profileUpdatedSuccessfully => 'Profil mis à jour avec succès';

  @override
  String get operationalHoursSaved =>
      'Heures de fonctionnement enregistrées avec succès';

  @override
  String get failedToSaveOperationalHours =>
      'Échec de l’enregistrement des heures de fonctionnement';

  @override
  String get failedToFetchCuisineTypes =>
      'Échec de la récupération des types de cuisine';

  @override
  String get cuisineTypeSetSuccessfully => 'Type de cuisine défini avec succès';

  @override
  String get failedToSetCuisineType =>
      'Échec de la définition du type de cuisine';

  @override
  String get galleryImagesSaved =>
      'Images de la galerie enregistrées avec succès';

  @override
  String get failedToSaveGalleryImages =>
      'Échec de l’enregistrement des images de la galerie';

  @override
  String get failedToAddMenuCategory =>
      'Échec de l’ajout de la catégorie du menu';

  @override
  String get failedToFetchMenuCategories =>
      'Échec de la récupération des catégories du menu';

  @override
  String get slotDurationSetSuccessfully =>
      'Durée du créneau définie avec succès';

  @override
  String get failedToSetSlotDuration =>
      'Échec de la définition de la durée du créneau';

  @override
  String get failedToFetchProducerSlots =>
      'Échec de la récupération des créneaux du producteur';

  @override
  String get failedToFetchAllServiceTypes =>
      'Échec de la récupération de tous les types de services';

  @override
  String get serviceTypeSetSuccessfully => 'Type de service défini avec succès';

  @override
  String get failedToSetServiceType =>
      'Échec de la définition du type de service';

  @override
  String get failedToFetchProducerProfile =>
      'Échec de la récupération du profil du producteur';

  @override
  String get failedToAddMenuDish => 'Échec de l’ajout du plat au menu';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotificationsYet => 'Vous n’avez encore aucune notification';

  @override
  String get notificationsDescription =>
      'Vous recevrez des notifications concernant les réservations, les avis, etc.';

  @override
  String get shareExperienceReview =>
      'Partagez votre expérience en laissant un avis sur';

  @override
  String get enterEventName => 'Veuillez entrer le nom de l’événement.';

  @override
  String get enterEventDescription =>
      'Veuillez entrer la description de l’événement.';

  @override
  String get enterVenue => 'Veuillez entrer le lieu.';

  @override
  String get enterCapacity => 'Veuillez entrer la capacité.';

  @override
  String get enterValidCapacityNumber =>
      'Veuillez entrer un nombre valide pour la capacité.';

  @override
  String get enterPrice => 'Veuillez entrer le prix.';

  @override
  String get enterValidPrice => 'Veuillez entrer un prix valide.';

  @override
  String get deleteEvent => 'Supprimer l’événement ?';

  @override
  String get deleteEventDescription =>
      'Cette action supprimera définitivement l’événement.';

  @override
  String get category => 'Catégorie';

  @override
  String get lastMonth => 'Le mois dernier';

  @override
  String get week1 => 'Semaine 1';

  @override
  String get week2 => 'Semaine 2';

  @override
  String get week3 => 'Semaine 3';

  @override
  String get week4 => 'Semaine 4';

  @override
  String get dishRatings => 'Notes des plats';

  @override
  String get january => 'Janvier';

  @override
  String get february => 'Février';

  @override
  String get march => 'Mars';

  @override
  String get april => 'Avril';

  @override
  String get may => 'Mai';

  @override
  String get june => 'Juin';

  @override
  String get july => 'Juillet';

  @override
  String get august => 'Août';

  @override
  String get september => 'Septembre';

  @override
  String get october => 'Octobre';

  @override
  String get november => 'Novembre';

  @override
  String get december => 'Décembre';

  @override
  String get monthlyEvolution => 'Évolution mensuelle';

  @override
  String get selectMonth => 'Sélectionner un mois';

  @override
  String get pleaseSelectMonth => 'Veuillez sélectionner un mois';

  @override
  String get profileViews => 'Vues du profil';

  @override
  String get lastWeek => 'La semaine dernière';

  @override
  String get chosen => 'Choisi';

  @override
  String get timesThisWeek => 'fois cette semaine';

  @override
  String get dishDropAlerts => 'Alertes de suppression de plats';

  @override
  String get day1 => 'Jour 1';

  @override
  String get day2 => 'Jour 2';

  @override
  String get day3 => 'Jour 3';

  @override
  String get day4 => 'Jour 4';

  @override
  String get day5 => 'Jour 5';

  @override
  String get day6 => 'Jour 6';

  @override
  String get fourDaysAgo => 'Il y a 4 jours';

  @override
  String get rating => 'Évaluation';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get bookmark => 'Favori';

  @override
  String get choicesMade => 'Choix effectués';

  @override
  String get conversionRate => 'Taux de conversion';

  @override
  String get postConversionRate => 'Taux de conversion des publications';

  @override
  String get favoriteChoiceOfMonth => 'Choix favori du mois';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get mostChosenDish => 'Plat le plus choisi';

  @override
  String get waitingTimeComplaints => 'Plaintes sur le temps d’attente';

  @override
  String get choicesFlaggedLongWait => 'Choix signalés pour longue attente';

  @override
  String get topPerformingEventType => 'Type d’événement le plus performant';

  @override
  String get twoXMoreThanLiveMusic => '2x plus que la musique live';

  @override
  String get label => 'étiquette';

  @override
  String get value => 'valeur';

  @override
  String get ratingsByExperienceTheme => 'Notes par thème d’expérience';

  @override
  String get notRated => 'Non noté';

  @override
  String get rated => 'Noté';

  @override
  String get userOriginMap => 'Carte d’origine des utilisateurs';

  @override
  String get mon => 'Lun';

  @override
  String get tue => 'Mar';

  @override
  String get wed => 'Mer';

  @override
  String get thu => 'Jeu';

  @override
  String get fri => 'Ven';

  @override
  String get sat => 'Sam';

  @override
  String get sun => 'Dim';

  @override
  String get weeklyRatings => 'Notes hebdomadaires';

  @override
  String get home => 'Accueil';

  @override
  String get map => 'Carte';

  @override
  String get explore => 'Explorer';

  @override
  String get profile => 'Profil';

  @override
  String get allDay => 'Toute la journée';

  @override
  String get everyday => 'Tous les jours';

  @override
  String get morning => 'Matin (6h–12h)';

  @override
  String get afternoon => 'Après-midi (12h–18h)';

  @override
  String get evening => 'Soir (18h–00h)';

  @override
  String get night => 'Nuit (00h–6h)';

  @override
  String get monday => 'Lundi';

  @override
  String get tuesday => 'Mardi';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get thursday => 'Jeudi';

  @override
  String get friday => 'Vendredi';

  @override
  String get saturday => 'Samedi';

  @override
  String get sunday => 'Dimanche';

  @override
  String get heatmap => 'Carte thermique';

  @override
  String get createOffer => 'Créer une offre';

  @override
  String get offerTemplate => 'Modèle d’offre';

  @override
  String get noTemplateYet => 'Aucun modèle pour le moment';

  @override
  String get templateInfo =>
      'Une fois qu’un modèle a été publié par vous, il apparaîtra ici.';

  @override
  String get targetedNotification => 'Notification ciblée';

  @override
  String get step1WriteOffer => 'Étape 1 : Rédigez votre offre';

  @override
  String get exampleOffer =>
      'ex : Venez maintenant et profitez de 15 % de réduction';

  @override
  String get reductionPercent => 'Réduction %';

  @override
  String get validateMinutes => 'Valide (minutes)';

  @override
  String get numberOfUsers => 'Nombre d’utilisateurs';

  @override
  String get step2ChooseTarget => 'Étape 2 : Choisissez votre cible';

  @override
  String get allNearbyUsers => 'Tous les utilisateurs à proximité';

  @override
  String get allActiveUsers => 'Tous les utilisateurs actifs (rayon de 2 km)';

  @override
  String get estimated => 'Estimé :';

  @override
  String get onlineUsers => 'Utilisateurs en ligne';

  @override
  String get notificationAppearance => 'Apparence de la notification';

  @override
  String get saveAsTemplate => 'Enregistrer comme modèle';

  @override
  String get sendNow => 'Envoyer maintenant';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get cuisineType => 'Type de cuisine';

  @override
  String get selectCuisineType => 'Sélectionnez le type de cuisine';

  @override
  String get italian => 'Italienne';

  @override
  String get chinese => 'Chinoise';

  @override
  String get mexican => 'Mexicaine';

  @override
  String get indian => 'Indienne';

  @override
  String get massageRelaxation => 'Massage et relaxation';

  @override
  String get skinTreatmentsFacials => 'Soins de la peau et du visage';

  @override
  String get makeupBeautyServices => 'Maquillage et services de beauté';

  @override
  String get waxingHairRemoval => 'Épilation et soins des poils';

  @override
  String get spaWellnessPackages => 'Forfaits spa et bien-être';

  @override
  String get laserTreatments => 'Traitements au laser';

  @override
  String get tattooPiercingServices => 'Services de tatouage et de piercing';

  @override
  String get eyebrowEyelashTreatments => 'Soins des sourcils et des cils';

  @override
  String get bridalEventPackages => 'Forfaits mariage et événements';

  @override
  String get dermatologyConsultation =>
      'Consultation dermatologique et soins de la peau';

  @override
  String get footHandCare => 'Soins des mains et des pieds';

  @override
  String get hairTransplantScalpServices =>
      'Greffe de cheveux et soins du cuir chevelu';

  @override
  String get servicesType => 'Type de service';

  @override
  String get selectServicesType => 'Sélectionnez le type de service';

  @override
  String get selectAtLeastOneServiceType =>
      'Veuillez sélectionner au moins un type de service.';

  @override
  String get pleasePickImage => 'Veuillez choisir une image';

  @override
  String get mainImage => 'Image principale';

  @override
  String get addImages => 'Ajouter des images';

  @override
  String get allDishesAddedSuccessfully =>
      'Tous les plats ont été ajoutés avec succès';

  @override
  String get noCategoriesAddedYet => 'Aucune catégorie ajoutée pour le moment.';

  @override
  String get tapAddCategoryTitle =>
      'Appuyez sur \' + Ajouter un titre de catégorie\' pour commencer.';

  @override
  String get categoryTitle => 'Titre de la catégorie';

  @override
  String get save => 'Enregistrer';

  @override
  String get editDish => 'Modifier le plat';

  @override
  String get addDish => 'Ajouter un plat';

  @override
  String get day => 'jour';

  @override
  String get slots => 'créneaux';

  @override
  String get slotManagement => 'Gestion des créneaux';

  @override
  String get slotDuration => 'Durée du créneau';

  @override
  String get hour => 'heure';

  @override
  String get selectDuration => 'Sélectionnez la durée';

  @override
  String get pleaseSelectDuration => 'Veuillez sélectionner une durée';

  @override
  String get markUnavailableSlots =>
      'Marquez vos créneaux horaires indisponibles';

  @override
  String get unavailableSlotsDescription =>
      'Sélectionnez les créneaux horaires où vous n’êtes pas disponible chaque jour. Vous pouvez choisir des créneaux individuels ou utiliser \'Tout sélectionner\' pour marquer la journée entière comme indisponible. Appuyez sur \'Enregistrer les modifications\' pour appliquer vos préférences.';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get date => 'Date';

  @override
  String get selectDates => 'Sélectionnez les dates';

  @override
  String get selectTimeSlots => 'Sélectionnez les créneaux horaires';

  @override
  String get descriptionOptional => 'Description (facultative)';

  @override
  String get password => 'Mot de passe';

  @override
  String get closingTimeCannotBeMidnight =>
      'L’heure de fermeture ne peut pas être 00h00';

  @override
  String get closingTimeCannotBeAfter1159 =>
      'L’heure de fermeture ne peut pas être après 23h59';

  @override
  String get closingTimeMustBeAfterOpening =>
      'L’heure de fermeture doit être après l’heure d’ouverture';

  @override
  String get setWeeklyAvailability => 'Définir la disponibilité hebdomadaire';

  @override
  String get weeklyAvailabilityDescription =>
      'Sélectionnez les jours et les heures d’ouverture de votre entreprise. Ce planning se répétera chaque semaine toute l’année. Pour marquer des jours spécifiques comme fermés, utilisez l’onglet d’indisponibilité.';

  @override
  String get selectForAllDay => 'Sélectionner pour toute la journée';

  @override
  String get dayOnOff => 'Jour activé/désactivé';

  @override
  String get closed => 'Fermé';

  @override
  String get pleaseSelectAtLeastOneDay =>
      'Veuillez sélectionner au moins un jour';

  @override
  String get setUpTime => 'Heure de configuration';

  @override
  String get noTimeSlotsFound => 'Aucun créneau horaire trouvé';

  @override
  String get addCategoryTitle => 'Ajouter un titre de catégorie';

  @override
  String get briefDescriptionDish => 'Brève description du plat...';

  @override
  String get typeMessage => 'Tapez un message...';

  @override
  String get upgrade => 'Mettre à niveau';

  @override
  String get reason => 'Raison';

  @override
  String get reservationCanceledMessage =>
      'Votre réservation a été annulée en raison d’un retard à l’arrivée ou d’une circonstance imprévue. Nous nous excusons pour la gêne occasionnée et vous remercions de votre compréhension.';

  @override
  String get bookingId => 'ID de réservation';

  @override
  String get numberOfPersons => 'Nombre de personnes';

  @override
  String get time => 'Heure';

  @override
  String get amount => 'Montant';

  @override
  String get person => 'personne';

  @override
  String get allergyNote =>
      'Allergique aux cacahuètes. Demande une table en extérieur.';

  @override
  String get guests => 'Invités';

  @override
  String get cancelBooking => 'Annuler la réservation';

  @override
  String get cancelBookingConfirmation =>
      'Êtes-vous sûr de vouloir annuler votre réservation ?';

  @override
  String get shareReason => 'Partagez votre raison ici...';

  @override
  String get no => 'Non';

  @override
  String get yes => 'Oui';

  @override
  String get numberOfPersons2 => 'Nombre de personnes';

  @override
  String get nothingToShow => 'Rien à afficher';

  @override
  String get participantsList => 'Liste des participants';

  @override
  String get newGroup => 'Nouveau groupe';

  @override
  String get suggested => 'Suggéré';

  @override
  String get newChat => 'Nouvelle discussion';

  @override
  String get groupChat => 'Discussion de groupe';

  @override
  String get chatWithUpTo50Friends => 'Discutez avec jusqu’à 50 amis';

  @override
  String get read => 'Lu';

  @override
  String get members => 'Membres';

  @override
  String get outOf => 'sur';

  @override
  String get interested => 'Intéressé';

  @override
  String get writeAboutYourself => 'Écrivez quelque chose sur vous...';

  @override
  String get bio => 'Bio';

  @override
  String get showMore => 'Afficher plus';

  @override
  String get friends => 'Amis';

  @override
  String get all => 'Tout';

  @override
  String get mapLocation => 'Carte et emplacement';

  @override
  String get editTimeSlot => 'Modifier le créneau horaire';

  @override
  String get suggestTimeSlot => 'Suggérer un créneau horaire';

  @override
  String get confirm => 'Confirmer';

  @override
  String get pleaseSelectDate => 'Veuillez sélectionner une date';

  @override
  String get pleaseSelectTime => 'Veuillez sélectionner une heure';

  @override
  String get selected => 'Sélectionné';

  @override
  String get selectTime => 'Sélectionner l’heure';

  @override
  String get suggestATimeSlot => 'Suggérer un créneau horaire';

  @override
  String get selectFriends => 'Sélectionner des amis';

  @override
  String get sendInvite => 'Envoyer l’invitation';

  @override
  String get interestDetails => 'Détails de l’intérêt';

  @override
  String get editTime => 'Modifier l’heure';

  @override
  String get reserveNow => 'Réserver maintenant';

  @override
  String get invitees => 'Invités';

  @override
  String get joined => 'A rejoint';

  @override
  String get declined => 'A refusé';

  @override
  String get suggestedDateTime => 'Date et heure suggérées';

  @override
  String get suggestedTime => 'Heure suggérée';

  @override
  String get suggestNewTime => 'Suggérer une nouvelle heure';

  @override
  String get decline => 'Refuser';

  @override
  String get viewDetails => 'Voir les détails';

  @override
  String get reasonOfDecline => 'Raison du refus';

  @override
  String get daysAgo => 'jours auparavant';

  @override
  String get createChoice => 'Créer un choix';

  @override
  String get overallWellnessRating => 'Note globale de bien-être';

  @override
  String get overallLeisureRating => 'Note globale de loisirs';

  @override
  String get choiceCreatedSuccessfully => 'Choix créé avec succès !';

  @override
  String get anyoneCanSeeFeed => 'Tout le monde peut voir le fil';

  @override
  String get friendsOnly => 'Amis uniquement';

  @override
  String get yourFriendsOnChoice => 'Vos amis sur Choice';

  @override
  String get private => 'Privé';

  @override
  String get onlyMe => 'Moi uniquement';

  @override
  String get privateLower => 'privé';

  @override
  String get friendsOnlyLower => 'amis_uniquement';

  @override
  String get publicLower => 'public';

  @override
  String get shareYourExperience => 'Partagez votre expérience';

  @override
  String get tapToSelect => 'Appuyez pour sélectionner';

  @override
  String get select => 'Sélectionner';

  @override
  String get failedToFetchPlaces => 'Échec de la récupération des lieux';

  @override
  String get searchForRestaurant => 'Recherchez un restaurant...';

  @override
  String get searchForWellness => 'Rechercher un bien-être';

  @override
  String get searchForLeisure => 'Rechercher un loisir';

  @override
  String get back => 'Retour';

  @override
  String get changeType => 'Changer le type';

  @override
  String get search => 'Rechercher...';

  @override
  String get whatWouldYouLikeToShare => 'Que souhaitez-vous partager ?';

  @override
  String get imageUploadFailed => 'Échec du téléchargement de l’image';

  @override
  String get phoneNumberMissing => 'Le numéro de téléphone est manquant';

  @override
  String get usernameMissing => 'Le nom d’utilisateur est manquant';

  @override
  String get nameMissing => 'Le nom est manquant';

  @override
  String get failedToRegisterAccount => 'Échec de l’inscription du compte';

  @override
  String get confirmPasswordMissing =>
      'La confirmation du mot de passe est manquante';

  @override
  String get newAndConfirmPasswordNotMatched =>
      'Le nouveau mot de passe et la confirmation ne correspondent pas';

  @override
  String get completeYourRegistration => 'Complétez votre inscription';

  @override
  String get secureYourAccount =>
      'Sécurisez votre compte en ajoutant votre e-mail et votre mot de passe';

  @override
  String get selectType => 'Sélectionnez le type';

  @override
  String get searchAPlace => 'Rechercher un lieu';

  @override
  String get documentSelectedSuccessfully => 'Document sélectionné avec succès';

  @override
  String get failedToUploadDocument => 'Échec du téléchargement du document';

  @override
  String get noPlacesFound => 'Aucun lieu trouvé';

  @override
  String get noFileSelected => 'Aucun fichier sélectionné';

  @override
  String get documentSavedSuccessfully => 'Document enregistré avec succès';

  @override
  String get failedToSaveDocument => 'Échec de l’enregistrement du document';

  @override
  String get unexpectedErrorWhileUploading =>
      'Erreur inattendue lors du téléchargement';

  @override
  String get document => 'Document';

  @override
  String get selectDocument => 'Sélectionner un document';

  @override
  String get pleaseSelectDocumentFirst =>
      'Veuillez d’abord sélectionner un document.';

  @override
  String get pleaseUploadDocumentFirst =>
      'Veuillez d’abord télécharger le document.';

  @override
  String get documentUploadedSuccessfully => 'Document téléchargé avec succès';

  @override
  String get failedToGetUploadUrl =>
      'Échec de l’obtention de l’URL de téléchargement';
}
