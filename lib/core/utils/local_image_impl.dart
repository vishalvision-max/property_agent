import 'package:flutter/widgets.dart';

import 'local_image_io.dart' if (dart.library.html) 'local_image_web.dart' as impl;

Widget buildLocalImageImpl(
  String path, {
  required BoxFit fit,
  Widget? placeholder,
}) {
  return impl.buildLocalImageImpl(path, fit: fit, placeholder: placeholder);
}

