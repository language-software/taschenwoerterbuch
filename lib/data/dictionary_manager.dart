import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taschenwoerterbuch/data/dictionary_installer.dart';
import 'package:taschenwoerterbuch/data/dictionary_manifest.dart';
import 'package:taschenwoerterbuch/data/dictionary_providers.dart';

sealed class DictionaryState {
  const DictionaryState();
}

/// Checking installed dictionaries / fetching the manifest.
class DictionaryChecking extends DictionaryState {
  const DictionaryChecking();
}

/// No dictionary installed; [manifest] describes the download.
class DictionaryMissing extends DictionaryState {
  const DictionaryMissing(this.manifest);
  final DictionaryManifest manifest;
}

/// Dictionaries installed and usable; [update] is set if a newer, compatible
/// release exists.
class DictionaryReady extends DictionaryState {
  const DictionaryReady({this.update});
  final DictionaryManifest? update;
}

/// Download in progress; the app is blocked meanwhile.
class DictionaryDownloading extends DictionaryState {
  const DictionaryDownloading(this.progress);
  final double progress;
}

/// A failed check or install.
class DictionaryFailed extends DictionaryState {
  const DictionaryFailed(this.error, {this.manifest, this.hasDictionary});
  final Object error;
  final DictionaryManifest? manifest;

  /// Whether usable dictionaries are installed.
  final bool? hasDictionary;
}

final dictionaryInstallerProvider = Provider<DictionaryInstaller>(
  (ref) => DictionaryInstaller(),
);

final dictionaryManagerProvider =
    NotifierProvider<DictionaryManager, DictionaryState>(DictionaryManager.new);

class DictionaryManager extends Notifier<DictionaryState> {
  @override
  DictionaryState build() {
    Future.microtask(check);
    return const DictionaryChecking();
  }

  DictionaryInstaller get _installer => ref.read(dictionaryInstallerProvider);

  /// Determine installed state and look for updates.
  Future<void> check() async {
    state = const DictionaryChecking();
    try {
      await _check();
    } catch (e) {
      state = DictionaryFailed(e, hasDictionary: false);
    }
  }

  Future<void> _check() async {
    final installed = await _installer.installedVersions();
    DictionaryManifest? manifest;
    try {
      manifest = await _installer.fetchManifest();
    } catch (e) {
      state = installed.isEmpty
          ? DictionaryFailed(e, hasDictionary: false)
          : const DictionaryReady();
      return;
    }
    final compatible = manifest.isCompatible(await _installer.appVersion());
    if (installed.isEmpty) {
      state = compatible
          ? DictionaryMissing(manifest)
          : DictionaryFailed(
              IncompatibleAppException(manifest.minAppVersion),
              hasDictionary: false,
            );
      return;
    }
    final newer = manifest.datasets.values.any(
      (d) => d.version > (installed[d.name] ?? 0),
    );
    state = DictionaryReady(update: compatible && newer ? manifest : null);
  }

  /// Download and install [manifest]; blocks the app while running.
  Future<void> install(DictionaryManifest manifest) async {
    final hadDictionary = (await _installer.installedVersions()).isNotEmpty;
    state = const DictionaryDownloading(0);
    try {
      await _installer.install(
        manifest,
        onProgress: (p) => state = DictionaryDownloading(p),
        beforeReplace: ref.read(dictionaryLoaderProvider).close,
      );
    } catch (e) {
      state = DictionaryFailed(
        e,
        manifest: manifest,
        hasDictionary: hadDictionary,
      );
      return;
    }
    ref.invalidate(dictionaryLoaderProvider);
    state = const DictionaryReady();
  }
}
