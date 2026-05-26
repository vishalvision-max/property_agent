import 'package:flutter/foundation.dart';
import 'package:property_agent/data/models/media_item.dart';
import 'package:property_agent/data/models/property_enums.dart';
import 'package:property_agent/data/models/property_kind.dart';
import 'state/modular_states.dart';
import 'state/commercial_state.dart';
import 'state/residential_state.dart';
import 'state/pg_state.dart';

@immutable
class PropertyFormState {
  const PropertyFormState({
    this.basicInfo = const BasicInfoState(),
    this.pricing = const PricingState(),
    this.location = const LocationState(),
    this.media = const MediaState(),
    this.commercial = const CommercialState(),
    this.residential = const ResidentialState(),
    this.pg = const PgState(),
    
    // UI state that doesn't need its own modular class right now
    this.selectedAmenityIds = const {},
    this.selectedFurnishingIds = const {},
    this.furnishingQuantities = const {},
    this.expandedSections = const {
      'basic': true,
      'details': false,
      'pricing': false,
      'amenities': false,
      'furnishings': false,
      'media': false,
      'location': false,
      'description': false,
    },
    this.isSubmitting = false,
    this.isDraftSaving = false,
    this.validationErrors = const {},
  });

  final BasicInfoState basicInfo;
  final PricingState pricing;
  final LocationState location;
  final MediaState media;
  final CommercialState commercial;
  final ResidentialState residential;
  final PgState pg;

  // UI state
  final Set<int> selectedAmenityIds;
  final Set<int> selectedFurnishingIds;
  final Map<int, int> furnishingQuantities;
  final Map<String, bool> expandedSections;
  final bool isSubmitting;
  final bool isDraftSaving;
  final Map<String, String?> validationErrors;

  // ── BACKWARD COMPATIBLE GETTERS ─────────────────────────────
  // These allow the 10,000+ line UI shell to continue functioning
  // without rewriting every single `s.price` or `s.title` access.

  // Basic Info
  String get title => basicInfo.title;
  String get description => basicInfo.description;
  String get area => basicInfo.area;
  String get areaUnit => basicInfo.areaUnit;
  PropertyType get type => basicInfo.type;
  String get listingType => basicInfo.listingType;
  PropertyKind? get propertyKind => basicInfo.propertyKind;
  int? get selectedParentCategoryId => basicInfo.selectedParentCategoryId;
  int? get selectedCategoryId => basicInfo.selectedCategoryId;
  String get selectedParentCategorySlug => basicInfo.selectedParentCategorySlug;
  String get selectedCategorySlug => basicInfo.selectedCategorySlug;

  // Pricing
  String get price => pricing.price;
  String get maintenanceCharges => pricing.maintenanceCharges;
  String get bookingAmount => pricing.bookingAmount;
  bool? get priceNegotiable => pricing.priceNegotiable;
  String get securityDeposit => pricing.securityDeposit;
  String get villaMaintenanceCharges => pricing.villaMaintenanceCharges;
  String get villaBookingAmount => pricing.villaBookingAmount;
  String get rentMaintenanceCharges => pricing.rentMaintenanceCharges;
  String get brokerage => pricing.brokerage;
  bool? get rentNegotiable => pricing.rentNegotiable;

  // Location
  String get address => location.address;
  String get city => location.city;
  String get state => location.state;
  String get pincode => location.pincode;
  double? get latitude => location.latitude;
  double? get longitude => location.longitude;

  // Media
  List<MediaItem> get images => media.images;
  List<MediaItem> get videos => media.videos;
  int get primaryImageIndex => media.primaryImageIndex;

