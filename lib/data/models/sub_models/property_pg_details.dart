import 'dart:convert';
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

  Map<String, dynamic> toJson() => {
    'gender_based': genderBased,
    'occupancy_type': occupancyType,
    'tenant_types': tenantTypes,
    'food_available': foodAvailability,
    'property_type': propertyType,
    'bathroom_type': bathroomType,
    'suitable_for': suitableFor,
    'building_name': buildingName,
    'total_beds': totalBeds,
    'available_beds': availableBeds,
    'room_type': roomType,
    'attached_bathroom': attachedBathroom,
    'balcony': balcony,
    'room_size': roomSize,
    'bed_type': bedType,
    'security_deposit': securityDeposit,
    'electricity_included': electricityIncluded,
    'water_included': waterIncluded,
    'food_charges_included': foodChargesIncluded,
    'brokerage_required': brokerageRequired,
    'couple_friendly': coupleFriendly,
    'id_proof_required': idProofRequired,
    'available_from': availableFrom,
    'min_stay_days': minStayDays,
    'notice_period_days': noticePeriodDays,
    'preferred_tenant_age': preferredTenantAge,
    'smoking_allowed': smokingAllowed,
    'drinking_allowed': drinkingAllowed,
    'pets_allowed': petsAllowed,
    'visitors_allowed': visitorsAllowed,
    'curfew_time': curfewTime,
    'gate_locked_at_night': gateLockedAtNight,
    'nearby_preferences': nearbyPreferences,
    'availability_status': availability,
    'pg_sharing': sharing,
    'pg_security': security,
    'maintenance_charges': maintenanceCharges,
  };
  factory PropertyPgDetails.fromJson(Map<String, dynamic> json) {
    return PropertyPgDetails(
      genderBased: json['gender_based']?.toString(),
      occupancyType: json['occupancy_type']?.toString(),
      tenantTypes: _toStringList(json['tenant_types']),
      foodAvailability: json['food_available']?.toString(),
      propertyType: json['property_type']?.toString(),
      bathroomType: json['bathroom_type']?.toString(),
      suitableFor: json['suitable_for']?.toString(),
      buildingName: json['building_name']?.toString(),
      totalBeds: int.tryParse(json['total_beds']?.toString() ?? ''),
      availableBeds: int.tryParse(json['available_beds']?.toString() ?? ''),
      roomType: json['room_type']?.toString(),
      attachedBathroom:
          json['attached_bathroom'] == true || json['attached_bathroom'] == 1,
      balcony: json['balcony'] == true || json['balcony'] == 1,
      roomSize: json['room_size']?.toString(),
      bedType: json['bed_type']?.toString(),
      cupboardAvailable:
          json['cupboard_available'] == true || json['cupboard_available'] == 1,
      studyTableAvailable:
          json['study_table_available'] == true ||
          json['study_table_available'] == 1,
      securityDeposit: double.tryParse(
        json['security_deposit']?.toString() ?? '',
      ),
      electricityIncluded:
          json['electricity_included'] == true ||
          json['electricity_included'] == 1,
      waterIncluded:
          json['water_included'] == true || json['water_included'] == 1,
      foodChargesIncluded:
          json['food_charges_included'] == true ||
          json['food_charges_included'] == 1,
      brokerageRequired:
          json['brokerage_required'] == true || json['brokerage_required'] == 1,
      coupleFriendly:
          json['couple_friendly'] == true || json['couple_friendly'] == 1,
      idProofRequired:
          json['id_proof_required'] == true || json['id_proof_required'] == 1,
      availableFrom: json['available_from']?.toString(),
      minStayDays: int.tryParse(json['min_stay_days']?.toString() ?? ''),
      noticePeriodDays: int.tryParse(
        json['notice_period_days']?.toString() ?? '',
      ),
      preferredTenantAge: int.tryParse(
        json['preferred_tenant_age']?.toString() ?? '',
      ),
      smokingAllowed:
          json['smoking_allowed'] == true || json['smoking_allowed'] == 1,
      drinkingAllowed:
          json['drinking_allowed'] == true || json['drinking_allowed'] == 1,
      petsAllowed: json['pets_allowed'] == true || json['pets_allowed'] == 1,
      visitorsAllowed:
          json['visitors_allowed'] == true || json['visitors_allowed'] == 1,
      curfewTime: json['curfew_time']?.toString(),
      gateLockedAtNight:
          json['gate_locked_at_night'] == true ||
          json['gate_locked_at_night'] == 1,
      nearbyPreferences: _toStringList(json['nearby_preferences']),
      availability: json['availability_status']?.toString(),
      sharing: int.tryParse(json['pg_sharing']?.toString() ?? ''),
      security: json['pg_security'] == true || json['pg_security'] == 1,
      maintenanceCharges: double.tryParse(
        json['maintenance_charges']?.toString() ?? '',
      ),
    );
  }
}

List<String> _toStringList(dynamic val) {
  if (val == null) return const [];
  if (val is List) {
    return val
        .map((e) => e.toString().trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
  if (val is String) {
    final s = val.trim();
    if (s.isEmpty) return const [];
    if (s.startsWith('[') && s.endsWith(']')) {
      try {
        final parsed = jsonDecode(s);
        if (parsed is List) {
          return parsed
              .map((e) => e.toString().trim())
              .where((x) => x.isNotEmpty)
              .toList();
        }
      } catch (_) {}
    }
    return s
        .split(',')
        .map((e) {
          return e
              .replaceAll('[', '')
              .replaceAll(']', '')
              .replaceAll('"', '')
              .replaceAll("'", "")
              .trim();
        })
        .where((e) => e.isNotEmpty)
        .toList();
  }
  return const [];
}
