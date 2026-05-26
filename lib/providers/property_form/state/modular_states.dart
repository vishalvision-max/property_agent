import 'package:flutter/foundation.dart';
import 'package:property_agent/data/models/media_item.dart';
import 'package:property_agent/data/models/property_enums.dart';
import 'package:property_agent/data/models/property_kind.dart';

@immutable
class BasicInfoState {
  const BasicInfoState({
    this.title = '',
    this.description = '',
    this.area = '',
    this.areaUnit = 'sqft',
    this.type = PropertyType.rent,
    this.listingType = 'owner',
    this.propertyKind,
    this.selectedParentCategoryId,
    this.selectedCategoryId,
    this.selectedParentCategorySlug = '',
    this.selectedCategorySlug = '',
    this.ownerName = '',
    this.ownerPhone = '',
  });

  final String title;
  final String description;
  final String area;
  final String areaUnit;
  final PropertyType type;
  final String listingType;
  final PropertyKind? propertyKind;
  final int? selectedParentCategoryId;
  final int? selectedCategoryId;
  final String selectedParentCategorySlug;
  final String selectedCategorySlug;
  final String ownerName;
  final String ownerPhone;

  BasicInfoState copyWith({
    String? title,
    String? description,
    String? area,
    String? areaUnit,
    PropertyType? type,
    String? listingType,
    PropertyKind? propertyKind,
    int? selectedParentCategoryId,
    int? selectedCategoryId,
    String? selectedParentCategorySlug,
    String? selectedCategorySlug,
    String? ownerName,
    String? ownerPhone,
  }) {
    return BasicInfoState(
      title: title ?? this.title,
      description: description ?? this.description,
      area: area ?? this.area,
      areaUnit: areaUnit ?? this.areaUnit,
      type: type ?? this.type,
      listingType: listingType ?? this.listingType,
      propertyKind: propertyKind ?? this.propertyKind,
      selectedParentCategoryId:
          selectedParentCategoryId ?? this.selectedParentCategoryId,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedParentCategorySlug:
          selectedParentCategorySlug ?? this.selectedParentCategorySlug,
      selectedCategorySlug: selectedCategorySlug ?? this.selectedCategorySlug,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
    );
  }
}

@immutable
class PricingState {
  const PricingState({
    this.price = '',
    this.maintenanceCharges = '',
    this.bookingAmount = '',
    this.priceNegotiable,
    this.securityDeposit = '',
    this.villaMaintenanceCharges = '',
    this.villaBookingAmount = '',
    this.rentMaintenanceCharges = '',
    this.brokerage = '',
    this.rentNegotiable,
  });

  final String price;
  final String maintenanceCharges;
  final String bookingAmount;
  final bool? priceNegotiable;
  final String securityDeposit;
  final String villaMaintenanceCharges;
  final String villaBookingAmount;
  final String rentMaintenanceCharges;
  final String brokerage;
  final bool? rentNegotiable;

  PricingState copyWith({
    String? price,
    String? maintenanceCharges,
    String? bookingAmount,
    bool? priceNegotiable,
    String? securityDeposit,
    String? villaMaintenanceCharges,
    String? villaBookingAmount,
    String? rentMaintenanceCharges,
    String? brokerage,
    bool? rentNegotiable,
  }) {
    return PricingState(
      price: price ?? this.price,
      maintenanceCharges: maintenanceCharges ?? this.maintenanceCharges,
      bookingAmount: bookingAmount ?? this.bookingAmount,
      priceNegotiable: priceNegotiable ?? this.priceNegotiable,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      villaMaintenanceCharges:
          villaMaintenanceCharges ?? this.villaMaintenanceCharges,
      villaBookingAmount: villaBookingAmount ?? this.villaBookingAmount,
      rentMaintenanceCharges:
          rentMaintenanceCharges ?? this.rentMaintenanceCharges,
      brokerage: brokerage ?? this.brokerage,
      rentNegotiable: rentNegotiable ?? this.rentNegotiable,
    );
  }
}

@immutable
class LocationState {
  const LocationState({
    this.address = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.latitude,
    this.longitude,
  });

  final String address;
  final String city;
  final String state;
  final String pincode;
  final double? latitude;
  final double? longitude;

  LocationState copyWith({
    String? address,
    String? city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
  }) {
    return LocationState(
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

@immutable
class MediaState {
  const MediaState({
    this.images = const [],
    this.videos = const [],
    this.primaryImageIndex = 0,
  });

  final List<MediaItem> images;
  final List<MediaItem> videos;
  final int primaryImageIndex;

  MediaState copyWith({
    List<MediaItem>? images,
    List<MediaItem>? videos,
    int? primaryImageIndex,
  }) {
    return MediaState(
      images: images ?? this.images,
      videos: videos ?? this.videos,
      primaryImageIndex: primaryImageIndex ?? this.primaryImageIndex,
    );
  }
}
