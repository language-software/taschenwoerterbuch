// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Taschenwörterbuch';

  @override
  String get searchTitle => 'Wörterbuch';

  @override
  String get searchHint => 'Wort suchen …';

  @override
  String get searchEmptyPrompt => 'Suche nach einem Wort...';

  @override
  String dictionaryLoadError(Object error) {
    return 'Wörterbuch leider nicht ladbar: $error';
  }

  @override
  String entryLoadError(Object error) {
    return 'Eintrag leider nicht ladbar: $error';
  }

  @override
  String get back => '← Zurück';

  @override
  String get senses => 'Bedeutungen';

  @override
  String pluralAbbr(String plural) {
    return 'Plural: $plural';
  }

  @override
  String auxiliaryVerb(String auxiliary) {
    return 'Hilfsverb: $auxiliary';
  }

  @override
  String get audioUnavailable => 'Audio ist nicht verfügbar';

  @override
  String get noInternet => 'Keine Internetverbindung';

  @override
  String get volumeMuted => 'Dein Ton ist stummgeschaltet';

  @override
  String get playPronunciation => 'Aussprache abspielen';

  @override
  String get loading => 'Lädt';

  @override
  String percentValue(int percent) {
    return '$percent %';
  }

  @override
  String get posNoun => 'Nomen';

  @override
  String get posVerb => 'Verb';

  @override
  String get posAdjective => 'Adjektiv';

  @override
  String get posAdverb => 'Adverb';

  @override
  String get posProperNoun => 'Eigenname';

  @override
  String get listen => 'Anhören';

  @override
  String conjugations(String template) {
    return 'Konjugationen (über: $template)';
  }

  @override
  String conjugationLoadError(Object error) {
    return 'Konjugation leider nicht ladbar: $error';
  }

  @override
  String get tenseIndicativePresent => 'Indikativ Présent';

  @override
  String get tenseIndicativeImperfect => 'Indikativ Imparfait';

  @override
  String get tenseIndicativeSimplePast => 'Indikativ Passé simple';

  @override
  String get tenseIndicativeFuture => 'Indikativ Futur simple';

  @override
  String get tenseConditionalPresent => 'Konditional Présent';

  @override
  String get tenseSubjunctivePresent => 'Konjunktiv Présent';

  @override
  String get tenseSubjunctiveImperfect => 'Konjunktiv Imperfekt';

  @override
  String get tenseImperative => 'Imperativ';

  @override
  String get tensePastParticiple => 'Partizip Perfekt';

  @override
  String get tensePresentParticiple => 'Partizip Präsens';
}
