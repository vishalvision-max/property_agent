import 'package:property_agent/providers/property_form/property_form_state.dart';

/// Converts `PropertyFormState` into the flat `Map<String, dynamic>` that
/// `StaffPropertyService._toCreateForm` / `_toUpdateForm` expects.
///
/// Moving this out of the 11k-line screen means:
///  1. It can be unit-tested in isolation.
///  2. The screen has zero API-mapping logic.
///  3. Changes to field names require editing ONE file.
class PropertyPayloadBuilder {
  const PropertyPayloadBuilder._();

  static Map<String, dynamic> build(PropertyFormState s) {
    return {
      // ── Core ────────────────────────────────────────────────
      'title': s.title.trim(),
      'description': s.description.trim(),
      'price': double.tryParse(s.price.trim()),
      'area': double.tryParse(s.area.trim()),
      'area_unit': s.areaUnit,
      'type': s.type.name,
      'listing_type': s.listingType,
      'category_id': s.selectedCategoryId,
      'property_kind': _propertyKindLabel(s),
      'address': s.address.trim(),
      'city': s.city.trim(),
      'state': s.state.trim(),
      'pincode': s.pincode.trim(),
      if (s.latitude != null) 'latitude': s.latitude,
      if (s.longitude != null) 'longitude': s.longitude,

      // ── Owner ───────────────────────────────────────────────
      if (s.ownerName.isNotEmpty) 'owner_name': s.ownerName.trim(),
      if (s.ownerPhone.isNotEmpty) 'owner_phone': s.ownerPhone.trim(),
      if (s.ownerPhone.isNotEmpty) 'owner_mobile': s.ownerPhone.trim(),

      // ── Pricing ─────────────────────────────────────────────
      if (s.maintenanceCharges.isNotEmpty)
        'maintenance_charges': double.tryParse(s.maintenanceCharges),
      if (s.bookingAmount.isNotEmpty)
        'booking_amount': double.tryParse(s.bookingAmount),
      if (s.priceNegotiable != null)
        'price_negotiable': s.priceNegotiable! ? 1 : 0,
      if (s.securityDeposit.isNotEmpty)
        'security_deposit': double.tryParse(s.securityDeposit),
      if (s.possessionStatus.isNotEmpty) 'possession_status': s.possessionStatus,
      if (s.availability.isNotEmpty) 'availability': s.availability,
      if (s.ownership.isNotEmpty) 'ownership': s.ownership,

      // ── Common details ──────────────────────────────────────
      if (!s.isCommercial && !s.isLandPlot) ...{
        if (s.bedrooms > 0) 'bedrooms': s.bedrooms,
        if (s.bathrooms > 0) 'bathrooms': s.bathrooms,
      },
      'parking': s.parking,
      'open_sides': s.openSides,
      if (s.furnishing.isNotEmpty) 'furnishing': s.furnishing,
      if (s.facing.isNotEmpty) 'facing': s.facing,
      if (s.floor.isNotEmpty) 'floor': int.tryParse(s.floor),
      if (s.totalFloors.isNotEmpty) 'total_floors': int.tryParse(s.totalFloors),
      if (s.carpetArea.isNotEmpty)
        'carpet_area': double.tryParse(s.carpetArea),
      if (s.builtUpArea.isNotEmpty)
        'built_up_area': double.tryParse(s.builtUpArea),
      if (s.superBuiltUpArea.isNotEmpty)
        'super_built_up_area': double.tryParse(s.superBuiltUpArea),

      // ── Commercial type ─────────────────────────────────────
      if (s.isCommercial) 'commercial_type': s.commercialType,

      // ── Warehouse ───────────────────────────────────────────
      if (s.isWarehouse) ..._warehouseFields(s),

      // ── Amenities ───────────────────────────────────────────
      // (amenity_ids[] and furnishing arrays are added separately
      //  by the service as FormData parts)
    };
  }

  // ── Private helpers ─────────────────────────────────────────────────────

  static String _propertyKindLabel(PropertyFormState s) {
    if (s.isCommercial) return 'commercial';
    if (s.isResidential) return 'residential';
    if (s.isLandPlot) return 'land';
    if (s.isPgOrCoLiving) return 'pg';
    return 'residential';
  }

  static Map<String, dynamic> _warehouseFields(PropertyFormState s) => {
        'warehouse_type': s.warehouseType,
        'lift_available': s.warehouseLiftAvailable ? 1 : 0,
        'goods_lift': s.warehouseGoodsLift ? 1 : 0,
        'pre_leased': s.warehousePreLeased ? 1 : 0,
        if (s.warehousePlotArea.isNotEmpty) ...{
          'warehouse_plot_area': double.tryParse(s.warehousePlotArea),
          'plot_area': double.tryParse(s.warehousePlotArea),
        },
        'warehouse_plot_area_unit': s.warehousePlotAreaUnit,
        if (s.warehouseCeilingHeight.isNotEmpty) ...{
          'warehouse_ceiling_height_ft': double.tryParse(s.warehouseCeilingHeight),
          'ceiling_height_ft': double.tryParse(s.warehouseCeilingHeight),
        },
        if (s.warehouseLoadingBays.isNotEmpty)
          'loading_bays': int.tryParse(s.warehouseLoadingBays),
        if (s.warehouseDockLevelers.isNotEmpty)
          'dock_levelers': int.tryParse(s.warehouseDockLevelers),
        if (s.warehousePowerSupply.isNotEmpty)
          'power_supply': s.warehousePowerSupply,
        'industrial_license': s.warehouseIndustrialLicense == true ? 1 : 0,
        if (s.warehouseTruckAccess.isNotEmpty)
          'truck_access': s.warehouseTruckAccess,
        if (s.warehouseAreaName.isNotEmpty)
          'industrial_area_name': s.warehouseAreaName,
        if (s.warehouseCity.isNotEmpty)
          'industrial_area_city': s.warehouseCity,
      };
}
