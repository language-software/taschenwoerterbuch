import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:taschenwoerterbuch/l10n/generated/app_localizations.dart';
import 'package:volume_controller/volume_controller.dart';

import '../../../shared/widgets/sketch_text_button.dart';

/// Speaker button that plays the related audio file.
class SpeakerButton extends StatefulWidget {
  const SpeakerButton({super.key, required this.audioUrl});

  final String audioUrl;

  @override
  State<SpeakerButton> createState() => _SpeakerButtonState();
}

class _SpeakerButtonState extends State<SpeakerButton> {
  final _player = AudioPlayer();

  /// Checks whether an internet connection exists.
  Future<bool> _isConnected() async {
    final connectivity = await Connectivity().checkConnectivity();
    return !connectivity.every((c) => c == ConnectivityResult.none);
  }

  /// Checks whether the audio is muted.
  Future<bool> _isMuted() async {
    return await VolumeController.instance.getVolume() <= 0;
  }

  /// Checks whether an internet connection exists and the volume is set up.
  Future<bool> _canPlay(
    ScaffoldMessengerState messenger,
    AppLocalizations l10n,
  ) async {
    if (! await _isConnected()) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.noInternet)));
      return false;
    }
    if (await _isMuted()) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.volumeMuted)));
      return false;
    }
    return true;
  }

  /// Plays audio if playback is possible.
  Future<void> _play() async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      if (!await _canPlay(messenger, l10n)) return;
      await _player.setUrl(widget.audioUrl);
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.audioUnavailable)));
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: l10n.playPronunciation,
      child: SketchTextButton(label: l10n.listen, onPressed: _play),
    );
  }
}
