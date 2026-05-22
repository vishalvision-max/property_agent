import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/property.dart';
import '../../../../data/models/property_enums.dart';

/// The 5 transaction kinds supported in the creation/edit UI.
enum CreatePropertyKind { sale, rent, lease, pg, coLiving }

/// A safe, immutable data class representing the state of the Property Form.
class PropertyFormState {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? area;
  final String areaUnit;
  final CreatePropertyKind? propertyKind;
  final PropertyType type;
  
  // Basic attributes
  final int? bedrooms;
  final int? bathrooms;
  final int balconies;
  final int parking;
  final String furnishing;
  final String facing;
  final String floor;
  final String totalFloors;

  // Land / Plot fields
  final String plotArea;
  final String length;
  final String breadth;
  final String floorsAllowed;
  final int openSides;
  final bool boundaryWall;
  final bool constructionDone;
  final String roadWidth;
  final bool plotRoadAccess;

  // General transaction attributes
  final String availability;
  final String readyTimeframe;
  final String possessionBy;
  final String ownership;
  final List<String> additionalRooms;
  final String bookingAmount;

  // PG Specific fields
  final String pgGenderBased;
  final String pgOccupancyType;
  final List<String> pgTenantTypes;
  final String pgFoodAvailability;
  final String pgPropertyType;
  final String pgBathroomType;
  final bool pgSmokingAllowed;
  final bool pgDrinkingAllowed;
  final bool pgPetsAllowed;
  final bool pgVisitorsAllowed;
  final bool pgGateLockedAtNight;
  final bool pgSecurity;
  final String pgCurfewTime;
  final List<String> pgNearbyPreferences;
  final String pgAvailability;
  final String pgSuitableFor;
  final String pgBuildingName;
  final String pgTotalBeds;
  final String pgAvailableBeds;
  final String pgRoomType;

