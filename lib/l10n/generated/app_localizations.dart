import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  static const List<Locale> supportedLocales = <Locale>[Locale('de')];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Taschenwörterbuch'**
  String get appTitle;

  /// No description provided for @searchTitle.
  ///
  /// In de, this message translates to:
  /// **'Wörterbuch'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In de, this message translates to:
  /// **'Wort suchen …'**
  String get searchHint;

  /// No description provided for @searchEmptyPrompt.
  ///
  /// In de, this message translates to:
  /// **'Suche nach einem Wort...'**
  String get searchEmptyPrompt;

  /// No description provided for @dictionaryLoadError.
  ///
  /// In de, this message translates to:
  /// **'Wörterbuch leider nicht ladbar: {error}'**
  String dictionaryLoadError(Object error);

  /// No description provided for @entryLoadError.
  ///
  /// In de, this message translates to:
  /// **'Eintrag leider nicht ladbar: {error}'**
  String entryLoadError(Object error);

  /// No description provided for @back.
  ///
  /// In de, this message translates to:
  /// **'← Zurück'**
  String get back;

  /// No description provided for @senses.
  ///
  /// In de, this message translates to:
  /// **'Bedeutungen'**
  String get senses;

  /// No description provided for @pluralAbbr.
  ///
  /// In de, this message translates to:
  /// **'Plural: {plural}'**
  String pluralAbbr(String plural);

  /// No description provided for @auxiliaryVerb.
  ///
  /// In de, this message translates to:
  /// **'Hilfsverb: {auxiliary}'**
  String auxiliaryVerb(String auxiliary);

  /// No description provided for @audioUnavailable.
  ///
  /// In de, this message translates to:
  /// **'Audio ist nicht verfügbar'**
  String get audioUnavailable;

  /// No description provided for @noInternet.
  ///
  /// In de, this message translates to:
  /// **'Keine Internetverbindung'**
  String get noInternet;

  /// No description provided for @volumeMuted.
  ///
  /// In de, this message translates to:
  /// **'Dein Ton ist stummgeschaltet'**
  String get volumeMuted;

  /// No description provided for @playPronunciation.
  ///
  /// In de, this message translates to:
  /// **'Aussprache abspielen'**
  String get playPronunciation;

  /// No description provided for @loading.
  ///
  /// In de, this message translates to:
  /// **'Lädt'**
  String get loading;

  /// No description provided for @percentValue.
  ///
  /// In de, this message translates to:
  /// **'{percent} %'**
  String percentValue(int percent);

  /// No description provided for @posNoun.
  ///
  /// In de, this message translates to:
  /// **'Nomen'**
  String get posNoun;

  /// No description provided for @posVerb.
  ///
  /// In de, this message translates to:
  /// **'Verb'**
  String get posVerb;

  /// No description provided for @posAdjective.
  ///
  /// In de, this message translates to:
  /// **'Adjektiv'**
  String get posAdjective;

  /// No description provided for @posAdverb.
  ///
  /// In de, this message translates to:
  /// **'Adverb'**
  String get posAdverb;

  /// No description provided for @posProperNoun.
  ///
  /// In de, this message translates to:
  /// **'Eigenname'**
  String get posProperNoun;

  /// No description provided for @listen.
  ///
  /// In de, this message translates to:
  /// **'Anhören'**
  String get listen;

  /// No description provided for @conjugations.
  ///
  /// In de, this message translates to:
  /// **'Konjugationen (über: {template})'**
  String conjugations(String template);

  /// No description provided for @conjugationLoadError.
  ///
  /// In de, this message translates to:
  /// **'Konjugation leider nicht ladbar: {error}'**
  String conjugationLoadError(Object error);

  /// No description provided for @tenseIndicativePresent.
  ///
  /// In de, this message translates to:
  /// **'Indikativ Présent'**
  String get tenseIndicativePresent;

  /// No description provided for @tenseIndicativeImperfect.
  ///
  /// In de, this message translates to:
  /// **'Indikativ Imparfait'**
  String get tenseIndicativeImperfect;

  /// No description provided for @tenseIndicativeSimplePast.
  ///
  /// In de, this message translates to:
  /// **'Indikativ Passé simple'**
  String get tenseIndicativeSimplePast;

  /// No description provided for @tenseIndicativeFuture.
  ///
  /// In de, this message translates to:
  /// **'Indikativ Futur simple'**
  String get tenseIndicativeFuture;

  /// No description provided for @tenseConditionalPresent.
  ///
  /// In de, this message translates to:
  /// **'Konditional Présent'**
  String get tenseConditionalPresent;

  /// No description provided for @tenseSubjunctivePresent.
  ///
  /// In de, this message translates to:
  /// **'Konjunktiv Présent'**
  String get tenseSubjunctivePresent;

  /// No description provided for @tenseSubjunctiveImperfect.
  ///
  /// In de, this message translates to:
  /// **'Konjunktiv Imperfekt'**
  String get tenseSubjunctiveImperfect;

  /// No description provided for @tenseImperative.
  ///
  /// In de, this message translates to:
  /// **'Imperativ'**
  String get tenseImperative;

  /// No description provided for @tensePastParticiple.
  ///
  /// In de, this message translates to:
  /// **'Partizip Perfekt'**
  String get tensePastParticiple;

  /// No description provided for @tensePresentParticiple.
  ///
  /// In de, this message translates to:
  /// **'Partizip Präsens'**
  String get tensePresentParticiple;
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
      <String>['de'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
