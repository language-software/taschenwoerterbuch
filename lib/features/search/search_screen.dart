import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/data/dictionary_installer.dart';
import 'package:taschenwoerterbuch/data/dictionary_manager.dart';
import 'package:taschenwoerterbuch/data/dictionary_manifest.dart';
import 'package:taschenwoerterbuch/data/models/lang_pair.dart';
import 'package:taschenwoerterbuch/features/detail/detail_screen.dart';
import 'package:taschenwoerterbuch/features/search/search_controller.dart';
import 'package:taschenwoerterbuch/features/search/widgets/direction_switch.dart';
import 'package:taschenwoerterbuch/features/search/widgets/dictionary_status_view.dart';
import 'package:taschenwoerterbuch/features/search/widgets/search_bar_bottom.dart';
import 'package:taschenwoerterbuch/features/search/widgets/search_row.dart';
import 'package:taschenwoerterbuch/l10n/generated/app_localizations.dart';

import '../../shared/widgets/sketch_dialog.dart';
import '../../shared/widgets/sketch_divider.dart';
import '../../shared/widgets/sketch_text_button.dart';
import '../../shared/widgets/sketch_progress_indicator.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchTextController = TextEditingController();
  LangPair _pair = LangPair.frDe;

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(_onQueryChanged);
  }

  void _onQueryChanged() {
    ref
        .read(searchControllerProvider.notifier)
        .search(_searchTextController.text);
  }

  void _togglePair() {
    setState(() => _pair = _pair.reversed);
    ref.read(searchControllerProvider.notifier).setPair(_pair);
    _onQueryChanged();
  }

  void _openDetail(SearchHit hit) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DetailScreen(
          entryIds: [for (final e in hit.entries) e.id],
          pair: _pair,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchTextController.removeListener(_onQueryChanged);
    _searchTextController.dispose();
    super.dispose();
  }

  Future<void> _confirmUpdate(DictionaryManifest manifest) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showSketchDialog<bool>(
      context: context,
      title: l10n.dictionaryUpdateTitle,
      content: Text(
        l10n.dictionaryUpdateBody(formatMegabytes(manifest.totalSize)),
      ),
      actions: [
        Builder(
          builder: (ctx) => SketchTextButton(
            label: l10n.cancel,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
        ),
        Builder(
          builder: (ctx) => SketchTextButton(
            label: l10n.dictionaryUpdateConfirm,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ),
      ],
    );
    if (confirmed == true) {
      ref.read(dictionaryManagerProvider.notifier).install(manifest);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final manager = ref.watch(dictionaryManagerProvider);
    final notifier = ref.read(dictionaryManagerProvider.notifier);
    ref.listen(dictionaryManagerProvider, (prev, next) {
      if (next is DictionaryFailed && next.hasDictionary == true) {
        final message = switch (next.error) {
          HashMismatchException() => l10n.dictionaryErrorHash,
          IncompatibleAppException(:final minAppVersion) =>
            l10n.dictionaryErrorIncompatible(minAppVersion),
          _ => l10n.dictionaryErrorNetwork,
        };
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    });

    final update = manager is DictionaryReady ? manager.update : null;
    final usable =
        manager is DictionaryReady ||
        (manager is DictionaryFailed && manager.hasDictionary == true);

    final body = switch (manager) {
      DictionaryChecking() ||
      DictionaryDownloading() => const Center(child: SketchSpinner()),
      DictionaryMissing(:final manifest) => DictionaryMissingView(
        manifest: manifest,
        onDownload: () => notifier.install(manifest),
      ),
      DictionaryFailed(:final error, :final manifest, hasDictionary: false) =>
        DictionaryErrorView(
          error: error,
          onRetry: () =>
              manifest != null ? notifier.install(manifest) : notifier.check(),
        ),
      _ => _buildSearchBody(l10n),
    };

    return PopScope(
      canPop: manager is! DictionaryDownloading,
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Semantics(
                            header: true,
                            child: Text(
                              l10n.searchTitle,
                              style: AppTypography.headlineSerif.copyWith(
                                color: context.colors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        if (update != null)
                          SketchTextButton(
                            label: l10n.dictionaryUpdates,
                            onPressed: () => _confirmUpdate(update),
                          ),
                      ],
                    ),
                    Expanded(child: body),
                    if (usable)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DirectionSwitch(pair: _pair, onPressed: _togglePair),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SearchBarBottom(
                              controller: _searchTextController,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            if (manager is DictionaryDownloading)
              DictionaryDownloadOverlay(progress: manager.progress),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBody(AppLocalizations l10n) {
    final hits = ref.watch(searchControllerProvider);
    return hits.when(
      data: (list) => ValueListenableBuilder(
        valueListenable: _searchTextController,
        builder: (context, value, _) {
          if (value.text.trim().isEmpty) {
            return Center(
              child: Text(
                l10n.searchEmptyPrompt,
                style: AppTypography.body.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (context, i) => SketchDivider(seed: i + 1),
            itemBuilder: (context, i) =>
                SearchRow(hit: list[i], onTap: () => _openDetail(list[i])),
          );
        },
      ),
      loading: () => const Center(child: SketchSpinner()),
      error: (e, _) => Text(l10n.dictionaryLoadError(e)),
    );
  }
}
