part of 'property_create_screen.dart';

class MediaItem {
  final String path;
  final MediaType type;
  String? tag;

  MediaItem({required this.path, required this.type, this.tag});
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({required this.src});
  final String src;

  @override
  Widget build(BuildContext context) {
    if (src.startsWith('http')) {
      return Image.network(
        src,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return buildLocalImage(src, fit: BoxFit.cover);
  }
}

class _VideoPlayerDialog extends StatefulWidget {
  const _VideoPlayerDialog({required this.src});

  final String src;

  @override
  State<_VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<_VideoPlayerDialog> {
  VideoPlayerController? _controller;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final ctrl = widget.src.startsWith('http')
          ? VideoPlayerController.networkUrl(Uri.parse(widget.src))
          : VideoPlayerController.file(File(widget.src));
      await ctrl.initialize();
      await ctrl.setLooping(true);
      await ctrl.play();
      if (!mounted) {
        await ctrl.dispose();
        return;
      }
      setState(() => _controller = ctrl);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: (_controller?.value.aspectRatio ?? 16 / 9),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_error.toString(), textAlign: TextAlign.center),
                ),
              )
            else if (_controller == null)
              const Center(child: CircularProgressIndicator())
            else
              VideoPlayer(_controller!),
            if (_controller != null)
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton.filled(
                  onPressed: () {
                    final c = _controller!;
                    setState(() {
                      c.value.isPlaying ? c.pause() : c.play();
                    });
                  },
                  icon: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });
  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 16,
            icon: const Icon(Icons.remove, color: AppTheme.gold),
            onPressed: enabled
                ? () => onChanged((value - 1).clamp(1, 99))
                : null,
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.gold,
            ),
          ),
          IconButton(
            iconSize: 16,
            icon: const Icon(Icons.add, color: AppTheme.gold),
            onPressed: enabled
                ? () => onChanged((value + 1).clamp(1, 99))
                : null,
          ),
        ],
      ),
    );
  }
}

