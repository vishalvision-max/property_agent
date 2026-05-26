import 'package:property_agent/data/models/property.dart';
import 'package:property_agent/providers/property_form/property_form_state.dart';
import 'package:property_agent/providers/property_form/state/modular_states.dart';
import 'package:property_agent/providers/property_form/state/commercial_state.dart';
import 'package:property_agent/providers/property_form/state/residential_state.dart';

/// Pure mapping layer translating an API Property payload into immutable PropertyFormState.
/// By extracting this, we remove hundreds of lines of parsing logic from the UI
/// and keep our Notifiers clean.
class PropertyPrefillMapper {
  /// Converts an existing [Property] into a [PropertyFormState] for editing.
  /// Note: As we continue modularizing, this will map sub-states
  /// (e.g., BasicInfoState, PricingState) once they are split.
  static PropertyFormState fromProperty(Property p) {
    final f = p.apiFields ?? const <String, dynamic>{};
    
    // Extracted shared parsing utilities
    String fbString(List<String> keys, {String fallback = ''}) {
      for (final k in keys) {
        if (f[k] != null) return f[k].toString();
      }
      return fallback;
    }

    bool? fbBool(List<String> keys) {
      for (final k in keys) {
        if (f[k] != null) {
          final val = f[k];
          if (val is bool) return val;
          if (val is int) return val == 1;
          if (val is String) return val == '1' || val.toLowerCase() == 'true';
        }
      }
      return null;
    }

    // Commercial parsing blocks
    final warehouse = (f['warehouse_details'] as Map?) ?? {};
    String fd(Map source, List<String> keys) {
      for (final k in keys) {
        if (source[k] != null) return source[k].toString();
      }
      return '';
    }

    return PropertyFormState(
      basicInfo: BasicInfoState(
        title: p.name,
        description: p.description,
        area: p.area?.toString() ?? '',
        areaUnit: p.areaUnit ?? 'sqft',
        type: p.type,
        listingType: p.listingType ?? 'owner',
        selectedCategoryId: int.tryParse((p.categoryId ?? '').toString()),
        ownerName: f['owner_name']?.toString() ?? '',
        ownerPhone: f['owner_phone']?.toString() ?? '',
      ),
      pricing: PricingState(
        price: p.price.toStringAsFixed(0),
        maintenanceCharges: p.maintenanceCharges?.toString() ?? '',
        bookingAmount: p.bookingAmount?.toString() ?? '',
        priceNegotiable: p.priceNegotiable,
        securityDeposit: f['security_deposit']?.toString() ?? '',
        villaMaintenanceCharges: p.maintenanceCharges?.toString() ?? fbString(['villa_maintenance_charges']),
        villaBookingAmount: p.bookingAmount?.toString() ?? fbString(['villa_booking_amount']),
        rentMaintenanceCharges: fbString(['maintenance_charges', 'maintenance_charges_rent']),
        brokerage: fbString(['brokerage']),
        rentNegotiable: p.rentNegotiable ?? fbBool(['rent_negotiable', 'price_negotiable']),
      ),
      location: LocationState(
        address: p.address ?? '',
        city: p.city ?? '',
        state: p.state ?? '',
        pincode: p.pincode ?? '',
        latitude: p.latitude,
        longitude: p.longitude,
      ),
      residential: const ResidentialState(),
      commercial: CommercialState(
        commercialType: f['commercial_type']?.toString() ?? '',
        warehouseType: fd(warehouse, ['warehouse_type']) != '' 
            ? fd(warehouse, ['warehouse_type']) 
            : f['warehouse_type']?.toString() ?? '',
        warehousePlotArea: fd(warehouse, ['warehouse_plot_area']) != '' 
            ? fd(warehouse, ['warehouse_plot_area']) 
            : fbString(['warehouse_plot_area', 'plot_area']),
        warehousePlotAreaUnit: fd(warehouse, ['warehouse_plot_area_unit', 'area_unit']) != '' 
            ? fd(warehouse, ['warehouse_plot_area_unit', 'area_unit']) 
            : fbString(['warehouse_plot_area_unit', 'area_unit'], fallback: 'sqft'),
        warehouseCeilingHeight: fd(warehouse, ['warehouse_ceiling_height_ft', 'warehouse_ceiling_height', 'ceiling_height_ft', 'ceiling_height']) != ''
            ? fd(warehouse, ['warehouse_ceiling_height_ft', 'warehouse_ceiling_height', 'ceiling_height_ft', 'ceiling_height'])
            : fbString(['warehouse_ceiling_height_ft', 'warehouse_ceiling_height', 'ceiling_height_ft', 'ceiling_height']),
        warehouseLoadingBays: fd(warehouse, ['loading_bays']) != '' 
            ? fd(warehouse, ['loading_bays']) 
            : fbString(['loading_bays']),
        warehouseDockLevelers: fd(warehouse, ['dock_levelers']) != '' 
            ? fd(warehouse, ['dock_levelers']) 
            : fbString(['dock_levelers']),
        warehousePowerSupply: fd(warehouse, ['power_supply_kw', 'power_supply']) != '' 
            ? fd(warehouse, ['power_supply_kw', 'power_supply']) 
            : fbString(['power_supply_kw', 'power_supply']),
        warehouseIndustrialLicense: warehouse['industrial_license_available'] ?? fbBool(['industrial_license_available', 'industrial_license']),
        warehouseTruckAccess: fd(warehouse, ['truck_access']) != '' 
            ? fd(warehouse, ['truck_access']) 
            : fbString(['truck_access']),
        warehouseAreaName: fd(warehouse, ['industrial_area_name']) != '' 
            ? fd(warehouse, ['industrial_area_name']) 
            : fbString(['industrial_area_name']),
        warehouseCity: fd(warehouse, ['industrial_city']) != '' 
            ? fd(warehouse, ['industrial_city']) 
            : fbString(['industrial_city']),
        warehouseLiftAvailable: warehouse['lift_available'] ?? fbBool(['lift_available', 'lift_available_warehouse']) ?? true,
        warehouseGoodsLift: warehouse['goods_lift_available'] ?? fbBool(['goods_lift_available']) ?? false,
        warehousePreLeased: warehouse['pre_leased'] ?? fbBool(['pre_leased', 'is_pre_leased']) ?? false,
        officeType: fbString(['office_type', 'type_of_office']),
        officeArea: fbString(['office_area', 'floor_plate_area']),
        cabins: fbString(['cabins', 'number_of_cabins']),
        meetingRooms: fbString(['meeting_rooms', 'number_of_meeting_rooms']),
        seats: fbString(['seats', 'number_of_seats', 'workstations']),
        maxSeats: fbString(['max_seats', 'maximum_seats']),
        conferenceRooms: fbString(['conference_rooms']),
        receptionArea: fbBool(['reception_area', 'has_reception']) ?? false,
        pantry: fbBool(['pantry', 'has_pantry']) ?? false,
        cafeteria: fbBool(['cafeteria', 'has_cafeteria']) ?? false,
        serverRoom: fbBool(['server_room', 'has_server_room']) ?? false,
        fireSafetyInstalled: fbBool(['fire_safety_installed', 'fire_safety']) ?? false,
        centralAC: fbBool(['central_ac', 'is_central_ac']) ?? false,
        visitorParking: fbBool(['visitor_parking', 'has_visitor_parking']) ?? false,
        numberOfLifts: fbString(['number_of_lifts', 'lifts']),
        officeNegotiable: fbBool(['office_negotiable', 'negotiable']),
        officeMaintenanceCharges: fbString(['office_maintenance_charges', 'maintenance_charges', 'maintenance_charges_office']),
        officeBookingAmount: fbString(['office_booking_amount', 'booking_amount']),
        shopType: fbString(['shop_type', 'type_of_shop']),
        shopArea: fbString(['shop_area', 'carpet_area', 'built_up_area']),
        shopAreaUnit: fbString(['shop_area_unit', 'area_unit'], fallback: 'sqft'),
        frontageWidth: fbString(['frontage_width', 'frontage_ft']),
        ceilingHeight: fbString(['ceiling_height', 'ceiling_height_ft']),
        mainRoadFacing: fbBool(['main_road_facing', 'is_main_road_facing']),
        cornerShop: fbBool(['corner_shop', 'is_corner_shop']),
        washroomAvailable: fbBool(['washroom_available', 'has_washroom']),
        floorType: fbString(['floor_type', 'floor']),
        marketName: fbString(['market_name', 'market']),
        locality: fbString(['locality']),
        showroomArea: fbString(['showroom_area', 'carpet_area', 'built_up_area']),
        showroomAreaUnit: fbString(['showroom_area_unit', 'area_unit'], fallback: 'sqft'),
        showroomFrontageWidth: fbString(['showroom_frontage_width', 'frontage_ft', 'frontage_width']),
        showroomCeilingHeight: fbString(['showroom_ceiling_height_ft', 'showroom_ceiling_height', 'ceiling_height_ft']),
        showroomMainRoadFacing: fbBool(['showroom_main_road_facing', 'main_road_facing']),
        showroomCorner: fbBool(['corner_showroom', 'corner_property', 'is_corner']),
        showroomWashroom: fbBool(['showroom_washroom_available', 'washroom_available']),
        showroomParkingSlots: fbString(['showroom_parking_slots', 'parking_slots', 'parking']),
        showroomFurnishing: fbString(['showroom_furnishing', 'furnishing_status']),
        showroomFloorType: fbString(['showroom_floor_type', 'floor_type', 'floor']),
        showroomMarketName: fbString(['showroom_market_name', 'market_name', 'market']),
        showroomLocality: fbString(['showroom_locality', 'locality']),
        showroomOwnerName: fbString(['showroom_owner_name', 'owner_name']),
        showroomOwnerMobile: fbString(['showroom_owner_mobile', 'owner_phone', 'owner_mobile']),
      ),
    );
  }
}
