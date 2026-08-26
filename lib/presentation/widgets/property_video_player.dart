import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class PropertyVideoPlayer extends StatefulWidget {
  const PropertyVideoPlayer({
    super.key,
    required this.url,
    this.autoPlay = false,
  });

  final String url;
  final bool autoPlay;

  @override
  State<PropertyVideoPlayer> createState() => _PropertyVideoPlayerState();
}

class _PropertyVideoPlayerState extends State<PropertyVideoPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _init;
  bool _muted = false;
  String? _activeUrl;

  @override
  void initState() {
    super.initState();
    _setController(widget.url, autoPlay: widget.autoPlay);
  }

  @override
  void didUpdateWidget(covariant PropertyVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _setController(widget.url, autoPlay: widget.autoPlay);
    }
  }

  void _setController(String url, {required bool autoPlay}) {
    _activeUrl = url;
    _controller?.dispose();
    _controller = null;
    _init = _createController(url).then((c) async {
      // If widget url changed while downloading, ignore this controller.
      if (!mounted || _activeUrl != url) {
        await c.dispose();
        return;
      }
      _controller = c;
      await c.initialize();
      if (!mounted || _activeUrl != url) {
        await c.dispose();
        return;
      }
      if (_muted) {
        await c.setVolume(0);
      }
      setState(() {});
      if (autoPlay) await c.play();
    });
  }

  Future<VideoPlayerController> _createController(String url) async {
    // Web cannot play from local file path; use network controller.
    if (kIsWeb) {
      return VideoPlayerController.networkUrl(Uri.parse(url));
    }
    try {
      final file = await DefaultCacheManager().getSingleFile(url);
      return VideoPlayerController.file(file);
    } catch (_) {
      return VideoPlayerController.networkUrl(Uri.parse(url));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// Opens the same controller in an immersive full-screen page, keeping the
  /// device in portrait (no forced landscape rotation). The controller is
  /// shared (not disposed here) so playback continues seamlessly on return.
  Future<void> _openFullScreen(
    BuildContext context,
    VideoPlayerController c,
  ) async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => _FullScreenVideoPlayer(
            controller: c,
            onToggleMute: () async {
              final next = c.value.volume != 0;
              setState(() => _muted = next);
              await c.setVolume(next ? 0 : 1);
            },
          ),
        ),
      );
    }
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final init = _init;
    if (c == null || init == null) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder<void>(
      future: init,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const AspectRatio(
            aspectRatio: 16 / 9,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final aspect = c.value.aspectRatio == 0
            ? (16 / 9)
            : c.value.aspectRatio;
        return AspectRatio(
          aspectRatio: aspect,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Zoom + pan works while paused and while playing (pan can fight with scrubbing, so controls are separate).
                InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  panEnabled: true,
                  clipBehavior: Clip.none,
                  child: Center(child: VideoPlayer(c)),
                ),
                Positioned.fill(
                  child: _ControlsOverlay(
                    controller: c,
                    onToggleMute: () async {
                      final next = !_muted;
                      setState(() => _muted = next);
                      await c.setVolume(next ? 0 : 1);
                    },
                    onToggleFullScreen: () => _openFullScreen(context, c),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({
    required this.controller,
    required this.onToggleMute,
    this.isFullScreen = false,
    this.onToggleFullScreen,
  });

  final VideoPlayerController controller;
  final VoidCallback onToggleMute;
  // When true this overlay is shown inside the full-screen player, so the
  // full-screen button becomes an "exit full screen" button.
  final bool isFullScreen;
  final VoidCallback? onToggleFullScreen;

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  bool _show = true;

  @override
  void initState() {
    super.initState();
    // Listen to controller value changes so the play/pause icon and timestamp
    // update automatically during playback without requiring a user tap.
    widget.controller.addListener(_onControllerUpdate);
  }

  @override
  void didUpdateWidget(covariant _ControlsOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerUpdate);
      widget.controller.addListener(_onControllerUpdate);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final value = c.value;
    final pos = value.position;
    final dur = value.duration;
    final canSeek = dur.inMilliseconds > 0;

    final muted = c.value.volume == 0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _show = !_show),
      child: Stack(
        children: [
          if (_show)
            Align(
              alignment: Alignment.center,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 46,
                  color: Colors.white,
                  onPressed: () async {
                    if (value.isPlaying) {
                      await c.pause();
                    } else {
                      await c.play();
                    }
                    if (mounted) setState(() {});
                  },
                  icon: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
                ),
              ),
            ),
          // Full-screen / exit-full-screen toggle (top-right).
          if (_show && widget.onToggleFullScreen != null)
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                tooltip: widget.isFullScreen ? 'Exit full screen' : 'Full screen',
                onPressed: widget.onToggleFullScreen,
                color: Colors.white,
                icon: Icon(
                  widget.isFullScreen
                      ? Icons.fullscreen_exit
                      : Icons.fullscreen,
                ),
              ),
            ),
          if (_show)
            Positioned(
              left: 10,
              right: 10,
              bottom: 8,
              child: Row(
                children: [
                  IconButton(
                    tooltip: muted ? 'Unmute' : 'Mute',
                    onPressed: widget.onToggleMute,
                    color: Colors.white,
                    icon: Icon(
                      muted ? Icons.volume_off : Icons.volume_up,
                    ),
                  ),
                  Expanded(
                    child: canSeek
                        ? VideoProgressIndicator(
                            c,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              bufferedColor: Colors.white24,
                              backgroundColor: Colors.white12,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _format(pos) + (canSeek ? ' / ${_format(dur)}' : ''),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    if (h > 0) return '${h.toString().padLeft(2, '0')}:$m:$s';
    return '$m:$s';
  }
}

/// Full-screen page that renders a shared [VideoPlayerController] on a black
/// background with the standard controls plus a close/exit-full-screen action.
/// Does not own or dispose the controller.
class _FullScreenVideoPlayer extends StatelessWidget {
  const _FullScreenVideoPlayer({
    required this.controller,
    required this.onToggleMute,
  });

  final VideoPlayerController controller;
  final VoidCallback onToggleMute;

  @override
  Widget build(BuildContext context) {
    final aspect = controller.value.aspectRatio == 0
        ? (16 / 9)
        : controller.value.aspectRatio;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: aspect,
              child: Stack(
                children: [
                  InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    panEnabled: true,
                    clipBehavior: Clip.none,
                    child: Center(child: VideoPlayer(controller)),
                  ),
                  Positioned.fill(
                    child: _ControlsOverlay(
                      controller: controller,
                      onToggleMute: onToggleMute,
                      isFullScreen: true,
                      onToggleFullScreen: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Close button, offset for the status bar area.
          Positioned(
            top: 8,
            left: 8,
            child: SafeArea(
              child: IconButton(
                tooltip: 'Close',
                color: Colors.white,
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
