import 'dart:io';

import 'package:flutter/widgets.dart';

Widget buildLocalImageImpl(
  String path, {
  required BoxFit fit,
  Widget? placeholder,
}) {
  return Image.file(
    File(path),
    fit: fit,
    errorBuilder: (context, error, st) => placeholder ?? const SizedBox.shrink(),
  );
}