  // Commercial
  String get commercialType => commercial.commercialType;
  String get warehouseType => commercial.warehouseType;
  String get warehousePlotArea => commercial.warehousePlotArea;
  String get warehousePlotAreaUnit => commercial.warehousePlotAreaUnit;
  String get warehouseCeilingHeight => commercial.warehouseCeilingHeight;
  String get warehouseLoadingBays => commercial.warehouseLoadingBays;
  String get warehouseDockLevelers => commercial.warehouseDockLevelers;
  String get warehousePowerSupply => commercial.warehousePowerSupply;
  bool? get warehouseIndustrialLicense => commercial.warehouseIndustrialLicense;
  String get warehouseTruckAccess => commercial.warehouseTruckAccess;
  String get warehouseAreaName => commercial.warehouseAreaName;
  String get warehouseCity => commercial.warehouseCity;
  bool get warehouseLiftAvailable => commercial.warehouseLiftAvailable;
  bool get warehouseGoodsLift => commercial.warehouseGoodsLift;
  bool get warehousePreLeased => commercial.warehousePreLeased;
  String get officeType => commercial.officeType;
  String get officeArea => commercial.officeArea;
  String get cabins => commercial.cabins;
  String get meetingRooms => commercial.meetingRooms;
  String get seats => commercial.seats;
  String get maxSeats => commercial.maxSeats;
  String get conferenceRooms => commercial.conferenceRooms;
  bool get receptionArea => commercial.receptionArea;
  bool get pantry => commercial.pantry;
  bool get cafeteria => commercial.cafeteria;
  bool get serverRoom => commercial.serverRoom;
  bool get fireSafetyInstalled => commercial.fireSafetyInstalled;
  bool get centralAC => commercial.centralAC;
  bool get visitorParking => commercial.visitorParking;
  String get numberOfLifts => commercial.numberOfLifts;
  bool? get officeNegotiable => commercial.officeNegotiable;
  String get officeMaintenanceCharges => commercial.officeMaintenanceCharges;
  String get officeBookingAmount => commercial.officeBookingAmount;
  String get shopType => commercial.shopType;
  String get shopArea => commercial.shopArea;
  String get shopAreaUnit => commercial.shopAreaUnit;
  String get frontageWidth => commercial.frontageWidth;
  String get ceilingHeight => commercial.ceilingHeight;
  bool? get mainRoadFacing => commercial.mainRoadFacing;
  bool? get cornerShop => commercial.cornerShop;
  bool? get washroomAvailable => commercial.washroomAvailable;
  String get floorType => commercial.floorType;
  String get marketName => commercial.marketName;
  String get locality => commercial.locality;
  String get showroomArea => commercial.showroomArea;
  String get showroomAreaUnit => commercial.showroomAreaUnit;
  String get showroomFrontageWidth => commercial.showroomFrontageWidth;
  String get showroomCeilingHeight => commercial.showroomCeilingHeight;
  bool? get showroomMainRoadFacing => commercial.showroomMainRoadFacing;
  bool? get showroomCorner => commercial.showroomCorner;
  bool? get showroomWashroom => commercial.showroomWashroom;
  String get showroomParkingSlots => commercial.showroomParkingSlots;
  String get showroomFurnishing => commercial.showroomFurnishing;
  String get showroomFloorType => commercial.showroomFloorType;
  String get showroomMarketName => commercial.showroomMarketName;
  String get showroomLocality => commercial.showroomLocality;
  String get showroomOwnerName => commercial.showroomOwnerName;
  String get showroomOwnerMobile => commercial.showroomOwnerMobile;

  // Residential
  String get carpetArea => residential.carpetArea;
  String get builtUpArea => residential.builtUpArea;
  String get superBuiltUpArea => residential.superBuiltUpArea;
  String get plotArea => residential.plotArea;
  int get openSides => residential.openSides;
  String get possessionStatus => 'ready'; // default placeholder
  String get availability => residential.availability;
  String get ownership => residential.ownership;
  int get bedrooms => residential.bedrooms;
  int get bathrooms => residential.bathrooms;
  int get balconies => residential.balconies;
  int get parking => residential.parking;
  String get furnishing => residential.furnishing;
  String get facing => residential.facing;
  String get floor => residential.floor;
  String get totalFloors => residential.totalFloors;
  String get ownerName => basicInfo.ownerName;
  String get ownerPhone => basicInfo.ownerPhone;

