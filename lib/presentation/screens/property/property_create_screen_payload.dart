part of 'property_create_screen.dart';

extension PropertyCreateScreenPayload on _PropertyCreateScreenState {
  Map<String, dynamic> buildApiFields() {
    final isLandPlot = _isLandPlotContext;
    final isCommercial = _isCommercialContext;
    final isPgCoLiving =
        _propertyKind == _CreatePropertyKind.pg ||
        _propertyKind == _CreatePropertyKind.coLiving;
    final seatsValue = int.tryParse(_seats.text.trim());
    final maxSeatsValue = int.tryParse(_maxSeats.text.trim());
    final normalizedMaxSeats = (isCommercial && _commercialType == 'office')
        ? _normalizeOfficeMaxSeats(
            seatsValue: seatsValue,
            maxSeatsValue: maxSeatsValue,
          )
        : maxSeatsValue;
    final shopAreaValue = double.tryParse(_shopArea.text.trim());
    final showroomAreaValue = double.tryParse(_showroomArea.text.trim());
    final resolvedShopArea = shopAreaValue ?? showroomAreaValue;
    final resolvedShopAreaUnit = _shopAreaUnit.trim().isNotEmpty
        ? _shopAreaUnit
        : (_showroomAreaUnit.trim().isNotEmpty ? _showroomAreaUnit : _areaUnit);

    final String resolvedType;
    switch (_propertyKind) {
      case _CreatePropertyKind.sale:
        resolvedType = 'sale';
        break;
      case _CreatePropertyKind.rent:
        resolvedType = 'rent';
        break;
      case _CreatePropertyKind.lease:
        resolvedType = 'lease';
        break;
      case _CreatePropertyKind.pg:
        resolvedType = 'pg';
        break;
      case _CreatePropertyKind.coLiving:
        resolvedType = 'co_living';
        break;
      default:
        resolvedType = _type.name;
    }

    return {
      'type': resolvedType,
      'property_kind': isPgCoLiving
          ? 'pg'
          : (isLandPlot
                ? 'plot'
                : (isCommercial ? 'commercial' : 'residential')),
      'pg_food_availability': isPgCoLiving
          ? _normalizePgFoodAvailabilityForApi(_pgFoodAvailability)
          : null,
      'pg_sharing': isPgCoLiving ? _pgSharing : null,
      'pg_gender_based': isPgCoLiving
          ? _normalizePgGenderForApi(_pgGenderBased)
          : null,
      'pg_occupancy_type': isPgCoLiving
          ? _normalizePgOccupancyForApi(_pgOccupancyType)
          : null,
      'pg_tenant_types': isPgCoLiving ? _pgTenantTypes.toList() : null,
      'pg_property_type': isPgCoLiving
          ? _normalizePgPropertyTypeForApi(_pgPropertyType)
          : null,
      'pg_furnishing_type': isPgCoLiving
          ? _normalizePgFurnishingTypeForApi(_furnishing)
          : null,
      'pg_bathroom_type': isPgCoLiving ? _pgBathroomType : null,
      'pg_suitable_for': isPgCoLiving ? _pgSuitableFor : null,
      'pg_building_name': isPgCoLiving && _pgBuildingName.text.trim().isNotEmpty
          ? _pgBuildingName.text.trim()
          : null,
      'pg_total_beds': isPgCoLiving
          ? int.tryParse(_pgTotalBeds.text.trim())
          : null,
      'pg_available_beds': isPgCoLiving
          ? int.tryParse(_pgAvailableBeds.text.trim())
          : null,
      'pg_total_rooms': isPgCoLiving ? int.tryParse(_rooms.text.trim()) : null,
      'pg_room_type': isPgCoLiving ? _pgRoomType : null,
      'pg_attached_bathroom': isPgCoLiving ? _pgAttachedBathroom : null,
      'attached_bathroom': isPgCoLiving ? _pgAttachedBathroom : null,
      'attached_washroom': isPgCoLiving ? (_pgAttachedBathroom == true ? 1 : 0) : null,
      'pg_balcony': isPgCoLiving ? _pgBalcony : null,
      'balcony': isPgCoLiving ? _pgBalcony : null,
      'pg_room_size': isPgCoLiving && _pgRoomSize.text.trim().isNotEmpty
          ? _pgRoomSize.text.trim()
          : null,
      'room_size': isPgCoLiving && _pgRoomSize.text.trim().isNotEmpty
          ? _pgRoomSize.text.trim()
          : null,
      'pg_room_size_unit': isPgCoLiving ? _areaUnit : null,
      'room_size_unit': isPgCoLiving ? _areaUnit : null,
      'pg_bed_type': isPgCoLiving ? _pgBedType : null,
      'bed_type': isPgCoLiving ? _pgBedType : null,
      'pg_cupboard_available': isPgCoLiving ? _pgCupboardAvailable : null,
      'cupboard_available': isPgCoLiving ? _pgCupboardAvailable : null,
      'pg_study_table_available': isPgCoLiving ? _pgStudyTableAvailable : null,
      'study_table_available': isPgCoLiving ? _pgStudyTableAvailable : null,
      'pg_security_deposit': isPgCoLiving
          ? double.tryParse(_pgSecurityDeposit.text.trim())
          : null,
      'security_deposit': isPgCoLiving
          ? double.tryParse(_pgSecurityDeposit.text.trim())
          : (((_propertyKind == _CreatePropertyKind.rent ||
                        _propertyKind == _CreatePropertyKind.lease) &&
                    _isResidential)
                ? double.tryParse(_securityDeposit.text.trim())
                : null),
      'pg_maintenance_charges': isPgCoLiving
          ? double.tryParse(_pgMaintenanceCharges.text.trim())
          : null,
      'maintenance_charges': isPgCoLiving
          ? double.tryParse(_pgMaintenanceCharges.text.trim())
          : (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeMaintenanceCharges.text.trim())
          : _isResidential
          ? double.tryParse(
              ((_propertyKind == _CreatePropertyKind.rent ||
                          _propertyKind == _CreatePropertyKind.lease)
                      ? _rentMaintenanceCharges
                      : _isSellResidentialVillaHouse
                      ? _villaMaintenanceCharges
                      : _maintenanceCharges)
                  .text
                  .trim(),
            )
          : double.tryParse(_maintenanceCharges.text.trim()),
      'pg_electricity_included': isPgCoLiving ? _pgElectricityIncluded : null,
      'electricity_included': isPgCoLiving ? _pgElectricityIncluded : null,
      'pg_water_included': isPgCoLiving ? _pgWaterIncluded : null,
      'water_included': isPgCoLiving ? _pgWaterIncluded : null,
      'pg_food_charges_included': isPgCoLiving ? _pgFoodChargesIncluded : null,
      'food_charges_included': isPgCoLiving ? _pgFoodChargesIncluded : null,
      'food_preference': isPgCoLiving
          ? _normalizePgFoodPreferenceForApi(_pgFoodAvailability)
          : (_isRentLeaseResidentialApartment ? _foodPreference : null),
      'pg_brokerage_required': isPgCoLiving ? _pgBrokerageRequired : null,
      'pg_couple_friendly': isPgCoLiving ? _pgCoupleFriendly : null,
      'pg_id_proof_required': isPgCoLiving ? _pgIdProofRequired : null,
      'pg_available_from': isPgCoLiving ? _pgAvailableFrom.text.trim() : null,
      'pg_min_stay_days': isPgCoLiving
          ? int.tryParse(_pgMinStayDays.text.trim())
          : null,
      'pg_notice_period_days': isPgCoLiving
          ? int.tryParse(_pgNoticePeriodDays.text.trim())
          : null,
      'pg_preferred_tenant_age': isPgCoLiving
          ? int.tryParse(_pgPreferredTenantAge.text.trim())
          : null,
      'pg_smoking_allowed': isPgCoLiving ? _pgSmokingAllowed : null,
      'pg_drinking_allowed': isPgCoLiving ? _pgDrinkingAllowed : null,
      'pg_pets_allowed': isPgCoLiving ? _pgPetsAllowed : null,
      'pg_visitors_allowed': isPgCoLiving ? _pgVisitorsAllowed : null,
      'pg_curfew_time': isPgCoLiving ? _pgCurfewTime.text.trim() : null,
      'pg_gate_locked_at_night': isPgCoLiving ? _pgGateLockedAtNight : null,
      'pg_nearby_preferences': isPgCoLiving
          ? _pgNearbyPreferences.toList()
          : null,
      'pg_availability': isPgCoLiving ? _pgAvailability : null,
      'pg_security': isPgCoLiving ? _pgSecurity : null,
      'carpet_area': double.tryParse(_carpetArea.text.trim()),
      'built_up_area': double.tryParse(_builtUpArea.text.trim()),
      'super_built_up_area': double.tryParse(_superBuiltUpArea.text.trim()),
      'plot_area': double.tryParse(_plotArea.text.trim()),
      'plot_length': double.tryParse(_length.text.trim()),
      'plot_width': double.tryParse(_breadth.text.trim()),
      'floors_allowed': int.tryParse(_floorsAllowed.text.trim()),
      'open_sides': _openSides,
      'boundary_wall': _boundaryWall,
      'construction_done': _constructionDone,
      'availability': _availability,
      'ready_timeframe': _readyTimeframe,
      'property_age_range': _readyTimeframe,
      'property_age': () {
        switch (_readyTimeframe) {
          case '0_1':
            return 1;
          case '1_5':
            return 3;
          case '5_10':
            return 7;
          case '10_plus':
            return 10;
          default:
            return null;
        }
      }(),
      'property_age_years': () {
        switch (_readyTimeframe) {
          case '0_1':
            return 1;
          case '1_5':
            return 3;
          case '5_10':
            return 7;
          case '10_plus':
            return 10;
          default:
            return null;
        }
      }(),
      'possession_by': _possessionBy.text.trim().isEmpty
          ? null
          : _possessionBy.text.trim(),
      'ownership': _ownership.isEmpty ? null : _ownership,
      'balconies': _isResidential ? (_balconies >= 0 ? _balconies : 0) : null,
      'commercial_type': isCommercial ? _commercialType : null,
      'floor_plate_area': isCommercial
          ? double.tryParse(_floorPlateArea.text.trim())
          : null,
      'cabins': isCommercial ? int.tryParse(_cabins.text.trim()) : null,
      'meeting_rooms': isCommercial
          ? int.tryParse(_meetingRooms.text.trim())
          : null,
      'seats': isCommercial ? seatsValue : null,
      'max_seats': isCommercial ? normalizedMaxSeats : null,
      'conference_rooms': isCommercial
          ? int.tryParse(_conferenceRooms.text.trim())
          : null,
      'lift_available': isCommercial ? _liftAvailable : null,
      'goods_lift': isCommercial ? _liftAvailable : null,
      'loading_dock': (isCommercial && _commercialType == 'office')
          ? _liftAvailable
          : null,
      'commercial_parking': (isCommercial && _commercialType == 'office')
          ? _visitorParking
          : null,
      'pre_leased': isCommercial ? _preLeased : null,
      'office_type': (isCommercial && _commercialType == 'office')
          ? _normalizeOfficeTypeForApi(_officeType)
          : null,
      'reception_area': (isCommercial && _commercialType == 'office')
          ? _receptionArea
          : null,
      'pantry': (isCommercial && _commercialType == 'office') ? _pantry : null,
      'cafeteria': (isCommercial && _commercialType == 'office')
          ? _cafeteria
          : null,
      'server_room': (isCommercial && _commercialType == 'office')
          ? _serverRoom
          : null,
      'fire_safety_installed': (isCommercial && _commercialType == 'office')
          ? _fireSafetyInstalled
          : null,
      'central_ac': (isCommercial && _commercialType == 'office')
          ? _centralAC
          : null,
      'visitor_parking': (isCommercial && _commercialType == 'office')
          ? _visitorParking
          : null,
      'number_of_lifts': (isCommercial && _commercialType == 'office')
          ? int.tryParse(_numberOfLifts.text.trim())
          : null,
      'tax_included': (isCommercial && _commercialType == 'office')
          ? _taxIncluded
          : null,
      'price_negotiable_office': (isCommercial && _commercialType == 'office')
          ? (_officeNegotiable == null ? null : (_officeNegotiable! ? 1 : 0))
          : null,
      'negotiable': (isCommercial && _commercialType == 'office')
          ? (_officeNegotiable == null ? null : (_officeNegotiable! ? 1 : 0))
          : (_isSellResidentialBuilderFloor
                ? (_builderNegotiable == null
                      ? null
                      : (_builderNegotiable! ? 1 : 0))
                : null),
      'office_maintenance_charges':
          (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeMaintenanceCharges.text.trim())
          : null,
      'maintenance_charges_office':
          (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeMaintenanceCharges.text.trim())
          : null,
      'office_booking_amount': (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeBookingAmount.text.trim())
          : null,
      'booking_amount_office': (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeBookingAmount.text.trim())
          : null,
      'booking_amount': (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeBookingAmount.text.trim())
          : _isResidential
          ? double.tryParse(
              (_isSellResidentialVillaHouse
                      ? _villaBookingAmount
                      : _bookingAmount)
                  .text
                  .trim(),
            )
          : null,
      'floor_plate_area_unit': (isCommercial && _commercialType == 'office')
          ? _areaUnit
          : null,
      'shop_type': (isCommercial && _commercialType == 'shop')
          ? _shopType
          : null,
      'shop_area':
          (isCommercial &&
              (_commercialType == 'shop' || _commercialType == 'showroom'))
          ? resolvedShopArea
          : null,
      'shop_area_unit':
          (isCommercial &&
              (_commercialType == 'shop' || _commercialType == 'showroom'))
          ? resolvedShopAreaUnit
          : null,
      'showroom_area': (isCommercial && _commercialType == 'shop')
          ? double.tryParse(_shopArea.text.trim())
          : ((isCommercial && _commercialType == 'showroom')
                ? double.tryParse(_showroomArea.text.trim())
                : null),
      'showroom_area_unit': (isCommercial && _commercialType == 'shop')
          ? _shopAreaUnit
          : ((isCommercial && _commercialType == 'showroom')
                ? _showroomAreaUnit
                : null),
      'frontage_width_ft': (isCommercial && _commercialType == 'shop')
          ? double.tryParse(_frontageWidth.text.trim())
          : null,
      'frontage_width': (isCommercial && _commercialType == 'shop')
          ? double.tryParse(_frontageWidth.text.trim())
          : null,
      'ceiling_height_ft': (isCommercial && _commercialType == 'shop')
          ? double.tryParse(_ceilingHeight.text.trim())
          : null,
      'ceiling_height': (isCommercial && _commercialType == 'shop')
          ? (_ceilingHeight.text.trim().isEmpty
                ? null
                : _ceilingHeight.text.trim())
          : null,
      'main_road_facing':
          (isCommercial && _commercialType == 'shop' && _mainRoadFacing != null)
          ? (_mainRoadFacing! ? 1 : 0)
          : null,
      'corner_shop':
          (isCommercial && _commercialType == 'shop' && _cornerShop != null)
          ? (_cornerShop! ? 1 : 0)
          : null,
      'washroom_available':
          (isCommercial &&
              _commercialType == 'shop' &&
              _washroomAvailable != null)
          ? (_washroomAvailable! ? 1 : 0)
          : null,
      'floor_type':
          (isCommercial &&
              _commercialType == 'shop' &&
              _floorType.trim().isNotEmpty)
          ? _floorType.trim()
          : (isCommercial &&
                _commercialType == 'showroom' &&
                _showroomFloorType.trim().isNotEmpty)
          ? _showroomFloorType.trim()
          : null,
      'parking_slots': (isCommercial && _commercialType == 'shop')
          ? _parking
          : null,
      'market_name': (isCommercial && _commercialType == 'shop')
          ? (_marketName.text.trim().isEmpty ? null : _marketName.text.trim())
          : null,
      'locality': (isCommercial && _commercialType == 'shop')
          ? (_locality.text.trim().isEmpty ? null : _locality.text.trim())
          : null,
      'owner_name': () {
        final val = _ownerName.text.trim();
        if (val.isNotEmpty) return val;
        if (isCommercial && _commercialType == 'shop') {
          return _showroomOwnerName.text.trim().isEmpty
              ? null
              : _showroomOwnerName.text.trim();
        }
        if (isCommercial && _commercialType == 'showroom') {
          return _showroomOwnerName.text.trim().isEmpty
              ? null
              : _showroomOwnerName.text.trim();
        }
        return null;
      }(),
      'owner_phone': () {
        final val = _ownerPhone.text.trim();
        if (val.isNotEmpty) return val;
        if (isCommercial && _commercialType == 'shop') {
          return _showroomOwnerMobile.text.trim().isEmpty
              ? null
              : _showroomOwnerMobile.text.trim();
        }
        if (isCommercial && _commercialType == 'showroom') {
          return _showroomOwnerMobile.text.trim().isEmpty
              ? null
              : _showroomOwnerMobile.text.trim();
        }
        return null;
      }(),
      'owner_mobile': () {
        final val = _ownerPhone.text.trim();
        if (val.isNotEmpty) return val;
        if (isCommercial && _commercialType == 'shop') {
          return _showroomOwnerMobile.text.trim().isEmpty
              ? null
              : _showroomOwnerMobile.text.trim();
        }
        if (isCommercial && _commercialType == 'showroom') {
          return _showroomOwnerMobile.text.trim().isEmpty
              ? null
              : _showroomOwnerMobile.text.trim();
        }
        return null;
      }(),
      'showroom_frontage_width_ft':
          (isCommercial && _commercialType == 'showroom')
          ? double.tryParse(_showroomFrontageWidth.text.trim())
          : null,
      'showroom_ceiling_height_ft':
          (isCommercial && _commercialType == 'showroom')
          ? double.tryParse(_showroomCeilingHeight.text.trim())
          : null,
      'showroom_main_road_facing':
          (isCommercial &&
              _commercialType == 'showroom' &&
              _showroomMainRoadFacing != null)
          ? (_showroomMainRoadFacing! ? 1 : 0)
          : null,
      'corner_showroom':
          (isCommercial &&
              _commercialType == 'showroom' &&
              _showroomCorner != null)
          ? (_showroomCorner! ? 1 : 0)
          : null,
      'showroom_washroom_available':
          (isCommercial &&
              _commercialType == 'showroom' &&
              _showroomWashroom != null)
          ? (_showroomWashroom! ? 1 : 0)
          : null,
      'showroom_parking_slots': (isCommercial && _commercialType == 'showroom')
          ? int.tryParse(_showroomParkingSlots.text.trim())
          : null,
      'showroom_furnishing_status':
          (isCommercial && _commercialType == 'showroom')
          ? _showroomFurnishing
          : null,
      'showroom_floor_type':
          (isCommercial &&
              _commercialType == 'showroom' &&
              _showroomFloorType.trim().isNotEmpty)
          ? _showroomFloorType.trim()
          : null,
      'showroom_market_name': (isCommercial && _commercialType == 'showroom')
          ? (_showroomMarketName.text.trim().isEmpty
                ? null
                : _showroomMarketName.text.trim())
          : null,
      'showroom_locality': (isCommercial && _commercialType == 'showroom')
          ? (_showroomLocality.text.trim().isEmpty
                ? null
                : _showroomLocality.text.trim())
          : null,
      'showroom_owner_name': (isCommercial && _commercialType == 'showroom')
          ? (_showroomOwnerName.text.trim().isEmpty
                ? null
                : _showroomOwnerName.text.trim())
          : null,
      'showroom_owner_mobile': (isCommercial && _commercialType == 'showroom')
          ? (_showroomOwnerMobile.text.trim().isEmpty
                ? null
                : _showroomOwnerMobile.text.trim())
          : null,
      'warehouse_type': (isCommercial && _commercialType == 'warehouse')
          ? _warehouseType
          : null,
      'warehouse_plot_area': (isCommercial && _commercialType == 'warehouse')
          ? double.tryParse(_warehousePlotArea.text.trim())
          : null,
      'warehouse_plot_area_unit':
          (isCommercial && _commercialType == 'warehouse')
          ? _warehousePlotAreaUnit
          : null,
      'warehouse_ceiling_height_ft':
          (isCommercial && _commercialType == 'warehouse')
          ? double.tryParse(_warehouseCeilingHeight.text.trim())
          : null,
      'loading_bays': (isCommercial && _commercialType == 'warehouse')
          ? int.tryParse(_warehouseLoadingBays.text.trim())
          : null,
      'dock_levelers': (isCommercial && _commercialType == 'warehouse')
          ? int.tryParse(_warehouseDockLevelers.text.trim())
          : null,
      'power_supply': (isCommercial && _commercialType == 'warehouse')
          ? (_warehousePowerSupply.text.trim().isEmpty
                ? null
                : _warehousePowerSupply.text.trim())
          : null,
      'industrial_license': (isCommercial && _commercialType == 'warehouse')
          ? _warehouseIndustrialLicense
          : null,
      'truck_access': (isCommercial && _commercialType == 'warehouse')
          ? _warehouseTruckAccess
          : null,
      'industrial_area_name': (isCommercial && _commercialType == 'warehouse')
          ? (_warehouseAreaName.text.trim().isEmpty
                ? null
                : _warehouseAreaName.text.trim())
          : null,
      'industrial_area_city': (isCommercial && _commercialType == 'warehouse')
          ? (_warehouseCity.text.trim().isEmpty
                ? null
                : _warehouseCity.text.trim())
          : null,
      'shop_facade': isCommercial
          ? (_shopFacade.text.trim().isEmpty ? null : _shopFacade.text.trim())
          : null,
      'washrooms': isCommercial ? int.tryParse(_washrooms.text.trim()) : null,
      'parking_type': isCommercial ? _parkingType : null,
      'plot_type': isCommercial
          ? (_plotType.text.trim().isEmpty ? null : _plotType.text.trim())
          : null,
      'rooms': (isCommercial || isPgCoLiving)
          ? int.tryParse(_rooms.text.trim())
          : null,
      'quality_rating': isCommercial
          ? double.tryParse(_qualityRating.text.trim())
          : null,
      'land_type': isLandPlot ? _landType : null,
      'road_width_ft': isLandPlot
          ? double.tryParse(_roadWidth.text.trim())
          : null,
      'plot_area_unit': isLandPlot ? _plotAreaUnit : null,
      'road_access': isLandPlot ? _plotRoadAccess : null,
      'fencing': (isLandPlot && _landType == 'agricultural')
          ? _agriFencing
          : null,
      'agri_fencing': (isLandPlot && _landType == 'agricultural')
          ? _agriFencing
          : null,
      'water_source': (isLandPlot && _landType == 'agricultural')
          ? _agriWaterSource
          : (_isSellResidentialVillaHouse ? _waterSource : null),
      'agri_water_source': (isLandPlot && _landType == 'agricultural')
          ? _agriWaterSource
          : null,
      'farm_land_area': isLandPlot
          ? double.tryParse(_plotArea.text.trim())
          : (_isSellResidentialFarmhouse
                ? double.tryParse(_farmLandArea.text.trim())
                : null),
      'farm_built_up_area': isLandPlot
          ? double.tryParse(_builtUpArea.text.trim())
          : (_isSellResidentialFarmhouse
                ? double.tryParse(_farmBuiltUpArea.text.trim())
                : null),
      'farm_rooms': isLandPlot
          ? int.tryParse(_rooms.text.trim())
          : (_isSellResidentialFarmhouse
                ? int.tryParse(_farmRooms.text.trim())
                : null),
      'farm_garden': isLandPlot
          ? _boundaryWall
          : (_isSellResidentialFarmhouse ? _farmGarden : null),
      'farm_swimming_pool': isLandPlot
          ? false
          : (_isSellResidentialFarmhouse ? _farmSwimmingPool : null),
      'farm_utilities': isLandPlot
          ? <String>[]
          : (_isSellResidentialFarmhouse
                ? _farmUtilities.toList(growable: false)
                : null),
      'farm_monthly_charges': isLandPlot
          ? double.tryParse(_maintenanceCharges.text.trim())
          : (_isSellResidentialFarmhouse
                ? double.tryParse(_farmMonthlyCharges.text.trim())
                : (_isRentLeaseResidentialFarmhouse
                      ? double.tryParse(_farmMonthlyCharges.text.trim())
                      : null)),
      'farm_daily_charges': _isRentLeaseResidentialFarmhouse
          ? double.tryParse(_farmDailyCharges.text.trim())
          : null,
      'farm_event_charges': _isRentLeaseResidentialFarmhouse
          ? double.tryParse(_farmEventCharges.text.trim())
          : null,
      'min_stay_days': isLandPlot
          ? int.tryParse(_pgMinStayDays.text.trim())
          : (_isRentLeaseResidentialFarmhouse
                ? int.tryParse(_minStayDays.text.trim())
                : null),

      // Sell -> Residential -> Flat/Apartment extra fields
      'corner_property':
          ((_cornerProperty ?? false) ||
              (_rentCornerProperty ?? false) ||
              (_villaCornerProperty ?? false) ||
              (_builderCornerProperty ?? false) ||
              (_duplexCornerPlot ?? false) ||
              (_cornerShop ?? false) ||
              (_showroomCorner ?? false) ||
              (_plotCorner ?? false))
          ? 1
          : 0,
      'price_negotiable': (_propertyKind == _CreatePropertyKind.sale)
          ? (_isSellResidentialVillaHouse
                ? (_villaPriceNegotiable == null
                      ? null
                      : (_villaPriceNegotiable! ? 1 : 0))
                : (_priceNegotiable == null
                      ? null
                      : (_priceNegotiable! ? 1 : 0)))
          : null,
      'additional_rooms': () {
        if (!_isResidential) return null;
        final rooms =
            (_isSellResidentialApartment
                    ? _additionalRooms
                    : _isSellResidentialVillaHouse
                    ? _villaAdditionalRooms
                    : _isRentLeaseResidentialApartment
                    ? _rentAdditionalRooms
                    : <String>{})
                .toList(growable: false);
        return rooms.isNotEmpty ? rooms : null;
      }(),
      'property_highlights': _isSellResidentialApartment
          ? _propertyHighlights.toList(growable: false)
          : null,
      // 'whatsapp_updates': _isSellResidentialApartment ? _whatsappUpdates : null,
      'promotion': _isSellResidentialApartment
          ? _promotionTags.toList(growable: false)
          : null,
      'pet_friendly': _isRentLeaseResidentialApartment ? _petFriendly : null,
      'wheelchair_friendly': _isRentLeaseResidentialApartment
          ? _wheelchairFriendly
          : null,
      'gated_society_rent': _isRentLeaseResidentialApartment
          ? _rentGatedSociety
          : null,
      'brokerage':
          ((_propertyKind == _CreatePropertyKind.rent ||
                  _propertyKind == _CreatePropertyKind.lease) &&
              _isResidential)
          ? double.tryParse(_brokerage.text.trim())
          : null,
      'rent_negotiable':
          ((_propertyKind == _CreatePropertyKind.rent ||
                  _propertyKind == _CreatePropertyKind.lease) &&
              _isResidential)
          ? _rentNegotiable
          : null,
      'available_from':
          ((_propertyKind == _CreatePropertyKind.rent ||
                  _propertyKind == _CreatePropertyKind.lease) &&
              _isResidential)
          ? (_availableFrom.text.trim().isEmpty
                ? null
                : _availableFrom.text.trim())
          : null,
      'lease_duration_months': _isRentLeaseResidentialApartment
          ? int.tryParse(_leaseDurationMonths.text.trim())
          : null,
      'lock_in_months': _isRentLeaseResidentialApartment
          ? int.tryParse(_lockInMonths.text.trim())
          : null,
      'notice_period_value': _isRentLeaseResidentialApartment
          ? int.tryParse(_noticePeriodValue.text.trim())
          : null,
      'notice_period_unit': _isRentLeaseResidentialApartment
          ? _noticePeriodUnit
          : null,
      'preferred_tenant': _isRentLeaseResidentialApartment
          ? _preferredTenant
          : null,
      'rent_promotion': _isRentLeaseResidentialApartment
          ? _rentPromotionTypes.toList(growable: false)
          : null,
      'rent_villa_outdoors': _isRentLeaseResidentialVillaHouse
          ? _rentVillaOutdoors.toList(growable: false)
          : null,
      'rent_villa_water_source': _isRentLeaseResidentialVillaHouse
          ? _rentVillaWaterSource
          : null,
      'solar_power': _isRentLeaseResidentialVillaHouse ? _rentSolarPower : null,
      'independent_entry': _isRentLeaseResidentialVillaHouse
          ? _rentIndependentEntry
          : null,
      'lift_available_rent': _isRentLeaseResidentialBuilderFloor
          ? _rentLiftAvailable
          : null,
      'society_name': _isRentLeaseResidentialBuilderFloor
          ? (_societyName.text.trim().isEmpty ? null : _societyName.text.trim())
          : null,
      'tenant_types': _isRentLeaseResidentialBuilderFloor
          ? _rentTenantTypes.toList(growable: false)
          : null,
      'studio_config': _isRentLeaseResidentialStudioApartment
          ? _studioConfig
          : null,
      'kitchen_type': _isRentLeaseResidentialStudioApartment
          ? _kitchenType
          : null,
      'studio_tenant_preferences': _isRentLeaseResidentialStudioApartment
          ? _studioTenantPrefs.toList(growable: false)
          : null,
      'farm_land_area_rent': _isRentLeaseResidentialFarmhouse
          ? double.tryParse(_rentFarmLandArea.text.trim())
          : null,
      'farm_rooms_rent': _isRentLeaseResidentialFarmhouse
          ? int.tryParse(_rentFarmRooms.text.trim())
          : null,
      'farm_pool_rent': _isRentLeaseResidentialFarmhouse ? _rentFarmPool : null,
      'farm_fencing_rent': _isRentLeaseResidentialFarmhouse
          ? _rentFarmFencing
          : null,
      'farm_use_cases': _isRentLeaseResidentialFarmhouse
          ? _rentFarmUseCases.toList(growable: false)
          : null,

      // Sell -> Residential -> Independent House / Villa extra fields
      'gated_society': _isSellResidentialVillaHouse
          ? _gatedCommunity
          : (_isSellResidentialBuilderFloor ? _builderGatedSociety : null),
      'parking_types': _isSellResidentialVillaHouse
          ? _villaParking.toList(growable: false)
          : null,
      'outdoors': _isSellResidentialVillaHouse
          ? _outdoors.toList(growable: false)
          : null,
      'connections': _isSellResidentialVillaHouse
          ? _connections.toList(growable: false)
          : null,

      // Sell -> Residential -> Builder Floor extra fields
      'construction_allowed': _isSellResidentialBuilderFloor
          ? _constructionAllowed
          : null,
      'utilities': _isSellResidentialBuilderFloor
          ? _builderUtilities.toList(growable: false)
          : null,
      'price_per_sqft': _isSellResidentialBuilderFloor
          ? double.tryParse(_pricePerSqft.text.trim())
          : null,

      // Sell -> Residential -> Duplex extra fields
      'duplex_gated_community': _isSellResidentialDuplex
          ? _duplexGatedCommunity
          : null,
      'duplex_construction_allowed': _isSellResidentialDuplex
          ? _duplexConstructionAllowed
          : null,
      'duplex_water_connection': _isSellResidentialDuplex
          ? _duplexWaterConnection
          : null,
      'duplex_electricity_connection': _isSellResidentialDuplex
          ? _duplexElectricityConnection
          : null,
      'duplex_negotiable': _isSellResidentialDuplex
          ? (_duplexNegotiable == null ? null : (_duplexNegotiable! ? 1 : 0))
          : null,
      'duplex_road_access': _isSellResidentialDuplex ? _duplexRoadAccess : null,
      'duplex_nearby_facilities': _isSellResidentialDuplex
          ? _duplexNearbyFacilities.toList(growable: false)
          : null,

      // Sell -> Residential -> Farmhouse extra fields
      'village': _isSellResidentialFarmhouse
          ? (_village.text.trim().isEmpty ? null : _village.text.trim())
          : null,
      'landmark': _isSellResidentialFarmhouse
          ? (_landmark.text.trim().isEmpty ? null : _landmark.text.trim())
          : null,
      'owner_details': {
        'name': _ownerName.text.trim().isEmpty ? null : _ownerName.text.trim(),
        'phone': _ownerPhone.text.trim().isEmpty
            ? null
            : _ownerPhone.text.trim(),
      },
    };
  }

