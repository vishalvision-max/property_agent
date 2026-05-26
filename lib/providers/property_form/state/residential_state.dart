import 'package:flutter/foundation.dart';

@immutable
class ResidentialState {
  const ResidentialState({
    this.carpetArea = '',
    this.builtUpArea = '',
    this.superBuiltUpArea = '',
    this.plotArea = '',
    this.plotLength = '',
    this.plotBreadth = '',
    this.floorsAllowed = '',
    this.openSides = 0,
    this.boundaryWall = false,
    this.constructionDone = false,
    this.availability = '',
    this.readyTimeframe = '',
    this.possessionBy = '',
    this.ownership = '',
    this.balconies = -1,
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.parking = 0,
    this.furnishing = '',
    this.facing = '',
    this.floor = '',
    this.totalFloors = '',

    // Additional fields
    this.additionalRooms = const [],
    this.cornerProperty = false,
    this.propertyHighlights = const [],
    this.whatsappUpdates = false,
    this.promotionTags = const [],
    this.petFriendly = false,
    this.wheelchairFriendly = false,
    this.gatedSociety = false,

    // Land/Plot
    this.landType = '',
    this.roadWidth = '',
    this.plotAreaUnit = 'sqft',
    this.plotCorner = false,
    this.plotRoadAccess = false,
    this.agriFencing = false,
    this.agriWaterSource = '',
  });

  final String carpetArea;
  final String builtUpArea;
  final String superBuiltUpArea;
  final String plotArea;
  final String plotLength;
  final String plotBreadth;
  final String floorsAllowed;
  final int openSides;
  final bool boundaryWall;
  final bool constructionDone;
  final String availability;
  final String readyTimeframe;
  final String possessionBy;
  final String ownership;
  final int balconies;
  final int bedrooms;
  final int bathrooms;
  final int parking;
  final String furnishing;
  final String facing;
  final String floor;
  final String totalFloors;

  final List<String> additionalRooms;
  final bool cornerProperty;
  final List<String> propertyHighlights;
  final bool whatsappUpdates;
  final List<String> promotionTags;
  final bool petFriendly;
  final bool wheelchairFriendly;
  final bool gatedSociety;

  final String landType;
  final String roadWidth;
  final String plotAreaUnit;
  final bool plotCorner;
  final bool plotRoadAccess;
  final bool agriFencing;
  final String agriWaterSource;

  ResidentialState copyWith({
    String? carpetArea,
    String? builtUpArea,
    String? superBuiltUpArea,
    String? plotArea,
    String? plotLength,
    String? plotBreadth,
    String? floorsAllowed,
    int? openSides,
    bool? boundaryWall,
    bool? constructionDone,
    String? availability,
    String? readyTimeframe,
    String? possessionBy,
    String? ownership,
    int? balconies,
    int? bedrooms,
    int? bathrooms,
    int? parking,
    String? furnishing,
    String? facing,
    String? floor,
    String? totalFloors,
    List<String>? additionalRooms,
    bool? cornerProperty,
    List<String>? propertyHighlights,
    bool? whatsappUpdates,
    List<String>? promotionTags,
    bool? petFriendly,
    bool? wheelchairFriendly,
    bool? gatedSociety,
    String? landType,
    String? roadWidth,
    String? plotAreaUnit,
    bool? plotCorner,
    bool? plotRoadAccess,
    bool? agriFencing,
    String? agriWaterSource,
  }) {
    return ResidentialState(
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
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      parking: parking ?? this.parking,
      furnishing: furnishing ?? this.furnishing,
      facing: facing ?? this.facing,
      floor: floor ?? this.floor,
      totalFloors: totalFloors ?? this.totalFloors,
      additionalRooms: additionalRooms ?? this.additionalRooms,
      cornerProperty: cornerProperty ?? this.cornerProperty,
      propertyHighlights: propertyHighlights ?? this.propertyHighlights,
      whatsappUpdates: whatsappUpdates ?? this.whatsappUpdates,
      promotionTags: promotionTags ?? this.promotionTags,
      petFriendly: petFriendly ?? this.petFriendly,
      wheelchairFriendly: wheelchairFriendly ?? this.wheelchairFriendly,
      gatedSociety: gatedSociety ?? this.gatedSociety,
      landType: landType ?? this.landType,
      roadWidth: roadWidth ?? this.roadWidth,
      plotAreaUnit: plotAreaUnit ?? this.plotAreaUnit,
      plotCorner: plotCorner ?? this.plotCorner,
      plotRoadAccess: plotRoadAccess ?? this.plotRoadAccess,
      agriFencing: agriFencing ?? this.agriFencing,
      agriWaterSource: agriWaterSource ?? this.agriWaterSource,
    );
  }
}
