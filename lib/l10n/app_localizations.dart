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
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

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

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'WelcomeBack'**
  String get welcomeBack;

  /// No description provided for @search_for_technician.
  ///
  /// In en, this message translates to:
  /// **'Search For Technician'**
  String get search_for_technician;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logOut;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forget_password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don’t have account?'**
  String get dont_have_account;

  /// No description provided for @login_with_google.
  ///
  /// In en, this message translates to:
  /// **'Login With Google'**
  String get login_with_google;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @profix.
  ///
  /// In en, this message translates to:
  /// **'PROFIX'**
  String get profix;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @re_password.
  ///
  /// In en, this message translates to:
  /// **'Re Password'**
  String get re_password;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have account?'**
  String get already_have_account;

  /// No description provided for @reSetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reSetPassword;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @newRequests.
  ///
  /// In en, this message translates to:
  /// **'New Requests'**
  String get newRequests;

  /// No description provided for @statusUpdates.
  ///
  /// In en, this message translates to:
  /// **'Statues Update'**
  String get statusUpdates;

  /// No description provided for @newMessages.
  ///
  /// In en, this message translates to:
  /// **'New Messages'**
  String get newMessages;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @serviceAreas.
  ///
  /// In en, this message translates to:
  /// **'Service Areas'**
  String get serviceAreas;

  /// No description provided for @selectAreas.
  ///
  /// In en, this message translates to:
  /// **'Select the areas where you provide services.'**
  String get selectAreas;

  /// No description provided for @saveAreas.
  ///
  /// In en, this message translates to:
  /// **'Save Areas'**
  String get saveAreas;

  /// No description provided for @downtown.
  ///
  /// In en, this message translates to:
  /// **'Downtown'**
  String get downtown;

  /// No description provided for @midtown.
  ///
  /// In en, this message translates to:
  /// **'Midtown'**
  String get midtown;

  /// No description provided for @uptown.
  ///
  /// In en, this message translates to:
  /// **'Uptown'**
  String get uptown;

  /// No description provided for @eastSide.
  ///
  /// In en, this message translates to:
  /// **'East Side'**
  String get eastSide;

  /// No description provided for @westSide.
  ///
  /// In en, this message translates to:
  /// **'West Side'**
  String get westSide;

  /// No description provided for @northDistrict.
  ///
  /// In en, this message translates to:
  /// **'North District'**
  String get northDistrict;

  /// No description provided for @southDistrict.
  ///
  /// In en, this message translates to:
  /// **'South District'**
  String get southDistrict;

  /// No description provided for @industrialZone.
  ///
  /// In en, this message translates to:
  /// **'Industrial Zone'**
  String get industrialZone;

  /// No description provided for @suburbanArea.
  ///
  /// In en, this message translates to:
  /// **'Suburban Area'**
  String get suburbanArea;

  /// No description provided for @businessDistrict.
  ///
  /// In en, this message translates to:
  /// **'Business District'**
  String get businessDistrict;

  /// No description provided for @pleaseSelectArea.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one service area'**
  String get pleaseSelectArea;

  /// No description provided for @serviceAreasUpdated.
  ///
  /// In en, this message translates to:
  /// **'Service areas updated successfully!'**
  String get serviceAreasUpdated;

  /// No description provided for @failedToUpdateAreas.
  ///
  /// In en, this message translates to:
  /// **'Failed to update service areas'**
  String get failedToUpdateAreas;

  /// No description provided for @customerReviews.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get customerReviews;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @emailCannotBeChanged.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be changed'**
  String get emailCannotBeChanged;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @defaultAddress.
  ///
  /// In en, this message translates to:
  /// **'Default Address'**
  String get defaultAddress;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @tapToChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap camera to change photo'**
  String get tapToChangePhoto;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// No description provided for @enterDefaultAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your default address'**
  String get enterDefaultAddress;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @technician.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get technician;

  /// No description provided for @no_internet.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get no_internet;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @login_successful.
  ///
  /// In en, this message translates to:
  /// **'Login successful! Welcome back'**
  String get login_successful;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @invalid_credentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please check your credentials and try again.'**
  String get invalid_credentials;

  /// No description provided for @network_error.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection and try again.'**
  String get network_error;

  /// No description provided for @user_not_found.
  ///
  /// In en, this message translates to:
  /// **'User not found. Please check your email or register for a new account.'**
  String get user_not_found;

  /// No description provided for @account_suspended.
  ///
  /// In en, this message translates to:
  /// **'Your account has been suspended. Please contact support.'**
  String get account_suspended;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @find_skilled_technicians.
  ///
  /// In en, this message translates to:
  /// **'Find skilled technicians for your home repairs'**
  String get find_skilled_technicians;

  /// No description provided for @offer_services_and_earn.
  ///
  /// In en, this message translates to:
  /// **'Offer your services and earn money'**
  String get offer_services_and_earn;

  /// No description provided for @continue_as.
  ///
  /// In en, this message translates to:
  /// **'Continue as'**
  String get continue_as;

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get coming_soon;

  /// No description provided for @request_accepted.
  ///
  /// In en, this message translates to:
  /// **'Request accepted!'**
  String get request_accepted;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @find.
  ///
  /// In en, this message translates to:
  /// **'Find'**
  String get find;

  /// No description provided for @my_jobs.
  ///
  /// In en, this message translates to:
  /// **'My Jobs'**
  String get my_jobs;

  /// No description provided for @customer_login.
  ///
  /// In en, this message translates to:
  /// **'Customer Login'**
  String get customer_login;

  /// No description provided for @technician_login.
  ///
  /// In en, this message translates to:
  /// **'Technician Login'**
  String get technician_login;

  /// No description provided for @welcome_to_profix.
  ///
  /// In en, this message translates to:
  /// **'Welcome to ProFix'**
  String get welcome_to_profix;

  /// No description provided for @your_trusted_platform.
  ///
  /// In en, this message translates to:
  /// **'Your trusted home services platform'**
  String get your_trusted_platform;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @test_accounts.
  ///
  /// In en, this message translates to:
  /// **'Test Accounts'**
  String get test_accounts;

  /// No description provided for @customer_test.
  ///
  /// In en, this message translates to:
  /// **'Customer: customer@test.com'**
  String get customer_test;

  /// No description provided for @technician_test.
  ///
  /// In en, this message translates to:
  /// **'Technician: tech@test.com'**
  String get technician_test;

  /// No description provided for @test_password.
  ///
  /// In en, this message translates to:
  /// **'Password: password123'**
  String get test_password;
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
