import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:taschenwoerterbuch/data/dictionary_manifest.dart';

const manifestUrl =
    'https://github.com/language-software/taschenwoerterbuch-database/releases/latest/download/manifest.json';

class HashMismatchException implements Exception {
  const HashMismatchException(this.name);

  final String name;

  @override
  String toString() => 'Hash mismatch for $name';
}

class IncompatibleAppException implements Exception {
  const IncompatibleAppException(this.minAppVersion);

  final String minAppVersion;

  @override
  String toString() => 'App version too old, need >= $minAppVersion';
}

/// Fetches the release manifest and installs dictionaries.
class DictionaryInstaller {
  DictionaryInstaller({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<Directory> _dir() async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory(p.join(base.path, 'dictionaries'));
    await dir.create(recursive: true);
    return dir;
  }

  Future<File> _versionFile() async =>
      File(p.join((await _dir()).path, 'installed.json'));

  Future<String> appVersion() async =>
      (await PackageInfo.fromPlatform()).version;

  Future<DictionaryManifest> fetchManifest() async {
    final res = await _client
        .get(Uri.parse(manifestUrl))
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw HttpException('Manifest: HTTP ${res.statusCode}');
    }
    return DictionaryManifest.fromJson(
      jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
    );
  }

  /// Installed dataset versions; only datasets whose file exists.
  Future<Map<String, int>> installedVersions() async {
    final file = await _versionFile();
    if (!await file.exists()) return {};
    try {
      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final dir = await _dir();
      return {
        for (final e in json.entries)
          if (await File(p.join(dir.path, '${e.key}.db')).exists())
            e.key: e.value as int,
      };
    } catch (_) {
      return {};
    }
  }

  /// Download, verify and install all datasets of [manifest].
  ///
  /// Nothing is replaced until every dataset has been downloaded and
  /// verified. [beforeReplace] is called right before the files are swapped
  /// so that open databases can be closed.
  Future<void> install(
    DictionaryManifest manifest, {
    required void Function(double progress) onProgress,
    required Future<void> Function() beforeReplace,
  }) async {
    final appVer = await appVersion();
    if (!manifest.isCompatible(appVer)) {
      throw IncompatibleAppException(manifest.minAppVersion);
    }

    final dir = await _dir();
    final total = manifest.totalSize;
    var done = 0;
    final staged = <DatasetInfo, File>{};
    try {
      for (final ds in manifest.datasets.values) {
        final gz = File(p.join(dir.path, '${ds.name}.db.gz.tmp'));
        await _download(ds, gz, (bytes) {
          onProgress((done + bytes) / total * 0.95);
        });
        done += ds.size;

        if (await _sha256(gz) != ds.sha256) {
          throw HashMismatchException(ds.name);
        }
        final db = File(p.join(dir.path, '${ds.name}.db.tmp'));
        await _gunzip(gz, db);
        await gz.delete();
        staged[ds] = db;
      }

      await beforeReplace();
      for (final e in staged.entries) {
        await e.value.rename(p.join(dir.path, '${e.key.name}.db'));
      }
      final versions = {
        ...await installedVersions(),
        for (final ds in manifest.datasets.values) ds.name: ds.version,
      };
      await (await _versionFile()).writeAsString(jsonEncode(versions));
      onProgress(1);
    } finally {
      for (final f in dir.listSync().whereType<File>()) {
        if (f.path.endsWith('.tmp')) await f.delete();
      }
    }
  }

  Future<void> _download(
    DatasetInfo ds,
    File target,
    void Function(int bytes) onBytes,
  ) async {
    final res = await _client.send(http.Request('GET', Uri.parse(ds.url)));
    if (res.statusCode != 200) {
      throw HttpException('${ds.name}: HTTP ${res.statusCode}');
    }
    final sink = target.openWrite();
    var received = 0;
    try {
      await for (final chunk in res.stream) {
        sink.add(chunk);
        received += chunk.length;
        onBytes(received);
      }
      await sink.flush();
    } finally {
      await sink.close();
    }
  }

  Future<String> _sha256(File file) async =>
      (await sha256.bind(file.openRead()).first).toString();

  Future<void> _gunzip(File src, File dst) async {
    final sink = dst.openWrite();
    try {
      await sink.addStream(src.openRead().transform(gzip.decoder));
    } finally {
      await sink.close();
    }
  }
}
