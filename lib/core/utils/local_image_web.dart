import 'package:flutter/widgets.dart';

Widget buildLocalImageImpl(
  String path, {
  required BoxFit fit,
  Widget? placeholder,
}) {
  return placeholder ?? const SizedBox.shrink();
}