  String _normalizePgGenderForApi(String value) {
    switch (value) {
      case 'boys_pg':
        return 'male';
      case 'girls_pg':
        return 'female';
      case 'co_living':
      case 'unisex_pg':
      default:
        return 'unisex';
    }
  }

  String _normalizePgOccupancyForApi(String value) {
    switch (value) {
      case 'single_sharing':
        return 'single';
      case 'double_sharing':
      case 'triple_sharing':
      case 'four_plus_sharing':
      case 'dormitory':
      default:
        return 'multiple';
    }
  }

  String _normalizePgPropertyTypeForApi(String value) {
    switch (value) {
      case 'independent_house_pg':
        return 'independent_house';
      case 'apartment_pg':
        return 'apartment';
      case 'co_living_space':
        return 'co_living';
      case 'service_apartment':
        return 'service_apartment';
      case 'hostel':
      default:
        return 'hostel';
    }
  }

  String _normalizePgFurnishingTypeForApi(String value) {
    switch (value.trim().toLowerCase()) {
      case 'semi-furnished':
      case 'semi_furnished':
        return 'semi_furnished';
      case 'fully furnished':
      case 'fully-furnished':
      case 'fully_furnished':
      case 'furnished':
        return 'furnished';
      case 'unfurnished':
      default:
        return 'unfurnished';
    }
  }