  // UI state
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  PropertyFormState({
    this.id = '',
    this.title = '',
    this.description = '',
    this.price = 0.0,
    this.area,
    this.areaUnit = 'sqft',
    this.propertyKind,
    this.type = PropertyType.rent,
    this.bedrooms,
    this.bathrooms,
    this.balconies = 0,
    this.parking = 0,
    this.furnishing = 'unfurnished',
    this.facing = 'north',
    this.floor = '',
    this.totalFloors = '',
    this.plotArea = '',
    this.length = '',
    this.breadth = '',
    this.floorsAllowed = '',
    this.openSides = 1,
    this.boundaryWall = false,
    this.constructionDone = false,
    this.roadWidth = '',
    this.plotRoadAccess = true,
    this.availability = '',
    this.readyTimeframe = '',
    this.possessionBy = '',
    this.ownership = '',
    this.additionalRooms = const [],
    this.bookingAmount = '',
    this.pgGenderBased = '',
    this.pgOccupancyType = '',
    this.pgTenantTypes = const [],
    this.pgFoodAvailability = '',
    this.pgPropertyType = '',
    this.pgBathroomType = '',
    this.pgSmokingAllowed = false,
    this.pgDrinkingAllowed = false,
    this.pgPetsAllowed = false,
    this.pgVisitorsAllowed = false,
    this.pgGateLockedAtNight = false,
    this.pgSecurity = false,
    this.pgCurfewTime = '',
    this.pgNearbyPreferences = const [],
    this.pgAvailability = '',
    this.pgSuitableFor = '',
    this.pgBuildingName = '',
    this.pgTotalBeds = '',
    this.pgAvailableBeds = '',
    this.pgRoomType = '',
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  /// Helper getter to determine context dynamically without complex UI conditions
  bool get isLandPlot =>
      propertyKind == CreatePropertyKind.sale &&
      (categoryId == '4' || categoryId == '5'); // Example category IDs for plots

  bool get isCommercial =>
      propertyKind == CreatePropertyKind.sale && categoryId == '3';

  bool get isPgCoLiving =>
      propertyKind == CreatePropertyKind.pg ||
      propertyKind == CreatePropertyKind.coLiving;

  // Placeholder categoryId helper
  String get categoryId => '';

  PropertyFormState copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    double? area,
    String? areaUnit,
    CreatePropertyKind? propertyKind,
    PropertyType? type,
    int? bedrooms,
    int? bathrooms,
    int? balconies,
    int? parking,
    String? furnishing,
    String? facing,
    String? floor,
    String? totalFloors,
    String? plotArea,
    String? length,
    String? breadth,
    String? floorsAllowed,
    int? openSides,
    bool? boundaryWall,
    bool? constructionDone,
    String? roadWidth,
    bool? plotRoadAccess,
    String? availability,
    String? readyTimeframe,
    String? possessionBy,
    String? ownership,
    List<String>? additionalRooms,
    String? bookingAmount,
    String? pgGenderBased,
    String? pgOccupancyType,
    List<String>? pgTenantTypes,
    String? pgFoodAvailability,
    String? pgPropertyType,
    String? pgBathroomType,
    bool? pgSmokingAllowed,
    bool? pgDrinkingAllowed,
    bool? pgPetsAllowed,
    bool? pgVisitorsAllowed,
    bool? pgGateLockedAtNight,
    bool? pgSecurity,
    String? pgCurfewTime,
    List<String>? pgNearbyPreferences,
    String? pgAvailability,
    String? pgSuitableFor,
    String? pgBuildingName,
    String? pgTotalBeds,
    String? pgAvailableBeds,
    String? pgRoomType,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return PropertyFormState(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      area: area ?? this.area,
      areaUnit: areaUnit ?? this.areaUnit,
      propertyKind: propertyKind ?? this.propertyKind,
      type: type ?? this.type,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      balconies: balconies ?? this.balconies,
      parking: parking ?? this.parking,
      furnishing: furnishing ?? this.furnishing,
      facing: facing ?? this.facing,
      floor: floor ?? this.floor,
      totalFloors: totalFloors ?? this.totalFloors,
      plotArea: plotArea ?? this.plotArea,
      length: length ?? this.length,
      breadth: breadth ?? this.breadth,
      floorsAllowed: floorsAllowed ?? this.floorsAllowed,
      openSides: openSides ?? this.openSides,
      boundaryWall: boundaryWall ?? this.boundaryWall,
      constructionDone: constructionDone ?? this.constructionDone,
      roadWidth: roadWidth ?? this.roadWidth,
      plotRoadAccess: plotRoadAccess ?? this.plotRoadAccess,
      availability: availability ?? this.availability,
      readyTimeframe: readyTimeframe ?? this.readyTimeframe,
      possessionBy: possessionBy ?? this.possessionBy,
      ownership: ownership ?? this.ownership,
      additionalRooms: additionalRooms ?? this.additionalRooms,
      bookingAmount: bookingAmount ?? this.bookingAmount,
      pgGenderBased: pgGenderBased ?? this.pgGenderBased,
      pgOccupancyType: pgOccupancyType ?? this.pgOccupancyType,
      pgTenantTypes: pgTenantTypes ?? this.pgTenantTypes,
      pgFoodAvailability: pgFoodAvailability ?? this.pgFoodAvailability,
      pgPropertyType: pgPropertyType ?? this.pgPropertyType,
      pgBathroomType: pgBathroomType ?? this.pgBathroomType,
      pgSmokingAllowed: pgSmokingAllowed ?? this.pgSmokingAllowed,
      pgDrinkingAllowed: pgDrinkingAllowed ?? this.pgDrinkingAllowed,
      pgPetsAllowed: pgPetsAllowed ?? this.pgPetsAllowed,
      pgVisitorsAllowed: pgVisitorsAllowed ?? this.pgVisitorsAllowed,
      pgGateLockedAtNight: pgGateLockedAtNight ?? this.pgGateLockedAtNight,
      pgSecurity: pgSecurity ?? this.pgSecurity,
      pgCurfewTime: pgCurfewTime ?? this.pgCurfewTime,
      pgNearbyPreferences: pgNearbyPreferences ?? this.pgNearbyPreferences,
      pgAvailability: pgAvailability ?? this.pgAvailability,
      pgSuitableFor: pgSuitableFor ?? this.pgSuitableFor,
      pgBuildingName: pgBuildingName ?? this.pgBuildingName,
      pgTotalBeds: pgTotalBeds ?? this.pgTotalBeds,
      pgAvailableBeds: pgAvailableBeds ?? this.pgAvailableBeds,
      pgRoomType: pgRoomType ?? this.pgRoomType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// The state controller that acts as the "brain" for the entire Property Create/Edit Screen.
class PropertyFormNotifier extends StateNotifier<PropertyFormState> {
  PropertyFormNotifier() : super(PropertyFormState());

  // Updates simple text inputs
  void updateTitle(String value) => state = state.copyWith(title: value);
  void updateDescription(String value) => state = state.copyWith(description: value);
  void updatePrice(double value) => state = state.copyWith(price: value);
  void updateArea(double? value) => state = state.copyWith(area: value);
  void updateAreaUnit(String value) => state = state.copyWith(areaUnit: value);

  // Updates transaction kind and dynamically maps standard PropertyType
  void updatePropertyKind(CreatePropertyKind kind) {
    final type = (kind == CreatePropertyKind.sale)
        ? PropertyType.sale
        : PropertyType.rent;
    state = state.copyWith(propertyKind: kind, type: type);
  }

  // Updates single-select choice chip row attributes
  void updateAvailability(String value) => state = state.copyWith(availability: value);
  void updateOwnership(String value) => state = state.copyWith(ownership: value);
  void updateFacing(String value) => state = state.copyWith(facing: value);
  void updateFurnishing(String value) => state = state.copyWith(furnishing: value);

  // Updates multi-select items (e.g. additional rooms)
  void toggleAdditionalRoom(String room) {
    final list = List<String>.from(state.additionalRooms);
    if (list.contains(room)) {
      list.remove(room);
    } else {
      list.add(room);
    }
    state = state.copyWith(additionalRooms: list);
  }

  // Resets the state cleanly
  void reset() {
    state = PropertyFormState();
  }

  /// Load existing draft or API property safely
  void loadFromProperty(Property p) {
    state = PropertyFormState(
      id: p.id,
      title: p.name,
      description: p.description,
      price: p.price,
      area: p.area,
      areaUnit: p.areaUnit ?? 'sqft',
      type: p.type,
      bedrooms: p.bedrooms,
      bathrooms: p.bathrooms,
      balconies: p.balconies ?? 0,
      parking: p.parking ?? 0,
      furnishing: p.furnishing ?? 'unfurnished',
      facing: p.facing ?? 'north',
      floor: p.floor?.toString() ?? '',
      totalFloors: p.totalFloors?.toString() ?? '',
      availability: p.availability ?? '',
      possessionBy: p.possessionBy ?? '',
      ownership: p.ownership ?? '',
      additionalRooms: p.additionalRooms ?? const [],
      bookingAmount: p.bookingAmount?.toString() ?? '',
    );
  }
}

/// Dynamic provider declaration for global application access
final propertyFormProvider =
    StateNotifierProvider.autoDispose<PropertyFormNotifier, PropertyFormState>((ref) {
  return PropertyFormNotifier();
});
