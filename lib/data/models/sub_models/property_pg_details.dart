import 'package:equatable/equatable.dart';

class PropertyPgDetails extends Equatable {
  final String? genderBased;
  final String? occupancyType;
  final List<String>? tenantTypes;
  final String? foodAvailability;
  final String? propertyType;
  final String? bathroomType;
  final String? suitableFor;
  final String? buildingName;
  final int? totalBeds;
  final int? availableBeds;
  final String? roomType;
  final bool? attachedBathroom;
  final bool? balcony;
  final String? roomSize;
  final String? bedType;
  final bool? cupboardAvailable;
  final bool? studyTableAvailable;
  final double? securityDeposit;
  final bool? electricityIncluded;
  final bool? waterIncluded;
  final bool? foodChargesIncluded;
  final bool? brokerageRequired;
  final bool? coupleFriendly;
  final bool? idProofRequired;
  final String? availableFrom;
  final int? minStayDays;
  final int? noticePeriodDays;
  final int? preferredTenantAge;
  final bool? smokingAllowed;
  final bool? drinkingAllowed;
  final bool? petsAllowed;
  final bool? visitorsAllowed;
  final String? curfewTime;
  final bool? gateLockedAtNight;
  final List<String>? nearbyPreferences;
  final String? availability;
  final int? sharing;
  final bool? security;
  final double? maintenanceCharges;

  const PropertyPgDetails({
    this.genderBased,
    this.occupancyType,
    this.tenantTypes,
    this.foodAvailability,
    this.propertyType,
    this.bathroomType,
    this.suitableFor,
    this.buildingName,
    this.totalBeds,
    this.availableBeds,
    this.roomType,
    this.attachedBathroom,
    this.balcony,
    this.roomSize,
    this.bedType,
    this.cupboardAvailable,
    this.studyTableAvailable,
    this.securityDeposit,
    this.electricityIncluded,
    this.waterIncluded,
    this.foodChargesIncluded,
    this.brokerageRequired,
    this.coupleFriendly,
    this.idProofRequired,
    this.availableFrom,
    this.minStayDays,
    this.noticePeriodDays,
    this.preferredTenantAge,
    this.smokingAllowed,
    this.drinkingAllowed,
    this.petsAllowed,
    this.visitorsAllowed,
    this.curfewTime,
    this.gateLockedAtNight,
    this.nearbyPreferences,
    this.availability,
    this.sharing,
    this.security,
    this.maintenanceCharges,
  });

  @override
  List<Object?> get props => [
        genderBased,
        occupancyType,
        tenantTypes,
        foodAvailability,
        propertyType,
        bathroomType,
        suitableFor,
        buildingName,
        totalBeds,
        availableBeds,
        roomType,
        attachedBathroom,
        balcony,
        roomSize,
        bedType,
        cupboardAvailable,
        studyTableAvailable,
        securityDeposit,
        electricityIncluded,
        waterIncluded,
        foodChargesIncluded,
        brokerageRequired,
        coupleFriendly,
        idProofRequired,
        availableFrom,
        minStayDays,
        noticePeriodDays,
        preferredTenantAge,
        smokingAllowed,
        drinkingAllowed,
        petsAllowed,
        visitorsAllowed,
        curfewTime,
        gateLockedAtNight,
        nearbyPreferences,
        availability,
        sharing,
        security,
        maintenanceCharges,
      ];
}
