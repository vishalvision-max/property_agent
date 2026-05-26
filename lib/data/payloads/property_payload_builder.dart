import 'package:property_agent/providers/property_form/property_form_state.dart';
import 'package:property_agent/core/utils/property_category_helper.dart';
import 'commercial_payload.dart';

/// Centralized factory for assembling the final API payload from Riverpod state.
class PropertyPayloadBuilder {
  static Map<String, dynamic> build(PropertyFormState state) {
    // 1. Base property info common to all submissions
    final body = <String, dynamic>{
      'type': state.type.name, // TODO: map properly based on listingType
      'property_kind': PropertyCategoryHelper.isPgCoLiving(state)
          ? 'pg'
          : (PropertyCategoryHelper.isLandPlotContext(state)
                ? 'plot'
                : (PropertyCategoryHelper.isCommercialContext(state)
                      ? 'commercial'
                      : 'residential')),
      'carpet_area': double.tryParse(state.carpetArea),
      'built_up_area': double.tryParse(state.builtUpArea),
      'super_built_up_area': double.tryParse(state.superBuiltUpArea),
      'plot_area': double.tryParse(state.plotArea),
      'open_sides': state.openSides,
      'availability': state.availability,
      'ownership': state.ownership,

      // Pricing
      'maintenance_charges': double.tryParse(state.maintenanceCharges),
      'security_deposit': double.tryParse(state.securityDeposit),
      'booking_amount': double.tryParse(state.bookingAmount),
      'brokerage': double.tryParse(state.brokerage),
      'negotiable': state.priceNegotiable != null
          ? (state.priceNegotiable! ? 1 : 0)
          : null,
      'rent_negotiable': state.rentNegotiable != null
          ? (state.rentNegotiable! ? 1 : 0)
          : null,

      // Location
      'address': state.address,
      'city': state.city,
      'state': state.state,
      'pincode': state.pincode,
      'latitude': state.latitude,
      'longitude': state.longitude,

      // Lookups
      'amenities': state.selectedAmenityIds.toList(),
      'furnishings': _buildFurnishingsPayload(state),
    };

    // 2. Append domain-specific chunks dynamically
    if (PropertyCategoryHelper.isCommercialContext(state)) {
      body.addAll(CommercialPayloadBuilder.build(state));
    }

    return body;
  }

  static List<Map<String, dynamic>> _buildFurnishingsPayload(
    PropertyFormState state,
  ) {
    return state.selectedFurnishingIds.map((id) {
      return {'id': id, 'quantity': state.furnishingQuantities[id] ?? 1};
    }).toList();
  }
}
