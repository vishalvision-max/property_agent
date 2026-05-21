import 'package:flutter/widgets.dart';

import 'local_image_impl.dart';

/// Renders a local (device) image path when supported.
///
/// - Mobile/desktop: uses `Image.file`.
/// - Web: returns a lightweight placeholder (since `dart:io` isn't available).
Widget buildLocalImage(
  String path, {
  BoxFit fit = BoxFit.cover,
  Widget? placeholder,
}) {
  return buildLocalImageImpl(path, fit: fit, placeholder: placeholder);
}

