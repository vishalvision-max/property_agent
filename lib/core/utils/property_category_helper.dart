import 'package:property_agent/providers/property_form/property_form_state.dart';

/// Centralized helper to determine property categories, contexts, and segments
/// based on the immutable PropertyFormState. This replaces dozens of boolean
/// getters that were previously cluttering the UI layer.
class PropertyCategoryHelper {
  static bool isResidential(PropertyFormState state) {
    return state.selectedParentCategorySlug.toLowerCase() == 'residential';
  }

  static bool isCommercialContext(PropertyFormState state) {
    final parent = state.selectedParentCategorySlug.toLowerCase();
    if (parent == 'land-plot') return false;
    if (parent == 'commercial') return true;

    final child = state.selectedCategorySlug.toLowerCase();
    return child.contains('office') ||
        child.contains('retail') ||
        child.contains('shop') ||
        child.contains('showroom') ||
        child.contains('warehouse') ||
        child.contains('storage') ||
        child.contains('industry') ||
        child.contains('industrial') ||
        child.contains('hospitality') ||
        child.contains('commercial');
  }

  static bool isLandPlotContext(PropertyFormState state) {
    final parent = state.selectedParentCategorySlug.toLowerCase();
    if (parent == 'land-plot') return true;

    final child = state.selectedCategorySlug.toLowerCase();
    return child.contains('plot') || child.contains('land');
  }

  static bool isSellResidentialApartment(PropertyFormState state) {
    if (state.listingType != 'sale') return false;
    if (!isResidential(state)) return false;
    final slug = state.selectedCategorySlug.toLowerCase();
    return slug.contains('apartment') || slug.contains('flat');
  }

  static bool isRentLeaseResidentialApartment(PropertyFormState state) {
    final isRentLease =
        state.listingType == 'rent' || state.listingType == 'lease';
    if (!isRentLease) return false;
    if (!isResidential(state)) return false;
    final slug = state.selectedCategorySlug.toLowerCase();
    return slug.contains('apartment') || slug.contains('flat');
  }

  static bool isRentLeaseResidentialVillaHouse(PropertyFormState state) {
    final isRentLease =
        state.listingType == 'rent' || state.listingType == 'lease';
    if (!isRentLease) return false;
    if (!isResidential(state)) return false;
    final slug = state.selectedCategorySlug.toLowerCase();
    if (slug.contains('floor') || slug.contains('builder')) return false;
    if (slug.contains('farm') || slug.contains('farmhouse')) return false;
    return slug.contains('villa') ||
        slug.contains('independent') ||
        slug.contains('house');
  }

  static bool isRentLeaseResidentialBuilderFloor(PropertyFormState state) {
    final isRentLease =
        state.listingType == 'rent' || state.listingType == 'lease';
    if (!isRentLease) return false;
    if (!isResidential(state)) return false;
    final slug = state.selectedCategorySlug.toLowerCase();
    return slug.contains('builder') || slug.contains('floor');
  }

  static bool isRentLeaseResidentialStudioApartment(PropertyFormState state) {
    final isRentLease =
        state.listingType == 'rent' || state.listingType == 'lease';
    if (!isRentLease) return false;
    if (!isResidential(state)) return false;
    final slug = state.selectedCategorySlug.toLowerCase();
    return slug.contains('studio') ||
        slug.contains('1rk') ||
        slug.contains('1_rk') ||
        slug.contains('rk');
  }

  static bool isRentLeaseResidentialFarmhouse(PropertyFormState state) {
    final isRentLease =
        state.listingType == 'rent' || state.listingType == 'lease';
    if (!isRentLease) return false;
    if (!isResidential(state)) return false;
    final slug = state.selectedCategorySlug.toLowerCase();
    return slug.contains('farm') || slug.contains('farmhouse');
  }

  static bool isRentLeaseResidentialDuplex(PropertyFormState state) {
    final isRentLease =
        state.listingType == 'rent' || state.listingType == 'lease';
    if (!isRentLease) return false;
    if (!isResidential(state)) return false;
    final slug = state.selectedCategorySlug.toLowerCase();
    return slug.contains('duplex');
  }

  static bool isSellResidentialVillaHouse(PropertyFormState state) {
    if (state.listingType != 'sale') return false;
    if (!isResidential(state)) return false;
    final slug = state.selectedCategorySlug.toLowerCase();
    if (slug.contains('floor') || slug.contains('builder')) return false;
    if (slug.contains('farm') || slug.contains('farmhouse')) return false;
    return slug.contains('villa') ||
        slug.contains('independent') ||
        slug.contains('house');
  }

  static bool isSellResidentialBuilderFloor(PropertyFormState state) {
    if (state.listingType != 'sale') return false;
    if (!isResidential(state)) return false;
    final slug = state.selectedCategorySlug.toLowerCase();
    return slug.contains('builder') || slug.contains('floor');
  }

  static bool isSellResidentialDuplex(PropertyFormState state) {
    if (state.listingType != 'sale') return false;
    if (!isResidential(state)) return false;
    final slug = state.selectedCategorySlug.toLowerCase();
    return slug.contains('duplex');
  }

  static bool isSellResidentialFarmhouse(PropertyFormState state) {
    if (state.listingType != 'sale') return false;
    if (!isResidential(state)) return false;
    final slug = state.selectedCategorySlug.toLowerCase();
    return slug.contains('farm') || slug.contains('farmhouse');
  }

  static bool isPgCoLiving(PropertyFormState state) {
    return state.listingType == 'pg' || state.listingType == 'coLiving';
  }

  static String getRentLeaseHouseVillaTitle(PropertyFormState state) {
    final slug = state.selectedCategorySlug.toLowerCase();
    if (slug.contains('farm')) return 'Farmhouse Details';
    if (slug.contains('independent-floor') ||
        slug.contains('independent_floor') ||
        slug.contains('independentfloor')) {
      return 'Independent Floor Details';
    }
    if (slug.contains('villa')) return 'Villa Details';
    return 'Independent House Details';
  }
}
