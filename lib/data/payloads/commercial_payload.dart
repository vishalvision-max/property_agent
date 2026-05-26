import 'package:property_agent/providers/property_form/property_form_state.dart';

/// Modular payload builder for all Commercial property subcategories.
class CommercialPayloadBuilder {
  static Map<String, dynamic> build(PropertyFormState state) {
    final type = state.commercialType.toLowerCase();

    final payload = <String, dynamic>{'commercial_type': state.commercialType};

    if (type == 'warehouse') {
      payload.addAll(_buildWarehouse(state));
    } else if (type == 'office') {
      payload.addAll(_buildOffice(state));
    } else if (type == 'shop') {
      payload.addAll(_buildShop(state));
    } else if (type == 'showroom') {
      payload.addAll(_buildShowroom(state));
    }

    return payload;
  }

  static Map<String, dynamic> _buildWarehouse(PropertyFormState state) {
    return {
      'warehouse_type': state.warehouseType,
      'warehouse_plot_area': double.tryParse(state.warehousePlotArea),
      'warehouse_plot_area_unit': state.warehousePlotAreaUnit,
      'warehouse_ceiling_height_ft': double.tryParse(
        state.warehouseCeilingHeight,
      ),
      'loading_bays': int.tryParse(state.warehouseLoadingBays),
      'dock_levelers': int.tryParse(state.warehouseDockLevelers),
      'power_supply_kw': state.warehousePowerSupply,
      'industrial_license_available': state.warehouseIndustrialLicense != null
          ? (state.warehouseIndustrialLicense! ? 1 : 0)
          : null,
      'truck_access': state.warehouseTruckAccess,
      'industrial_area_name': state.warehouseAreaName,
      'industrial_city': state.warehouseCity,
      'lift_available': state.warehouseLiftAvailable ? 1 : 0,
      'goods_lift_available': state.warehouseGoodsLift ? 1 : 0,
      'pre_leased': state.warehousePreLeased ? 1 : 0,
    };
  }

  static Map<String, dynamic> _buildOffice(PropertyFormState state) {
    return {
      'office_type': state.officeType,
      'floor_plate_area': double.tryParse(state.officeArea),
      'cabins': int.tryParse(state.cabins),
      'meeting_rooms': int.tryParse(state.meetingRooms),
      'seats': int.tryParse(state.seats),
      'max_seats': int.tryParse(state.maxSeats),
      'conference_rooms': int.tryParse(state.conferenceRooms),
      'reception_area': state.receptionArea ? 1 : 0,
      'pantry': state.pantry ? 1 : 0,
      'cafeteria': state.cafeteria ? 1 : 0,
      'server_room': state.serverRoom ? 1 : 0,
      'fire_safety_installed': state.fireSafetyInstalled ? 1 : 0,
      'central_ac': state.centralAC ? 1 : 0,
      'visitor_parking': state.visitorParking ? 1 : 0,
      'number_of_lifts': int.tryParse(state.numberOfLifts),
      'office_negotiable': state.officeNegotiable != null
          ? (state.officeNegotiable! ? 1 : 0)
          : null,
      'office_maintenance_charges': double.tryParse(
        state.officeMaintenanceCharges,
      ),
      'office_booking_amount': double.tryParse(state.officeBookingAmount),
    };
  }

  static Map<String, dynamic> _buildShop(PropertyFormState state) {
    return {
      'shop_type': state.shopType,
      'shop_area': double.tryParse(state.shopArea),
      'shop_area_unit': state.shopAreaUnit,
      'frontage_width_ft': double.tryParse(state.frontageWidth),
      'ceiling_height_ft': double.tryParse(state.ceilingHeight),
      'main_road_facing': state.mainRoadFacing != null
          ? (state.mainRoadFacing! ? 1 : 0)
          : null,
      'corner_shop': state.cornerShop != null
          ? (state.cornerShop! ? 1 : 0)
          : null,
      'washroom_available': state.washroomAvailable != null
          ? (state.washroomAvailable! ? 1 : 0)
          : null,
      'floor_type': state.floorType,
      'market_name': state.marketName,
      'locality': state.locality,
    };
  }

  static Map<String, dynamic> _buildShowroom(PropertyFormState state) {
    return {
      'showroom_area': double.tryParse(state.showroomArea),
      'showroom_area_unit': state.showroomAreaUnit,
      'showroom_frontage_width_ft': double.tryParse(
        state.showroomFrontageWidth,
      ),
      'showroom_ceiling_height_ft': double.tryParse(
        state.showroomCeilingHeight,
      ),
      'showroom_main_road_facing': state.showroomMainRoadFacing != null
          ? (state.showroomMainRoadFacing! ? 1 : 0)
          : null,
      'corner_showroom': state.showroomCorner != null
          ? (state.showroomCorner! ? 1 : 0)
          : null,
      'showroom_washroom_available': state.showroomWashroom != null
          ? (state.showroomWashroom! ? 1 : 0)
          : null,
      'showroom_parking_slots': int.tryParse(state.showroomParkingSlots),
      'showroom_furnishing_status': state.showroomFurnishing,
      'showroom_floor_type': state.showroomFloorType,
      'showroom_market_name': state.showroomMarketName,
      'showroom_locality': state.showroomLocality,
      'showroom_owner_name': state.showroomOwnerName,
      'showroom_owner_mobile': state.showroomOwnerMobile,
    };
  }
}
