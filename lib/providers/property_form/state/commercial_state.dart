import 'package:flutter/foundation.dart';

@immutable
class CommercialState {
  const CommercialState({
    this.commercialType = '',
    // Warehouse
    this.warehouseType = '',
    this.warehousePlotArea = '',
    this.warehousePlotAreaUnit = 'sqft',
    this.warehouseCeilingHeight = '',
    this.warehouseLoadingBays = '',
    this.warehouseDockLevelers = '',
    this.warehousePowerSupply = '',
    this.warehouseIndustrialLicense,
    this.warehouseTruckAccess = '',
    this.warehouseAreaName = '',
    this.warehouseCity = '',
    this.warehouseLiftAvailable = true,
    this.warehouseGoodsLift = false,
    this.warehousePreLeased = false,
    // Office
    this.officeType = '',
    this.officeArea = '',
    this.cabins = '',
    this.meetingRooms = '',
    this.seats = '',
    this.maxSeats = '',
    this.conferenceRooms = '',
    this.receptionArea = false,
    this.pantry = false,
    this.cafeteria = false,
    this.serverRoom = false,
    this.fireSafetyInstalled = false,
    this.centralAC = false,
    this.visitorParking = false,
    this.numberOfLifts = '',
    this.officeNegotiable,
    this.officeMaintenanceCharges = '',
    this.officeBookingAmount = '',
    // Shop
    this.shopType = '',
    this.shopArea = '',
    this.shopAreaUnit = 'sqft',
    this.frontageWidth = '',
    this.ceilingHeight = '',
    this.mainRoadFacing,
    this.cornerShop,
    this.washroomAvailable,
    this.floorType = '',
    this.marketName = '',
    this.locality = '',
    // Showroom
    this.showroomArea = '',
    this.showroomAreaUnit = 'sqft',
    this.showroomFrontageWidth = '',
    this.showroomCeilingHeight = '',
    this.showroomMainRoadFacing,
    this.showroomCorner,
    this.showroomWashroom,
    this.showroomParkingSlots = '',
    this.showroomFurnishing = '',
    this.showroomFloorType = '',
    this.showroomMarketName = '',
    this.showroomLocality = '',
    this.showroomOwnerName = '',
    this.showroomOwnerMobile = '',
  });

  final String commercialType;

  final String warehouseType;
  final String warehousePlotArea;
  final String warehousePlotAreaUnit;
  final String warehouseCeilingHeight;
  final String warehouseLoadingBays;
  final String warehouseDockLevelers;
  final String warehousePowerSupply;
  final bool? warehouseIndustrialLicense;
  final String warehouseTruckAccess;
  final String warehouseAreaName;
  final String warehouseCity;
  final bool warehouseLiftAvailable;
  final bool warehouseGoodsLift;
  final bool warehousePreLeased;

  final String officeType;
  final String officeArea;
  final String cabins;
  final String meetingRooms;
  final String seats;
  final String maxSeats;
  final String conferenceRooms;
  final bool receptionArea;
  final bool pantry;
  final bool cafeteria;
  final bool serverRoom;
  final bool fireSafetyInstalled;
  final bool centralAC;
  final bool visitorParking;
  final String numberOfLifts;
  final bool? officeNegotiable;
  final String officeMaintenanceCharges;
  final String officeBookingAmount;

  final String shopType;
  final String shopArea;
  final String shopAreaUnit;
  final String frontageWidth;
  final String ceilingHeight;
  final bool? mainRoadFacing;
  final bool? cornerShop;
  final bool? washroomAvailable;
  final String floorType;
  final String marketName;
  final String locality;

  final String showroomArea;
  final String showroomAreaUnit;
  final String showroomFrontageWidth;
  final String showroomCeilingHeight;
  final bool? showroomMainRoadFacing;
  final bool? showroomCorner;
  final bool? showroomWashroom;
  final String showroomParkingSlots;
  final String showroomFurnishing;
  final String showroomFloorType;
  final String showroomMarketName;
  final String showroomLocality;
  final String showroomOwnerName;
  final String showroomOwnerMobile;

