import 'package:flutter/material.dart';

class AppUi {
  static const radius = 16.0;
  static const cardRadius = 18.0;

  static BorderRadius borderRadius([double r = radius]) => BorderRadius.circular(r);

  static const cardPadding = EdgeInsets.all(14);
  static const screenPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
}

