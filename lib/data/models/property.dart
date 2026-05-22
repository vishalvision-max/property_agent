import 'package:equatable/equatable.dart';

import 'property_enums.dart';
import 'property_furnishing_selection.dart';
import 'property_video.dart';
import 'sub_models/property_pg_details.dart';
import 'sub_models/property_office_details.dart';
import 'sub_models/property_showroom_details.dart';
import 'sub_models/property_shop_details.dart';
import 'sub_models/property_warehouse_details.dart';

class Property extends Equatable {
  Property({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.location,
    this.ownerPhone,
    required this.price,
    required this.type,
    required this.amenities,
    required this.images,
    required this.videos,
    required this.description,
    required this.status,
    this.slug,
    this.listingType,
    this.propertyKind,
    this.area,
    this.areaUnit,
    this.propertyAge,
    this.facing,
    this.floor,
    this.totalFloors,
    this.possessionStatus,
    this.bedrooms,
    this.bathrooms,
    this.furnishing,
    this.parking,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.primaryImageIndex,
    this.rejectionReason,
    this.updatedAt,
    this.createdAt,
    this.categoryId,
    this.userId,
    this.isFeatured,
    this.featuredExpiry,
    this.documents,
    this.amenityIds,
    this.furnishingSelections,
    this.apiFields,
    this.sectionImagePaths,
    this.documentPaths,

    // Additional fields for residential, commercial, warehouse, showroom, land, pg, etc.
    this.carpetArea,
    this.builtUpArea,
    this.superBuiltUpArea,
    this.plotArea,
    this.plotLength,
    this.plotBreadth,
    this.floorsAllowed,
    this.openSides,
    this.boundaryWall,
    this.constructionDone,
    this.availability,
    this.readyTimeframe,
    this.possessionBy,
    this.ownership,
    this.balconies,
    this.commercialType,
    this.floorPlateArea,
    this.cabins,
    this.meetingRooms,
    this.seats,
    this.maxSeats,
    this.conferenceRooms,
    this.liftAvailable,
    this.preLeased,
    this.officeType,
    this.receptionArea,
    this.pantry,
    this.cafeteria,
    this.serverRoom,
    this.fireSafetyInstalled,
    this.centralAC,
    this.visitorParking,
    this.numberOfLifts,
    this.taxIncluded,
    this.officeNegotiable,
    this.officeMaintenanceCharges,
    this.officeBookingAmount,
    this.shopType,
    this.shopArea,
    this.shopAreaUnit,
    this.frontageWidth,
    this.ceilingHeight,
    this.mainRoadFacing,
    this.cornerShop,
    this.washroomAvailable,
    this.floorType,
    this.marketName,
    this.locality,
    this.showroomArea,
    this.showroomAreaUnit,
    this.showroomFrontageWidth,
    this.showroomCeilingHeight,
    this.showroomMainRoadFacing,
    this.showroomCorner,
    this.showroomWashroom,
    this.showroomParkingSlots,
    this.showroomFurnishing,
    this.showroomFloorType,
    this.showroomMarketName,
    this.showroomLocality,
    this.showroomOwneLeaserName,
    this.showroomOwnerMobile,
    this.warehouseType,
    this.warehousePlotArea,
    this.warehousePlotAreaUnit,
    this.warehouseCeilingHeight,
    this.warehouseLoadingBays,
    this.warehouseDockLevelers,
    this.warehousePowerSupply,
    this.warehouseIndustrialLicense,
    this.warehouseTruckAccess,
    this.warehouseAreaName,
    this.warehouseCity,
    this.shopFacade,
    this.washrooms,
    this.parkingType,
    this.plotType,
    this.rooms,
    this.qualityRating,
    this.landType,
    this.roadWidth,
    this.plotAreaUnit,
    this.plotCorner,
    this.plotRoadAccess,
    this.agriFencing,
    this.agriWaterSource,
    this.additionalRooms,
    this.cornerProperty,
    this.priceNegotiable,
    this.maintenanceCharges,
    this.bookingAmount,
    this.propertyHighlights,
    this.whatsappUpdates,
    this.promotionTags,
    this.rentAdditionalRooms,
    this.rentCornerProperty,
    this.petFriendly,
    this.wheelchairFriendly,
    this.rentGatedSociety,
    this.securityDeposit,
    this.rentMaintenanceCharges,
    this.brokerage,
    this.rentNegotiable,
    this.availableFrom,
    this.leaseDurationMonths,
    this.lockInMonths,
    this.noticePeriodValue,
    this.noticePeriodUnit,
    this.preferredTenant,
    this.foodPreference,
    this.rentPromotionTypes,
    this.rentVillaOutdoors,
    this.rentVillaWaterSource,
    this.rentSolarPower,
    this.rentIndependentEntry,
    this.rentLiftAvailable,
    this.societyName,
    this.rentTenantTypes,
    this.studioConfig,
    this.kitchenType,
    this.studioTenantPrefs,
    this.rentFarmLandArea,
    this.rentFarmRooms,
    this.rentFarmPool,
    this.rentFarmFencing,
    this.rentFarmUseCases,
    this.farmMonthlyCharges,
    this.farmDailyCharges,
    this.farmEventCharges,
    this.minStayDays,
    this.villaAdditionalRooms,
    this.villaCornerProperty,
    this.gatedCommunity,
    this.villaParking,
    this.outdoors,
    this.waterSource,
    this.connections,
    this.villaPriceNegotiable,
    this.villaMaintenanceCharges,
    this.villaBookingAmount,
    this.builderCornerProperty,
    this.builderGatedSociety,
    this.constructionAllowed,
    this.builderUtilities,
    this.pricePerSqft,
    this.builderNegotiable,
    this.duplexCornerPlot,
    this.duplexGatedCommunity,
    this.duplexConstructionAllowed,
    this.duplexWaterConnection,
    this.duplexElectricityConnection,
    this.duplexNegotiable,
    this.duplexRoadAccess,
    this.duplexNearbyFacilities,
    this.farmLandArea,
    this.farmBuiltUpArea,
    this.farmUtilities,
    this.farmRooms,
    this.farmGarden,
    this.farmSwimmingPool,
    this.village,
    this.landmark,
    this.pgGenderBased,
    this.pgOccupancyType,
    this.pgTenantTypes,
    this.pgFoodAvailability,
    this.pgPropertyType,
    this.pgBathroomType,
    this.pgSuitableFor,
    this.pgBuildingName,
    this.pgTotalBeds,
    this.pgAvailableBeds,
    this.pgRoomType,
    this.pgAttachedBathroom,
    this.pgBalcony,
    this.pgRoomSize,
    this.pgBedType,
    this.pgCupboardAvailable,
    this.pgStudyTableAvailable,
    this.pgSecurityDeposit,
    this.pgElectricityIncluded,
    this.pgWaterIncluded,
    this.pgFoodChargesIncluded,
    this.pgBrokerageRequired,
    this.pgCoupleFriendly,
    this.pgIdProofRequired,
    this.pgAvailableFrom,
    this.pgMinStayDays,
    this.pgNoticePeriodDays,
    this.pgPreferredTenantAge,
    this.pgSmokingAllowed,
    this.pgDrinkingAllowed,
    this.pgPetsAllowed,
    this.pgVisitorsAllowed,
    this.pgCurfewTime,
    this.pgGateLockedAtNight,
    this.pgNearbyPreferences,
    this.pgAvailability,
    this.pgSharing,
    this.pgSecurity,
    this.pgMaintenanceCharges,  this.showroomOwnerName,
  })  : pgDetails = PropertyPgDetails(
          genderBased: pgGenderBased,
          occupancyType: pgOccupancyType,
          tenantTypes: pgTenantTypes,
          foodAvailability: pgFoodAvailability,
          propertyType: pgPropertyType,
          bathroomType: pgBathroomType,
          suitableFor: pgSuitableFor,
          buildingName: pgBuildingName,
          totalBeds: pgTotalBeds,
          availableBeds: pgAvailableBeds,
          roomType: pgRoomType,
          attachedBathroom: pgAttachedBathroom,
          balcony: pgBalcony,
          roomSize: pgRoomSize,
          bedType: pgBedType,
          cupboardAvailable: pgCupboardAvailable,
          studyTableAvailable: pgStudyTableAvailable,
          securityDeposit: pgSecurityDeposit,
          electricityIncluded: pgElectricityIncluded,
          waterIncluded: pgWaterIncluded,
          foodChargesIncluded: pgFoodChargesIncluded,
          brokerageRequired: pgBrokerageRequired,
          coupleFriendly: pgCoupleFriendly,
          idProofRequired: pgIdProofRequired,
          availableFrom: pgAvailableFrom,
          minStayDays: pgMinStayDays,
          noticePeriodDays: pgNoticePeriodDays,
          preferredTenantAge: pgPreferredTenantAge,
          smokingAllowed: pgSmokingAllowed,
          drinkingAllowed: pgDrinkingAllowed,
          petsAllowed: pgPetsAllowed,
          visitorsAllowed: pgVisitorsAllowed,
          curfewTime: pgCurfewTime,
          gateLockedAtNight: pgGateLockedAtNight,
          nearbyPreferences: pgNearbyPreferences,
          availability: pgAvailability,
          sharing: pgSharing,
          security: pgSecurity,
          maintenanceCharges: pgMaintenanceCharges,
        ),
        officeDetails = PropertyOfficeDetails(
          carpetArea: carpetArea,
          builtUpArea: builtUpArea,
          superBuiltUpArea: superBuiltUpArea,
          cabins: cabins,
          meetingRooms: meetingRooms,
          seats: seats,
          maxSeats: maxSeats,
          conferenceRooms: conferenceRooms,
          liftAvailable: liftAvailable,
          preLeased: preLeased,
          officeType: officeType,
          receptionArea: receptionArea,
          pantry: pantry,
          cafeteria: cafeteria,
          serverRoom: serverRoom,
          fireSafetyInstalled: fireSafetyInstalled,
          centralAC: centralAC,
          visitorParking: visitorParking,
          numberOfLifts: numberOfLifts,
          taxIncluded: taxIncluded,
          officeNegotiable: officeNegotiable,
          officeMaintenanceCharges: officeMaintenanceCharges,
          officeBookingAmount: officeBookingAmount,
        ),
        showroomDetails = PropertyShowroomDetails(
          showroomArea: showroomArea,
          showroomAreaUnit: showroomAreaUnit,
          showroomFrontageWidth: showroomFrontageWidth,
          showroomCeilingHeight: showroomCeilingHeight,
          showroomMainRoadFacing: showroomMainRoadFacing,
          showroomCorner: showroomCorner,
          showroomWashroom: showroomWashroom,
          showroomParkingSlots: showroomParkingSlots,
          showroomFurnishing: showroomFurnishing,
          showroomFloorType: showroomFloorType,
          showroomMarketName: showroomMarketName,
          showroomLocality: showroomLocality,
          showroomOwnerName: showroomOwnerName,
          showroomOwnerMobile: showroomOwnerMobile,
        ),
        shopDetails = PropertyShopDetails(
          shopType: shopType,
          shopArea: shopArea,
          shopAreaUnit: shopAreaUnit,
          frontageWidth: frontageWidth,
          ceilingHeight: ceilingHeight,
          mainRoadFacing: mainRoadFacing,
          cornerShop: cornerShop,
          washroomAvailable: washroomAvailable,
          floorType: floorType,
          marketName: marketName,
          locality: locality,
        ),
        warehouseDetails = PropertyWarehouseDetails(
          warehouseType: warehouseType,
          warehousePlotArea: warehousePlotArea,
          warehousePlotAreaUnit: warehousePlotAreaUnit,
          warehouseCeilingHeight: warehouseCeilingHeight,
          warehouseLoadingBays: warehouseLoadingBays,
          warehouseDockLevelers: warehouseDockLevelers,
          warehousePowerSupply: warehousePowerSupply,
          warehouseIndustrialLicense: warehouseIndustrialLicense,
          warehouseTruckAccess: warehouseTruckAccess,
          warehouseAreaName: warehouseAreaName,
          warehouseCity: warehouseCity,
        );