  // ── Derived helpers ───────────────────────────
  bool get isCommercial => selectedParentCategorySlug.toLowerCase() == 'commercial';
  bool get isResidential => selectedParentCategorySlug.toLowerCase() == 'residential';
  bool get isLandPlot {
    final slug = selectedCategorySlug.toLowerCase();
    return slug == 'plot' || slug == 'land' || slug == 'agricultural-land';
  }
  bool get isPgOrCoLiving {
    final slug = selectedParentCategorySlug.toLowerCase();
    return slug == 'pg' || slug == 'co-living' || slug == 'pg-co-living';
  }
  bool get isWarehouse => isCommercial && selectedCategorySlug.toLowerCase() == 'warehouse';
  bool get isOffice => isCommercial && selectedCategorySlug.toLowerCase() == 'office';
  bool get isShop => isCommercial && selectedCategorySlug.toLowerCase() == 'shop';
  bool get isShowroom => isCommercial && selectedCategorySlug.toLowerCase() == 'showroom';

  bool get isSale => propertyKind == PropertyKind.sale;
  bool get isRentOrLease => propertyKind == PropertyKind.rent || propertyKind == PropertyKind.lease;

  String? errorFor(String field) => validationErrors[field];

  // ── copyWith ──────────────────────────────────
  // This massive copyWith preserves backward compatibility with the existing notifier.
  // It transparently maps flat updates into the correct modular state updates.
  PropertyFormState copyWith({
    BasicInfoState? basicInfo,
    PricingState? pricing,
    LocationState? location,
    MediaState? media,
    CommercialState? commercial,
    ResidentialState? residential,
    PgState? pg,

    // Flat override fields
    String? title, String? description, String? area, String? areaUnit, PropertyType? type, String? listingType, PropertyKind? propertyKind, int? selectedParentCategoryId, int? selectedCategoryId, String? selectedParentCategorySlug, String? selectedCategorySlug,
    String? price, String? maintenanceCharges, String? bookingAmount, bool? priceNegotiable, String? securityDeposit, String? villaMaintenanceCharges, String? villaBookingAmount, String? rentMaintenanceCharges, String? brokerage, bool? rentNegotiable,
    String? address, String? city, String? state, String? pincode, double? latitude, double? longitude,
    List<MediaItem>? images, List<MediaItem>? videos, int? primaryImageIndex,
    String? commercialType, String? warehouseType, String? warehousePlotArea, String? warehousePlotAreaUnit, String? warehouseCeilingHeight, String? warehouseLoadingBays, String? warehouseDockLevelers, String? warehousePowerSupply, bool? warehouseIndustrialLicense, String? warehouseTruckAccess, String? warehouseAreaName, String? warehouseCity, bool? warehouseLiftAvailable, bool? warehouseGoodsLift, bool? warehousePreLeased, String? officeType, String? officeArea, String? cabins, String? meetingRooms, String? seats, String? maxSeats, String? conferenceRooms, bool? receptionArea, bool? pantry, bool? cafeteria, bool? serverRoom, bool? fireSafetyInstalled, bool? centralAC, bool? visitorParking, String? numberOfLifts, bool? officeNegotiable, String? officeMaintenanceCharges, String? officeBookingAmount, String? shopType, String? shopArea, String? shopAreaUnit, String? frontageWidth, String? ceilingHeight, bool? mainRoadFacing, bool? cornerShop, bool? washroomAvailable, String? floorType, String? marketName, String? locality, String? showroomArea, String? showroomAreaUnit, String? showroomFrontageWidth, String? showroomCeilingHeight, bool? showroomMainRoadFacing, bool? showroomCorner, bool? showroomWashroom, String? showroomParkingSlots, String? showroomFurnishing, String? showroomFloorType, String? showroomMarketName, String? showroomLocality, String? showroomOwnerName, String? showroomOwnerMobile,
    String? carpetArea, String? builtUpArea, String? superBuiltUpArea, String? plotArea, int? openSides, String? possessionStatus, String? availability, String? ownership, int? bedrooms, int? bathrooms, int? balconies, int? parking, String? furnishing, String? facing, String? floor, String? totalFloors, String? ownerName, String? ownerPhone,

    Set<int>? selectedAmenityIds,
    Set<int>? selectedFurnishingIds,
    Map<int, int>? furnishingQuantities,
    Map<String, bool>? expandedSections,
    bool? isSubmitting,
    bool? isDraftSaving,
    Map<String, String?>? validationErrors,
  }) {
    return PropertyFormState(
      basicInfo: basicInfo ?? this.basicInfo.copyWith(
        title: title, description: description, area: area, areaUnit: areaUnit, type: type, listingType: listingType, propertyKind: propertyKind, selectedParentCategoryId: selectedParentCategoryId, selectedCategoryId: selectedCategoryId, selectedParentCategorySlug: selectedParentCategorySlug, selectedCategorySlug: selectedCategorySlug,
      ),
      pricing: pricing ?? this.pricing.copyWith(
        price: price, maintenanceCharges: maintenanceCharges, bookingAmount: bookingAmount, priceNegotiable: priceNegotiable, securityDeposit: securityDeposit, villaMaintenanceCharges: villaMaintenanceCharges, villaBookingAmount: villaBookingAmount, rentMaintenanceCharges: rentMaintenanceCharges, brokerage: brokerage, rentNegotiable: rentNegotiable,
      ),
      location: location ?? this.location.copyWith(
        address: address, city: city, state: state, pincode: pincode, latitude: latitude, longitude: longitude,
      ),
      media: media ?? this.media.copyWith(
        images: images, videos: videos, primaryImageIndex: primaryImageIndex,
      ),
      commercial: commercial ?? this.commercial.copyWith(
        commercialType: commercialType, warehouseType: warehouseType, warehousePlotArea: warehousePlotArea, warehousePlotAreaUnit: warehousePlotAreaUnit, warehouseCeilingHeight: warehouseCeilingHeight, warehouseLoadingBays: warehouseLoadingBays, warehouseDockLevelers: warehouseDockLevelers, warehousePowerSupply: warehousePowerSupply, warehouseIndustrialLicense: warehouseIndustrialLicense, warehouseTruckAccess: warehouseTruckAccess, warehouseAreaName: warehouseAreaName, warehouseCity: warehouseCity, warehouseLiftAvailable: warehouseLiftAvailable, warehouseGoodsLift: warehouseGoodsLift, warehousePreLeased: warehousePreLeased, officeType: officeType, officeArea: officeArea, cabins: cabins, meetingRooms: meetingRooms, seats: seats, maxSeats: maxSeats, conferenceRooms: conferenceRooms, receptionArea: receptionArea, pantry: pantry, cafeteria: cafeteria, serverRoom: serverRoom, fireSafetyInstalled: fireSafetyInstalled, centralAC: centralAC, visitorParking: visitorParking, numberOfLifts: numberOfLifts, officeNegotiable: officeNegotiable, officeMaintenanceCharges: officeMaintenanceCharges, officeBookingAmount: officeBookingAmount, shopType: shopType, shopArea: shopArea, shopAreaUnit: shopAreaUnit, frontageWidth: frontageWidth, ceilingHeight: ceilingHeight, mainRoadFacing: mainRoadFacing, cornerShop: cornerShop, washroomAvailable: washroomAvailable, floorType: floorType, marketName: marketName, locality: locality, showroomArea: showroomArea, showroomAreaUnit: showroomAreaUnit, showroomFrontageWidth: showroomFrontageWidth, showroomCeilingHeight: showroomCeilingHeight, showroomMainRoadFacing: showroomMainRoadFacing, showroomCorner: showroomCorner, showroomWashroom: showroomWashroom, showroomParkingSlots: showroomParkingSlots, showroomFurnishing: showroomFurnishing, showroomFloorType: showroomFloorType, showroomMarketName: showroomMarketName, showroomLocality: showroomLocality, showroomOwnerName: showroomOwnerName, showroomOwnerMobile: showroomOwnerMobile,
      ),
      residential: residential ?? this.residential.copyWith(
        carpetArea: carpetArea, builtUpArea: builtUpArea, superBuiltUpArea: superBuiltUpArea, plotArea: plotArea, openSides: openSides, availability: availability, ownership: ownership, bedrooms: bedrooms, bathrooms: bathrooms, balconies: balconies, parking: parking, furnishing: furnishing, facing: facing, floor: floor, totalFloors: totalFloors,
      ),
      pg: pg ?? this.pg,
      
      selectedAmenityIds: selectedAmenityIds ?? this.selectedAmenityIds,
      selectedFurnishingIds: selectedFurnishingIds ?? this.selectedFurnishingIds,
      furnishingQuantities: furnishingQuantities ?? this.furnishingQuantities,
      expandedSections: expandedSections ?? this.expandedSections,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isDraftSaving: isDraftSaving ?? this.isDraftSaving,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }
}
