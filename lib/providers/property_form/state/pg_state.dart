import 'package:flutter/foundation.dart';

@immutable
class PgState {
  const PgState({
    this.pgGenderBased = '',
    this.pgOccupancyType = '',
    this.pgTenantTypes = const [],
    this.pgFoodAvailability = '',
    this.pgPropertyType = '',
    this.pgBathroomType = '',
    this.pgSuitableFor = '',
    this.pgBuildingName = '',
    this.pgTotalBeds = '',
    this.pgAvailableBeds = '',
    this.pgRoomType = '',
    this.pgAttachedBathroom = false,
    this.pgBalcony = false,
    this.pgRoomSize = '',
    this.pgBedType = '',
    this.pgCupboardAvailable = false,
    this.pgStudyTableAvailable = false,
    this.pgSecurityDeposit = '',
    this.pgElectricityIncluded = false,
    this.pgWaterIncluded = false,
    this.pgFoodChargesIncluded = false,
    this.pgBrokerageRequired = false,
    this.pgCoupleFriendly = false,
    this.pgIdProofRequired = false,
    this.pgAvailableFrom = '',
    this.pgMinStayDays = '',
    this.pgNoticePeriodDays = '',
    this.pgPreferredTenantAge = '',
    this.pgSmokingAllowed = false,
    this.pgDrinkingAllowed = false,
    this.pgPetsAllowed = false,
    this.pgVisitorsAllowed = false,
    this.pgCurfewTime = '',
    this.pgGateLockedAtNight = false,
    this.pgNearbyPreferences = const [],
    this.pgAvailability = '',
    this.pgSharing = 1,
    this.pgSecurity = false,
    this.pgMaintenanceCharges = '',
  });

  final String pgGenderBased;
  final String pgOccupancyType;
  final List<String> pgTenantTypes;
  final String pgFoodAvailability;
  final String pgPropertyType;
  final String pgBathroomType;
  final String pgSuitableFor;
  final String pgBuildingName;
  final String pgTotalBeds;
  final String pgAvailableBeds;
  final String pgRoomType;
  final bool pgAttachedBathroom;
  final bool pgBalcony;
  final String pgRoomSize;
  final String pgBedType;
  final bool pgCupboardAvailable;
  final bool pgStudyTableAvailable;
  final String pgSecurityDeposit;
  final bool pgElectricityIncluded;
  final bool pgWaterIncluded;
  final bool pgFoodChargesIncluded;
  final bool pgBrokerageRequired;
  final bool pgCoupleFriendly;
  final bool pgIdProofRequired;
  final String pgAvailableFrom;
  final String pgMinStayDays;
  final String pgNoticePeriodDays;
  final String pgPreferredTenantAge;
  final bool pgSmokingAllowed;
  final bool pgDrinkingAllowed;
  final bool pgPetsAllowed;
  final bool pgVisitorsAllowed;
  final String pgCurfewTime;
  final bool pgGateLockedAtNight;
  final List<String> pgNearbyPreferences;
  final String pgAvailability;
  final int pgSharing;
  final bool pgSecurity;
  final String pgMaintenanceCharges;

  PgState copyWith({
    String? pgGenderBased,
    String? pgOccupancyType,
    List<String>? pgTenantTypes,
    String? pgFoodAvailability,
    String? pgPropertyType,
    String? pgBathroomType,
    String? pgSuitableFor,
    String? pgBuildingName,
    String? pgTotalBeds,
    String? pgAvailableBeds,
    String? pgRoomType,
    bool? pgAttachedBathroom,
    bool? pgBalcony,
    String? pgRoomSize,
    String? pgBedType,
    bool? pgCupboardAvailable,
    bool? pgStudyTableAvailable,
    String? pgSecurityDeposit,
    bool? pgElectricityIncluded,
    bool? pgWaterIncluded,
    bool? pgFoodChargesIncluded,
    bool? pgBrokerageRequired,
    bool? pgCoupleFriendly,
    bool? pgIdProofRequired,
    String? pgAvailableFrom,
    String? pgMinStayDays,
    String? pgNoticePeriodDays,
    String? pgPreferredTenantAge,
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
    String? pgMaintenanceCharges,
  }) {
    return PgState(
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
      pgStudyTableAvailable:
          pgStudyTableAvailable ?? this.pgStudyTableAvailable,
      pgSecurityDeposit: pgSecurityDeposit ?? this.pgSecurityDeposit,
      pgElectricityIncluded:
          pgElectricityIncluded ?? this.pgElectricityIncluded,
      pgWaterIncluded: pgWaterIncluded ?? this.pgWaterIncluded,
      pgFoodChargesIncluded:
          pgFoodChargesIncluded ?? this.pgFoodChargesIncluded,
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
}