  String get displayTag {
    final pk = propertyKind?.toLowerCase();
    if (pk == 'pg') return 'PG';
    if (pk == 'co_living' || pk == 'co-living') return 'Co-Living';
    if (pk == 'lease') return 'Lease';
    if (pk == 'sale') return 'Sale';
    if (pk == 'rent') return 'Rent';
    return type.label;
  }

  final String id;
  final String name;
  final String ownerName;
  final String location;
  final double price;
  final PropertyType type;
  final List<String> amenities;
  final List<String> images;
  final List<PropertyVideo> videos;
  final String description;
  final PropertyStatus status;
  final String? slug;
  final String? listingType;
  final String? propertyKind;
  final double? area;
  final String? areaUnit;
  final int? propertyAge;
  final String? facing;
  final int? floor;
  final int? totalFloors;
  final String? possessionStatus;
  final int? bedrooms;
  final int? bathrooms;
  final String? furnishing;
  final int? parking;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final double? latitude;
  final double? longitude;
  final int? primaryImageIndex;
  final String? rejectionReason;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? categoryId;
  final int? userId;
  final String? ownerPhone;
  final bool? isFeatured;
  final DateTime? featuredExpiry;
  final List<String>? documents;
  final List<int>? amenityIds;
  final List<PropertyFurnishingSelection>? furnishingSelections;

  // Create-only helpers (not serialized directly from API, but populated / saved raw).
  final Map<String, dynamic>? apiFields;
  final Map<String, List<String>>? sectionImagePaths;
  final List<String>? documentPaths;

  // Additional fields for residential, commercial, warehouse, showroom, land, pg, etc.
  final double? carpetArea;
  final double? builtUpArea;
  final double? superBuiltUpArea;
  final double? plotArea;
  final double? plotLength;
  final double? plotBreadth;
  final int? floorsAllowed;
  final int? openSides;
  final bool? boundaryWall;
  final bool? constructionDone;
  final String? availability;
  final String? readyTimeframe;
  final String? possessionBy;
  final String? ownership;
  final int? balconies;

  final String? commercialType;
  final double? floorPlateArea;
  final int? cabins;
  final int? meetingRooms;
  final int? seats;
  final int? maxSeats;
  final int? conferenceRooms;
  final bool? liftAvailable;
  final bool? preLeased;
  final String? officeType;
  final bool? receptionArea;
  final bool? pantry;
  final bool? cafeteria;
  final bool? serverRoom;
  final bool? fireSafetyInstalled;
  final bool? centralAC;
  final bool? visitorParking;
  final int? numberOfLifts;
  final bool? taxIncluded;
  final bool? officeNegotiable;
  final double? officeMaintenanceCharges;
  final double? officeBookingAmount;

  final String? shopType;
  final double? shopArea;
  final String? shopAreaUnit;
  final double? frontageWidth;
  final double? ceilingHeight;
  final bool? mainRoadFacing;
  final bool? cornerShop;
  final bool? washroomAvailable;
  final String? floorType;
  final String? marketName;
  final String? locality;

  final double? showroomArea;
  final String? showroomAreaUnit;
  final double? showroomFrontageWidth;
  final double? showroomCeilingHeight;
  final bool? showroomMainRoadFacing;
  final bool? showroomCorner;
  final bool? showroomWashroom;
  final int? showroomParkingSlots;
  final String? showroomFurnishing;
  final String? showroomFloorType;
  final String? showroomMarketName;
  final String? showroomLocality;
  final String? showroomOwnerName;
  final String? showroomOwnerMobile;

  final String? warehouseType;
  final double? warehousePlotArea;
  final String? warehousePlotAreaUnit;
  final double? warehouseCeilingHeight;
  final int? warehouseLoadingBays;
  final int? warehouseDockLevelers;
  final String? warehousePowerSupply;
  final bool? warehouseIndustrialLicense;
  final String? warehouseTruckAccess;
  final String? warehouseAreaName;
  final String? warehouseCity;

  final String? shopFacade;
  final int? washrooms;
  final String? parkingType;
  final String? plotType;
  final int? rooms;
  final double? qualityRating;

  final String? landType;
  final double? roadWidth;
  final String? plotAreaUnit;
  final bool? plotCorner;
  final bool? plotRoadAccess;
  final bool? agriFencing;
  final String? agriWaterSource;

  final List<String>? additionalRooms;
  final bool? cornerProperty;
  final bool? priceNegotiable;
  final double? maintenanceCharges;
  final double? bookingAmount;
  final List<String>? propertyHighlights;
  final bool? whatsappUpdates;
  final List<String>? promotionTags;

  final List<String>? rentAdditionalRooms;
  final bool? rentCornerProperty;
  final bool? petFriendly;
  final bool? wheelchairFriendly;
  final bool? rentGatedSociety;
  final double? securityDeposit;
  final double? rentMaintenanceCharges;
  final double? brokerage;
  final bool? rentNegotiable;
  final String? availableFrom;
  final int? leaseDurationMonths;
  final int? lockInMonths;
  final int? noticePeriodValue;
  final String? noticePeriodUnit;
  final String? preferredTenant;
  final String? foodPreference;
  final List<String>? rentPromotionTypes;

  final List<String>? rentVillaOutdoors;
  final String? rentVillaWaterSource;
  final bool? rentSolarPower;
  final bool? rentIndependentEntry;
  final bool? rentLiftAvailable;
  final String? societyName;
  final List<String>? rentTenantTypes;

  final String? studioConfig;
  final String? kitchenType;
  final List<String>? studioTenantPrefs;
  final double? rentFarmLandArea;
  final int? rentFarmRooms;
  final bool? rentFarmPool;
  final bool? rentFarmFencing;
  final List<String>? rentFarmUseCases;
  final double? farmMonthlyCharges;
  final double? farmDailyCharges;
  final double? farmEventCharges;
  final int? minStayDays;

  final List<String>? villaAdditionalRooms;
  final bool? villaCornerProperty;
  final bool? gatedCommunity;
  final List<String>? villaParking;
  final List<String>? outdoors;
  final String? waterSource;
  final List<String>? connections;
  final bool? villaPriceNegotiable;
  final double? villaMaintenanceCharges;
  final double? villaBookingAmount;

  final bool? builderCornerProperty;
  final bool? builderGatedSociety;
  final bool? constructionAllowed;
  final List<String>? builderUtilities;
  final double? pricePerSqft;
  final bool? builderNegotiable;

  final bool? duplexCornerPlot;
  final bool? duplexGatedCommunity;
  final bool? duplexConstructionAllowed;
  final bool? duplexWaterConnection;
  final bool? duplexElectricityConnection;
  final bool? duplexNegotiable;
  final bool? duplexRoadAccess;
  final List<String>? duplexNearbyFacilities;

  final double? farmLandArea;
  final double? farmBuiltUpArea;
  final List<String>? farmUtilities;
  final int? farmRooms;
  final bool? farmGarden;
  final bool? farmSwimmingPool;
  final String? village;
  final String? landmark;

  final String? pgGenderBased;
  final String? pgOccupancyType;
  final List<String>? pgTenantTypes;
  final String? pgFoodAvailability;
  final String? pgPropertyType;
  final String? pgBathroomType;
  final String? pgSuitableFor;
  final String? pgBuildingName;
  final int? pgTotalBeds;
  final int? pgAvailableBeds;
  final String? pgRoomType;
  final bool? pgAttachedBathroom;
  final bool? pgBalcony;
  final String? pgRoomSize;
  final String? pgBedType;
  final bool? pgCupboardAvailable;
  final bool? pgStudyTableAvailable;
  final double? pgSecurityDeposit;
  final bool? pgElectricityIncluded;
  final bool? pgWaterIncluded;
  final bool? pgFoodChargesIncluded;
  final bool? pgBrokerageRequired;
  final bool? pgCoupleFriendly;
  final bool? pgIdProofRequired;
  final String? pgAvailableFrom;
  final int? pgMinStayDays;
  final int? pgNoticePeriodDays;
  final int? pgPreferredTenantAge;
  final bool? pgSmokingAllowed;
  final bool? pgDrinkingAllowed;
  final bool? pgPetsAllowed;
  final bool? pgVisitorsAllowed;
  final String? pgCurfewTime;
  final bool? pgGateLockedAtNight;
  final List<String>? pgNearbyPreferences;
  final String? pgAvailability;
  final int? pgSharing;
  final bool? pgSecurity;
  final double? pgMaintenanceCharges;

  final PropertyPgDetails pgDetails;
  final PropertyOfficeDetails officeDetails;
  final PropertyShowroomDetails showroomDetails;
  final PropertyShopDetails shopDetails;
  final PropertyWarehouseDetails warehouseDetails;
  
  var showroomOwneLeaserName;

