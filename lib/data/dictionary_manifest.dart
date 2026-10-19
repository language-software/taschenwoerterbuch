/// One downloadable dictionary of a release manifest.
class DatasetInfo {
  const DatasetInfo({
    required this.name,
    required this.version,
    required this.schema,
    required this.url,
    required this.sha256,
    required this.size,
  });

  factory DatasetInfo.fromJson(String name, Map<String, dynamic> json) =>
      DatasetInfo(
        name: name,
        version: json['version'] as int,
        schema: json['schema'] as int,
        url: json['url'] as String,
        sha256: (json['sha256'] as String).toLowerCase(),
        size: json['size'] as int,
      );

  /// Dataset name, e.g. `dictionary-fr-de`.
  final String name;
  final int version;
  final int schema;

  /// Download URL of the gzipped database.
  final String url;

  /// SHA-256 of the gzipped download.
  final String sha256;

  /// Download size in bytes.
  final int size;
}

/// Manifest of a dictionary release.
class DictionaryManifest {
  const DictionaryManifest({
    required this.minAppVersion,
    required this.datasets,
  });

  factory DictionaryManifest.fromJson(Map<String, dynamic> json) {
    final raw = json['datasets'] as Map<String, dynamic>;
    return DictionaryManifest(
      minAppVersion: json['min_app_version'] as String,
      datasets: {
        for (final e in raw.entries)
          e.key: DatasetInfo.fromJson(e.key, e.value as Map<String, dynamic>),
      },
    );
  }

  final String minAppVersion;
  final Map<String, DatasetInfo> datasets;

  /// Total download size in bytes.
  int get totalSize => datasets.values.fold(0, (sum, d) => sum + d.size);

  /// Whether an app with [appVersion] may install this release.
  bool isCompatible(String appVersion) =>
      compareVersions(appVersion, minAppVersion) >= 0;
}

/// Compares dotted numeric versions (ignores build/pre-release suffixes).
int compareVersions(String a, String b) {
  List<int> parse(String v) => v
      .split(RegExp(r'[+-]'))
      .first
      .split('.')
      .map((s) => int.tryParse(s) ?? 0)
      .toList();
  final pa = parse(a), pb = parse(b);
  for (var i = 0; i < pa.length || i < pb.length; i++) {
    final x = i < pa.length ? pa[i] : 0;
    final y = i < pb.length ? pb[i] : 0;
    if (x != y) return x.compareTo(y);
  }
  return 0;
}
