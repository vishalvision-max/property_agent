import 'package:intl/intl.dart';

/// Indian-style grouped number formatter (e.g. 3500 -> "3,500",
/// 3500000 -> "35,00,000"). Used to display prices with thousands separators
/// for readability across the app.
final NumberFormat _indianFormat = NumberFormat.decimalPattern('en_IN');

/// Formats [value] with Indian comma grouping and no decimals.
String formatIndianNumber(num value) {
  return _indianFormat.format(value.round());
}

/// Formats [value] as a rupee price, e.g. "₹35,00,000".
String formatIndianPrice(num value) {
  return '₹${formatIndianNumber(value)}';
}