  Property copyWith({
    String? name,
    String? ownerPhone,
    String? ownerName,
    String? location,
    double? price,
    PropertyType? type,
    List<String>? amenities,
    List<String>? images,
    List<PropertyVideo>? videos,
    String? description,
    PropertyStatus? status,
    String? slug,
    String? listingType,
    String? propertyKind,
    double? area,
    String? areaUnit,
    int? propertyAge,
    String? facing,
    int? floor,
    int? totalFloors,
    String? possessionStatus,
    int? bedrooms,
    int? bathrooms,
    String? furnishing,
    int? parking,
    String? address,
    String? city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    int? primaryImageIndex,
    String? rejectionReason,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? categoryId,
    int? userId,
    bool? isFeatured,
    DateTime? featuredExpiry,
    List<String>? documents,
    List<int>? amenityIds,
    List<PropertyFurnishingSelection>? furnishingSelections,
    Map<String, dynamic>? apiFields,
    Map<String, List<String>>? sectionImagePaths,
    List<String>? documentPaths,

    double? carpetArea,
    double? builtUpArea,
    double? superBuiltUpArea,
    double? plotArea,
    double? plotLength,
    double? plotBreadth,
    int? floorsAllowed,
    int? openSides,
    bool? boundaryWall,
    bool? constructionDone,
    String? availability,
    String? readyTimeframe,
    String? possessionBy,
    String? ownership,
    int? balconies,
    String? commercialType,
    double? floorPlateArea,
    int? cabins,
    int? meetingRooms,
    int? seats,
    int? maxSeats,
    int? conferenceRooms,
    bool? liftAvailable,
    bool? preLeased,
    String? officeType,
    bool? receptionArea,
    bool? pantry,
    bool? cafeteria,
    bool? serverRoom,
    bool? fireSafetyInstalled,
    bool? centralAC,
    bool? visitorParking,
    int? numberOfLifts,
    bool? taxIncluded,
    bool? officeNegotiable,
    double? officeMaintenanceCharges,
    double? officeBookingAmount,
    String? shopType,
    double? shopArea,
    String? shopAreaUnit,
    double? frontageWidth,
    double? ceilingHeight,
    bool? mainRoadFacing,
    bool? cornerShop,
    bool? washroomAvailable,
    String? floorType,
    String? marketName,
    String? locality,
    double? showroomArea,
    String? showroomAreaUnit,
    double? showroomFrontageWidth,
    double? showroomCeilingHeight,
    bool? showroomMainRoadFacing,
    bool? showroomCorner,
    bool? showroomWashroom,
    int? showroomParkingSlots,
    String? showroomFurnishing,
    String? showroomFloorType,
    String? showroomMarketName,
    String? showroomLocality,
    String? showroomOwnerName,
    String? showroomOwnerMobile,
    String? warehouseType,
    double? warehousePlotArea,
    String? warehousePlotAreaUnit,
    double? warehouseCeilingHeight,
    int? warehouseLoadingBays,
    int? warehouseDockLevelers,
    String? warehousePowerSupply,
    bool? warehouseIndustrialLicense,
    String? warehouseTruckAccess,
    String? warehouseAreaName,
    String? warehouseCity,
    String? shopFacade,
    int? washrooms,
    String? parkingType,
    String? plotType,
    int? rooms,
    double? qualityRating,
    String? landType,
    double? roadWidth,
    String? plotAreaUnit,
    bool? plotCorner,
    bool? plotRoadAccess,
    bool? agriFencing,
    String? agriWaterSource,
    List<String>? additionalRooms,
    bool? cornerProperty,
    bool? priceNegotiable,
    double? maintenanceCharges,
    double? bookingAmount,
    List<String>? propertyHighlights,
    bool? whatsappUpdates,
    List<String>? promotionTags,
    List<String>? rentAdditionalRooms,
    bool? rentCornerProperty,
    bool? petFriendly,
    bool? wheelchairFriendly,
    bool? rentGatedSociety,
    double? securityDeposit,
    double? rentMaintenanceCharges,
    double? brokerage,
    bool? rentNegotiable,
    String? availableFrom,
    int? leaseDurationMonths,
    int? lockInMonths,
    int? noticePeriodValue,
    String? noticePeriodUnit,
    String? preferredTenant,
    String? foodPreference,
    List<String>? rentPromotionTypes,
    List<String>? rentVillaOutdoors,
    String? rentVillaWaterSource,
    bool? rentSolarPower,
    bool? rentIndependentEntry,
    bool? rentLiftAvailable,
    String? societyName,
    List<String>? rentTenantTypes,
    String? studioConfig,
    String? kitchenType,
    List<String>? studioTenantPrefs,
    double? rentFarmLandArea,
    int? rentFarmRooms,
    bool? rentFarmPool,
    bool? rentFarmFencing,
    List<String>? rentFarmUseCases,
    double? farmMonthlyCharges,
    double? farmDailyCharges,
    double? farmEventCharges,
    int? minStayDays,
    List<String>? villaAdditionalRooms,
    bool? villaCornerProperty,
    bool? gatedCommunity,
    List<String>? villaParking,
    List<String>? outdoors,
    String? waterSource,
    List<String>? connections,
    bool? villaPriceNegotiable,
    double? villaMaintenanceCharges,
    double? villaBookingAmount,
    bool? builderCornerProperty,
    bool? builderGatedSociety,
    bool? constructionAllowed,
    List<String>? builderUtilities,
    double? pricePerSqft,
    bool? builderNegotiable,
    bool? duplexCornerPlot,
    bool? duplexGatedCommunity,
    bool? duplexConstructionAllowed,
    bool? duplexWaterConnection,
    bool? duplexElectricityConnection,
    bool? duplexNegotiable,
    bool? duplexRoadAccess,
    List<String>? duplexNearbyFacilities,
    double? farmLandArea,
    double? farmBuiltUpArea,
    List<String>? farmUtilities,
    int? farmRooms,
    bool? farmGarden,
    bool? farmSwimmingPool,
    String? village,
    String? landmark,
    String? pgGenderBased,
    String? pgOccupancyType,
    List<String>? pgTenantTypes,
    String? pgFoodAvailability,
    String? pgPropertyType,
    String? pgBathroomType,
    String? pgSuitableFor,
    String? pgBuildingName,
    int? pgTotalBeds,
    int? pgAvailableBeds,
    String? pgRoomType,
    bool? pgAttachedBathroom,
    bool? pgBalcony,
    String? pgRoomSize,
    String? pgBedType,
    bool? pgCupboardAvailable,
    bool? pgStudyTableAvailable,
    double? pgSecurityDeposit,
    bool? pgElectricityIncluded,
    bool? pgWaterIncluded,
    bool? pgFoodChargesIncluded,
    bool? pgBrokerageRequired,
    bool? pgCoupleFriendly,
    bool? pgIdProofRequired,
    String? pgAvailableFrom,
    int? pgMinStayDays,
    int? pgNoticePeriodDays,
    int? pgPreferredTenantAge,
    bool? pgSmokingAllowed,
    bool? pgDrinkingAllowed,
    bool? pgPetsAllowed,
    bool? pgVisitorsAllowed,
    String? pgCurfewTime,
    bool? pgGateLockedAtNight,
    List<String>? pgNearbyPreferences,
    String? pgAvailability,
    int? pgSharing,
    bool? pgSecurity,
    double? pgMaintenanceCharges,
  }) {
    return Property(
      id: id,
      name: name ?? this.name,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerName: ownerName ?? this.ownerName,
      location: location ?? this.location,
      price: price ?? this.price,
      type: type ?? this.type,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      description: description ?? this.description,
      status: status ?? this.status,
      slug: slug ?? this.slug,
      listingType: listingType ?? this.listingType,
      propertyKind: propertyKind ?? this.propertyKind,
      area: area ?? this.area,
      areaUnit: areaUnit ?? this.areaUnit,
      propertyAge: propertyAge ?? this.propertyAge,
      facing: facing ?? this.facing,
      floor: floor ?? this.floor,
      totalFloors: totalFloors ?? this.totalFloors,
      possessionStatus: possessionStatus ?? this.possessionStatus,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      furnishing: furnishing ?? this.furnishing,
      parking: parking ?? this.parking,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      primaryImageIndex: primaryImageIndex ?? this.primaryImageIndex,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      categoryId: categoryId ?? this.categoryId,
      userId: userId ?? this.userId,
      isFeatured: isFeatured ?? this.isFeatured,
      featuredExpiry: featuredExpiry ?? this.featuredExpiry,
      documents: documents ?? this.documents,
      amenityIds: amenityIds ?? this.amenityIds,
      furnishingSelections: furnishingSelections ?? this.furnishingSelections,
      apiFields: apiFields ?? this.apiFields,
      sectionImagePaths: sectionImagePaths ?? this.sectionImagePaths,
      documentPaths: documentPaths ?? this.documentPaths,

      carpetArea: carpetArea ?? this.carpetArea,
      builtUpArea: builtUpArea ?? this.builtUpArea,
      superBuiltUpArea: superBuiltUpArea ?? this.superBuiltUpArea,
      plotArea: plotArea ?? this.plotArea,
      plotLength: plotLength ?? this.plotLength,
      plotBreadth: plotBreadth ?? this.plotBreadth,
      floorsAllowed: floorsAllowed ?? this.floorsAllowed,
      openSides: openSides ?? this.openSides,
      boundaryWall: boundaryWall ?? this.boundaryWall,
      constructionDone: constructionDone ?? this.constructionDone,
      availability: availability ?? this.availability,
      readyTimeframe: readyTimeframe ?? this.readyTimeframe,
      possessionBy: possessionBy ?? this.possessionBy,
      ownership: ownership ?? this.ownership,
      balconies: balconies ?? this.balconies,
      commercialType: commercialType ?? this.commercialType,
      floorPlateArea: floorPlateArea ?? this.floorPlateArea,
      cabins: cabins ?? this.cabins,
      meetingRooms: meetingRooms ?? this.meetingRooms,
      seats: seats ?? this.seats,
      maxSeats: maxSeats ?? this.maxSeats,
      conferenceRooms: conferenceRooms ?? this.conferenceRooms,
      liftAvailable: liftAvailable ?? this.liftAvailable,
      preLeased: preLeased ?? this.preLeased,
      officeType: officeType ?? this.officeType,
      receptionArea: receptionArea ?? this.receptionArea,
      pantry: pantry ?? this.pantry,
      cafeteria: cafeteria ?? this.cafeteria,
      serverRoom: serverRoom ?? this.serverRoom,
      fireSafetyInstalled: fireSafetyInstalled ?? this.fireSafetyInstalled,
      centralAC: centralAC ?? this.centralAC,
      visitorParking: visitorParking ?? this.visitorParking,
      numberOfLifts: numberOfLifts ?? this.numberOfLifts,
      taxIncluded: taxIncluded ?? this.taxIncluded,
      officeNegotiable: officeNegotiable ?? this.officeNegotiable,
      officeMaintenanceCharges: officeMaintenanceCharges ?? this.officeMaintenanceCharges,
      officeBookingAmount: officeBookingAmount ?? this.officeBookingAmount,
      shopType: shopType ?? this.shopType,
      shopArea: shopArea ?? this.shopArea,
      shopAreaUnit: shopAreaUnit ?? this.shopAreaUnit,
      frontageWidth: frontageWidth ?? this.frontageWidth,
      ceilingHeight: ceilingHeight ?? this.ceilingHeight,
      mainRoadFacing: mainRoadFacing ?? this.mainRoadFacing,
      cornerShop: cornerShop ?? this.cornerShop,
      washroomAvailable: washroomAvailable ?? this.washroomAvailable,
      floorType: floorType ?? this.floorType,
      marketName: marketName ?? this.marketName,
      locality: locality ?? this.locality,
      showroomArea: showroomArea ?? this.showroomArea,
      showroomAreaUnit: showroomAreaUnit ?? this.showroomAreaUnit,
      showroomFrontageWidth: showroomFrontageWidth ?? this.showroomFrontageWidth,
      showroomCeilingHeight: showroomCeilingHeight ?? this.showroomCeilingHeight,
      showroomMainRoadFacing: showroomMainRoadFacing ?? this.showroomMainRoadFacing,
      showroomCorner: showroomCorner ?? this.showroomCorner,
      showroomWashroom: showroomWashroom ?? this.showroomWashroom,
      showroomParkingSlots: showroomParkingSlots ?? this.showroomParkingSlots,
      showroomFurnishing: showroomFurnishing ?? this.showroomFurnishing,
      showroomFloorType: showroomFloorType ?? this.showroomFloorType,
      showroomMarketName: showroomMarketName ?? this.showroomMarketName,
      showroomLocality: showroomLocality ?? this.showroomLocality,
      showroomOwnerName: showroomOwnerName ?? this.showroomOwnerName,
      showroomOwnerMobile: showroomOwnerMobile ?? this.showroomOwnerMobile,
      warehouseType: warehouseType ?? this.warehouseType,
      warehousePlotArea: warehousePlotArea ?? this.warehousePlotArea,
      warehousePlotAreaUnit: warehousePlotAreaUnit ?? this.warehousePlotAreaUnit,
      warehouseCeilingHeight: warehouseCeilingHeight ?? this.warehouseCeilingHeight,
      warehouseLoadingBays: warehouseLoadingBays ?? this.warehouseLoadingBays,
      warehouseDockLevelers: warehouseDockLevelers ?? this.warehouseDockLevelers,
      warehousePowerSupply: warehousePowerSupply ?? this.warehousePowerSupply,
      warehouseIndustrialLicense: warehouseIndustrialLicense ?? this.warehouseIndustrialLicense,
      warehouseTruckAccess: warehouseTruckAccess ?? this.warehouseTruckAccess,
      warehouseAreaName: warehouseAreaName ?? this.warehouseAreaName,
      warehouseCity: warehouseCity ?? this.warehouseCity,
      shopFacade: shopFacade ?? this.shopFacade,
      washrooms: washrooms ?? this.washrooms,
      parkingType: parkingType ?? this.parkingType,
      plotType: plotType ?? this.plotType,
      rooms: rooms ?? this.rooms,
      qualityRating: qualityRating ?? this.qualityRating,
      landType: landType ?? this.landType,
      roadWidth: roadWidth ?? this.roadWidth,
      plotAreaUnit: plotAreaUnit ?? this.plotAreaUnit,
      plotCorner: plotCorner ?? this.plotCorner,
      plotRoadAccess: plotRoadAccess ?? this.plotRoadAccess,
      agriFencing: agriFencing ?? this.agriFencing,
      agriWaterSource: agriWaterSource ?? this.agriWaterSource,
      additionalRooms: additionalRooms ?? this.additionalRooms,
      cornerProperty: cornerProperty ?? this.cornerProperty,
      priceNegotiable: priceNegotiable ?? this.priceNegotiable,
      maintenanceCharges: maintenanceCharges ?? this.maintenanceCharges,
      bookingAmount: bookingAmount ?? this.bookingAmount,
      propertyHighlights: propertyHighlights ?? this.propertyHighlights,
      whatsappUpdates: whatsappUpdates ?? this.whatsappUpdates,
      promotionTags: promotionTags ?? this.promotionTags,
      rentAdditionalRooms: rentAdditionalRooms ?? this.rentAdditionalRooms,
      rentCornerProperty: rentCornerProperty ?? this.rentCornerProperty,
      petFriendly: petFriendly ?? this.petFriendly,
      wheelchairFriendly: wheelchairFriendly ?? this.wheelchairFriendly,
      rentGatedSociety: rentGatedSociety ?? this.rentGatedSociety,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      rentMaintenanceCharges: rentMaintenanceCharges ?? this.rentMaintenanceCharges,
      brokerage: brokerage ?? this.brokerage,
      rentNegotiable: rentNegotiable ?? this.rentNegotiable,
      availableFrom: availableFrom ?? this.availableFrom,
      leaseDurationMonths: leaseDurationMonths ?? this.leaseDurationMonths,
      lockInMonths: lockInMonths ?? this.lockInMonths,
      noticePeriodValue: noticePeriodValue ?? this.noticePeriodValue,
      noticePeriodUnit: noticePeriodUnit ?? this.noticePeriodUnit,
      preferredTenant: preferredTenant ?? this.preferredTenant,
      foodPreference: foodPreference ?? this.foodPreference,
      rentPromotionTypes: rentPromotionTypes ?? this.rentPromotionTypes,
      rentVillaOutdoors: rentVillaOutdoors ?? this.rentVillaOutdoors,
      rentVillaWaterSource: rentVillaWaterSource ?? this.rentVillaWaterSource,
      rentSolarPower: rentSolarPower ?? this.rentSolarPower,
      rentIndependentEntry: rentIndependentEntry ?? this.rentIndependentEntry,
      rentLiftAvailable: rentLiftAvailable ?? this.rentLiftAvailable,
      societyName: societyName ?? this.societyName,
      rentTenantTypes: rentTenantTypes ?? this.rentTenantTypes,
      studioConfig: studioConfig ?? this.studioConfig,
      kitchenType: kitchenType ?? this.kitchenType,
      studioTenantPrefs: studioTenantPrefs ?? this.studioTenantPrefs,
      rentFarmLandArea: rentFarmLandArea ?? this.rentFarmLandArea,
      rentFarmRooms: rentFarmRooms ?? this.rentFarmRooms,
      rentFarmPool: rentFarmPool ?? this.rentFarmPool,
      rentFarmFencing: rentFarmFencing ?? this.rentFarmFencing,
      rentFarmUseCases: rentFarmUseCases ?? this.rentFarmUseCases,
      farmMonthlyCharges: farmMonthlyCharges ?? this.farmMonthlyCharges,
      farmDailyCharges: farmDailyCharges ?? this.farmDailyCharges,
      farmEventCharges: farmEventCharges ?? this.farmEventCharges,
      minStayDays: minStayDays ?? this.minStayDays,
      villaAdditionalRooms: villaAdditionalRooms ?? this.villaAdditionalRooms,
      villaCornerProperty: villaCornerProperty ?? this.villaCornerProperty,
      gatedCommunity: gatedCommunity ?? this.gatedCommunity,
      villaParking: villaParking ?? this.villaParking,
      outdoors: outdoors ?? this.outdoors,
      waterSource: waterSource ?? this.waterSource,
      connections: connections ?? this.connections,
      villaPriceNegotiable: villaPriceNegotiable ?? this.villaPriceNegotiable,
      villaMaintenanceCharges: villaMaintenanceCharges ?? this.villaMaintenanceCharges,
      villaBookingAmount: villaBookingAmount ?? this.villaBookingAmount,
      builderCornerProperty: builderCornerProperty ?? this.builderCornerProperty,
      builderGatedSociety: builderGatedSociety ?? this.builderGatedSociety,
      constructionAllowed: constructionAllowed ?? this.constructionAllowed,
      builderUtilities: builderUtilities ?? this.builderUtilities,
      pricePerSqft: pricePerSqft ?? this.pricePerSqft,
      builderNegotiable: builderNegotiable ?? this.builderNegotiable,
      duplexCornerPlot: duplexCornerPlot ?? this.duplexCornerPlot,
      duplexGatedCommunity: duplexGatedCommunity ?? this.duplexGatedCommunity,
      duplexConstructionAllowed: duplexConstructionAllowed ?? this.duplexConstructionAllowed,
      duplexWaterConnection: duplexWaterConnection ?? this.duplexWaterConnection,
      duplexElectricityConnection: duplexElectricityConnection ?? this.duplexElectricityConnection,
      duplexNegotiable: duplexNegotiable ?? this.duplexNegotiable,
      duplexRoadAccess: duplexRoadAccess ?? this.duplexRoadAccess,
      duplexNearbyFacilities: duplexNearbyFacilities ?? this.duplexNearbyFacilities,
      farmLandArea: farmLandArea ?? this.farmLandArea,
      farmBuiltUpArea: farmBuiltUpArea ?? this.farmBuiltUpArea,
      farmUtilities: farmUtilities ?? this.farmUtilities,
      farmRooms: farmRooms ?? this.farmRooms,
      farmGarden: farmGarden ?? this.farmGarden,
      farmSwimmingPool: farmSwimmingPool ?? this.farmSwimmingPool,
      village: village ?? this.village,
      landmark: landmark ?? this.landmark,
      pgGenderBased: pgGenderBased ?? this.pgGenderBased,
      pgOccupancyType: pgOccupancyType ?? this.pgOccupancyType,
      pgTenantTypes: pgTenantTypes ?? this.pgTenantTypes,
      pgFoodAvailability: pgFoodAvailability ?? this.pgFoodAvailability,
      pgPropertyType: pgPropertyType ?? this.pgPropertyType,
      pgBathroomType: pgBathroomType ?? this.pgBathroomType,
      pgSuitableFor: pgSuitableFor ?? this.pgSuitableFor,
      pgBuildingName: pgBuildingName ?? this.pgBuildingName,
      pgTotalBeds: pgTotalBeds ?? this.pgTotalBeds,
      pgAvailableBeds: pgAvailableBeds ?? this.pgAvailableBeds,
      pgRoomType: pgRoomType ?? this.pgRoomType,
      pgAttachedBathroom: pgAttachedBathroom ?? this.pgAttachedBathroom,
      pgBalcony: pgBalcony ?? this.pgBalcony,
      pgRoomSize: pgRoomSize ?? this.pgRoomSize,
      pgBedType: pgBedType ?? this.pgBedType,
      pgCupboardAvailable: pgCupboardAvailable ?? this.pgCupboardAvailable,
      pgStudyTableAvailable: pgStudyTableAvailable ?? this.pgStudyTableAvailable,
      pgSecurityDeposit: pgSecurityDeposit ?? this.pgSecurityDeposit,
      pgElectricityIncluded: pgElectricityIncluded ?? this.pgElectricityIncluded,
      pgWaterIncluded: pgWaterIncluded ?? this.pgWaterIncluded,
      pgFoodChargesIncluded: pgFoodChargesIncluded ?? this.pgFoodChargesIncluded,
      pgBrokerageRequired: pgBrokerageRequired ?? this.pgBrokerageRequired,
      pgCoupleFriendly: pgCoupleFriendly ?? this.pgCoupleFriendly,
      pgIdProofRequired: pgIdProofRequired ?? this.pgIdProofRequired,
      pgAvailableFrom: pgAvailableFrom ?? this.pgAvailableFrom,
      pgMinStayDays: pgMinStayDays ?? this.pgMinStayDays,
      pgNoticePeriodDays: pgNoticePeriodDays ?? this.pgNoticePeriodDays,
      pgPreferredTenantAge: pgPreferredTenantAge ?? this.pgPreferredTenantAge,
      pgSmokingAllowed: pgSmokingAllowed ?? this.pgSmokingAllowed,
      pgDrinkingAllowed: pgDrinkingAllowed ?? this.pgDrinkingAllowed,
      pgPetsAllowed: pgPetsAllowed ?? this.pgPetsAllowed,
      pgVisitorsAllowed: pgVisitorsAllowed ?? this.pgVisitorsAllowed,
      pgCurfewTime: pgCurfewTime ?? this.pgCurfewTime,
      pgGateLockedAtNight: pgGateLockedAtNight ?? this.pgGateLockedAtNight,
      pgNearbyPreferences: pgNearbyPreferences ?? this.pgNearbyPreferences,
      pgAvailability: pgAvailability ?? this.pgAvailability,
      pgSharing: pgSharing ?? this.pgSharing,
      pgSecurity: pgSecurity ?? this.pgSecurity,
      pgMaintenanceCharges: pgMaintenanceCharges ?? this.pgMaintenanceCharges,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'owner_phone': ownerPhone,
        'owner_name': ownerName,
        'location': location,
        'price': price,
        'type': type.name,
        'amenities': amenities,
        'images': images,
        'videos': videos.map((e) => e.toJson()).toList(),
        'description': description,
        'status': status.name,
        'slug': slug,
        'listing_type': listingType,
        'property_kind': propertyKind,
        'area': area,
        'area_unit': areaUnit,
        'property_age': propertyAge,
        'facing': facing,
        'floor': floor,
        'total_floors': totalFloors,
        'possession_status': possessionStatus,
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
        'furnishing': furnishing,
        'parking': parking,
        'address': address,
        'city': city,
        'state': state,
        'pincode': pincode,
        'latitude': latitude,
        'longitude': longitude,
        'primary_image_index': primaryImageIndex,
        'rejection_reason': rejectionReason,
        'updated_at': updatedAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'category_id': categoryId,
        'user_id': userId,
        'is_featured': isFeatured,
        'featured_expiry': featuredExpiry?.toIso8601String(),
        'documents': documents,
        'amenity_ids': amenityIds,

        'carpet_area': carpetArea,
        'built_up_area': builtUpArea,
        'super_built_up_area': superBuiltUpArea,
        'plot_area': plotArea,
        'plot_length': plotLength,
        'plot_breadth': plotBreadth,
        'floors_allowed': floorsAllowed,
        'open_sides': openSides,
        'boundary_wall': boundaryWall,
        'construction_done': constructionDone,
        'availability': availability,
        'ready_timeframe': readyTimeframe,
        'possession_by': possessionBy,
        'ownership': ownership,
        'balconies': balconies,
        'commercial_type': commercialType,
        'floor_plate_area': floorPlateArea,
        'cabins': cabins,
        'meeting_rooms': meetingRooms,
        'seats': seats,
        'max_seats': maxSeats,
        'conference_rooms': conferenceRooms,
        'lift_available': liftAvailable,
        'pre_leased': preLeased,
        'office_type': officeType,
        'reception_area': receptionArea,
        'pantry': pantry,
        'cafeteria': cafeteria,
        'server_room': serverRoom,
        'fire_safety_installed': fireSafetyInstalled,
        'central_ac': centralAC,
        'visitor_parking': visitorParking,
        'number_of_lifts': numberOfLifts,
        'tax_included': taxIncluded,
        'price_negotiable_office': officeNegotiable,
        'maintenance_charges_office': officeMaintenanceCharges,
        'booking_amount_office': officeBookingAmount,
        'shop_type': shopType,
        'shop_area': shopArea,
        'shop_area_unit': shopAreaUnit,
        'frontage_width': frontageWidth,
        'ceiling_height': ceilingHeight,
        'main_road_facing': mainRoadFacing,
        'corner_shop': cornerShop,
        'washroom_available': washroomAvailable,
        'floor_type': floorType,
        'market_name': marketName,
        'locality': locality,
        'showroom_area': showroomArea,
        'showroom_area_unit': showroomAreaUnit,
        'showroom_frontage_width_ft': showroomFrontageWidth,
        'showroom_ceiling_height_ft': showroomCeilingHeight,
        'showroom_main_road_facing': showroomMainRoadFacing,
        'corner_showroom': showroomCorner,
        'showroom_washroom_available': showroomWashroom,
        'showroom_parking_slots': showroomParkingSlots,
        'showroom_furnishing_status': showroomFurnishing,
        'showroom_floor_type': showroomFloorType,
        'showroom_market_name': showroomMarketName,
        'showroom_locality': showroomLocality,
        'showroom_owner_name': showroomOwnerName,
        'showroom_owner_mobile': showroomOwnerMobile,
        'warehouse_type': warehouseType,
        'warehouse_plot_area': warehousePlotArea,
        'warehouse_plot_area_unit': warehousePlotAreaUnit,
        'warehouse_ceiling_height_ft': warehouseCeilingHeight,
        'loading_bays': warehouseLoadingBays,
        'dock_levelers': warehouseDockLevelers,
        'power_supply': warehousePowerSupply,
        'industrial_license': warehouseIndustrialLicense,
        'truck_access': warehouseTruckAccess,
        'industrial_area_name': warehouseAreaName,
        'industrial_area_city': warehouseCity,
        'shop_facade': shopFacade,
        'washrooms': washrooms,
        'parking_type': parkingType,
        'plot_type': plotType,
        'rooms': rooms,
        'quality_rating': qualityRating,
        'land_type': landType,
        'road_width': roadWidth,
        'plot_area_unit': plotAreaUnit,
        'corner_plot': plotCorner,
        'road_access': plotRoadAccess,
        'fencing': agriFencing,
        'water_source': agriWaterSource,
        'additional_rooms': additionalRooms,
        'corner_property': cornerProperty,
        'price_negotiable': priceNegotiable,
        'maintenance_charges': maintenanceCharges,
        'booking_amount': bookingAmount,
        'property_highlights': propertyHighlights,
        'whatsapp_updates': whatsappUpdates,
        'promotion': promotionTags,
        'rent_additional_rooms': rentAdditionalRooms,
        'rent_corner_property': rentCornerProperty,
        'pet_friendly': petFriendly,
        'wheelchair_friendly': wheelchairFriendly,
        'gated_society_rent': rentGatedSociety,
        'security_deposit': securityDeposit,
        'maintenance_charges_rent': rentMaintenanceCharges,
        'brokerage': brokerage,
        'rent_negotiable': rentNegotiable,
        'available_from': availableFrom,
        'lease_duration_months': leaseDurationMonths,
        'lock_in_months': lockInMonths,
        'notice_period_value': noticePeriodValue,
        'notice_period_unit': noticePeriodUnit,
        'preferred_tenant': preferredTenant,
        'food_preference': foodPreference,
        'rent_promotion': rentPromotionTypes,
        'rent_villa_outdoors': rentVillaOutdoors,
        'rent_villa_water_source': rentVillaWaterSource,
        'solar_power': rentSolarPower,
        'independent_entry': rentIndependentEntry,
        'lift_available_rent': rentLiftAvailable,
        'society_name': societyName,
        'tenant_types': rentTenantTypes,
        'studio_config': studioConfig,
        'kitchen_type': kitchenType,
        'studio_tenant_preferences': studioTenantPrefs,
        'farm_land_area_rent': rentFarmLandArea,
        'farm_rooms_rent': rentFarmRooms,
        'farm_pool_rent': rentFarmPool,
        'farm_fencing_rent': rentFarmFencing,
        'farm_use_cases': rentFarmUseCases,
        'farm_monthly_charges': farmMonthlyCharges,
        'farm_daily_charges': farmDailyCharges,
        'farm_event_charges': farmEventCharges,
        'min_stay_days': minStayDays,
        'villa_additional_rooms': villaAdditionalRooms,
        'villa_corner_property': villaCornerProperty,
        'gated_community': gatedCommunity,
        'parking_types': villaParking,
        'outdoors': outdoors,
        'villa_water_source': waterSource,
        'connections': connections,
        'villa_price_negotiable': villaPriceNegotiable,
        'villa_maintenance_charges': villaMaintenanceCharges,
        'villa_booking_amount': villaBookingAmount,
        'builder_corner_property': builderCornerProperty,
        'builder_gated_society': builderGatedSociety,
        'construction_allowed': constructionAllowed,
        'utilities': builderUtilities,
        'price_per_sqft': pricePerSqft,
        'negotiable': builderNegotiable,
        'duplex_corner_plot': duplexCornerPlot,
        'duplex_gated_community': duplexGatedCommunity,
        'duplex_construction_allowed': duplexConstructionAllowed,
        'duplex_water_connection': duplexWaterConnection,
        'duplex_electricity_connection': duplexElectricityConnection,
        'duplex_negotiable': duplexNegotiable,
        'duplex_road_access': duplexRoadAccess,
        'duplex_nearby_facilities': duplexNearbyFacilities,
        'farm_land_area': farmLandArea,
        'farm_built_up_area': farmBuiltUpArea,
        'farm_utilities': farmUtilities,
        'farm_rooms': farmRooms,
        'farm_garden': farmGarden,
        'farm_swimming_pool': farmSwimmingPool,
        'village': village,
        'landmark': landmark,
        'pg_gender_based': pgGenderBased,
        'pg_occupancy_type': pgOccupancyType,
        'pg_tenant_types': pgTenantTypes,
        'pg_food_availability': pgFoodAvailability,
        'pg_property_type': pgPropertyType,
        'pg_bathroom_type': pgBathroomType,
        'pg_suitable_for': pgSuitableFor,
        'pg_building_name': pgBuildingName,
        'pg_total_beds': pgTotalBeds,
        'pg_available_beds': pgAvailableBeds,
        'pg_room_type': pgRoomType,
        'pg_attached_bathroom': pgAttachedBathroom,
        'pg_balcony': pgBalcony,
        'pg_room_size': pgRoomSize,
        'pg_bed_type': pgBedType,
        'pg_cupboard_available': pgCupboardAvailable,
        'pg_study_table_available': pgStudyTableAvailable,
        'pg_security_deposit': pgSecurityDeposit,
        'pg_electricity_included': pgElectricityIncluded,
        'pg_water_included': pgWaterIncluded,
        'pg_food_charges_included': pgFoodChargesIncluded,
        'pg_brokerage_required': pgBrokerageRequired,
        'pg_couple_friendly': pgCoupleFriendly,
        'pg_id_proof_required': pgIdProofRequired,
        'pg_available_from': pgAvailableFrom,
        'pg_min_stay_days': pgMinStayDays,
        'pg_notice_period_days': pgNoticePeriodDays,
        'pg_preferred_tenant_age': pgPreferredTenantAge,
        'pg_smoking_allowed': pgSmokingAllowed,
        'pg_drinking_allowed': pgDrinkingAllowed,
        'pg_pets_allowed': pgPetsAllowed,
        'pg_visitors_allowed': pgVisitorsAllowed,
        'pg_curfew_time': pgCurfewTime,
        'pg_gate_locked_at_night': pgGateLockedAtNight,
        'pg_nearby_preferences': pgNearbyPreferences,
        'pg_availability': pgAvailability,
        'pg_sharing': pgSharing,
        'pg_security': pgSecurity,
        'pg_maintenance_charges': pgMaintenanceCharges,
      };

  factory Property.fromJson(Map<String, dynamic> json) {
    final f = json;
final pg = (f['pg_details'] as Map?) ?? {};
    int? toInt(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toInt();
      if (val is String) {
        final s = val.trim();
        if (s.isEmpty) return null;
        return int.tryParse(s);
      }
      return null;
    }

    double? toDouble(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      if (val is String) {
        final s = val.trim();
        if (s.isEmpty) return null;
        return double.tryParse(s);
      }
      return null;
    }

    bool? toBool(dynamic val) {
      if (val == null) return null;
      if (val is bool) return val;
      if (val is num) return val != 0;
      if (val is String) {
        final s = val.trim().toLowerCase();
        if (s == 'true' || s == '1') return true;
        if (s == 'false' || s == '0') return false;
      }
      return null;
    }

    List<String> toStringList(dynamic val) {
      if (val is List) {
        return val.map((e) => e.toString().trim()).where((s) => s.isNotEmpty).toList();
      }
      if (val is String && val.trim().isNotEmpty) {
        return val.split(',').map((e) => e.trim()).where((s) => s.isNotEmpty).toList();
      }
      return const [];
    }

    return Property(
      
      id: (f['id'] ?? '').toString(),
name: (f['title'] ?? f['name'] ?? '').toString(),      ownerPhone: f['ownerPhone']?.toString() ??
          f['owner_phone']?.toString() ??
          '',
      ownerName: (f['ownerName'] ?? f['owner_name'] ?? '').toString(),
location: (
  f['location'] ??
  f['address'] ??
  f['city'] ??
  ''
).toString(),      price: (f['price'] as num?)?.toDouble() ?? 0,
      type: PropertyType.values.byName((f['type'] ?? 'rent').toString()),
      amenities: toStringList(f['amenities']),
      
      // Parse images flexibly supporting both Map objects and string lists.
      images: ((f['images'] as List?) ?? const [])
          .map((e) {
            if (e is Map) {
              return (e['image_path'] ?? e['path'] ?? '').toString();
            }
            return e.toString();
          })
          .where((s) => s.isNotEmpty)
          .toList(),

      videos: ((f['videos'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => PropertyVideo.fromJson(Map<String, dynamic>.from(e)))
          .toList(growable: false),
      description: (f['description'] ?? '').toString(),
      status: PropertyStatus.values.byName((f['status'] ?? 'pending').toString()),
      slug: f['slug']?.toString(),
      listingType: f['listingType']?.toString() ?? f['listing_type']?.toString(),
      propertyKind: f['propertyKind']?.toString() ?? f['property_kind']?.toString(),
      area: f['area'] is num
          ? (f['area'] as num).toDouble()
          : double.tryParse(f['area']?.toString() ?? ''),
      areaUnit: f['areaUnit']?.toString() ?? f['area_unit']?.toString(),
      propertyAge: toInt(f['propertyAge'] ?? f['property_age']),
      facing: f['facing']?.toString(),
      floor: toInt(f['floor']),
      totalFloors: toInt(f['totalFloors'] ?? f['total_floors']),
      possessionStatus: f['possessionStatus']?.toString() ?? f['possession_status']?.toString(),
      bedrooms: toInt(f['bedrooms']),
      bathrooms: toInt(f['bathrooms']),
      furnishing: f['furnishing']?.toString(),
      parking: toInt(f['parking']),
      address: f['address']?.toString(),
      city: f['city']?.toString(),
      state: f['state']?.toString(),
      pincode: f['pincode']?.toString(),
      latitude: f['latitude'] is num
          ? (f['latitude'] as num).toDouble()
          : double.tryParse(f['latitude']?.toString() ?? ''),
      longitude: f['longitude'] is num
          ? (f['longitude'] as num).toDouble()
          : double.tryParse(f['longitude']?.toString() ?? ''),
      primaryImageIndex: toInt(f['primaryImageIndex'] ?? f['primary_image_index']),
      rejectionReason: f['rejectionReason']?.toString() ?? f['rejection_reason']?.toString(),
      updatedAt: f['updatedAt'] == null ? (f['updated_at'] == null ? null : DateTime.tryParse(f['updated_at'].toString())) : DateTime.tryParse(f['updatedAt'].toString()),
      createdAt: f['createdAt'] == null ? (f['created_at'] == null ? null : DateTime.tryParse(f['created_at'].toString())) : DateTime.tryParse(f['createdAt'].toString()),
      categoryId: f['categoryId']?.toString() ?? f['category_id']?.toString(),
      userId: toInt(f['userId'] ?? f['user_id']),
      isFeatured: toBool(f['isFeatured'] ?? f['is_featured']),
      featuredExpiry: f['featuredExpiry'] == null ? (f['featured_expiry'] == null ? null : DateTime.tryParse(f['featured_expiry'].toString())) : DateTime.tryParse(f['featuredExpiry'].toString()),
      documents: toStringList(f['documents']),
      amenityIds: () {
        final list1 = f['amenityIds'] as List? ?? f['amenity_ids'] as List?;
        if (list1 != null) {
          return list1
              .map((e) {
                if (e is Map) {
                  final idVal = e['id'] ?? (e['pivot'] as Map?)?['feature_id'];
                  return idVal is num ? idVal.toInt() : int.tryParse(idVal?.toString() ?? '');
                }
                return e is num ? e.toInt() : int.tryParse(e.toString());
              })
              .whereType<int>()
              .toList();
        }
        return <int>[];
      }(),
      furnishingSelections: () {
        final list = f['furnishings'] as List? ??
            f['furnishing_selections'] as List? ??
            f['furnishingSelections'] as List?;
        if (list == null) return <PropertyFurnishingSelection>[];
        return list
            .map((e) {
              if (e is Map) {
                final idVal = e['id'] ?? (e['pivot'] as Map?)?['feature_id'];
                final id = idVal is num ? idVal.toInt() : int.tryParse(idVal?.toString() ?? '');
                final qVal = e['quantity'] ?? (e['pivot'] as Map?)?['quantity'];
                final quantity = qVal is num ? qVal.toInt() : int.tryParse(qVal?.toString() ?? '') ?? 1;
                if (id != null) {
                  return PropertyFurnishingSelection(id: id, quantity: quantity);
                }
              }
              return null;
            })
            .whereType<PropertyFurnishingSelection>()
            .toList();
      }(),

      // Store raw API response
      apiFields: json,

      carpetArea: toDouble(f['carpetArea'] ?? f['carpet_area']),
      builtUpArea: toDouble(f['builtUpArea'] ?? f['built_up_area']),
      superBuiltUpArea: toDouble(f['superBuiltUpArea'] ?? f['super_built_up_area']),
      plotArea: toDouble(f['plotArea'] ?? f['plot_area']),
      plotLength: toDouble(f['plotLength'] ?? f['plot_length'] ?? f['plot_length_ft']),
      plotBreadth: toDouble(f['plotBreadth'] ?? f['plot_breadth'] ?? f['plot_breadth_ft']),
      floorsAllowed: toInt(f['floorsAllowed'] ?? f['floors_allowed']),
      openSides: toInt(f['openSides'] ?? f['open_sides']),
      boundaryWall: toBool(f['boundaryWall'] ?? f['boundary_wall']),
      constructionDone: toBool(f['constructionDone'] ?? f['construction_done']),
      availability: f['availability']?.toString(),
      readyTimeframe: f['readyTimeframe']?.toString() ?? f['ready_timeframe']?.toString(),
      possessionBy: f['possessionBy']?.toString() ?? f['possession_by']?.toString(),
      ownership: f['ownership']?.toString(),
      balconies: toInt(f['balconies'] ?? f['balcony']),

      commercialType: f['commercialType']?.toString() ?? f['commercial_type']?.toString(),
      floorPlateArea: toDouble(f['floorPlateArea'] ?? f['floor_plate_area']),
      cabins: toInt(f['cabins']),
      meetingRooms: toInt(f['meetingRooms'] ?? f['meeting_rooms']),
      seats: toInt(f['seats']),
      maxSeats: toInt(f['maxSeats'] ?? f['max_seats']),
      conferenceRooms: toInt(f['conferenceRooms'] ?? f['conference_rooms']),
      liftAvailable: toBool(f['liftAvailable'] ?? f['lift_available'] ?? f['goods_lift']),
      preLeased: toBool(f['preLeased'] ?? f['pre_leased']),
      officeType: f['officeType']?.toString() ?? f['office_type']?.toString(),
      receptionArea: toBool(f['receptionArea'] ?? f['reception_area']),
      pantry: toBool(f['pantry']),
      cafeteria: toBool(f['cafeteria']),
      serverRoom: toBool(f['serverRoom'] ?? f['server_room']),
      fireSafetyInstalled: toBool(f['fireSafetyInstalled'] ?? f['fire_safety_installed']),
      centralAC: toBool(f['centralAC'] ?? f['central_ac']),
      visitorParking: toBool(f['visitorParking'] ?? f['visitor_parking'] ?? f['commercial_parking']),
      numberOfLifts: toInt(f['numberOfLifts'] ?? f['number_of_lifts']),
      taxIncluded: toBool(f['taxIncluded'] ?? f['tax_included']),
      officeNegotiable: toBool(f['officeNegotiable'] ?? f['price_negotiable_office'] ?? f['negotiable']),
      officeMaintenanceCharges: toDouble(f['officeMaintenanceCharges'] ?? f['maintenance_charges_office'] ?? f['maintenance_charges']),
      officeBookingAmount: toDouble(f['officeBookingAmount'] ?? f['booking_amount_office'] ?? f['booking_amount']),

      shopType: f['shopType']?.toString() ?? f['shop_type']?.toString(),
      shopArea: toDouble(f['shopArea'] ?? f['shop_area']),
      shopAreaUnit: f['shopAreaUnit']?.toString() ?? f['shop_area_unit']?.toString(),
      frontageWidth: toDouble(f['frontageWidth'] ?? f['frontage_width'] ?? f['frontage_width_ft']),
      ceilingHeight: toDouble(f['ceilingHeight'] ?? f['ceiling_height'] ?? f['ceiling_height_ft']),
      mainRoadFacing: toBool(f['mainRoadFacing'] ?? f['main_road_facing']),
      cornerShop: toBool(f['cornerShop'] ?? f['corner_shop']),
      washroomAvailable: toBool(f['washroomAvailable'] ?? f['washroom_available']),
      floorType: f['floorType']?.toString() ?? f['floor_type']?.toString(),
      marketName: f['marketName']?.toString() ?? f['market_name']?.toString(),
      locality: f['locality']?.toString(),

      showroomArea: toDouble(f['showroomArea'] ?? f['showroom_area']),
      showroomAreaUnit: f['showroomAreaUnit']?.toString() ?? f['showroom_area_unit']?.toString(),
      showroomFrontageWidth: toDouble(f['showroomFrontageWidth'] ?? f['showroom_frontage_width'] ?? f['showroom_frontage_width_ft']),
      showroomCeilingHeight: toDouble(f['showroomCeilingHeight'] ?? f['showroom_ceiling_height'] ?? f['showroom_ceiling_height_ft']),
      showroomMainRoadFacing: toBool(f['showroomMainRoadFacing'] ?? f['showroom_main_road_facing']),
      showroomCorner: toBool(f['showroomCorner'] ?? f['corner_showroom']),
      showroomWashroom: toBool(f['showroomWashroom'] ?? f['showroom_washroom_available']),
      showroomParkingSlots: toInt(f['showroomParkingSlots'] ?? f['showroom_parking_slots']),
      showroomFurnishing: f['showroomFurnishing']?.toString() ?? f['showroom_furnishing_status']?.toString(),
      showroomFloorType: f['showroomFloorType']?.toString() ?? f['showroom_floor_type']?.toString(),
      showroomMarketName: f['showroomMarketName']?.toString() ?? f['showroom_market_name']?.toString(),
      showroomLocality: f['showroomLocality']?.toString() ?? f['showroom_locality']?.toString(),
      showroomOwnerName: f['showroomOwnerName']?.toString() ?? f['showroom_owner_name']?.toString(),
      showroomOwnerMobile: f['showroomOwnerMobile']?.toString() ?? f['showroom_owner_mobile']?.toString(),

      warehouseType: f['warehouseType']?.toString() ?? f['warehouse_type']?.toString(),
      warehousePlotArea: toDouble(f['warehousePlotArea'] ?? f['warehouse_plot_area']),
      warehousePlotAreaUnit: f['warehousePlotAreaUnit']?.toString() ?? f['warehouse_plot_area_unit']?.toString(),
      warehouseCeilingHeight: toDouble(f['warehouseCeilingHeight'] ?? f['warehouse_ceiling_height'] ?? f['warehouse_ceiling_height_ft']),
      warehouseLoadingBays: toInt(f['warehouseLoadingBays'] ?? f['loading_bays']),
      warehouseDockLevelers: toInt(f['warehouseDockLevelers'] ?? f['dock_levelers']),
      warehousePowerSupply: f['warehousePowerSupply']?.toString() ?? f['power_supply']?.toString(),
      warehouseIndustrialLicense: toBool(f['warehouseIndustrialLicense'] ?? f['industrial_license']),
      warehouseTruckAccess: f['warehouseTruckAccess']?.toString() ?? f['truck_access']?.toString(),
      warehouseAreaName: f['warehouseAreaName']?.toString() ?? f['industrial_area_name']?.toString(),
      warehouseCity: f['warehouseCity']?.toString() ?? f['industrial_area_city']?.toString(),

      shopFacade: f['shopFacade']?.toString() ?? f['shop_facade']?.toString(),
      washrooms: toInt(f['washrooms']),
      parkingType: f['parkingType']?.toString() ?? f['parking_type']?.toString(),
      plotType: f['plotType']?.toString() ?? f['plot_type']?.toString(),
      rooms: toInt(f['rooms'] ?? f['pg_total_rooms']),
      qualityRating: toDouble(f['qualityRating'] ?? f['quality_rating']),

      landType: f['landType']?.toString() ?? f['land_type']?.toString(),
      roadWidth: toDouble(f['roadWidth'] ?? f['road_width'] ?? f['road_width_ft']),
      plotAreaUnit: f['plotAreaUnit']?.toString() ?? f['plot_area_unit']?.toString(),
      plotCorner: toBool(f['plotCorner'] ?? f['corner_plot'] ?? f['plot_corner']),
      plotRoadAccess: toBool(f['plotRoadAccess'] ?? f['road_access']),
      agriFencing: toBool(f['agriFencing'] ?? f['fencing'] ?? f['agri_fencing']),
      agriWaterSource: f['agriWaterSource']?.toString() ?? f['water_source']?.toString() ?? f['agri_water_source']?.toString(),

      additionalRooms: toStringList(f['additionalRooms'] ?? f['additional_rooms']),
      cornerProperty: toBool(f['cornerProperty'] ?? f['corner_property']),
      priceNegotiable: toBool(f['priceNegotiable'] ?? f['price_negotiable']),
      maintenanceCharges: toDouble(f['maintenanceCharges'] ?? f['maintenance_charges']),
      bookingAmount: toDouble(f['bookingAmount'] ?? f['booking_amount']),
      propertyHighlights: toStringList(f['propertyHighlights'] ?? f['property_highlights']),
      whatsappUpdates: toBool(f['whatsappUpdates'] ?? f['whatsapp_updates']),
      promotionTags: toStringList(f['promotionTags'] ?? f['promotion']),

      rentAdditionalRooms: toStringList(f['rentAdditionalRooms'] ?? f['rent_additional_rooms']),
      rentCornerProperty: toBool(f['rentCornerProperty'] ?? f['rent_corner_property']),
      petFriendly: toBool(f['petFriendly'] ?? f['pet_friendly']),
      wheelchairFriendly: toBool(f['wheelchairFriendly'] ?? f['wheelchair_friendly']),
      rentGatedSociety: toBool(f['rentGatedSociety'] ?? f['gated_society_rent']),
      securityDeposit: toDouble(f['securityDeposit'] ?? f['security_deposit']),
      rentMaintenanceCharges: toDouble(f['rentMaintenanceCharges'] ?? f['maintenance_charges_rent']),
      brokerage: toDouble(f['brokerage']),
      rentNegotiable: toBool(f['rentNegotiable'] ?? f['rent_negotiable']),
      availableFrom: f['availableFrom']?.toString() ?? f['available_from']?.toString(),
      leaseDurationMonths: toInt(f['leaseDurationMonths'] ?? f['lease_duration_months']),
      lockInMonths: toInt(f['lockInMonths'] ?? f['lock_in_months'] ?? f['lock_in_period']),
      noticePeriodValue: toInt(f['noticePeriodValue'] ?? f['notice_period_value']),
      noticePeriodUnit: f['noticePeriodUnit']?.toString() ?? f['notice_period_unit']?.toString(),
      preferredTenant: f['preferredTenant']?.toString() ?? f['preferred_tenant']?.toString(),
      foodPreference: f['foodPreference']?.toString() ?? f['food_preference']?.toString(),
      rentPromotionTypes: toStringList(f['rentPromotionTypes'] ?? f['rent_promotion']),

      rentVillaOutdoors: toStringList(f['rentVillaOutdoors'] ?? f['rent_villa_outdoors']),
      rentVillaWaterSource: f['rentVillaWaterSource']?.toString() ?? f['rent_villa_water_source']?.toString(),
      rentSolarPower: toBool(f['rentSolarPower'] ?? f['solar_power']),
      rentIndependentEntry: toBool(f['rentIndependentEntry'] ?? f['independent_entry']),
      rentLiftAvailable: toBool(f['rentLiftAvailable'] ?? f['lift_available_rent']),
      societyName: f['societyName']?.toString() ?? f['society_name']?.toString(),
      rentTenantTypes: toStringList(f['rentTenantTypes'] ?? f['tenant_types']),

      studioConfig: f['studioConfig']?.toString() ?? f['studio_config']?.toString(),
      kitchenType: f['kitchenType']?.toString() ?? f['kitchen_type']?.toString(),
      studioTenantPrefs: toStringList(f['studioTenantPrefs'] ?? f['studio_tenant_preferences']),
      rentFarmLandArea: toDouble(f['rentFarmLandArea'] ?? f['farm_land_area_rent']),
      rentFarmRooms: toInt(f['rentFarmRooms'] ?? f['farm_rooms_rent']),
      rentFarmPool: toBool(f['rentFarmPool'] ?? f['farm_pool_rent']),
      rentFarmFencing: toBool(f['rentFarmFencing'] ?? f['farm_fencing_rent']),
      rentFarmUseCases: toStringList(f['rentFarmUseCases'] ?? f['farm_use_cases']),
      farmMonthlyCharges: toDouble(f['farmMonthlyCharges'] ?? f['farm_monthly_charges']),
      farmDailyCharges: toDouble(f['farmDailyCharges'] ?? f['farm_daily_charges']),
      farmEventCharges: toDouble(f['farmEventCharges'] ?? f['farm_event_charges']),
      minStayDays: toInt(f['minStayDays'] ?? f['min_stay_days']),

      villaAdditionalRooms: toStringList(f['villaAdditionalRooms'] ?? f['villa_additional_rooms']),
      villaCornerProperty: toBool(f['villaCornerProperty'] ?? f['villa_corner_property']),
      gatedCommunity: toBool(f['gatedCommunity'] ?? f['gated_community']),
      villaParking: toStringList(f['villaParking'] ?? f['parking_types']),
      outdoors: toStringList(f['outdoors']),
      waterSource: f['waterSource']?.toString() ?? f['villa_water_source']?.toString() ?? f['water_source']?.toString(),
      connections: toStringList(f['connections']),
      villaPriceNegotiable: toBool(f['villaPriceNegotiable'] ?? f['villa_price_negotiable']),
      villaMaintenanceCharges: toDouble(f['villaMaintenanceCharges'] ?? f['villa_maintenance_charges']),
      villaBookingAmount: toDouble(f['villaBookingAmount'] ?? f['villa_booking_amount']),

      builderCornerProperty: toBool(f['builderCornerProperty'] ?? f['builder_corner_property']),
      builderGatedSociety: toBool(f['builderGatedSociety'] ?? f['builder_gated_society']),
      constructionAllowed: toBool(f['constructionAllowed'] ?? f['construction_allowed']),
      builderUtilities: toStringList(f['builderUtilities'] ?? f['utilities']),
      pricePerSqft: toDouble(f['pricePerSqft'] ?? f['price_per_sqft']),
      builderNegotiable: toBool(f['builderNegotiable'] ?? f['negotiable']),

      duplexCornerPlot: toBool(f['duplexCornerPlot'] ?? f['duplex_corner_plot']),
      duplexGatedCommunity: toBool(f['duplexGatedCommunity'] ?? f['duplex_gated_community']),
      duplexConstructionAllowed: toBool(f['duplexConstructionAllowed'] ?? f['duplex_construction_allowed']),
      duplexWaterConnection: toBool(f['duplexWaterConnection'] ?? f['duplex_water_connection']),
      duplexElectricityConnection: toBool(f['duplexElectricityConnection'] ?? f['duplex_electricity_connection']),
      duplexNegotiable: toBool(f['duplexNegotiable'] ?? f['duplex_negotiable']),
      duplexRoadAccess: toBool(f['duplexRoadAccess'] ?? f['duplex_road_access']),
      duplexNearbyFacilities: toStringList(f['duplexNearbyFacilities'] ?? f['duplex_nearby_facilities']),

      farmLandArea: toDouble(f['farmLandArea'] ?? f['farm_land_area']),
      farmBuiltUpArea: toDouble(f['farmBuiltUpArea'] ?? f['farm_built_up_area']),
      farmUtilities: toStringList(f['farmUtilities'] ?? f['farm_utilities']),
      farmRooms: toInt(f['farmRooms'] ?? f['farm_rooms']),
      farmGarden: toBool(f['farmGarden'] ?? f['farm_garden']),
      farmSwimmingPool: toBool(f['farmSwimmingPool'] ?? f['farm_swimming_pool']),
      village: f['village']?.toString(),
      landmark: f['landmark']?.toString(),

      pgGenderBased: f['pgGenderBased']?.toString() ?? f['pg_gender_based']?.toString(),
      pgOccupancyType: f['pgOccupancyType']?.toString() ?? f['pg_occupancy_type']?.toString(),
      pgTenantTypes: toStringList(f['pgTenantTypes'] ?? f['pg_tenant_types']),
      pgFoodAvailability: f['pgFoodAvailability']?.toString() ?? f['pg_food_availability']?.toString(),
      pgPropertyType: f['pgPropertyType']?.toString() ?? f['pg_property_type']?.toString(),
      pgBathroomType: f['pgBathroomType']?.toString() ?? f['pg_bathroom_type']?.toString(),
      pgSuitableFor: f['pgSuitableFor']?.toString() ?? f['pg_suitable_for']?.toString(),
      pgBuildingName: f['pgBuildingName']?.toString() ?? f['pg_building_name']?.toString(),
pgTotalBeds: toInt(
  f['pgTotalBeds'] ??
  f['pg_total_beds'] ??
  pg['total_beds'],
),      pgAvailableBeds: toInt(f['pgAvailableBeds'] ?? f['pg_available_beds']),
      pgRoomType: f['pgRoomType']?.toString() ?? f['pg_room_type']?.toString(),
      pgAttachedBathroom: toBool(f['pgAttachedBathroom'] ?? f['pg_attached_bathroom'] ?? f['attached_bathroom']),
      pgBalcony: toBool(f['pgBalcony'] ?? f['pg_balcony'] ?? f['balcony']),
      pgRoomSize: f['pgRoomSize']?.toString() ?? f['pg_room_size']?.toString() ?? f['room_size']?.toString(),
      pgBedType: f['pgBedType']?.toString() ?? f['pg_bed_type']?.toString() ?? f['bed_type']?.toString(),
      pgCupboardAvailable: toBool(f['pgCupboardAvailable'] ?? f['pg_cupboard_available'] ?? f['cupboard_available']),
      pgStudyTableAvailable: toBool(f['pgStudyTableAvailable'] ?? f['pg_study_table_available'] ?? f['study_table_available']),
      pgSecurityDeposit: toDouble(f['pgSecurityDeposit'] ?? f['pg_security_deposit'] ?? f['security_deposit']),
      pgElectricityIncluded: toBool(f['pgElectricityIncluded'] ?? f['pg_electricity_included'] ?? f['electricity_included']),
      pgWaterIncluded: toBool(f['pgWaterIncluded'] ?? f['pg_water_included'] ?? f['water_included']),
      pgFoodChargesIncluded: toBool(f['pgFoodChargesIncluded'] ?? f['pg_food_charges_included'] ?? f['food_charges_included']),
      pgBrokerageRequired: toBool(f['pgBrokerageRequired'] ?? f['pg_brokerage_required']),
      pgCoupleFriendly: toBool(f['pgCoupleFriendly'] ?? f['pg_couple_friendly']),
      pgIdProofRequired: toBool(f['pgIdProofRequired'] ?? f['pg_id_proof_required']),
      pgAvailableFrom: f['pgAvailableFrom']?.toString() ?? f['pg_available_from']?.toString(),
      pgMinStayDays: toInt(f['pgMinStayDays'] ?? f['pg_min_stay_days']),
      pgNoticePeriodDays: toInt(f['pgNoticePeriodDays'] ?? f['pg_notice_period_days']),
      pgPreferredTenantAge: toInt(f['pgPreferredTenantAge'] ?? f['pg_preferred_tenant_age']),
      pgSmokingAllowed: toBool(f['pgSmokingAllowed'] ?? f['pg_smoking_allowed']),
      pgDrinkingAllowed: toBool(f['pgDrinkingAllowed'] ?? f['pg_drinking_allowed']),
      pgPetsAllowed: toBool(f['pgPetsAllowed'] ?? f['pg_pets_allowed']),
      pgVisitorsAllowed: toBool(f['pgVisitorsAllowed'] ?? f['pg_visitors_allowed']),
      pgCurfewTime: f['pgCurfewTime']?.toString() ?? f['pg_curfew_time']?.toString(),
      pgGateLockedAtNight: toBool(f['pgGateLockedAtNight'] ?? f['pg_gate_locked_at_night']),
      pgNearbyPreferences: toStringList(f['pgNearbyPreferences'] ?? f['pg_nearby_preferences']),
      pgAvailability: f['pgAvailability']?.toString() ?? f['pg_availability']?.toString(),
      pgSharing: toInt(f['pgSharing'] ?? f['pg_sharing']),
      pgSecurity: toBool(f['pgSecurity'] ?? f['pg_security']),
      pgMaintenanceCharges: toDouble(f['pgMaintenanceCharges'] ?? f['pg_maintenance_charges'] ?? f['maintenance_charges']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        ownerName,
        location,
        price,
        type,
        amenities,
        images,
        description,
        status,
        slug,
        listingType,
        propertyKind,
        area,
        areaUnit,
        propertyAge,
        facing,
        floor,
        totalFloors,
        possessionStatus,
        bedrooms,
        bathrooms,
        furnishing,
        parking,
        address,
        city,
        state,
        pincode,
        latitude,
        longitude,
        primaryImageIndex,
        rejectionReason,
        updatedAt,
        createdAt,
        categoryId,
        userId,
        isFeatured,
        featuredExpiry,
        documents,
        amenityIds,
        furnishingSelections,
        apiFields,
        sectionImagePaths,
        documentPaths,
        
        carpetArea,
        builtUpArea,
        superBuiltUpArea,
        plotArea,
        plotLength,
        plotBreadth,
        floorsAllowed,
        openSides,
        boundaryWall,
        constructionDone,
        availability,
        readyTimeframe,
        possessionBy,
        ownership,
        balconies,
        commercialType,
        floorPlateArea,
        cabins,
        meetingRooms,
        seats,
        maxSeats,
        conferenceRooms,
        liftAvailable,
        preLeased,
        officeType,
        receptionArea,
        pantry,
        cafeteria,
        serverRoom,
        fireSafetyInstalled,
        centralAC,
        visitorParking,
        numberOfLifts,
        taxIncluded,
        officeNegotiable,
        officeMaintenanceCharges,
        officeBookingAmount,
        shopType,
        shopArea,
        shopAreaUnit,
        frontageWidth,
        ceilingHeight,
        mainRoadFacing,
        cornerShop,
        washroomAvailable,
        floorType,
        marketName,
        locality,
        showroomArea,
        showroomAreaUnit,
        showroomFrontageWidth,
        showroomCeilingHeight,
        showroomMainRoadFacing,
        showroomCorner,
        showroomWashroom,
        showroomParkingSlots,
        showroomFurnishing,
        showroomFloorType,
        showroomMarketName,
        showroomLocality,
        showroomOwnerName,
        showroomOwnerMobile,
        warehouseType,
        warehousePlotArea,
        warehousePlotAreaUnit,
        warehouseCeilingHeight,
        warehouseLoadingBays,
        warehouseDockLevelers,
        warehousePowerSupply,
        warehouseIndustrialLicense,
        warehouseTruckAccess,
        warehouseAreaName,
        warehouseCity,
        shopFacade,
        washrooms,
        parkingType,
        plotType,
        rooms,
        qualityRating,
        landType,
        roadWidth,
        plotAreaUnit,
        plotCorner,
        plotRoadAccess,
        agriFencing,
        agriWaterSource,
        additionalRooms,
        cornerProperty,
        priceNegotiable,
        maintenanceCharges,
        bookingAmount,
        propertyHighlights,
        whatsappUpdates,
        promotionTags,
        rentAdditionalRooms,
        rentCornerProperty,
        petFriendly,
        wheelchairFriendly,
        rentGatedSociety,
        securityDeposit,
        rentMaintenanceCharges,
        brokerage,
        rentNegotiable,
        availableFrom,
        leaseDurationMonths,
        lockInMonths,
        noticePeriodValue,
        noticePeriodUnit,
        preferredTenant,
        foodPreference,
        rentPromotionTypes,
        rentVillaOutdoors,
        rentVillaWaterSource,
        rentSolarPower,
        rentIndependentEntry,
        rentLiftAvailable,
        societyName,
        rentTenantTypes,
        studioConfig,
        kitchenType,
        studioTenantPrefs,
        rentFarmLandArea,
        rentFarmRooms,
        rentFarmPool,
        rentFarmFencing,
        rentFarmUseCases,
        farmMonthlyCharges,
        farmDailyCharges,
        farmEventCharges,
        minStayDays,
        villaAdditionalRooms,
        villaCornerProperty,
        gatedCommunity,
        villaParking,
        outdoors,
        waterSource,
        connections,
        villaPriceNegotiable,
        villaMaintenanceCharges,
        villaBookingAmount,
        builderCornerProperty,
        builderGatedSociety,
        constructionAllowed,
        builderUtilities,
        pricePerSqft,
        builderNegotiable,
        duplexCornerPlot,
        duplexGatedCommunity,
        duplexConstructionAllowed,
        duplexWaterConnection,
        duplexElectricityConnection,
        duplexNegotiable,
        duplexRoadAccess,
        duplexNearbyFacilities,
        farmLandArea,
        farmBuiltUpArea,
        farmUtilities,
        farmRooms,
        farmGarden,
        farmSwimmingPool,
        village,
        landmark,
        pgGenderBased,
        pgOccupancyType,
        pgTenantTypes,
        pgFoodAvailability,
        pgPropertyType,
        pgBathroomType,
        pgSuitableFor,
        pgBuildingName,
        pgTotalBeds,
        pgAvailableBeds,
        pgRoomType,
        pgAttachedBathroom,
        pgBalcony,
        pgRoomSize,
        pgBedType,
        pgCupboardAvailable,
        pgStudyTableAvailable,
        pgSecurityDeposit,
        pgElectricityIncluded,
        pgWaterIncluded,
        pgFoodChargesIncluded,
        pgBrokerageRequired,
        pgCoupleFriendly,
        pgIdProofRequired,
        pgAvailableFrom,
        pgMinStayDays,
        pgNoticePeriodDays,
        pgPreferredTenantAge,
        pgSmokingAllowed,
        pgDrinkingAllowed,
        pgPetsAllowed,
        pgVisitorsAllowed,
        pgCurfewTime,
        pgGateLockedAtNight,
        pgNearbyPreferences,
        pgAvailability,
        pgSharing,
        pgSecurity,
        pgMaintenanceCharges,
        pgDetails,
        officeDetails,
        showroomDetails,
        shopDetails,
        warehouseDetails,
      ];
}
