import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../core/theme/app_colors.dart';

/// Auto-hiding, dark cinematic controls drawn on top of the video.
///
/// Purely presentational — all playback actions are delegated back to
/// the parent [PlayerScreen] via callbacks.
class PlayerControlsOverlay extends StatelessWidget {
  final String title;
  final VideoPlayerValue value;
  final bool isBuffering;
  final double volume;
  final VoidCallback onClose;
  final VoidCallback onPlayPause;
  final VoidCallback onRewind;
  final VoidCallback onForward;
  final VoidCallback onFullscreenToggle;
  final VoidCallback onSettingsTap;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<Duration> onSeek;
  final bool isFullscreen;

  const PlayerControlsOverlay({
    super.key,
    required this.title,
    required this.value,
    required this.isBuffering,
    required this.volume,
    required this.onClose,
    required this.onPlayPause,
    required this.onRewind,
    required this.onForward,
    required this.onFullscreenToggle,
    required this.onSettingsTap,
    required this.onVolumeChanged,
    required this.onSeek,
    required this.isFullscreen,
  });

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = d.inHours;
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final position = value.position;
    final duration = value.duration;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black54, Colors.transparent, Colors.black87],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Column(
        children: [
          _TopBar(title: title, onClose: onClose),
          const Spacer(),
          if (isBuffering)
            const CircularProgressIndicator(color: AppColors.accent)
          else
            _CenterControls(onRewind: onRewind, onForward: onForward, onPlayPause: onPlayPause, isPlaying: value.isPlaying),
          const Spacer(),
          _BottomBar(
            position: position,
            duration: duration,
            volume: volume,
            isFullscreen: isFullscreen,
            onSeek: onSeek,
            onVolumeChanged: onVolumeChanged,
            onFullscreenToggle: onFullscreenToggle,
            onSettingsTap: onSettingsTap,
            formatDuration: _formatDuration,
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  const _TopBar({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onClose,
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterControls extends StatelessWidget {
  final VoidCallback onRewind;
  final VoidCallback onForward;
  final VoidCallback onPlayPause;
  final bool isPlaying;

  const _CenterControls({
    required this.onRewind,
    required this.onForward,
    required this.onPlayPause,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.replay_10, color: Colors.white),
          onPressed: onRewind,
        ),
        const SizedBox(width: 24),
        IconButton(
          iconSize: 56,
          icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: Colors.white),
          onPressed: onPlayPause,
        ),
        const SizedBox(width: 24),
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.forward_10, color: Colors.white),
          onPressed: onForward,
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final double volume;
  final bool isFullscreen;
  final ValueChanged<Duration> onSeek;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback onFullscreenToggle;
  final VoidCallback onSettingsTap;
  final String Function(Duration) formatDuration;

  const _BottomBar({
    required this.position,
    required this.duration,
    required this.volume,
    required this.isFullscreen,
    required this.onSeek,
    required this.onVolumeChanged,
    required this.onFullscreenToggle,
    required this.onSettingsTap,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final maxMs = duration.inMilliseconds.clamp(1, double.maxFinite.toInt()).toDouble();
    final valueMs = position.inMilliseconds.clamp(0, maxMs.toInt()).toDouble();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                activeTrackColor: AppColors.accent,
                inactiveTrackColor: Colors.white24,
                thumbColor: AppColors.accent,
              ),
              child: Slider(
                min: 0,
                max: maxMs,
                value: valueMs,
                onChanged: (v) => onSeek(Duration(milliseconds: v.toInt())),
              ),
            ),
            Row(
              children: [
                Text(
                  formatDuration(position),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const Text(' / ', style: TextStyle(color: Colors.white30, fontSize: 12)),
                Text(
                  formatDuration(duration),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const Spacer(),
                SizedBox(
                  width: 90,
                  child: Row(
                    children: [
                      Icon(
                        volume == 0 ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white70,
                        size: 18,
                      ),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: 1,
                          value: volume,
                          activeColor: Colors.white70,
                          inactiveColor: Colors.white24,
                          onChanged: onVolumeChanged,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tune, color: Colors.white70, size: 20),
                  onPressed: onSettingsTap,
                ),
                IconButton(
                  icon: Icon(
                    isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white70,
                  ),
                  onPressed: onFullscreenToggle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
