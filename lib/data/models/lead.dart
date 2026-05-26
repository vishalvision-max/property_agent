class LeadProperty {
  final int id;
  final String title;
  final String description;
  final double price;
  final String city;
  final String state;
  final String type;
  final String address;
  final int? bedrooms;
  final int? bathrooms;
  final double? area;
  final String? areaUnit;
  final String? furnishing;
  final String? possessionStatus;

  LeadProperty({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.city,
    required this.state,
    required this.type,
    required this.address,
    this.bedrooms,
    this.bathrooms,
    this.area,
    this.areaUnit,
    this.furnishing,
    this.possessionStatus,
  });

  factory LeadProperty.fromJson(Map<String, dynamic> json) {
    return LeadProperty(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      bedrooms: json['bedrooms'] != null ? (json['bedrooms'] as num).toInt() : null,
      bathrooms: json['bathrooms'] != null ? (json['bathrooms'] as num).toInt() : null,
      area: json['area'] != null ? (json['area'] as num).toDouble() : null,
      areaUnit: json['area_unit']?.toString(),
      furnishing: json['furnishing']?.toString(),
      possessionStatus: json['possession_status']?.toString(),
    );
  }
}

class Lead {
  const Lead({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.type,
    required this.propertyType,
    required this.city,
    required this.state,
    required this.pincode,
    required this.address,
    required this.budgetMin,
    required this.budgetMax,
    required this.message,
    required this.assignedTo,
    required this.status,
    required this.source,
    required this.utmSource,
    required this.utmMedium,
    required this.utmCampaign,
    required this.lastContactedAt,
    required this.priority,
    required this.leadScore,
    required this.convertedPropertyId,
    this.propertyId,
    this.property,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String phone;
  final String? email;
  final String type;
  final String propertyType;
  final String city;
  final String state;
  final String pincode;
  final String? address;
  final double? budgetMin;
  final double? budgetMax;
  final String? message;
  final int? assignedTo;
  final String status;
  final String source;
  final String? utmSource;
  final String? utmMedium;
  final String? utmCampaign;
  final DateTime? lastContactedAt;
  final String priority;
  final int leadScore;
  final String? convertedPropertyId;
  final int? propertyId;
  final LeadProperty? property;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static double? _toDoubleOrNull(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static int? _toIntOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  static DateTime? _toDateTimeOrNull(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: (json['id'] as num?)?.toInt() ?? int.tryParse('${json['id']}') ?? 0,
      name: (json['name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      email: json['email']?.toString(),
      type: (json['type'] ?? '').toString(),
      propertyType: (json['property_type'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      pincode: (json['pincode'] ?? '').toString(),
      address: json['address']?.toString(),
      budgetMin: _toDoubleOrNull(json['budget_min']),
      budgetMax: _toDoubleOrNull(json['budget_max']),
      message: json['message']?.toString(),
      assignedTo: _toIntOrNull(json['assigned_to']),
      status: (json['status'] ?? '').toString(),
      source: (json['source'] ?? '').toString(),
      utmSource: json['utm_source']?.toString(),
      utmMedium: json['utm_medium']?.toString(),
      utmCampaign: json['utm_campaign']?.toString(),
      lastContactedAt: _toDateTimeOrNull(json['last_contacted_at']),
      priority: (json['priority'] ?? '').toString(),
      leadScore: (json['lead_score'] as num?)?.toInt() ?? _toIntOrNull(json['lead_score']) ?? 0,
      convertedPropertyId: json['converted_property_id']?.toString(),
      propertyId: json['property_id'] != null ? (json['property_id'] as num).toInt() : null,
      property: json['property'] != null && json['property'] is Map
          ? LeadProperty.fromJson(Map<String, dynamic>.from(json['property'] as Map))
          : null,
      createdAt: _toDateTimeOrNull(json['created_at']),
      updatedAt: _toDateTimeOrNull(json['updated_at']),
    );
  }
}
