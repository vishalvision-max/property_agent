import 'package:property_agent/providers/property_form/property_form_state.dart';

/// Pure validation — no Flutter, no Riverpod, no async.
/// Returns a map of fieldKey → error message (null = valid).
class PropertyFormValidator {
  const PropertyFormValidator._();

  static Map<String, String?> validate(PropertyFormState s) {
    final e = <String, String?>{};

    // ── Price ────────────────────────────────────────────────
    if (s.price.isEmpty) {
      e['price'] = 'Price is required';
    } else if (double.tryParse(s.price) == null || double.parse(s.price) <= 0) {
      e['price'] = 'Enter a valid price';
    }

    // ── Area ─────────────────────────────────────────────────
    if (s.area.isEmpty) {
      e['area'] = 'Area is required';
    } else if (double.tryParse(s.area) == null) {
      e['area'] = 'Enter a valid area';
    }

    // ── Category ─────────────────────────────────────────────
    if (s.selectedCategoryId == null) {
      e['category'] = 'Select a property category';
    }

    // ── Location ─────────────────────────────────────────────
    if (s.address.isEmpty) e['address'] = 'Address is required';
    if (s.city.isEmpty) e['city'] = 'City is required';
    if (s.state.isEmpty) e['state'] = 'State is required';
    if (s.pincode.isEmpty) {
      e['pincode'] = 'Pincode is required';
    } else if (s.pincode.length != 6) {
      e['pincode'] = 'Enter a valid 6-digit pincode';
    }

    // ── Description ──────────────────────────────────────────
    if (s.description.trim().length < 10) {
      e['description'] = 'Add at least 10 characters';
    }

    // ── Media ────────────────────────────────────────────────
    if (s.images.isEmpty) {
      e['media'] = 'Add at least 1 photo';
    }

    return e;
  }

  // ── Section completion helpers ────────────────────────────────────────────

  static bool isBasicComplete(PropertyFormState s) =>
      s.selectedCategoryId != null &&
      s.selectedParentCategoryId != null &&
      s.selectedCategorySlug.isNotEmpty;

  static bool isPricingComplete(PropertyFormState s) =>
      s.price.isNotEmpty && double.tryParse(s.price) != null;

  static bool isMediaComplete(PropertyFormState s) => s.images.isNotEmpty;

  static bool isLocationComplete(PropertyFormState s) =>
      s.address.isNotEmpty &&
      s.city.isNotEmpty &&
      s.state.isNotEmpty &&
      s.pincode.isNotEmpty;

  static bool isDescriptionComplete(PropertyFormState s) =>
      s.description.trim().length >= 10;

  static bool isDetailsComplete(PropertyFormState s) {
    if (s.isWarehouse) {
      return s.warehousePlotArea.isNotEmpty && s.warehouseCeilingHeight.isNotEmpty;
    }
    return true; // details are optional for most categories
  }

  static bool canProceedToNext(PropertyFormState s, String section) {
    return switch (section) {
      'basic' => isBasicComplete(s),
      'pricing' => isPricingComplete(s),
      'media' => isMediaComplete(s),
      'location' => isLocationComplete(s),
      'description' => isDescriptionComplete(s),
      _ => true,
    };
  }
}