  String _normalizeOfficeTypeForApi(String value) {
    final norm = value
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    const validTypes = {
      'bare_shell',
      'warm_shell',
      'fully_furnished',
      'semi_furnished',
      'plug_and_play',
      'customizable',
      'co_working',
      'private',
      'managed',
      'virtual',
      'corporate',
    };
    if (validTypes.contains(norm)) {
      return norm;
    }
    return 'bare_shell';
  }

  int? _normalizeOfficeMaxSeats({
    required int? seatsValue,
    required int? maxSeatsValue,
  }) {
    final maxBase = (maxSeatsValue ?? seatsValue);
    if (maxBase == null) return null;
    final atLeastTen = maxBase < 10 ? 10 : maxBase;
    if (seatsValue == null) return atLeastTen;
    return atLeastTen < seatsValue ? seatsValue : atLeastTen;
  }

  int _normalizePgFoodAvailabilityForApi(String value) {
    return value == 'without_food' ? 0 : 1;
  }

  String? _normalizePgFoodPreferenceForApi(String value) {
    switch (value) {
      case 'veg_only':
        return 'veg';
      case 'non_veg_allowed':
        return 'non_veg';
      default:
        return null;
    }
  }

  Map<String, List<String>> _buildSectionImages() {
    final sections = <String, List<String>>{};
    for (final img in _images) {
      final tag = img.tag ?? 'general';
      sections.putIfAbsent(tag, () => []).add(img.path);
    }
    return sections;
  }
}
