import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover Egypt'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get navTrips;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @marketplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplaceTitle;

  /// No description provided for @marketplaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book hotels, apartments, tours, guides, cars, attractions, and restaurants from one place.'**
  String get marketplaceSubtitle;

  /// No description provided for @featuredListings.
  ///
  /// In en, this message translates to:
  /// **'Featured listings'**
  String get featuredListings;

  /// No description provided for @browseByCategory.
  ///
  /// In en, this message translates to:
  /// **'Browse by category'**
  String get browseByCategory;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Egypt'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search hotels, tours, attractions, and more'**
  String get searchHint;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No listings matched your filters.'**
  String get searchEmpty;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @listingDetails.
  ///
  /// In en, this message translates to:
  /// **'Listing details'**
  String get listingDetails;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get bookNow;

  /// No description provided for @saveToTrip.
  ///
  /// In en, this message translates to:
  /// **'Add to itinerary'**
  String get saveToTrip;

  /// No description provided for @savedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get savedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @itineraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Planner'**
  String get itineraryTitle;

  /// No description provided for @itineraryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Start adding stays and experiences to build your Egypt itinerary.'**
  String get itineraryEmpty;

  /// No description provided for @itinerarySummary.
  ///
  /// In en, this message translates to:
  /// **'Trip summary'**
  String get itinerarySummary;

  /// No description provided for @estimatedSpend.
  ///
  /// In en, this message translates to:
  /// **'Estimated spend'**
  String get estimatedSpend;

  /// No description provided for @vendorDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Vendor Dashboard'**
  String get vendorDashboardTitle;

  /// No description provided for @vendorCreateListing.
  ///
  /// In en, this message translates to:
  /// **'Create listing'**
  String get vendorCreateListing;

  /// No description provided for @vendorListings.
  ///
  /// In en, this message translates to:
  /// **'Your listings'**
  String get vendorListings;

  /// No description provided for @vendorPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending approval'**
  String get vendorPendingApproval;

  /// No description provided for @vendorApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get vendorApproved;

  /// No description provided for @vendorDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get vendorDraft;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboardTitle;

  /// No description provided for @staffDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Internal Staff'**
  String get staffDashboardTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @workspaceMode.
  ///
  /// In en, this message translates to:
  /// **'Workspace mode'**
  String get workspaceMode;

  /// No description provided for @workspaceModeHelp.
  ///
  /// In en, this message translates to:
  /// **'Preview tourist, vendor, admin, and staff experiences locally until backend role claims are connected.'**
  String get workspaceModeHelp;

  /// No description provided for @touristRole.
  ///
  /// In en, this message translates to:
  /// **'Tourist'**
  String get touristRole;

  /// No description provided for @vendorRole.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get vendorRole;

  /// No description provided for @adminRole.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminRole;

  /// No description provided for @staffRole.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffRole;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @supportTickets.
  ///
  /// In en, this message translates to:
  /// **'Support tickets'**
  String get supportTickets;

  /// No description provided for @approvalQueue.
  ///
  /// In en, this message translates to:
  /// **'Approval queue'**
  String get approvalQueue;

  /// No description provided for @secureSessionActive.
  ///
  /// In en, this message translates to:
  /// **'Secure session storage is active.'**
  String get secureSessionActive;

  /// No description provided for @reviewInAdmin.
  ///
  /// In en, this message translates to:
  /// **'Review in admin'**
  String get reviewInAdmin;

  /// No description provided for @submitForReview.
  ///
  /// In en, this message translates to:
  /// **'Submit for review'**
  String get submitForReview;

  /// No description provided for @approvedStatus.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approvedStatus;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @draftStatus.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draftStatus;

  /// No description provided for @resolveTicket.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolveTicket;

  /// No description provided for @moveToInProgress.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get moveToInProgress;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to dashboard'**
  String get backToDashboard;

  /// No description provided for @startExploring.
  ///
  /// In en, this message translates to:
  /// **'Start exploring'**
  String get startExploring;

  /// No description provided for @bookableCategoriesNotice.
  ///
  /// In en, this message translates to:
  /// **'Restaurants are discoverable and reviewable in v1. Other categories are bookable.'**
  String get bookableCategoriesNotice;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
