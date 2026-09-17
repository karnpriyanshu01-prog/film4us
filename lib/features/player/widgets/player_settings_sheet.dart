import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Bottom sheet offering quality / audio / subtitle selection.
///
/// This phase only demonstrates the UI: the mock source exposes a
/// single stream, so switching selections here does not yet reload a
/// different underlying video — the backend will supply real
/// per-selection URLs in a future iteration.
class PlayerSettingsSheet extends StatelessWidget {
  final List<String> qualities;
  final String selectedQuality;
  final ValueChanged<String> onQualitySelected;

  final List<String> audioTracks;
  final String selectedAudio;
  final ValueChanged<String> onAudioSelected;

  final List<String> subtitles;
  final String selectedSubtitle;
  final ValueChanged<String> onSubtitleSelected;

  const PlayerSettingsSheet({
    super.key,
    required this.qualities,
    required this.selectedQuality,
    required this.onQualitySelected,
    required this.audioTracks,
    required this.selectedAudio,
    required this.onAudioSelected,
    required this.subtitles,
    required this.selectedSubtitle,
    required this.onSubtitleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              _SettingsSection(
                title: 'Quality',
                options: qualities,
                selected: selectedQuality,
                onSelected: onQualitySelected,
              ),
              const Divider(height: 24),
              _SettingsSection(
                title: 'Audio',
                options: audioTracks,
                selected: selectedAudio,
                onSelected: onAudioSelected,
              ),
              const Divider(height: 24),
              _SettingsSection(
                title: 'Subtitles',
                options: subtitles,
                selected: selectedSubtitle,
                onSelected: onSubtitleSelected,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const _SettingsSection({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        ...options.map(
          (option) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            dense: true,
            leading: Icon(
              option == selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: option == selected ? AppColors.accent : AppColors.textSecondary,
            ),
            title: Text(option),
            onTap: () {
              onSelected(option);
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
