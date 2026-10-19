import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:taschenwoerterbuch/data/models/lang_pair.dart';

/// This class is used to get the correct dictionary.
/// The dictionaries are downloaded from GitHub releases by
/// [DictionaryInstaller] into the application support directory.
class Paths {
  Paths._();

  /// Get file name for dictionary for given [LangPair].
  static String _dictionaryFileName(LangPair pair) => switch (pair) {
    LangPair.frDe => 'dictionary-fr-de.db',
    LangPair.deFr => 'dictionary-de-fr.db',
  };

  /// Get dictionary file for given [LangPair].
  static Future<String> dictionaryFile(LangPair pair) async {
    final dir = await getApplicationSupportDirectory();
    return p.join(dir.path, 'dictionaries', _dictionaryFileName(pair));
  }
}
