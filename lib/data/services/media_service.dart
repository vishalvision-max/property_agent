import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/media_item.dart';

/// Abstract interface for picking media from the device.
abstract class MediaService {
  Future<List<MediaItem>> pickImages({bool multi = true, ImageSource source = ImageSource.gallery});
  Future<List<MediaItem>> pickVideos({bool multi = true, ImageSource source = ImageSource.gallery});
}

class DeviceMediaService implements MediaService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<List<MediaItem>> pickImages({bool multi = true, ImageSource source = ImageSource.gallery}) async {
    final List<MediaItem> results = [];
    if (multi) {
      final xfiles = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      for (var f in xfiles) {
        results.add(MediaItem(path: f.path, type: MediaType.image));
      }
    } else {
      final xfile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (xfile != null) {
        results.add(MediaItem(path: xfile.path, type: MediaType.image));
      }
    }
    return results;
  }

  @override
  Future<List<MediaItem>> pickVideos({bool multi = true, ImageSource source = ImageSource.gallery}) async {
    final List<MediaItem> results = [];
    if (multi) {
      final xfiles = await _picker.pickMultiVideo();
      for (var f in xfiles) {
        results.add(MediaItem(path: f.path, type: MediaType.video));
      }
    } else {
      final xfile = await _picker.pickVideo(source: source);
      if (xfile != null) {
        results.add(MediaItem(path: xfile.path, type: MediaType.video));
      }
    }
    return results;
  }
}