  CommercialState copyWith({
    String? commercialType,
    String? warehouseType,
    String? warehousePlotArea,
    String? warehousePlotAreaUnit,
    String? warehouseCeilingHeight,
    String? warehouseLoadingBays,
    String? warehouseDockLevelers,
    String? warehousePowerSupply,
    bool? warehouseIndustrialLicense,
    String? warehouseTruckAccess,
    String? warehouseAreaName,
    String? warehouseCity,
    bool? warehouseLiftAvailable,
    bool? warehouseGoodsLift,
    bool? warehousePreLeased,
    String? officeType,
    String? officeArea,
    String? cabins,
    String? meetingRooms,
    String? seats,
    String? maxSeats,
    String? conferenceRooms,
    bool? receptionArea,
    bool? pantry,
    bool? cafeteria,
    bool? serverRoom,
    bool? fireSafetyInstalled,
    bool? centralAC,
    bool? visitorParking,
    String? numberOfLifts,
    bool? officeNegotiable,
    String? officeMaintenanceCharges,
    String? officeBookingAmount,
    String? shopType,
    String? shopArea,
    String? shopAreaUnit,
    String? frontageWidth,
    String? ceilingHeight,
    bool? mainRoadFacing,
    bool? cornerShop,
    bool? washroomAvailable,
    String? floorType,
    String? marketName,
    String? locality,
    String? showroomArea,
    String? showroomAreaUnit,
    String? showroomFrontageWidth,
    String? showroomCeilingHeight,
    bool? showroomMainRoadFacing,
    bool? showroomCorner,
    bool? showroomWashroom,
    String? showroomParkingSlots,
    String? showroomFurnishing,
    String? showroomFloorType,
    String? showroomMarketName,
    String? showroomLocality,
    String? showroomOwnerName,
    String? showroomOwnerMobile,
  }) {
    return CommercialState(
      commercialType: commercialType ?? this.commercialType,
      warehouseType: warehouseType ?? this.warehouseType,
      warehousePlotArea: warehousePlotArea ?? this.warehousePlotArea,
      warehousePlotAreaUnit:
          warehousePlotAreaUnit ?? this.warehousePlotAreaUnit,
      warehouseCeilingHeight:
          warehouseCeilingHeight ?? this.warehouseCeilingHeight,
      warehouseLoadingBays: warehouseLoadingBays ?? this.warehouseLoadingBays,
      warehouseDockLevelers:
          warehouseDockLevelers ?? this.warehouseDockLevelers,
      warehousePowerSupply: warehousePowerSupply ?? this.warehousePowerSupply,
      warehouseIndustrialLicense:
          warehouseIndustrialLicense ?? this.warehouseIndustrialLicense,
      warehouseTruckAccess: warehouseTruckAccess ?? this.warehouseTruckAccess,
      warehouseAreaName: warehouseAreaName ?? this.warehouseAreaName,
      warehouseCity: warehouseCity ?? this.warehouseCity,
      warehouseLiftAvailable:
          warehouseLiftAvailable ?? this.warehouseLiftAvailable,
      warehouseGoodsLift: warehouseGoodsLift ?? this.warehouseGoodsLift,
      warehousePreLeased: warehousePreLeased ?? this.warehousePreLeased,
      officeType: officeType ?? this.officeType,
      officeArea: officeArea ?? this.officeArea,
      cabins: cabins ?? this.cabins,
      meetingRooms: meetingRooms ?? this.meetingRooms,
      seats: seats ?? this.seats,
      maxSeats: maxSeats ?? this.maxSeats,
      conferenceRooms: conferenceRooms ?? this.conferenceRooms,
      receptionArea: receptionArea ?? this.receptionArea,
      pantry: pantry ?? this.pantry,
      cafeteria: cafeteria ?? this.cafeteria,
      serverRoom: serverRoom ?? this.serverRoom,
      fireSafetyInstalled: fireSafetyInstalled ?? this.fireSafetyInstalled,
      centralAC: centralAC ?? this.centralAC,
      visitorParking: visitorParking ?? this.visitorParking,
      numberOfLifts: numberOfLifts ?? this.numberOfLifts,
      officeNegotiable: officeNegotiable ?? this.officeNegotiable,
      officeMaintenanceCharges:
          officeMaintenanceCharges ?? this.officeMaintenanceCharges,
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
      showroomFrontageWidth:
          showroomFrontageWidth ?? this.showroomFrontageWidth,
      showroomCeilingHeight:
          showroomCeilingHeight ?? this.showroomCeilingHeight,
      showroomMainRoadFacing:
          showroomMainRoadFacing ?? this.showroomMainRoadFacing,
      showroomCorner: showroomCorner ?? this.showroomCorner,
      showroomWashroom: showroomWashroom ?? this.showroomWashroom,
      showroomParkingSlots: showroomParkingSlots ?? this.showroomParkingSlots,
      showroomFurnishing: showroomFurnishing ?? this.showroomFurnishing,
      showroomFloorType: showroomFloorType ?? this.showroomFloorType,
      showroomMarketName: showroomMarketName ?? this.showroomMarketName,
      showroomLocality: showroomLocality ?? this.showroomLocality,
      showroomOwnerName: showroomOwnerName ?? this.showroomOwnerName,
      showroomOwnerMobile: showroomOwnerMobile ?? this.showroomOwnerMobile,
    );
  }
}
