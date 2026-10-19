import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/data/dictionary_installer.dart';
import 'package:taschenwoerterbuch/data/dictionary_manifest.dart';
import 'package:taschenwoerterbuch/l10n/generated/app_localizations.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_button.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_progress_indicator.dart';

String formatMegabytes(int bytes) => (bytes / (1000 * 1000)).toStringAsFixed(1);

/// Message shown when no dictionary is installed (yet).
class DictionaryMissingView extends StatelessWidget {
  const DictionaryMissingView({
    super.key,
    required this.manifest,
    required this.onDownload,
  });

  final DictionaryManifest manifest;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Centered(
      children: [
        Text(
          l10n.dictionaryDownloadPrompt,
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(color: context.colors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.dictionaryDownloadSize(formatMegabytes(manifest.totalSize)),
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        SketchButton(label: l10n.dictionaryDownload, onPressed: onDownload),
      ],
    );
  }
}

/// Error message with retry.
class DictionaryErrorView extends StatelessWidget {
  const DictionaryErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = switch (error) {
      HashMismatchException() => l10n.dictionaryErrorHash,
      IncompatibleAppException(:final minAppVersion) =>
        l10n.dictionaryErrorIncompatible(minAppVersion),
      _ => l10n.dictionaryErrorNetwork,
    };
    return _Centered(
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(color: context.colors.textPrimary),
        ),
        if (error is! IncompatibleAppException) ...[
          const SizedBox(height: 24),
          SketchButton(label: l10n.dictionaryRetry, onPressed: onRetry),
        ],
      ],
    );
  }
}

/// Full-screen blocking overlay shown while downloading.
class DictionaryDownloadOverlay extends StatelessWidget {
  const DictionaryDownloadOverlay({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Positioned.fill(
      child: AbsorbPointer(
        child: ColoredBox(
          color: context.colors.background,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: _Centered(
              children: [
                Text(
                  l10n.dictionaryDownloading,
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                SketchProgressBar(value: progress),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: children),
  );
}
