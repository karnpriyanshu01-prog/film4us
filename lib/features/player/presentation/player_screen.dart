import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_source.dart';
import '../widgets/player_controls_overlay.dart';
import '../widgets/player_settings_sheet.dart';

/// Full-screen, dark, minimal video player.
///
/// Handles its own orientation lifecycle (locks to landscape on
/// fullscreen, restores portrait+system UI on exit) and never leaks
/// that state into the rest of the app.
class PlayerScreen extends StatefulWidget {
  final Movie movie;
  final MovieSource source;

  const PlayerScreen({super.key, required this.movie, required this.source});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

enum _PlayerLoadState { loading, ready, error }

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _controller;
  _PlayerLoadState _loadState = _PlayerLoadState.loading;

  bool _showControls = true;
  bool _isFullscreen = false;
  bool _isBuffering = false;
  double _volume = 1;
  Timer? _hideTimer;

  late String _selectedQuality;
  late String _selectedAudio;
  late String _selectedSubtitle;

  static const _seekStep = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    _selectedQuality = widget.source.quality ?? 'Auto';
    _selectedAudio = widget.source.language ?? 'Original';
    _selectedSubtitle = 'Off';
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final url = widget.source.watchUrl;
    if (url == null) {
      setState(() => _loadState = _PlayerLoadState.error);
      return;
    }
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controller = controller;
    try {
      await controller.initialize();
      controller.addListener(_onControllerUpdate);
      await controller.play();
      if (!mounted) return;
      setState(() => _loadState = _PlayerLoadState.ready);
      _resetHideTimer();
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadState = _PlayerLoadState.error);
    }
  }

  void _onControllerUpdate() {
    final controller = _controller;
    if (controller == null || !mounted) return;
    final buffering = controller.value.isBuffering;
    if (buffering != _isBuffering) {
      setState(() => _isBuffering = buffering);
    }
    if (controller.value.hasError && _loadState != _PlayerLoadState.error) {
      setState(() => _loadState = _PlayerLoadState.error);
    }
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && (_controller?.value.isPlaying ?? false)) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _resetHideTimer();
  }

  void _togglePlayPause() {
    final controller = _controller;
    if (controller == null) return;
    controller.value.isPlaying ? controller.pause() : controller.play();
    _resetHideTimer();
  }

  void _seekBy(Duration offset) {
    final controller = _controller;
    if (controller == null) return;
    final target = controller.value.position + offset;
    final clamped = target < Duration.zero
        ? Duration.zero
        : (target > controller.value.duration ? controller.value.duration : target);
    controller.seekTo(clamped);
    _resetHideTimer();
  }

  void _seekTo(Duration position) {
    _controller?.seekTo(position);
    _resetHideTimer();
  }

  void _setVolume(double v) {
    setState(() => _volume = v);
    _controller?.setVolume(v);
  }

  Future<void> _toggleFullscreen() async {
    setState(() => _isFullscreen = !_isFullscreen);
    if (_isFullscreen) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => PlayerSettingsSheet(
        qualities: {'Auto', '1080p', '720p', '480p', _selectedQuality}.toList(),
        selectedQuality: _selectedQuality,
        onQualitySelected: (v) => setState(() => _selectedQuality = v),
        audioTracks: {_selectedAudio, 'Original'}.toList(),
        selectedAudio: _selectedAudio,
        onAudioSelected: (v) => setState(() => _selectedAudio = v),
        subtitles: ['Off', ...widget.source.subtitles.map((s) => s.language)],
        selectedSubtitle: _selectedSubtitle,
        onSubtitleSelected: (v) => setState(() => _selectedSubtitle = v),
      ),
    );
  }

  Future<void> _handleClose() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.removeListener(_onControllerUpdate);
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) return;
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_loadState) {
      case _PlayerLoadState.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        );
      case _PlayerLoadState.error:
        return _PlayerErrorState(onClose: _handleClose, onRetry: () {
          setState(() => _loadState = _PlayerLoadState.loading);
          _initializePlayer();
        });
      case _PlayerLoadState.ready:
        final controller = _controller!;
        return GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              ),
              _DoubleTapSeekZones(onRewind: () => _seekBy(-_seekStep), onForward: () => _seekBy(_seekStep)),
              AnimatedOpacity(
                opacity: _showControls ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !_showControls,
                  child: ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: controller,
                    builder: (context, value, _) {
                      return PlayerControlsOverlay(
                        title: widget.movie.title,
                        value: value,
                        isBuffering: _isBuffering,
                        volume: _volume,
                        isFullscreen: _isFullscreen,
                        onClose: _handleClose,
                        onPlayPause: _togglePlayPause,
                        onRewind: () => _seekBy(-_seekStep),
                        onForward: () => _seekBy(_seekStep),
                        onFullscreenToggle: _toggleFullscreen,
                        onSettingsTap: _openSettings,
                        onVolumeChanged: _setVolume,
                        onSeek: _seekTo,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}

/// Invisible left/right tap zones enabling double-tap-to-seek, layered
/// under the controls overlay.
class _DoubleTapSeekZones extends StatelessWidget {
  final VoidCallback onRewind;
  final VoidCallback onForward;

  const _DoubleTapSeekZones({required this.onRewind, required this.onForward});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onDoubleTap: onRewind,
          ),
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onDoubleTap: onForward,
          ),
        ),
      ],
    );
  }
}

class _PlayerErrorState extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onRetry;

  const _PlayerErrorState({required this.onClose, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 8,
          left: 8,
          child: SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onClose,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.white70, size: 40),
              const SizedBox(height: 12),
              const Text('Something went wrong', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onRetry, child: const Text('Try Again')),
            ],
          ),
        ),
      ],
    );
  }
}
