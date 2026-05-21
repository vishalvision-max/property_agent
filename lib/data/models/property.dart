import 'package:equatable/equatable.dart';

import 'property_enums.dart';
import 'property_furnishing_selection.dart';
import 'property_video.dart';

class Property extends Equatable {
  const Property({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.location,
    required this.price,
    required this.type,
    required this.amenities,
    required this.images,
    required this.videos,
    required this.description,
    required this.status,
    this.slug,
    this.listingType,
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
  });

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
  final bool? isFeatured;
  final DateTime? featuredExpiry;
  final List<String>? documents;
  final List<int>? amenityIds;
  final List<PropertyFurnishingSelection>? furnishingSelections;

  // Create-only helpers (not serialized from API).
  final Map<String, dynamic>? apiFields;
  final Map<String, List<String>>? sectionImagePaths;
  final List<String>? documentPaths;

  Property copyWith({
    String? name,
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
  }) {
    return Property(
      id: id,
      name: name ?? this.name,
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
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'ownerName': ownerName,
        'location': location,
        'price': price,
        'type': type.name,
        'amenities': amenities,
        'images': images,
        'videos': videos.map((e) => e.toJson()).toList(),
        'description': description,
        'status': status.name,
        'slug': slug,
        'listingType': listingType,
        'area': area,
        'areaUnit': areaUnit,
        'propertyAge': propertyAge,
        'facing': facing,
        'floor': floor,
        'totalFloors': totalFloors,
        'possessionStatus': possessionStatus,
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
        'primaryImageIndex': primaryImageIndex,
        'rejectionReason': rejectionReason,
        'updatedAt': updatedAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'categoryId': categoryId,
        'userId': userId,
        'isFeatured': isFeatured,
        'featuredExpiry': featuredExpiry?.toIso8601String(),
        'documents': documents,
        'amenityIds': amenityIds,
      };

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        ownerName: (json['ownerName'] ?? '').toString(),
        location: (json['location'] ?? '').toString(),
        price: (json['price'] as num?)?.toDouble() ?? 0,
        type: PropertyType.values.byName((json['type'] ?? 'rent').toString()),
        amenities: ((json['amenities'] as List?) ?? const []).map((e) => e.toString()).toList(),
        images: ((json['images'] as List?) ?? const []).map((e) => e.toString()).toList(),
        videos: ((json['videos'] as List?) ?? const [])
            .whereType<Map>()
            .map((e) => PropertyVideo.fromJson(Map<String, dynamic>.from(e)))
            .toList(growable: false),
        description: (json['description'] ?? '').toString(),
        status: PropertyStatus.values.byName((json['status'] ?? 'pending').toString()),
        slug: json['slug']?.toString(),
        listingType: json['listingType']?.toString() ?? json['listing_type']?.toString(),
        area: (json['area'] as num?)?.toDouble(),
        areaUnit: json['areaUnit']?.toString() ?? json['area_unit']?.toString(),
        propertyAge: (json['propertyAge'] as num?)?.toInt() ?? (json['property_age'] as num?)?.toInt(),
        facing: json['facing']?.toString(),
        floor: (json['floor'] as num?)?.toInt(),
        totalFloors: (json['totalFloors'] as num?)?.toInt() ?? (json['total_floors'] as num?)?.toInt(),
        possessionStatus: json['possessionStatus']?.toString() ?? json['possession_status']?.toString(),
        bedrooms: (json['bedrooms'] as num?)?.toInt(),
        bathrooms: (json['bathrooms'] as num?)?.toInt(),
        furnishing: json['furnishing']?.toString(),
        parking: (json['parking'] as num?)?.toInt(),
        address: json['address']?.toString(),
        city: json['city']?.toString(),
        state: json['state']?.toString(),
        pincode: json['pincode']?.toString(),
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        primaryImageIndex: (json['primaryImageIndex'] as num?)?.toInt() ?? (json['primary_image_index'] as num?)?.toInt(),
        rejectionReason: json['rejectionReason']?.toString(),
        updatedAt: json['updatedAt'] == null ? null : DateTime.tryParse(json['updatedAt'].toString()),
        createdAt: json['createdAt'] == null ? null : DateTime.tryParse(json['created_at']?.toString() ?? json['createdAt'].toString()),
        categoryId: json['categoryId']?.toString() ?? json['category_id']?.toString(),
        userId: (json['userId'] as num?)?.toInt() ?? (json['user_id'] as num?)?.toInt(),
        isFeatured: json['isFeatured'] as bool? ?? json['is_featured'] as bool?,
        featuredExpiry: json['featuredExpiry'] == null ? null : DateTime.tryParse(json['featured_expiry']?.toString() ?? json['featuredExpiry'].toString()),
        documents: ((json['documents'] as List?) ?? const []).map((e) => e.toString()).toList(),
        amenityIds: (json['amenityIds'] as List?)?.whereType<num>().map((e) => e.toInt()).toList(),
        furnishingSelections: () {
          final list = json['furnishings'] as List? ??
              json['furnishing_selections'] as List? ??
              json['furnishingSelections'] as List?;
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
      );

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
      ];
}
