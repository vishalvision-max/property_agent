import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode, compute;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_agent/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:video_player/video_player.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/local_image.dart';
import '../../../core/validators/validators.dart';
import '../../../data/models/property.dart';
import '../../../data/models/category.dart';
import '../../../data/models/property_enums.dart';
import '../../../data/models/property_furnishing_selection.dart';
import '../../../providers/lookup_provider.dart';
import '../../../providers/property_provider.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/app_dropdown.dart';
import '../../../data/services/google_places_service.dart';

class PropertyCreateScreen extends ConsumerStatefulWidget {
  const PropertyCreateScreen({
    super.key,
    this.autoRestoreDraft = false,
    this.initialProperty,
  });

  final bool autoRestoreDraft;
  final Property? initialProperty;

  @override
  ConsumerState<PropertyCreateScreen> createState() =>
      _PropertyCreateScreenState();
}

class _PropertyCreateScreenState extends ConsumerState<PropertyCreateScreen> {
  static const _draftPrefsKey = 'property_create_draft_v1';

  // ==================== BASIC INFO ====================
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _area = TextEditingController();
  String _areaUnit = 'sqft';
  PropertyType _type = PropertyType.rent;
  String _listingType = 'owner';

  _CreatePropertyKind? _propertyKind;
  int? _selectedParentCategoryId;
  int? _selectedCategoryId;
  String? _selectedParentCategorySlug;
  String? _selectedCategorySlug;

  // ==================== PROPERTY DETAILS ====================
  // Common
  int _bedrooms = 0;
  int _bathrooms = 0;
  int _balconies = -1;
  int _parking = 0;
  String _furnishing = '';
  String _facing = '';
  final _floor = TextEditingController();
  final _totalFloors = TextEditingController();
  int? _lastTotalFloorsValue;
  final _carpetArea = TextEditingController();
  final _builtUpArea = TextEditingController();
  final _superBuiltUpArea = TextEditingController();
  final _plotArea = TextEditingController();
  final _length = TextEditingController();
  final _breadth = TextEditingController();
  final _floorsAllowed = TextEditingController();
  int _openSides = 0;
  bool? _boundaryWall;
  bool? _constructionDone;

  String _availability = '';
  String _readyTimeframe = '';
  final _possessionBy = TextEditingController();
  String _ownership = '';

  // Commercial specific
  String _commercialType = '';
  final _floorPlateArea = TextEditingController();
  final _cabins = TextEditingController();
  final _meetingRooms = TextEditingController();
  final _seats = TextEditingController();
  final _maxSeats = TextEditingController();
  final _conferenceRooms = TextEditingController();
  bool _liftAvailable = true;
  bool _preLeased = false;
  final _shopFacade = TextEditingController();
  final _washrooms = TextEditingController();
  String _parkingType = '';
  final _plotType = TextEditingController();
  final _qualityRating = TextEditingController();
  final _rooms = TextEditingController();
  String _officeType = '';
  bool _receptionArea = false;
  bool _pantry = false;
  bool _cafeteria = false;
  bool _serverRoom = false;
  bool _fireSafetyInstalled = false;
  bool _centralAC = false;
  bool _visitorParking = false;
  final _numberOfLifts = TextEditingController();
  bool _taxIncluded = false;
  bool? _officeNegotiable;
  final _officeMaintenanceCharges = TextEditingController();
  final _officeBookingAmount = TextEditingController();

  // Sell -> Commercial -> Shop specific
  String _shopType = '';
  final _shopArea = TextEditingController();
  String _shopAreaUnit = 'sqft';
  final _frontageWidth = TextEditingController();
  final _ceilingHeight = TextEditingController();
  bool? _mainRoadFacing;
  bool? _cornerShop;
  bool? _washroomAvailable;
  String _floorType = '';
  final _marketName = TextEditingController();
  final _locality = TextEditingController();

  // Sell -> Commercial -> Showroom specific
  final _showroomArea = TextEditingController();
  String _showroomAreaUnit = 'sqft';
  final _showroomFrontageWidth = TextEditingController();
  final _showroomCeilingHeight = TextEditingController();
  bool? _showroomMainRoadFacing;
  bool? _showroomCorner;
  bool? _showroomWashroom;
  final _showroomParkingSlots = TextEditingController();
  String _showroomFurnishing = '';
  String _showroomFloorType = '';
  final _showroomMarketName = TextEditingController();
  final _showroomLocality = TextEditingController();
  final _showroomOwnerName = TextEditingController();
  final _showroomOwnerMobile = TextEditingController();

  // Sell -> Commercial -> Warehouse specific
  String _warehouseType = ''; // warehouse, factory, industrial_building
  final _warehousePlotArea = TextEditingController();
  String _warehousePlotAreaUnit = 'sqft';
  final _warehouseCeilingHeight = TextEditingController();
  final _warehouseLoadingBays = TextEditingController();
  final _warehouseDockLevelers = TextEditingController();
  final _warehousePowerSupply = TextEditingController();
  bool? _warehouseIndustrialLicense;
  String _warehouseTruckAccess = ''; // heavy, medium, small
  final _warehouseAreaName = TextEditingController();
  final _warehouseCity = TextEditingController();

  // Land specific
  String _landType = '';
  final _roadWidth = TextEditingController();
  String _plotAreaUnit = 'sqft';
  bool? _plotCorner;
  bool? _plotRoadAccess;
  bool _agriFencing = false;
  String _agriWaterSource =
      ''; // borewell, canal, river, tanker, municipal, other

  // Sell -> Residential -> Flat/Apartment specific
  final Set<String> _additionalRooms = <String>{};
  bool? _cornerProperty;
  bool? _priceNegotiable;
  final _maintenanceCharges = TextEditingController();
  final _bookingAmount = TextEditingController();
  final Set<String> _propertyHighlights = <String>{};
  bool _whatsappUpdates = true;
  final Set<String> _promotionTags = <String>{};

  // Rent/Lease -> Residential -> Flat/Apartment specific
  final Set<String> _rentAdditionalRooms = <String>{};
  bool? _rentCornerProperty;
  bool _petFriendly = false;
  bool _wheelchairFriendly = false;
  bool? _rentGatedSociety;
  final _securityDeposit = TextEditingController();
  final _rentMaintenanceCharges = TextEditingController();
  final _brokerage = TextEditingController();
  bool? _rentNegotiable;
  final _availableFrom = TextEditingController(); // yyyy-mm-dd
  final _leaseDurationMonths = TextEditingController(text: '11');
  final _lockInMonths = TextEditingController(text: '0');
  final _noticePeriodValue = TextEditingController(text: '0');
  String _noticePeriodUnit = 'days'; // days, months
  String _preferredTenant = '';
  String _foodPreference = '';
  final Set<String> _rentPromotionTypes = <String>{};

  // PG / Co-Living specific
  String _pgGenderBased = ''; // boys_pg, girls_pg, co_living, unisex_pg
  String _pgOccupancyType =
      ''; // single_sharing, double_sharing, triple_sharing, four_plus_sharing, dormitory
  final Set<String> _pgTenantTypes =
      <
        String
      >{}; // students, working_professionals, couples_allowed, family_pg, interns_trainees
  String _pgFoodAvailability =
      ''; // with_food, without_food, veg_only, non_veg_allowed, self_cooking_allowed
  String _pgPropertyType =
      ''; // independent_house_pg, apartment_pg, hostel, co_living_space, service_apartment
  String _pgBathroomType = ''; // attached, common
  String _pgSuitableFor = ''; // students, working_professionals, both
  final _pgBuildingName = TextEditingController();
  final _pgTotalBeds = TextEditingController();
  final _pgAvailableBeds = TextEditingController();
  String _pgRoomType =
      ''; // private_room, twin_sharing, triple_sharing, dormitory
  bool _pgAttachedBathroom = false;
  bool _pgBalcony = false;
  final _pgRoomSize = TextEditingController();
  String _pgBedType = ''; // single, bunk
  bool _pgCupboardAvailable = true;
  bool _pgStudyTableAvailable = false;
  final _pgSecurityDeposit = TextEditingController();
  final _pgMaintenanceCharges = TextEditingController();
  bool _pgElectricityIncluded = false;
  bool _pgWaterIncluded = true;
  bool _pgFoodChargesIncluded = false;
  bool _pgBrokerageRequired = false;
  bool _pgCoupleFriendly = false;
  bool _pgIdProofRequired = true;
  final _pgAvailableFrom = TextEditingController(); // yyyy-mm-dd
  final _pgMinStayDays = TextEditingController();
  final _pgNoticePeriodDays = TextEditingController();
  final _pgPreferredTenantAge = TextEditingController();
  bool _pgSmokingAllowed = false;
  bool _pgDrinkingAllowed = false;
  bool _pgPetsAllowed = false;
  bool _pgVisitorsAllowed = true;
  final _pgCurfewTime = TextEditingController(); // e.g. 10:00 PM
  bool _pgGateLockedAtNight = true;
  final Set<String> _pgNearbyPreferences =
      <
        String
      >{}; // near_metro, near_college, near_office_area, near_market, near_hospital
  String _pgAvailability = ''; // immediate, next_month, short_term, long_term
  int _pgSharing =
      0; // persons per room (fallback if occupancy type isn't explicit)
  bool _pgSecurity = true;

  // Rent/Lease -> Residential -> Independent House/Villa/Independent Floor extras
  final Set<String> _rentVillaOutdoors = <String>{}; // garden_lawn, terrace
  String _rentVillaWaterSource = '';
  bool _rentSolarPower = false;
  bool _rentIndependentEntry = false;

  // Rent/Lease -> Residential -> Builder Floor extras
  bool _rentLiftAvailable = true;
  final _societyName = TextEditingController();
  final Set<String> _rentTenantTypes = <String>{}; // family, bachelor, company

  // Rent/Lease -> Residential -> Studio Apartment extras
  String _studioConfig = ''; // 1rk, studio
  String _kitchenType = ''; // open, closed
  final Set<String> _studioTenantPrefs =
      <String>{}; // student, professional, bachelor

  // Rent/Lease -> Residential -> Farmhouse extras
  final _rentFarmLandArea = TextEditingController();
  final _rentFarmRooms = TextEditingController();
  bool _rentFarmPool = false;
  bool _rentFarmFencing = false;
  final Set<String> _rentFarmUseCases =
      <String>{}; // weekend, events, parties, weddings
  final _farmMonthlyCharges = TextEditingController();
  final _farmDailyCharges = TextEditingController();
  final _farmEventCharges = TextEditingController();
  final _minStayDays = TextEditingController(text: '1');

  // Sell -> Residential -> Independent House / Villa specific
  final Set<String> _villaAdditionalRooms = <String>{};
  bool? _villaCornerProperty;
  bool? _gatedCommunity;
  final Set<String> _villaParking = <String>{}; // open, covered (multi)
  final Set<String> _outdoors = <String>{};
  String _waterSource = '';
  final Set<String> _connections = <String>{};
  bool? _villaPriceNegotiable;
  final _villaMaintenanceCharges = TextEditingController();
  final _villaBookingAmount = TextEditingController();

  // Sell -> Residential -> Builder Floor specific
  bool? _builderCornerProperty;
  bool? _builderGatedSociety;
  bool? _constructionAllowed;
  final Set<String> _builderUtilities = <String>{};
  final _pricePerSqft = TextEditingController();
  bool? _builderNegotiable;

  // Sell -> Residential -> Duplex specific (plot-style details)
  bool? _duplexCornerPlot;
  bool? _duplexGatedCommunity;
  bool? _duplexConstructionAllowed;
  bool? _duplexWaterConnection;
  bool? _duplexElectricityConnection;
  bool? _duplexNegotiable;
  bool? _duplexRoadAccess;
  final Set<String> _duplexNearbyFacilities = <String>{};

  // Sell -> Residential -> Farmhouse specific
  final _farmLandArea = TextEditingController();
  final _farmBuiltUpArea = TextEditingController();
  final Set<String> _farmUtilities = <String>{};
  final _farmRooms = TextEditingController();
  bool? _farmGarden;
  bool? _farmSwimmingPool;
  final _village = TextEditingController();
  final _landmark = TextEditingController();
  final _ownerName = TextEditingController();
  final _ownerPhone = TextEditingController();

  // Lookups
  final Set<int> _selectedAmenityIds = <int>{};
  final Set<int> _selectedFurnishingIds = <int>{};
  final Map<int, int> _furnishingQuantities = <int, int>{};

  // ==================== LOCATION ====================
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _pincode = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  // ==================== MEDIA ====================
  final List<MediaItem> _images = [];
  final List<MediaItem> _videos = [];
  int _primaryImageIndex = 0;

  // Validation
  String? _priceErr,
      _areaErr,
      _descErr,
      _addressErr,
      _cityErr,
      _stateErr,
      _pincodeErr,
      _mediaErr;

  // UI State
  final Map<String, bool> _expandedSections = {
    'basic': true,
    'details': false,
    'pricing': false,
    'amenities': false,
    'furnishings': false,
    'media': false,
    'location': false,
    'description': false,
    'promotion': false,
  };

  // Address autocomplete
  final _addressFocus = FocusNode();
  final _places = GooglePlacesService();
  Timer? _addressDebounce;
  bool _isFetchingAddress = false;
  List<PlacePrediction> _addressPredictions = const [];
  bool _suppressAddressAutocomplete = false;
  bool _didAttemptAutoLocationFill = false;
  bool _didShowPlacesError = false;

  // Static options
  static const _listingTypes = <String>['owner', 'builder', 'agent'];
  static const _areaUnits = <String>['sqft', 'sqm', 'sqyd', 'acre'];
  static const _showroomAreaUnits = <String>['sqft', 'sqyd', 'sqm'];
  static const _facings = <String>[
    'north',
    'south',
    'east',
    'west',
    'north_east',
    'north_west',
    'south_east',
    'south_west',
  ];
  static const _furnishings = <String>[
    'unfurnished',
    'semi-furnished',
    'furnished',
  ];
  static const _commercialTypes = <String>[
    'office',
    'retail',
    'shop',
    'warehouse',
    'showroom',
  ];
  static const _warehouseTypes = <String>[
    'warehouse',
    'factory',
    'industrial_building',
  ];
  static const _truckAccessTypes = <String>['heavy', 'medium', 'small'];
  static const _landTypes = <String>[
    'residential',
    'commercial',
    'agricultural',
    'industrial',
  ];
  static const _agriWaterSources = <String>[
    'municipal',
    'borewell',
    'canal',
    'river',
    'tanker',
    'other',
  ];
  static const _showroomFloorTypes = <String>[
    'ground_floor',
    'mall_floor',
    'high_street',
  ];
  static const _availabilityTypes = <String>[
    'ready_to_move',
    'under_construction',
    'immediate',
    'within_3_months',
  ];
  static const _readyTimeframes = <String>['0_1', '1_5', '5_10', '10_plus'];
  static const _ownershipTypes = <String>[
    'freehold',
    'leasehold',
    'co-operative_society',
    'power_of_attorney',
  ];
  static const _parkingTypes = <String>[
    'none',
    'open',
    'covered',
    'basement',
    'multilevel',
  ];

  // PG / Hostel options
  static const _pgGenderBasedOptions = <String>[
    'boys_pg',
    'girls_pg',
    'co_living',
    'unisex_pg',
  ];
  static const _pgOccupancyTypeOptions = <String>[
    'single_sharing',
    'double_sharing',
    'triple_sharing',
    'four_plus_sharing',
    'dormitory',
  ];
  static const _pgTenantTypeOptions = <String>[
    'students',
    'working_professionals',
    'couples_allowed',
    'family_pg',
    'interns_trainees',
  ];
  static const _pgFoodAvailabilityOptions = <String>[
    'with_food',
    'without_food',
    'veg_only',
    'non_veg_allowed',
    'self_cooking_allowed',
  ];
  static const _pgPropertyTypeOptions = <String>[
    'independent_house_pg',
    'apartment_pg',
    'hostel',
    'co_living_space',
    'service_apartment',
  ];
  static const _pgBathroomTypeOptions = <String>['attached', 'common'];
  static const _pgNearbyPreferenceOptions = <String>[
    'near_metro',
    'near_college',
    'near_office_area',
    'near_market',
    'near_hospital',
  ];
  static const _pgAvailabilityOptions = <String>[
    'immediate',
    'next_month',
    'short_term',
    'long_term',
  ];

  static const _pgResidentialSubcategories = <String>[
    'boys_pg',
    'girls_pg',
    // 'co_living_space',
    'student_pg',
    'working_professional_pg',
    // 'hostel',
    // 'room_sharing_pg',
    'single_room_pg',
    'twin_sharing_pg',
    'triple_sharing_pg',
    'dormitory',
    // 'managed_pg',
    // 'luxury_pg',
  ];

  static const _officeTypes = <String>[
    'bare_shell',
    'warm_shell',
    'fully_furnished',
    'semi_furnished',
    'plug_and_play',
    'customizable',
    'co_working',
    'private',
    'managed',
    'virtual',
    'corporate',
  ];

  static const _shopTypes = <String>['retail', 'mall', 'high_street'];
  static const _floorTypes = <String>[
    'ground',
    'basement',
    'upper',
    'mall_floor',
  ];

  static const _apartmentAdditionalRooms = <String>[
    'servant_room',
    'pooja_room',
    'study_room',
    'store_room',
  ];

  static const _apartmentHighlights = <String>[
    'Near Metro',
    'Prime Location',
    'Gated Society',
    'Park Facing',
    'Clubhouse',
    'Near Market',
    'Near School',
    'Near Hospital',
  ];

  static const _promotionOptions = <String>['featured', 'premium', 'urgent'];

  static const _villaParkingOptions = <String>['open', 'covered'];
  static const _outdoorsOptions = <String>[
    'garden_lawn',
    'terrace',
    'boundary_wall',
  ];
  static const _waterSourceOptions = <String>[
    'municipal',
    'borewell',
    'tanker',
    'other',
  ];
  static const _connectionOptions = <String>[
    'electricity_connection',
    'solar_power',
    'rainwater_harvesting',
  ];

  static const _builderUtilitiesOptions = <String>[
    'water',
    'electricity',
    'sewerage',
    'road_access',
  ];

  static const _nearbyFacilitiesOptions = <String>[
    'metro',
    'bus_stop',
    'market',
    'school',
    'hospital',
    'park',
    'mall',
    'highway',
  ];

  static const _farmUtilitiesOptions = <String>[
    'water_source',
    'borewell',
    'road_access',
    'fencing',
  ];

  static const _villaOutdoorsOptions = <String>['garden_lawn', 'terrace'];

  static const _roomOptions = <String>[
    'servant_room',
    'pooja_room',
    'study_room',
    'store_room',
  ];

  static const _preferredTenants = <String>[
    'family',
    'bachelor_male',
    'bachelor_female',
    'company_lease',
    'anyone',
  ];
  static const _tenantTypeOptions = <String>['family', 'bachelor', 'company'];
  static const _studioTenantOptions = <String>[
    'student',
    'professional',
    'bachelor',
  ];
  static const _kitchenTypes = <String>['open', 'closed'];
  static const _farmUseCaseOptions = <String>[
    'weekend',
    'events',
    'parties',
    'weddings',
  ];

  static const _foodPreferences = <String>['veg', 'non_veg', 'any'];
  static const _noticeUnits = <String>['days', 'months'];
  static const _rentPromotionOptions = <String>[
    'featured',
    'urgent',
    'homepage_boost',
  ];

  String get _parentKind {
    final s = (_selectedParentCategorySlug ?? '').trim().toLowerCase();
    if (s == 'commercial') return 'commercial';
    if (s == 'land-plot') return 'land-plot';
    if (s == 'residential') return 'residential';
    // fallback: infer by substring to keep UI working even if backend slugs vary
    if (s.contains('commercial')) return 'commercial';
    if (s.contains('land') || s.contains('plot')) return 'land-plot';
    if (s.contains('residential')) return 'residential';
    return s;
  }

  bool get _isResidential => _parentKind == 'residential';

  bool get _isCommercialContext {
    // If parent is Land/Plot, never treat it as Commercial even if child slug
    // contains "commercial-plot".
    if (_parentKind == 'land-plot') return false;
    if (_parentKind == 'commercial') return true;
    final child = (_selectedCategorySlug ?? '').toLowerCase();
    // Fallback: infer commercial from selected leaf type.
    return child.contains('office') ||
        child.contains('retail') ||
        child.contains('shop') ||
        child.contains('showroom') ||
        child.contains('warehouse') ||
        child.contains('storage') ||
        child.contains('industry') ||
        child.contains('industrial') ||
        child.contains('hospitality') ||
        child.contains('commercial');
  }

  bool get _isLandPlotContext {
    if (_parentKind == 'land-plot') return true;
    final child = (_selectedCategorySlug ?? '').toLowerCase();
    return child.contains('plot') || child.contains('land');
  }

  String _normalizeParentSlug({required String rawSlug, required String name}) {
    final s = rawSlug.trim().toLowerCase();
    final n = name.trim().toLowerCase();
    final looksCommercial =
        s == 'commercial' ||
        s.contains('commercial') ||
        n.contains('commercial') ||
        n.contains('office') ||
        n.contains('retail') ||
        n.contains('shop') ||
        n.contains('showroom') ||
        n.contains('warehouse') ||
        n.contains('storage') ||
        n.contains('industry') ||
        n.contains('industrial') ||
        n.contains('hospitality');
    if (looksCommercial) return 'commercial';
    if (s == 'land-plot' ||
        s.contains('land') ||
        s.contains('plot') ||
        n.contains('land') ||
        n.contains('plot')) {
      return 'land-plot';
    }
    if (s == 'residential' || n.contains('residential')) return 'residential';
    return s;
  }

  bool get _isSellResidentialApartment {
    if (_propertyKind != _CreatePropertyKind.sale) return false;
    if (!_isResidential) return false;
    final slug = (_selectedCategorySlug ?? '').toLowerCase();
    return slug.contains('apartment') || slug.contains('flat');
  }

  bool get _isRentLeaseResidentialApartment {
    final isRentLease =
        _propertyKind == _CreatePropertyKind.rent ||
        _propertyKind == _CreatePropertyKind.lease;
    if (!isRentLease) return false;
    if (!_isResidential) return false;
    final slug = (_selectedCategorySlug ?? '').toLowerCase();
    return slug.contains('apartment') || slug.contains('flat');
  }

  bool get _isRentLeaseResidentialVillaHouse {
    final isRentLease =
        _propertyKind == _CreatePropertyKind.rent ||
        _propertyKind == _CreatePropertyKind.lease;
    if (!isRentLease) return false;
    if (!_isResidential) return false;
    final slug = (_selectedCategorySlug ?? '').toLowerCase();
    if (slug.contains('floor') || slug.contains('builder')) return false;
    if (slug.contains('farm') || slug.contains('farmhouse')) return false;
    return slug.contains('villa') ||
        slug.contains('independent') ||
        slug.contains('house');
  }

  String get _rentLeaseHouseVillaTitle {
    final slug = (_selectedCategorySlug ?? '').toLowerCase();
    if (slug.contains('farm')) return 'Farmhouse Details';
    if (slug.contains('independent-floor') ||
        slug.contains('independent_floor') ||
        slug.contains('independentfloor')) {
      return 'Independent Floor Details';
    }
    if (slug.contains('villa')) return 'Villa Details';
    return 'Independent House Details';
  }

  bool get _isRentLeaseResidentialBuilderFloor {
    final isRentLease =
        _propertyKind == _CreatePropertyKind.rent ||
        _propertyKind == _CreatePropertyKind.lease;
    if (!isRentLease) return false;
    if (!_isResidential) return false;
    final slug = (_selectedCategorySlug ?? '').toLowerCase();
    return slug.contains('builder') || slug.contains('floor');
  }

  bool get _isRentLeaseResidentialStudioApartment {
    final isRentLease =
        _propertyKind == _CreatePropertyKind.rent ||
        _propertyKind == _CreatePropertyKind.lease;
    if (!isRentLease) return false;
    if (!_isResidential) return false;
    final slug = (_selectedCategorySlug ?? '').toLowerCase();
    return slug.contains('studio') ||
        slug.contains('1rk') ||
        slug.contains('1_rk') ||
        slug.contains('rk');
  }

  bool get _isRentLeaseResidentialFarmhouse {
    final isRentLease =
        _propertyKind == _CreatePropertyKind.rent ||
        _propertyKind == _CreatePropertyKind.lease;
    if (!isRentLease) return false;
    if (!_isResidential) return false;
    final slug = (_selectedCategorySlug ?? '').toLowerCase();
    return slug.contains('farm') || slug.contains('farmhouse');
  }

  bool get _isRentLeaseResidentialDuplex {
    final isRentLease =
        _propertyKind == _CreatePropertyKind.rent ||
        _propertyKind == _CreatePropertyKind.lease;
    if (!isRentLease) return false;
    if (!_isResidential) return false;
    final slug = (_selectedCategorySlug ?? '').toLowerCase();
    return slug.contains('duplex');
  }

  bool get _isSellResidentialVillaHouse {
    if (_propertyKind != _CreatePropertyKind.sale) return false;
    if (!_isResidential) return false;
    final slug = (_selectedCategorySlug ?? '').toLowerCase();
    if (slug.contains('floor') || slug.contains('builder')) return false;
    if (slug.contains('farm') || slug.contains('farmhouse')) return false;
    return slug.contains('villa') ||
        slug.contains('independent') ||
        slug.contains('house');
  }

  bool get _isSellResidentialBuilderFloor {
    if (_propertyKind != _CreatePropertyKind.sale) return false;
    if (!_isResidential) return false;
    final slug = (_selectedCategorySlug ?? '').toLowerCase();
    return slug.contains('builder') || slug.contains('floor');
  }

  bool get _isSellResidentialDuplex {
    if (_propertyKind != _CreatePropertyKind.sale) return false;
    if (!_isResidential) return false;
    final slug = (_selectedCategorySlug ?? '').toLowerCase();
    return slug.contains('duplex');
  }

  bool get _isSellResidentialFarmhouse {
    if (_propertyKind != _CreatePropertyKind.sale) return false;
    if (!_isResidential) return false;
    final slug = (_selectedCategorySlug ?? '').toLowerCase();
    return slug.contains('farm') || slug.contains('farmhouse');
  }

  bool get _segmentLockedToResidential =>
      _propertyKind == _CreatePropertyKind.pg ||
      _propertyKind == _CreatePropertyKind.coLiving;

  void _syncDetailsFromSelectedCategorySlugs() {
    final parentSlug = _parentKind;
    final childSlug = (_selectedCategorySlug ?? '').trim().toLowerCase();
    final slug = childSlug.isNotEmpty ? childSlug : parentSlug;

    if (parentSlug == 'commercial') {
      if (_commercialTypes.contains(slug)) {
        _commercialType = slug;
      } else if (slug.contains('office')) {
        _commercialType = 'office';
      } else if (slug.contains('warehouse')) {
        _commercialType = 'warehouse';
      } else if (slug.contains('showroom')) {
        _commercialType = 'showroom';
      } else if (slug.contains('shop')) {
        _commercialType = 'shop';
      } else if (slug.contains('retail')) {
        _commercialType = 'retail';
      }
    }

    if (parentSlug == 'land-plot') {
      if (_landTypes.contains(slug)) {
        _landType = slug;
      } else if (slug.contains('agri')) {
        _landType = 'agricultural';
      } else if (slug.contains('industrial')) {
        _landType = 'industrial';
      } else if (slug.contains('commercial')) {
        _landType = 'commercial';
      } else if (slug.contains('residential')) {
        _landType = 'residential';
      }
    }
  }

  void _syncTypeAndResetInvalidCategorySelection() {
    final kind = _propertyKind;
    if (kind == null) return;
    if (kind == _CreatePropertyKind.sale) {
      _type = PropertyType.sale;
    } else if (kind == _CreatePropertyKind.lease) {
      _type = PropertyType.lease;
    } else {
      _type = PropertyType.rent;
    }

    if (_segmentLockedToResidential) {
      final parentSlug = (_selectedParentCategorySlug ?? '').trim();
      if (parentSlug == 'commercial' ||
          parentSlug == 'land-plot' ||
          parentSlug == 'agriculture' ||
          parentSlug == 'agricultural') {
        _selectedParentCategoryId = null;
        _selectedCategoryId = null;
        _selectedParentCategorySlug = null;
        _selectedCategorySlug = null;
      }
    }
  }

  // Tracks whether we have already resolved category IDs from the loaded
  // categories list in edit mode. Reset to false whenever initialProperty
  // changes so a hot-reload or widget update re-resolves correctly.
  bool _categoryResolved = false;

  @override
  void initState() {
    super.initState();
    _totalFloors.addListener(_handleTotalFloorsChanged);

    // Edit mode: prefill from the existing property and avoid draft/autofill
    // overwriting server values.
    if (widget.initialProperty != null) {
      _prefillFromProperty(widget.initialProperty!);
      // If the property doesn't have location fields, try autofill.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final hasLatLng =
            _latitudeController.text.trim().isNotEmpty &&
            _longitudeController.text.trim().isNotEmpty;
        final hasAddress =
            _address.text.trim().isNotEmpty &&
            _city.text.trim().isNotEmpty &&
            _state.text.trim().isNotEmpty &&
            _pincode.text.trim().isNotEmpty;
        if (!hasLatLng || !hasAddress) _autoFillLocation();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _autoFillLocation();
      });
      _attachDraftListeners();
      if (widget.autoRestoreDraft) _loadDraft();
    }

    _addressFocus.addListener(_onAddressFocusChange);
  }

  /// Called from build() once categories are loaded in edit mode.
  /// Walks the category tree to find the parent and child that match
  /// [_selectedCategoryId], then sets all four slug/id fields and triggers
  /// a rebuild so the selector shows the correct selection.
  void _resolveCategoryFromList(List<Category> cats) {
    if (_categoryResolved) return;
    final targetId = _selectedCategoryId;
    if (targetId == null) return;

    // Flatten: find which parent contains this child id, or if the id IS a
    // parent (leaf parent with no children).
    for (final parent in cats) {
      // The target is the parent itself (no children / leaf parent).
      if (parent.id == targetId) {
        _categoryResolved = true;
        setState(() {
          _selectedParentCategoryId = parent.id;
          _selectedParentCategorySlug = _normalizeParentSlug(
            rawSlug: parent.slug,
            name: parent.name,
          );
          _selectedCategoryId = parent.id;
          if (_propertyKind == _CreatePropertyKind.pg ||
              _propertyKind == _CreatePropertyKind.coLiving) {
            _selectedCategorySlug = _pgGenderBased.isNotEmpty
                ? _pgGenderBased
                : parent.slug;
          } else {
            _selectedCategorySlug = parent.slug;
          }
          _syncDetailsFromSelectedCategorySlugs();
        });
        return;
      }
      // Search children.
      for (final child in parent.children) {
        if (child.id == targetId) {
          _categoryResolved = true;
          setState(() {
            _selectedParentCategoryId = parent.id;
            _selectedParentCategorySlug = _normalizeParentSlug(
              rawSlug: parent.slug,
              name: parent.name,
            );
            _selectedCategoryId = child.id;
            if (_propertyKind == _CreatePropertyKind.pg ||
                _propertyKind == _CreatePropertyKind.coLiving) {
              _selectedCategorySlug = _pgGenderBased.isNotEmpty
                  ? _pgGenderBased
                  : child.slug;
            } else {
              _selectedCategorySlug = child.slug;
            }
            _syncDetailsFromSelectedCategorySlugs();
          });
          return;
        }
        // Support one more level of nesting (grandchildren).
        for (final grandchild in child.children) {
          if (grandchild.id == targetId) {
            _categoryResolved = true;
            setState(() {
              _selectedParentCategoryId = parent.id;
              _selectedParentCategorySlug = _normalizeParentSlug(
                rawSlug: parent.slug,
                name: parent.name,
              );
              _selectedCategoryId = grandchild.id;
              if (_propertyKind == _CreatePropertyKind.pg ||
                  _propertyKind == _CreatePropertyKind.coLiving) {
                _selectedCategorySlug = _pgGenderBased.isNotEmpty
                    ? _pgGenderBased
                    : grandchild.slug;
              } else {
                _selectedCategorySlug = grandchild.slug;
              }
              _syncDetailsFromSelectedCategorySlugs();
            });
            return;
          }
        }
      }
    }
  }

  void _onAddressFocusChange() {
    if (!_addressFocus.hasFocus) {
      setState(() => _addressPredictions = const []);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers used only inside _prefillFromProperty
  // ---------------------------------------------------------------------------

  /// Read a string from [f] (the raw apiFields map). Returns null when absent
  /// or blank.
  String? _f(Map<String, dynamic> f, List<String> keys) {
    for (final k in keys) {
      final v = f[k];
      if (v != null) {
        final s = v.toString().trim();
        if (s.isNotEmpty) return s;
      }
    }
    return null;
  }

  bool _fb(Map<String, dynamic> f, List<String> keys, {bool fallback = false}) {
    for (final k in keys) {
      final v = f[k];
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final s = v.trim().toLowerCase();
        if (s == 'true' || s == '1') return true;
        if (s == 'false' || s == '0') return false;
      }
    }
    return fallback;
  }

  bool? _fbNullable(Map<String, dynamic> f, List<String> keys) {
    for (final k in keys) {
      final v = f[k];
      if (v == null) continue;
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final s = v.trim().toLowerCase();
        if (s == 'true' || s == '1' || s == 'yes' || s == 'available')
          return true;
        if (s == 'false' || s == '0' || s == 'no' || s == 'not_available')
          return false;
      }
    }
    return null;
  }

  bool? _fbNullableInverted(Map<String, dynamic> f, List<String> keys) {
    for (final k in keys) {
      final v = f[k];
      if (v == null) continue;
      if (v is bool) return v;
      if (v is num) return v == 0;
      if (v is String) {
        final s = v.trim().toLowerCase();
        if (s == 'true' || s == '0' || s == 'yes') return true;
        if (s == 'false' || s == '1' || s == 'no') return false;
      }
    }
    return null;
  }

  int? _fi(Map<String, dynamic> f, List<String> keys) {
    for (final k in keys) {
      final v = f[k];
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v.trim());
    }
    return null;
  }

  double? _fd(Map<String, dynamic> f, List<String> keys) {
    for (final k in keys) {
      final v = f[k];
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v.trim());
    }
    return null;
  }

  List<String> _fl(Map<String, dynamic> f, List<String> keys) {
    for (final k in keys) {
      final v = f[k];
      if (v == null) continue;
      if (v is List) {
        return v
            .map((e) => e.toString().trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }
      if (v is String) {
        final s = v.trim();
        if (s.isEmpty) continue;
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
    }
    return const [];
  }

  // ---------------------------------------------------------------------------

  void _prefillFromProperty(Property p) {
    if (kDebugMode) {
      debugPrint(
        '[PropertyEdit] Prefilling from property id=${p.id} name="${p.name}"',
      );
      debugPrint('[PropertyEdit] apiFields keys=${p.apiFields?.keys.toList()}');
      debugPrint(
        '[PropertyEdit] categoryId=${p.categoryId}, type=${p.type}, kind=${p.propertyKind}',
      );
    }
    // ── 1. Basic fields from the typed Property model ──────────────────────
    _title.text = p.name;
    _description.text = p.description;
    _price.text = p.price.toStringAsFixed(0);
    _area.text = p.area?.toString() ?? '';
    _areaUnit = (p.areaUnit?.trim().isNotEmpty ?? false)
        ? p.areaUnit!.trim()
        : _areaUnit;
    _type = p.type;
    _listingType = (p.listingType?.trim().isNotEmpty ?? false)
        ? p.listingType!.trim()
        : _listingType;

    _bedrooms = p.bedrooms ?? _bedrooms;
    _bathrooms = p.bathrooms ?? _bathrooms;
    _parking = p.parking ?? _parking;
    _furnishing = (p.furnishing?.trim().isNotEmpty ?? false)
        ? p.furnishing!.trim()
        : _furnishing;
    _facing = (p.facing?.trim().isNotEmpty ?? false)
        ? p.facing!.trim()
        : _facing;
    _floor.text = p.floor?.toString() ?? '';
    _totalFloors.text = p.totalFloors?.toString() ?? '';

    _address.text = p.address ?? '';
    _city.text = p.city ?? '';
    _state.text = p.state ?? '';
    _pincode.text = p.pincode ?? '';
    _latitudeController.text = p.latitude?.toString() ?? '';
    _longitudeController.text = p.longitude?.toString() ?? '';

    // The raw API JSON is stored in apiFields. Use it to restore every field.
    final f = Map<String, dynamic>.from(
      p.apiFields ?? const <String, dynamic>{},
    );

    // ── 2. Category / kind — restore so the correct section is shown ────────
    final isFarmhouse =
        f.containsKey('farm_land_area') ||
        f.containsKey('farm_land_area_rent') ||
        f.containsKey('farm_built_up_area') ||
        f.containsKey('farm_rooms') ||
        f.containsKey('farm_rooms_rent') ||
        f.containsKey('farm_monthly_charges') ||
        f.containsKey('farm_daily_charges') ||
        f.containsKey('farm_event_charges');

    if (isFarmhouse) {
      _selectedCategoryId = -9999;
      _selectedCategorySlug = 'farmhouse';
      _categoryResolved = true;
      _selectedParentCategoryId = 1;
      _selectedParentCategorySlug = 'residential';
    } else {
      final catId = int.tryParse((p.categoryId ?? '').toString());
      if (catId != null) _selectedCategoryId = catId;
    }

    _plotArea.text = _fd(f, ['plot_area'])?.toString() ?? '';
    _selectedAmenityIds
      ..clear()
      ..addAll(p.amenityIds ?? const []);
    _maintenanceCharges.text =
        _fd(f, ['maintenance_charges'])?.toString() ?? '';
    final pg = Map<String, dynamic>.from(
      f['pg_details'] is Map
          ? f['pg_details'] as Map
          : const <String, dynamic>{},
    );
    final office = Map<String, dynamic>.from(
      f['office_details'] is Map
          ? f['office_details'] as Map
          : const <String, dynamic>{},
    );
    final shop = Map<String, dynamic>.from(
      f['shop_details'] is Map
          ? f['shop_details'] as Map
          : const <String, dynamic>{},
    );
    final showroom = Map<String, dynamic>.from(
      f['showroom_details'] is Map
          ? f['showroom_details'] as Map
          : const <String, dynamic>{},
    );
    final warehouse = Map<String, dynamic>.from(
      f['warehouse_details'] is Map
          ? f['warehouse_details'] as Map
          : const <String, dynamic>{},
    );
    final plot = Map<String, dynamic>.from(
      f['plot_details'] is Map
          ? f['plot_details'] as Map
          : const <String, dynamic>{},
    );
    // ───────────── PG PREFILL ─────────────

    _pgGenderBased =
        _f(f, ['pg_gender_based']) ?? _f(pg, ['gender_based']) ?? '';

    _pgOccupancyType =
        _f(f, ['pg_occupancy_type']) ?? _f(pg, ['occupancy_type']) ?? '';

    _pgFoodAvailability =
        _f(f, ['pg_food_availability']) ?? _f(pg, ['food_available']) ?? '';

    _pgPropertyType =
        _f(f, ['pg_property_type']) ?? _f(pg, ['property_type']) ?? '';

    _pgBathroomType =
        _f(f, ['pg_bathroom_type']) ?? _f(pg, ['bathroom_type']) ?? '';

    _pgSuitableFor =
        _f(f, ['pg_suitable_for']) ?? _f(pg, ['suitable_for']) ?? '';

    _pgRoomType = _f(f, ['pg_room_type']) ?? _f(pg, ['room_type']) ?? '';

    _pgBedType = _f(f, ['pg_bed_type']) ?? _f(pg, ['bed_type']) ?? '';

    _pgAvailability =
        _f(f, ['pg_availability']) ?? _f(pg, ['availability_status']) ?? '';

    _pgBuildingName.text =
        _f(f, ['pg_building_name']) ?? _f(pg, ['building_name']) ?? '';

    _pgCurfewTime.text =
        _f(f, ['pg_curfew_time']) ?? _f(pg, ['curfew_time']) ?? '';

    _pgRoomSize.text = _f(f, ['pg_room_size']) ?? _f(pg, ['room_size']) ?? '';

    _pgTotalBeds.text =
        _fi(f, ['pg_total_beds'])?.toString() ??
        _fi(pg, ['total_beds'])?.toString() ??
        '';

    _pgAvailableBeds.text =
        _fi(f, ['pg_available_beds'])?.toString() ??
        _fi(pg, ['available_beds'])?.toString() ??
        '';

    _pgSecurityDeposit.text =
        _fd(f, ['pg_security_deposit'])?.toString() ??
        _fd(pg, ['security_deposit'])?.toString() ??
        '';

    _pgMaintenanceCharges.text =
        _fd(f, ['pg_maintenance_charges'])?.toString() ??
        _fd(pg, ['maintenance_charges'])?.toString() ??
        '';

    _pgAvailableFrom.text =
        _f(f, ['pg_available_from']) ?? _f(pg, ['available_from']) ?? '';

    _pgMinStayDays.text =
        _fi(f, ['pg_min_stay_days'])?.toString() ??
        _fi(pg, ['min_stay_days'])?.toString() ??
        '';

    _pgNoticePeriodDays.text =
        _fi(f, ['pg_notice_period_days'])?.toString() ??
        _fi(pg, ['notice_period_days'])?.toString() ??
        '';

    _pgPreferredTenantAge.text =
        _fi(f, ['pg_preferred_tenant_age'])?.toString() ??
        _fi(pg, ['preferred_tenant_age'])?.toString() ??
        '';

    _pgSharing = _fi(f, ['pg_sharing']) ?? _fi(pg, ['pg_sharing']) ?? 0;

    _pgAttachedBathroom =
        _fb(f, ['pg_attached_bathroom']) || _fb(pg, ['attached_bathroom']);

    _pgBalcony = _fb(f, ['pg_balcony']) || _fb(pg, ['balcony']);

    _pgCupboardAvailable =
        _fb(f, ['pg_cupboard_available']) || _fb(pg, ['cupboard_available']);

    _pgStudyTableAvailable =
        _fb(f, ['pg_study_table_available']) ||
        _fb(pg, ['study_table_available']);

    _pgElectricityIncluded =
        _fb(f, ['pg_electricity_included']) ||
        _fb(pg, ['electricity_included']);

    _pgWaterIncluded =
        _fb(f, ['pg_water_included']) || _fb(pg, ['water_included']);

    _pgFoodChargesIncluded =
        _fb(f, ['pg_food_charges_included']) ||
        _fb(pg, ['food_charges_included']);

    _pgBrokerageRequired =
        _fb(f, ['pg_brokerage_required']) || _fb(pg, ['brokerage_required']);

    _pgCoupleFriendly =
        _fb(f, ['pg_couple_friendly']) || _fb(pg, ['couple_friendly']);

    _pgIdProofRequired =
        _fb(f, ['pg_id_proof_required']) || _fb(pg, ['id_proof_required']);

    _pgSmokingAllowed =
        _fb(f, ['pg_smoking_allowed']) || _fb(pg, ['smoking_allowed']);

    _pgDrinkingAllowed =
        _fb(f, ['pg_drinking_allowed']) || _fb(pg, ['drinking_allowed']);

    _pgPetsAllowed = _fb(f, ['pg_pets_allowed']) || _fb(pg, ['pets_allowed']);

    _pgVisitorsAllowed =
        _fb(f, ['pg_visitors_allowed']) || _fb(pg, ['visitors_allowed']);

    _pgGateLockedAtNight =
        _fb(f, ['pg_gate_locked_at_night']) ||
        _fb(pg, ['gate_locked_at_night']);

    _pgSecurity = _fb(f, ['pg_security']) || _fb(pg, ['pg_security']);

    _pgTenantTypes
      ..clear()
      ..addAll(
        _fl(f, ['pg_tenant_types']).isNotEmpty
            ? _fl(f, ['pg_tenant_types'])
            : _fl(pg, ['tenant_types']),
      );

    _pgNearbyPreferences
      ..clear()
      ..addAll(
        _fl(f, ['pg_nearby_preferences']).isNotEmpty
            ? _fl(f, ['pg_nearby_preferences'])
            : _fl(pg, ['nearby_preferences']),
      );

    // ───────────── END PG PREFILL ─────────────
    // Derive _propertyKind from property type + property_kind field.
    final rawKind = _f(f, ['property_kind', 'propertyKind']) ?? '';
    if (rawKind == 'pg' || rawKind == 'co_living' || rawKind == 'coliving') {
      _propertyKind = rawKind.contains('co')
          ? _CreatePropertyKind.coLiving
          : _CreatePropertyKind.pg;
    } else {
      switch (p.type) {
        case PropertyType.sale:
          _propertyKind = _CreatePropertyKind.sale;
          break;
        case PropertyType.rent:
          final lt = (p.listingType ?? '').toLowerCase();
          if (lt == 'pg' || lt == 'co_living') {
            _propertyKind = _CreatePropertyKind.pg;
          } else {
            _propertyKind = _CreatePropertyKind.rent;
          }
          break;
        case PropertyType.lease:
          final lt = (p.listingType ?? '').toLowerCase();
          if (lt == 'pg' || lt == 'co_living') {
            _propertyKind = _CreatePropertyKind.pg;
          } else {
            _propertyKind = _CreatePropertyKind.lease;
          }
          break;
      }
    }

    // ── 3. Amenities & furnishings ──────────────────────────────────────────
    _selectedAmenityIds
      ..clear()
      ..addAll(p.amenityIds ?? const <int>[]);

    _selectedFurnishingIds.clear();
    _furnishingQuantities.clear();
    for (final sel in p.furnishingSelections ?? const []) {
      _selectedFurnishingIds.add(sel.id);
      _furnishingQuantities[sel.id] = sel.quantity;
    }

    // ── 4. Media ────────────────────────────────────────────────────────────
    _images
      ..clear()
      ..addAll([
        for (var i = 0; i < p.images.length; i++)
          MediaItem(
            path: p.images[i],
            type: MediaType.image,
            tag: _getDefaultTagForIndex(i),
          ),
      ]);
    _primaryImageIndex = (p.primaryImageIndex ?? 0).clamp(
      0,
      _images.isEmpty ? 0 : _images.length - 1,
    );

    // Videos stored as network URLs.
    _videos
      ..clear()
      ..addAll(
        p.videos.map((v) => MediaItem(path: v.url, type: MediaType.video)),
      );

    // ── 5. Common detail fields from apiFields ──────────────────────────────
    _carpetArea.text = _fd(f, ['carpet_area'])?.toString() ?? '';
    _builtUpArea.text =
        p.builtUpArea?.toString() ??
        _fd(f, ['built_up_area'])?.toString() ??
        '';
    _superBuiltUpArea.text = _fd(f, ['super_built_up_area'])?.toString() ?? '';
    final _plot = Map<String, dynamic>.from((f['plot_details'] as Map?) ?? {});
    _plotArea.text =
        p.plotArea?.toString() ??
        _fd(f, ['plot_area'])?.toString() ??
        _fd(_plot, ['plot_area'])?.toString() ??
        '';
    _length.text =
        p.plotLength?.toString() ??
        _fd(f, ['plot_length_ft', 'plot_length'])?.toString() ??
        _fd(_plot, ['plot_length', 'plot_length_ft'])?.toString() ??
        '';
    _breadth.text =
        p.plotBreadth?.toString() ??
        _fd(f, ['plot_breadth_ft', 'plot_breadth', 'plot_width'])?.toString() ??
        _fd(_plot, [
          'plot_breadth',
          'plot_breadth_ft',
          'plot_width',
        ])?.toString() ??
        '';
    _floorsAllowed.text = _fi(f, ['floors_allowed'])?.toString() ?? '';
    _openSides = _fi(f, ['open_sides']) ?? _openSides;
    _boundaryWall = _fb(f, ['boundary_wall']);
    _constructionDone = _fb(f, ['construction_done']);
    final rawAvail =
        p.availability ??
        _f(f, ['availability', 'possession_status', 'possessionStatus']);
    if (rawAvail != null && rawAvail.trim().isNotEmpty) {
      final normalized = rawAvail.trim().toLowerCase().replaceAll('-', '_');
      if (normalized == 'ready') {
        _availability = 'ready_to_move';
      } else {
        _availability = normalized;
      }
    }
    final rawAge = _f(f, [
      'ready_timeframe',
      'property_age',
      'property_age_years',
      'property_age_range',
    ]);
    if (rawAge != null) {
      final s = rawAge.trim().toLowerCase().replaceAll('-', '_');
      if (s == '0_1' || s == '1_5' || s == '5_10' || s == '10_plus') {
        _readyTimeframe = s;
      } else {
        final years = int.tryParse(s) ?? double.tryParse(s)?.toInt();
        if (years != null) {
          if (years <= 1) {
            _readyTimeframe = '0_1';
          } else if (years <= 5) {
            _readyTimeframe = '1_5';
          } else if (years <= 10) {
            _readyTimeframe = '5_10';
          } else {
            _readyTimeframe = '10_plus';
          }
        }
      }
    }
    _possessionBy.text = p.possessionBy ?? _f(f, ['possession_by']) ?? '';
    final rawOwner = p.ownership ?? _f(f, ['ownership']);
    if (rawOwner != null && rawOwner.trim().isNotEmpty) {
      _ownership = rawOwner.trim().toLowerCase().replaceAll('-', '_');
    }
    _balconies = p.balconies ?? _fi(f, ['balconies']) ?? _balconies;
    _ownerName.text = _f(f, ['owner_name']) ?? '';
    _ownerPhone.text = _f(f, ['owner_mobile', 'owner_phone']) ?? '';

    // ── 6. Commercial fields ────────────────────────────────────────────────
    _commercialType = _f(f, ['commercial_type']) ?? _commercialType;
    _floorPlateArea.text =
        (_fd(f, ['floor_plate_area']) ?? _fd(office, ['floor_plate_area']))
            ?.toString() ??
        '';
    _cabins.text =
        (_fi(f, ['cabins']) ?? _fi(office, ['cabins']))?.toString() ?? '';
    _meetingRooms.text =
        (_fi(f, ['meeting_rooms']) ?? _fi(office, ['meeting_rooms']))
            ?.toString() ??
        '';
    _seats.text =
        (_fi(f, ['seats']) ?? _fi(office, ['seats']))?.toString() ?? '';
    _maxSeats.text =
        (_fi(f, ['max_seats']) ?? _fi(office, ['max_seats']))?.toString() ?? '';
    _conferenceRooms.text =
        (_fi(f, ['conference_rooms']) ?? _fi(office, ['conference_rooms']))
            ?.toString() ??
        '';
    _liftAvailable = _fb(f, [
      'lift_available',
      'goods_lift',
    ], fallback: _fb(office, ['lift_available', 'goods_lift'], fallback: true));
    _preLeased = _fb(f, ['pre_leased'], fallback: _fb(office, ['pre_leased']));
    _officeType =
        _f(f, ['office_type']) ?? _f(office, ['office_type']) ?? _officeType;
    _receptionArea = _fb(f, [
      'reception_area',
    ], fallback: _fb(office, ['reception_area']));
    _pantry = _fb(f, ['pantry'], fallback: _fb(office, ['pantry']));
    _cafeteria = _fb(f, ['cafeteria'], fallback: _fb(office, ['cafeteria']));
    _serverRoom = _fb(f, [
      'server_room',
    ], fallback: _fb(office, ['server_room']));
    _fireSafetyInstalled = _fb(f, [
      'fire_safety_installed',
    ], fallback: _fb(office, ['fire_safety_installed']));
    _centralAC = _fb(f, ['central_ac'], fallback: _fb(office, ['central_ac']));
    _visitorParking = _fb(f, [
      'visitor_parking',
      'commercial_parking',
    ], fallback: _fb(office, ['visitor_parking', 'commercial_parking']));
    _numberOfLifts.text =
        (_fi(f, ['number_of_lifts']) ?? _fi(office, ['number_of_lifts']))
            ?.toString() ??
        '';
    _taxIncluded = _fb(f, [
      'tax_included',
    ], fallback: _fb(office, ['tax_included']));
    _officeNegotiable =
        p.priceNegotiable ??
        _fbNullable(f, ['price_negotiable_office', 'negotiable']) ??
        _fbNullable(office, ['price_negotiable_office', 'negotiable']);
    _officeMaintenanceCharges.text =
        (_fd(f, [
                  'office_maintenance_charges',
                  'maintenance_charges_office',
                  'maintenance_charges',
                ]) ??
                _fd(office, [
                  'office_maintenance_charges',
                  'maintenance_charges_office',
                  'maintenance_charges',
                ]))
            ?.toString() ??
        '';
    _officeBookingAmount.text =
        p.bookingAmount?.toString() ??
        (_fd(f, [
                  'office_booking_amount',
                  'booking_amount_office',
                  'booking_amount',
                ]) ??
                _fd(office, [
                  'office_booking_amount',
                  'booking_amount_office',
                  'booking_amount',
                ]))
            ?.toString() ??
        '';

    // Shop
    _shopType = _f(f, ['shop_type']) ?? _f(shop, ['shop_type']) ?? _shopType;
    _shopArea.text =
        (_fd(f, ['shop_area']) ?? _fd(shop, ['shop_area']))?.toString() ?? '';
    _shopAreaUnit =
        _f(f, ['shop_area_unit']) ??
        _f(shop, ['shop_area_unit']) ??
        _shopAreaUnit;
    _frontageWidth.text =
        (_fd(f, ['frontage_width_ft', 'frontage_width']) ??
                _fd(shop, ['frontage_width_ft', 'frontage_width']))
            ?.toString() ??
        '';
    _ceilingHeight.text =
        (_fd(f, ['ceiling_height_ft', 'ceiling_height']) ??
                _fd(shop, ['ceiling_height_ft', 'ceiling_height']))
            ?.toString() ??
        '';
    _mainRoadFacing = _fb(f, [
      'main_road_facing',
    ], fallback: _fb(shop, ['main_road_facing']));
    _cornerShop =
        p.cornerShop ??
        _fb(f, ['corner_shop'], fallback: _fb(shop, ['corner_shop']));
    _washroomAvailable = _fb(f, [
      'washroom_available',
    ], fallback: _fb(shop, ['washroom_available']));
    _floorType =
        _f(f, ['floor_type']) ?? _f(shop, ['floor_type']) ?? _floorType;
    _marketName.text =
        _f(f, ['market_name']) ?? _f(shop, ['market_name']) ?? '';
    _locality.text = _f(f, ['locality']) ?? _f(shop, ['locality']) ?? '';

    // Showroom
    _showroomArea.text =
        (_fd(f, ['showroom_area']) ?? _fd(showroom, ['showroom_area']))
            ?.toString() ??
        '';
    _showroomAreaUnit =
        _f(f, ['showroom_area_unit']) ??
        _f(showroom, ['showroom_area_unit']) ??
        _showroomAreaUnit;
    _showroomFrontageWidth.text =
        (_fd(f, ['showroom_frontage_width_ft']) ??
                _fd(showroom, ['showroom_frontage_width_ft']))
            ?.toString() ??
        '';
    _showroomCeilingHeight.text =
        (_fd(f, ['showroom_ceiling_height_ft']) ??
                _fd(showroom, ['showroom_ceiling_height_ft']))
            ?.toString() ??
        '';
    _showroomMainRoadFacing = _fb(f, [
      'showroom_main_road_facing',
    ], fallback: _fb(showroom, ['showroom_main_road_facing']));
    _showroomCorner =
        p.showroomCorner ??
        _fb(f, [
          'corner_showroom',
        ], fallback: _fb(showroom, ['corner_showroom']));
    _showroomWashroom = _fb(f, [
      'showroom_washroom_available',
    ], fallback: _fb(showroom, ['showroom_washroom_available']));
    _showroomParkingSlots.text =
        (_fi(f, ['showroom_parking_slots']) ??
                _fi(showroom, ['showroom_parking_slots']))
            ?.toString() ??
        '';
    _showroomFurnishing =
        _f(f, ['showroom_furnishing_status']) ??
        _f(showroom, ['showroom_furnishing_status']) ??
        _showroomFurnishing;
    _showroomFloorType =
        _f(f, ['showroom_floor_type']) ??
        _f(showroom, ['showroom_floor_type']) ??
        _showroomFloorType;
    _showroomMarketName.text =
        _f(f, ['showroom_market_name']) ??
        _f(showroom, ['showroom_market_name']) ??
        '';
    _showroomLocality.text =
        _f(f, ['showroom_locality']) ??
        _f(showroom, ['showroom_locality']) ??
        '';
    _showroomOwnerName.text =
        _f(f, ['showroom_owner_name', 'owner_name']) ??
        _f(showroom, ['showroom_owner_name', 'owner_name']) ??
        '';
    _showroomOwnerMobile.text =
        _f(f, ['showroom_owner_mobile', 'owner_mobile']) ??
        _f(showroom, ['showroom_owner_mobile', 'owner_mobile']) ??
        '';

    // Warehouse — check both prefixed names (what we send) and flat backend
    // keys (what the backend stores/returns). Backend often returns generic flat
    // column names instead of the warehouse-prefixed variants we submit.
    _warehouseType =
        _f(f, ['warehouse_type']) ??
        _f(warehouse, ['warehouse_type']) ??
        _warehouseType;

    // plot_area: try warehouse_plot_area first, then generic plot_area
    _warehousePlotArea.text =
        (_fd(f, ['warehouse_plot_area', 'warehouse_area', 'plot_area']) ??
                _fd(warehouse, ['warehouse_plot_area', 'plot_area']))
            ?.toString() ??
        p.warehousePlotArea?.toString() ??
        '';

    _warehousePlotAreaUnit =
        _f(f, ['warehouse_plot_area_unit', 'area_unit']) ??
        _f(warehouse, ['warehouse_plot_area_unit', 'area_unit']) ??
        (p.warehousePlotAreaUnit?.isNotEmpty == true ? p.warehousePlotAreaUnit : null) ??
        _warehousePlotAreaUnit;

    // ceiling_height: try all backend variants
    _warehouseCeilingHeight.text =
        (_fd(f, ['warehouse_ceiling_height_ft', 'warehouse_ceiling_height', 'ceiling_height_ft', 'ceiling_height']) ??
                _fd(warehouse, ['warehouse_ceiling_height_ft', 'warehouse_ceiling_height', 'ceiling_height_ft', 'ceiling_height']))
            ?.toString() ??
        p.warehouseCeilingHeight?.toString() ??
        '';

    _warehouseLoadingBays.text =
        (_fi(f, ['loading_bays']) ?? _fi(warehouse, ['loading_bays']))
            ?.toString() ??
        p.warehouseLoadingBays?.toString() ??
        '';

    _warehouseDockLevelers.text =
        (_fi(f, ['dock_levelers']) ?? _fi(warehouse, ['dock_levelers']))
            ?.toString() ??
        p.warehouseDockLevelers?.toString() ??
        '';

    _warehousePowerSupply.text =
        _f(f, ['power_supply']) ??
        _f(warehouse, ['power_supply']) ??
        p.warehousePowerSupply ??
        '';

    _warehouseIndustrialLicense =
        _fbNullable(f, ['industrial_license']) ??
        _fbNullable(warehouse, ['industrial_license']) ??
        p.warehouseIndustrialLicense;

    _warehouseTruckAccess =
        _f(f, ['truck_access']) ??
        _f(warehouse, ['truck_access']) ??
        p.warehouseTruckAccess ??
        _warehouseTruckAccess;

    // industrial_area_name: backend may return as industrial_area or area_name
    _warehouseAreaName.text =
        _f(f, ['industrial_area_name', 'industrial_area', 'area_name']) ??
        _f(warehouse, ['industrial_area_name', 'industrial_area']) ??
        p.warehouseAreaName ??
        '';

    // industrial_area_city: backend may return as city (but city is overwritten
    // by generic city field above, so also check warehouse-specific keys first)
    _warehouseCity.text =
        _f(f, ['industrial_area_city']) ??
        _f(warehouse, ['industrial_area_city', 'city']) ??
        p.warehouseCity ??
        '';

    if (kDebugMode) {
      debugPrint(
        '[WarehousePrefill] type=$_warehouseType '
        'plotArea=${_warehousePlotArea.text} '
        'ceilingHeight=${_warehouseCeilingHeight.text} '
        'loadingBays=${_warehouseLoadingBays.text} '
        'dockLevelers=${_warehouseDockLevelers.text} '
        'powerSupply=${_warehousePowerSupply.text} '
        'industrialLicense=$_warehouseIndustrialLicense '
        'truckAccess=$_warehouseTruckAccess '
        'areaName=${_warehouseAreaName.text} '
        'city=${_warehouseCity.text}',
      );
    }

    // Common commercial
    _shopFacade.text =
        _f(f, ['shop_facade']) ?? _f(shop, ['shop_facade']) ?? '';
    _washrooms.text =
        (_fi(f, ['washrooms']) ??
                _fi(office, ['washrooms']) ??
                _fi(shop, ['washrooms']) ??
                _fi(showroom, ['washrooms']))
            ?.toString() ??
        '';
    _parkingType =
        _f(f, ['parking_type']) ??
        _f(office, ['parking_type']) ??
        _f(shop, ['parking_type']) ??
        _f(showroom, ['parking_type']) ??
        _parkingType;
    _plotType.text = _f(f, ['plot_type']) ?? _f(plot, ['plot_type']) ?? '';
    _rooms.text =
        (_fi(f, ['rooms', 'pg_total_rooms']) ??
                _fi(pg, ['total_rooms', 'rooms']))
            ?.toString() ??
        '';
    _qualityRating.text =
        (_fd(f, ['quality_rating']) ??
                _fd(office, ['quality_rating']) ??
                _fd(shop, ['quality_rating']) ??
                _fd(showroom, ['quality_rating']) ??
                _fd(warehouse, ['quality_rating']))
            ?.toString() ??
        '';

    // ── 7. Land / Plot fields ───────────────────────────────────────────────
    _landType = _f(f, ['land_type']) ?? _f(plot, ['land_type']) ?? _landType;
    _roadWidth.text =
        (_fd(f, ['road_width_ft', 'road_width']) ??
                _fd(plot, ['road_width_ft', 'road_width']))
            ?.toString() ??
        '';
    _plotAreaUnit =
        _f(f, ['plot_area_unit']) ??
        _f(plot, ['plot_area_unit']) ??
        _plotAreaUnit;
    _plotCorner =
        p.plotCorner ??
        _fb(f, [
          'corner_plot',
          'plot_corner',
        ], fallback: _fb(plot, ['corner_plot', 'plot_corner']));
    _plotRoadAccess =
        p.plotRoadAccess ??
        _fbNullable(f, ['road_access']) ??
        _fbNullable(plot, ['road_access']);
    _agriFencing = _fb(f, [
      'fencing',
      'agri_fencing',
    ], fallback: _fb(plot, ['fencing', 'agri_fencing']));
    _agriWaterSource =
        _f(f, ['water_source', 'agri_water_source']) ??
        _f(plot, ['water_source', 'agri_water_source']) ??
        _agriWaterSource;

    // ── 8. Sell → Residential → Apartment ──────────────────────────────────
    _additionalRooms
      ..clear()
      ..addAll(p.additionalRooms ?? _fl(f, ['additional_rooms']));
    _cornerProperty = p.cornerProperty ?? _fbNullable(f, ['corner_property']);
    // price_negotiable: check both backend key names and model field
    _priceNegotiable =
        p.priceNegotiable ??
        _fbNullable(f, ['price_negotiable']) ??
        _fbNullable(f, ['negotiable']) ??
        _fbNullable(f, ['villa_price_negotiable']) ??
        _fbNullable(f, ['duplex_negotiable']) ??
        _fbNullable(f, ['price_negotiable_office']);

    // maintenance_charges: model field + direct API key fallback
    _maintenanceCharges.text =
        p.maintenanceCharges?.toString() ??
        _fd(f, ['maintenance_charges', 'office_maintenance_charges', 'maintenance_charges_office'])?.toString() ??
        '';
    _bookingAmount.text =
        p.bookingAmount?.toString() ??
        _fd(f, ['booking_amount'])?.toString() ??
        '';
    if (kDebugMode) {
      debugPrint(
        '[PricingPrefill] maintenanceCharges=${_maintenanceCharges.text} '
        'bookingAmount=${_bookingAmount.text} '
        'priceNegotiable=$_priceNegotiable',
      );
    }
    _propertyHighlights
      ..clear()
      ..addAll(_fl(f, ['property_highlights']));
    _whatsappUpdates = _fb(f, ['whatsapp_updates'], fallback: true);
    _promotionTags
      ..clear()
      ..addAll(_fl(f, ['promotion']));

    // ── 9. Rent/Lease → Residential → Apartment ────────────────────────────
    _rentAdditionalRooms
      ..clear()
      ..addAll(p.additionalRooms ?? _fl(f, ['rent_additional_rooms']));
    _rentCornerProperty =
        p.rentCornerProperty ?? _fbNullable(f, ['rent_corner_property']);
    _petFriendly = _fb(f, ['pet_friendly']);
    _wheelchairFriendly = _fb(f, ['wheelchair_friendly']);
    _rentGatedSociety = _fbNullable(f, ['gated_society_rent']);
    _securityDeposit.text = _fd(f, ['security_deposit'])?.toString() ?? '';
    _rentMaintenanceCharges.text =
        _fd(f, [
          'maintenance_charges',
          'maintenance_charges_rent',
        ])?.toString() ??
        '';
    _brokerage.text = _fd(f, ['brokerage'])?.toString() ?? '';
    _rentNegotiable =
        p.rentNegotiable ??
        _fbNullable(f, ['rent_negotiable', 'price_negotiable']);
    _availableFrom.text = _f(f, ['available_from']) ?? '';
    _leaseDurationMonths.text =
        _fi(f, ['lease_duration_months'])?.toString() ??
        _leaseDurationMonths.text;
    _lockInMonths.text =
        _fi(f, ['lock_in_months'])?.toString() ?? _lockInMonths.text;
    _noticePeriodValue.text =
        _fi(f, ['notice_period_value'])?.toString() ?? _noticePeriodValue.text;
    _noticePeriodUnit = _f(f, ['notice_period_unit']) ?? _noticePeriodUnit;
    _preferredTenant = _f(f, ['preferred_tenant']) ?? _preferredTenant;
    _foodPreference = _f(f, ['food_preference']) ?? _foodPreference;
    _rentPromotionTypes
      ..clear()
      ..addAll(_fl(f, ['rent_promotion']));

    // ── 10. Rent/Lease → Residential → Villa / House ───────────────────────
    _rentVillaOutdoors
      ..clear()
      ..addAll(_fl(f, ['rent_villa_outdoors']));
    _rentVillaWaterSource =
        _f(f, ['rent_villa_water_source']) ?? _rentVillaWaterSource;
    _rentSolarPower = _fb(f, ['solar_power']);
    _rentIndependentEntry = _fb(f, ['independent_entry']);

    // ── 11. Rent/Lease → Residential → Builder Floor ───────────────────────
    _rentLiftAvailable = _fb(f, ['lift_available_rent'], fallback: true);
    _societyName.text = _f(f, ['society_name']) ?? '';
    _rentTenantTypes
      ..clear()
      ..addAll(_fl(f, ['tenant_types']));

    // ── 12. Rent/Lease → Residential → Studio ──────────────────────────────
    _studioConfig = _f(f, ['studio_config']) ?? _studioConfig;
    _kitchenType = _f(f, ['kitchen_type']) ?? _kitchenType;
    _studioTenantPrefs
      ..clear()
      ..addAll(_fl(f, ['studio_tenant_preferences']));

    // ── 13. Rent/Lease → Residential → Farmhouse ───────────────────────────
    _rentFarmLandArea.text = _fd(f, ['farm_land_area_rent'])?.toString() ?? '';
    _rentFarmRooms.text = _fi(f, ['farm_rooms_rent'])?.toString() ?? '';
    _rentFarmPool = _fb(f, ['farm_pool_rent']);
    _rentFarmFencing = _fb(f, ['farm_fencing_rent']);
    _rentFarmUseCases
      ..clear()
      ..addAll(_fl(f, ['farm_use_cases']));
    _farmMonthlyCharges.text =
        _fd(f, ['farm_monthly_charges'])?.toString() ?? '';
    _farmDailyCharges.text = _fd(f, ['farm_daily_charges'])?.toString() ?? '';
    _farmEventCharges.text = _fd(f, ['farm_event_charges'])?.toString() ?? '';
    _minStayDays.text =
        _fi(f, ['min_stay_days'])?.toString() ?? _minStayDays.text;

    // ── 14. Sell → Residential → Villa / House ─────────────────────────────
    _villaAdditionalRooms
      ..clear()
      ..addAll(p.additionalRooms ?? _fl(f, ['villa_additional_rooms']));
    _villaCornerProperty =
        p.villaCornerProperty ??
        p.cornerProperty ??
        _fbNullable(f, ['villa_corner_property', 'corner_property']);
    _gatedCommunity =
        p.gatedCommunity ?? _fbNullable(f, ['gated_community', 'gated_society']);
    _villaParking
      ..clear()
      ..addAll(p.villaParking ?? _fl(f, ['parking_types']));
    _outdoors
      ..clear()
      ..addAll(p.outdoors ?? _fl(f, ['outdoors']));
    _waterSource =
        p.waterSource ??
        _f(f, ['villa_water_source', 'water_source']) ??
        _waterSource;
    _connections
      ..clear()
      ..addAll(p.connections ?? _fl(f, ['connections']));
    _villaPriceNegotiable =
        p.villaPriceNegotiable ??
        p.priceNegotiable ??
        _fbNullable(f, ['villa_price_negotiable', 'price_negotiable']);
    _villaMaintenanceCharges.text =
        p.maintenanceCharges?.toString() ??
        _fd(f, ['villa_maintenance_charges'])?.toString() ??
        '';
    _villaBookingAmount.text =
        p.bookingAmount?.toString() ??
        _fd(f, ['villa_booking_amount'])?.toString() ??
        '';

    // ── 15. Sell → Residential → Builder Floor ─────────────────────────────
    _builderCornerProperty =
        p.builderCornerProperty ??
        (p.cornerProperty ??
            _fbNullable(f, ['builder_corner_property', 'corner_property']));
    _builderGatedSociety = _fbNullable(f, ['builder_gated_society', 'gated_society']);
    _constructionAllowed =
        p.constructionAllowed ?? _fbNullable(f, ['construction_allowed']);
    _builderUtilities
      ..clear()
      ..addAll(_fl(f, ['utilities']));
    _pricePerSqft.text = _fd(f, ['price_per_sqft'])?.toString() ?? '';
    _builderNegotiable =
        p.builderNegotiable ?? _fbNullable(f, ['negotiable']);
    _maintenanceCharges.text =
        p.maintenanceCharges?.toString() ??
        _fd(f, ['maintenance_charges'])?.toString() ??
        '';
    _bookingAmount.text =
        p.bookingAmount?.toString() ??
        _fd(f, ['booking_amount'])?.toString() ??
        '';

    // ── 16. Sell → Residential → Duplex ────────────────────────────────────
    _duplexCornerPlot =
        p.duplexCornerPlot ?? _fb(f, ['duplex_corner_plot', 'corner_property']);
    _duplexGatedCommunity =
        p.duplexGatedCommunity ??
        _fb(f, ['duplex_gated_community', 'gated_society']);
    _duplexConstructionAllowed =
        p.duplexConstructionAllowed ??
        _fbNullable(f, ['duplex_construction_allowed', 'construction_allowed']);
    _duplexWaterConnection =
        p.duplexWaterConnection ??
        _fbNullable(f, ['duplex_water_connection', 'water_source']);
    if (_duplexWaterConnection == null) {
      final conn = f['connections'];
      if (conn != null) {
        if (conn is List) {
          if (conn.map((e) => e.toString().toLowerCase()).contains('water')) {
            _duplexWaterConnection = true;
          }
        } else if (conn is String) {
          if (conn.toLowerCase().contains('water')) {
            _duplexWaterConnection = true;
          }
        }
      }
    }
    _duplexElectricityConnection =
        p.duplexElectricityConnection ??
        _fbNullable(f, ['duplex_electricity_connection']);
    if (_duplexElectricityConnection == null) {
      for (final key in ['connections', 'utilities']) {
        final val = f[key];
        if (val != null) {
          if (val is List) {
            final items = val.map((e) => e.toString().toLowerCase()).toList();
            if (items.contains('electricity') || items.contains('power')) {
              _duplexElectricityConnection = true;
              break;
            }
          } else if (val is String) {
            final s = val.toLowerCase();
            if (s.contains('electricity') || s.contains('power')) {
              _duplexElectricityConnection = true;
              break;
            }
          }
        }
      }
    }
    _duplexNegotiable =
        p.duplexNegotiable ??
        _fbNullable(f, ['duplex_negotiable', 'price_negotiable']);
    _duplexRoadAccess =
        p.duplexRoadAccess ??
        _fbNullable(f, ['duplex_road_access', 'road_access']);
    _duplexNearbyFacilities
      ..clear()
      ..addAll(_fl(f, ['duplex_nearby_facilities']));
    _maintenanceCharges.text =
        p.maintenanceCharges?.toString() ??
        _fd(f, ['maintenance_charges'])?.toString() ??
        '';
    _bookingAmount.text =
        p.bookingAmount?.toString() ??
        _fd(f, ['booking_amount'])?.toString() ??
        '';

    // ── 17. Sell → Residential → Farmhouse ─────────────────────────────────
    _farmLandArea.text = _fd(f, ['farm_land_area'])?.toString() ?? '';
    _farmBuiltUpArea.text = _fd(f, ['farm_built_up_area'])?.toString() ?? '';
    _farmUtilities
      ..clear()
      ..addAll(_fl(f, ['farm_utilities']));
    _farmRooms.text = _fi(f, ['farm_rooms'])?.toString() ?? '';
    _farmGarden = _fb(f, ['farm_garden']);
    _farmSwimmingPool = _fb(f, ['farm_swimming_pool']);
    _village.text = _f(f, ['village']) ?? '';
    _landmark.text = _f(f, ['landmark']) ?? '';
    _maintenanceCharges.text =
        p.maintenanceCharges?.toString() ??
        _fd(f, ['maintenance_charges'])?.toString() ??
        '';
    _bookingAmount.text =
        p.bookingAmount?.toString() ??
        _fd(f, ['booking_amount'])?.toString() ??
        '';

    // ── 18. PG / Co-Living ──────────────────────────────────────────────────
    debugPrint('PG Details => ${p.pgDetails?.toJson()}');

    String normalizeFood(String? val, String? pref) {
      if (pref != null && pref.trim().isNotEmpty) {
        final pVal = pref.trim().toLowerCase();
        if (pVal == 'veg') return 'veg_only';
        if (pVal == 'non_veg' || pVal == 'non-veg') return 'non_veg_allowed';
      }
      if (val == null) return '';
      final s = val.trim().toLowerCase();
      if (s == '1' || s == 'true' || s == 'with_food') return 'with_food';
      if (s == '0' || s == 'false' || s == 'without_food')
        return 'without_food';
      return s;
    }

    String normalizePropertyType(String? val) {
      if (val == null) return '';
      final s = val.trim().toLowerCase();
      if (s == 'independent_house') return 'independent_house_pg';
      if (s == 'apartment') return 'apartment_pg';
      if (s == 'co_living') return 'co_living_space';
      return s;
    }

    String normalizeGender(String? val) {
      if (val == null) return '';
      final s = val.trim().toLowerCase();
      if (s == 'male') return 'boys_pg';
      if (s == 'female') return 'girls_pg';
      if (s == 'unisex') return 'unisex_pg';
      if (s == 'co_living') return 'co_living';
      return s;
    }

    String normalizeOccupancy(String? val) {
      if (val == null) return '';
      final s = val.trim().toLowerCase();
      if (s == 'single') return 'single_sharing';
      if (s == 'double') return 'double_sharing';
      if (s == 'triple') return 'triple_sharing';
      if (s == 'four_plus' || s == 'multiple') return 'four_plus_sharing';
      if (s == 'dormitory') return 'dormitory';
      return s;
    }

    final genderVal =
        p.pgDetails?.genderBased ??
        _f(f, ['pg_gender_based']) ??
        _f(pg, ['gender_based']);
    if (genderVal != null) {
      _pgGenderBased = normalizeGender(genderVal);
    }

    final occupancyVal =
        p.pgDetails?.occupancyType ??
        _f(f, ['pg_occupancy_type']) ??
        _f(pg, ['occupancy_type']);
    if (occupancyVal != null) {
      _pgOccupancyType = normalizeOccupancy(occupancyVal);
    }

    _pgTenantTypes
      ..clear()
      ..addAll(
        p.pgDetails?.tenantTypes ??
            (_fl(f, ['pg_tenant_types']).isNotEmpty
                ? _fl(f, ['pg_tenant_types'])
                : _fl(pg, ['tenant_types'])),
      );

    // Normalizing food availability
    final foodVal =
        p.pgDetails?.foodAvailability ??
        _f(f, ['pg_food_availability']) ??
        _f(pg, ['food_available', 'food_availability']);
    final foodPref =
        _f(f, ['food_preference']) ??
        _f(pg, ['food_preference']) ??
        f['food_preference'];
    if (foodVal != null || foodPref != null) {
      _pgFoodAvailability = normalizeFood(foodVal, foodPref);
    }

    // Normalizing property type
    final propTypeVal =
        p.pgDetails?.propertyType ??
        _f(f, ['pg_property_type']) ??
        _f(pg, ['property_type']);
    if (propTypeVal != null) {
      _pgPropertyType = normalizePropertyType(propTypeVal);
    }

    _pgBathroomType =
        p.pgDetails?.bathroomType ??
        _f(f, ['pg_bathroom_type']) ??
        _f(pg, ['bathroom_type']) ??
        _pgBathroomType;
    _pgSuitableFor =
        p.pgDetails?.suitableFor ??
        _f(f, ['pg_suitable_for']) ??
        _f(pg, ['suitable_for']) ??
        _pgSuitableFor;
    _pgBuildingName.text =
        p.pgDetails?.buildingName ??
        _f(f, ['pg_building_name']) ??
        _f(pg, ['building_name']) ??
        '';
    _pgTotalBeds.text =
        (p.pgDetails?.totalBeds ??
                _fi(f, ['pg_total_beds']) ??
                _fi(pg, ['total_beds']))
            ?.toString() ??
        '';
    _pgAvailableBeds.text =
        (p.pgDetails?.availableBeds ??
                _fi(f, ['pg_available_beds']) ??
                _fi(pg, ['available_beds']))
            ?.toString() ??
        '';
    _pgRoomType =
        p.pgDetails?.roomType ??
        _f(f, ['pg_room_type']) ??
        _f(pg, ['room_type']) ??
        _pgRoomType;
    _pgAttachedBathroom =
        p.pgDetails?.attachedBathroom ??
        _fb(f, ['pg_attached_bathroom', 'attached_bathroom']) ||
            _fb(pg, ['attached_bathroom']);
    _pgBalcony =
        p.pgDetails?.balcony ??
        _fb(f, ['pg_balcony', 'balcony']) || _fb(pg, ['balcony']);
    _pgRoomSize.text =
        p.pgDetails?.roomSize ??
        _f(f, ['pg_room_size', 'room_size']) ??
        _f(pg, ['room_size']) ??
        '';
    _pgBedType =
        p.pgDetails?.bedType ??
        _f(f, ['pg_bed_type', 'bed_type']) ??
        _f(pg, ['bed_type']) ??
        _pgBedType;
    _pgCupboardAvailable =
        p.pgDetails?.cupboardAvailable ??
        _fb(f, ['pg_cupboard_available', 'cupboard_available']) ||
            _fb(pg, ['cupboard_available']);
    _pgStudyTableAvailable =
        p.pgDetails?.studyTableAvailable ??
        _fb(f, ['pg_study_table_available', 'study_table_available']) ||
            _fb(pg, ['study_table_available']);
    _pgSecurityDeposit.text =
        (p.pgDetails?.securityDeposit ??
                _fd(f, ['pg_security_deposit', 'security_deposit']) ??
                _fd(pg, ['security_deposit']))
            ?.toString() ??
        '';
    _pgMaintenanceCharges.text =
        (p.pgDetails?.maintenanceCharges ??
                _fd(f, ['pg_maintenance_charges', 'maintenance_charges']) ??
                _fd(pg, ['maintenance_charges']))
            ?.toString() ??
        '';
    _pgElectricityIncluded =
        p.pgDetails?.electricityIncluded ??
        _fb(f, ['pg_electricity_included', 'electricity_included']) ||
            _fb(pg, ['electricity_included']);
    _pgWaterIncluded =
        p.pgDetails?.waterIncluded ??
        _fb(f, ['pg_water_included', 'water_included']) ||
            _fb(pg, ['water_included']);
    _pgFoodChargesIncluded =
        p.pgDetails?.foodChargesIncluded ??
        _fb(f, ['pg_food_charges_included', 'food_charges_included']) ||
            _fb(pg, ['food_charges_included']);
    _pgBrokerageRequired =
        p.pgDetails?.brokerageRequired ??
        _fb(f, ['pg_brokerage_required']) || _fb(pg, ['brokerage_required']);
    _pgCoupleFriendly =
        p.pgDetails?.coupleFriendly ??
        _fb(f, ['pg_couple_friendly']) || _fb(pg, ['couple_friendly']);
    _pgIdProofRequired =
        p.pgDetails?.idProofRequired ??
        _fb(f, ['pg_id_proof_required']) || _fb(pg, ['id_proof_required']);
    _pgAvailableFrom.text =
        p.pgDetails?.availableFrom ??
        _f(f, ['pg_available_from']) ??
        _f(pg, ['available_from']) ??
        '';
    _pgMinStayDays.text =
        (p.pgDetails?.minStayDays ??
                _fi(f, ['pg_min_stay_days']) ??
                _fi(pg, ['min_stay_days']))
            ?.toString() ??
        '';
    _pgNoticePeriodDays.text =
        (p.pgDetails?.noticePeriodDays ??
                _fi(f, ['pg_notice_period_days']) ??
                _fi(pg, ['notice_period_days']))
            ?.toString() ??
        '';
    _pgPreferredTenantAge.text =
        (p.pgDetails?.preferredTenantAge ??
                _fi(f, ['pg_preferred_tenant_age']) ??
                _fi(pg, ['preferred_tenant_age']))
            ?.toString() ??
        '';
    _pgSmokingAllowed =
        p.pgDetails?.smokingAllowed ??
        _fb(f, ['pg_smoking_allowed']) || _fb(pg, ['smoking_allowed']);
    _pgDrinkingAllowed =
        p.pgDetails?.drinkingAllowed ??
        _fb(f, ['pg_drinking_allowed']) || _fb(pg, ['drinking_allowed']);
    _pgPetsAllowed =
        p.pgDetails?.petsAllowed ??
        _fb(f, ['pg_pets_allowed']) || _fb(pg, ['pets_allowed']);
    _pgVisitorsAllowed =
        p.pgDetails?.visitorsAllowed ??
        _fb(f, ['pg_visitors_allowed']) || _fb(pg, ['visitors_allowed']);

    // Curfew time format conversion (e.g., 22:00:00 -> 10:00 PM)
    final rawCurfew =
        p.pgDetails?.curfewTime ??
        _f(f, ['pg_curfew_time']) ??
        _f(pg, ['curfew_time']);
    if (rawCurfew != null && rawCurfew.trim().isNotEmpty) {
      final s = rawCurfew.trim();
      final timeParts = s.split(':');
      if (timeParts.isNotEmpty) {
        final hour = int.tryParse(timeParts[0]);
        final minute = timeParts.length > 1
            ? int.tryParse(timeParts[1]) ?? 0
            : 0;
        if (hour != null) {
          final period = hour >= 12 ? 'PM' : 'AM';
          final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
          final displayMinute = minute.toString().padLeft(2, '0');
          _pgCurfewTime.text = '$displayHour:$displayMinute $period';
        } else {
          _pgCurfewTime.text = s;
        }
      } else {
        _pgCurfewTime.text = s;
      }
    } else {
      _pgCurfewTime.text = '';
    }

    _pgGateLockedAtNight =
        p.pgDetails?.gateLockedAtNight ??
        _fb(f, ['pg_gate_locked_at_night']) ||
            _fb(pg, ['gate_locked_at_night']);
    _pgNearbyPreferences
      ..clear()
      ..addAll(
        p.pgDetails?.nearbyPreferences ??
            (_fl(f, ['pg_nearby_preferences']).isNotEmpty
                ? _fl(f, ['pg_nearby_preferences'])
                : _fl(pg, ['nearby_preferences'])),
      );
    _pgAvailability =
        p.pgDetails?.availability ??
        _f(f, ['pg_availability']) ??
        _f(pg, ['availability_status']) ??
        _pgAvailability;
    _pgSharing =
        p.pgDetails?.sharing ??
        _fi(f, ['pg_sharing']) ??
        _fi(pg, ['pg_sharing', 'sharing']) ??
        _pgSharing;
    _pgSecurity =
        p.pgDetails?.security ??
        _fb(f, ['pg_security']) ||
            _fb(pg, ['pg_security', 'security_features', 'security']);

    // ── 19. Open all sections so the user can see everything ────────────────
    for (final key in _expandedSections.keys.toList()) {
      _expandedSections[key] = true;
    }

    // Trigger UI rebuild with all pre-filled data.
    setState(() {});
  }

  Timer? _draftSaveTimer;

  void _attachDraftListeners() {
    for (final c in [
      _title,
      _description,
      _price,
      _area,
      _floor,
      _totalFloors,
      _carpetArea,
      _builtUpArea,
      _superBuiltUpArea,
      _plotArea,
      _length,
      _breadth,
      _floorsAllowed,
      _possessionBy,
      _cabins,
      _meetingRooms,
      _seats,
      _maxSeats,
      _conferenceRooms,
      _shopFacade,
      _washrooms,
      _plotType,
      _qualityRating,
      _rooms,
      _numberOfLifts,
      _floorPlateArea,
      _roadWidth,
      _maintenanceCharges,
      _bookingAmount,
      _securityDeposit,
      _rentMaintenanceCharges,
      _brokerage,
      _availableFrom,
      _leaseDurationMonths,
      _lockInMonths,
      _noticePeriodValue,
      _societyName,
      _rentFarmLandArea,
      _rentFarmRooms,
      _farmMonthlyCharges,
      _farmDailyCharges,
      _farmEventCharges,
      _minStayDays,
      _villaMaintenanceCharges,
      _villaBookingAmount,
      _pricePerSqft,
      _officeMaintenanceCharges,
      _officeBookingAmount,
      _shopArea,
      _frontageWidth,
      _ceilingHeight,
      _marketName,
      _locality,
      _showroomArea,
      _showroomFrontageWidth,
      _showroomCeilingHeight,
      _showroomParkingSlots,
      _showroomMarketName,
      _showroomLocality,
      _showroomOwnerName,
      _showroomOwnerMobile,
      _warehousePlotArea,
      _warehouseCeilingHeight,
      _warehouseLoadingBays,
      _warehouseDockLevelers,
      _warehousePowerSupply,
      _warehouseAreaName,
      _warehouseCity,
      _farmLandArea,
      _farmBuiltUpArea,
      _farmRooms,
      _village,
      _landmark,
      _ownerName,
      _ownerPhone,
      _address,
      _city,
      _state,
      _pincode,
      _pgCurfewTime,
      _pgBuildingName,
      _pgTotalBeds,
      _pgAvailableBeds,
      _pgRoomSize,
      _pgSecurityDeposit,
      _pgMaintenanceCharges,
      _pgAvailableFrom,
      _pgMinStayDays,
      _pgNoticePeriodDays,
      _pgPreferredTenantAge,
    ]) {
      c.addListener(_scheduleSaveDraft);
    }
  }

  void _scheduleSaveDraft() {
    _draftSaveTimer?.cancel();
    _draftSaveTimer = Timer(const Duration(milliseconds: 400), _saveDraft);
  }

  Future<void> _saveDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = <String, Object?>{
        'title': _title.text,
        'description': _description.text,
        'price': _price.text,
        'area': _area.text,
        'areaUnit': _areaUnit,
        'propertyKind': _propertyKind?.name,
        'type': _type.name,
        'listingType': _listingType,
        'parentCategoryId': _selectedParentCategoryId,
        'categoryId': _selectedCategoryId,
        'parentCategorySlug': _selectedParentCategorySlug,
        'categorySlug': _selectedCategorySlug,
        'bedrooms': _bedrooms,
        'bathrooms': _bathrooms,
        'balconies': _balconies,
        'parking': _parking,
        'furnishing': _furnishing,
        'facing': _facing,
        'floor': _floor.text,
        'totalFloors': _totalFloors.text,
        'carpetArea': _carpetArea.text,
        'builtUpArea': _builtUpArea.text,
        'superBuiltUpArea': _superBuiltUpArea.text,
        'plotArea': _plotArea.text,
        'length': _length.text,
        'breadth': _breadth.text,
        'floorsAllowed': _floorsAllowed.text,
        'openSides': _openSides,
        'boundaryWall': _boundaryWall,
        'constructionDone': _constructionDone,
        'availability': _availability,
        'readyTimeframe': _readyTimeframe,
        'possessionBy': _possessionBy.text,
        'ownership': _ownership,
        'commercialType': _commercialType,
        'floorPlateArea': _floorPlateArea.text,
        'cabins': _cabins.text,
        'meetingRooms': _meetingRooms.text,
        'seats': _seats.text,
        'maxSeats': _maxSeats.text,
        'conferenceRooms': _conferenceRooms.text,
        'liftAvailable': _liftAvailable,
        'preLeased': _preLeased,
        'officeType': _officeType,
        'receptionArea': _receptionArea,
        'pantry': _pantry,
        'cafeteria': _cafeteria,
        'serverRoom': _serverRoom,
        'fireSafetyInstalled': _fireSafetyInstalled,
        'centralAC': _centralAC,
        'visitorParking': _visitorParking,
        'numberOfLifts': _numberOfLifts.text,
        'taxIncluded': _taxIncluded,
        'officeNegotiable': _officeNegotiable,
        'officeMaintenanceCharges': _officeMaintenanceCharges.text,
        'officeBookingAmount': _officeBookingAmount.text,
        'shopType': _shopType,
        'shopArea': _shopArea.text,
        'shopAreaUnit': _shopAreaUnit,
        'frontageWidth': _frontageWidth.text,
        'ceilingHeight': _ceilingHeight.text,
        'mainRoadFacing': _mainRoadFacing,
        'cornerShop': _cornerShop,
        'washroomAvailable': _washroomAvailable,
        'floorType': _floorType,
        'marketName': _marketName.text,
        'locality': _locality.text,
        'showroomArea': _showroomArea.text,
        'showroomAreaUnit': _showroomAreaUnit,
        'showroomFrontageWidth': _showroomFrontageWidth.text,
        'showroomCeilingHeight': _showroomCeilingHeight.text,
        'showroomMainRoadFacing': _showroomMainRoadFacing,
        'showroomCorner': _showroomCorner,
        'showroomWashroom': _showroomWashroom,
        'showroomParkingSlots': _showroomParkingSlots.text,
        'showroomFurnishing': _showroomFurnishing,
        'showroomFloorType': _showroomFloorType,
        'showroomMarketName': _showroomMarketName.text,
        'showroomLocality': _showroomLocality.text,
        'showroomOwnerName': _showroomOwnerName.text,
        'showroomOwnerMobile': _showroomOwnerMobile.text,
        'warehouseType': _warehouseType,
        'warehousePlotArea': _warehousePlotArea.text,
        'warehousePlotAreaUnit': _warehousePlotAreaUnit,
        'warehouseCeilingHeight': _warehouseCeilingHeight.text,
        'warehouseLoadingBays': _warehouseLoadingBays.text,
        'warehouseDockLevelers': _warehouseDockLevelers.text,
        'warehousePowerSupply': _warehousePowerSupply.text,
        'warehouseIndustrialLicense': _warehouseIndustrialLicense,
        'warehouseTruckAccess': _warehouseTruckAccess,
        'warehouseAreaName': _warehouseAreaName.text,
        'warehouseCity': _warehouseCity.text,
        'shopFacade': _shopFacade.text,
        'washrooms': _washrooms.text,
        'parkingType': _parkingType,
        'plotType': _plotType.text,
        'rooms': _rooms.text,
        'qualityRating': _qualityRating.text,
        'landType': _landType,
        'roadWidth': _roadWidth.text,
        'plotAreaUnit': _plotAreaUnit,
        'plotCorner': _plotCorner,
        'plotRoadAccess': _plotRoadAccess,
        'agriFencing': _agriFencing,
        'agriWaterSource': _agriWaterSource,
        'additionalRooms': _additionalRooms.toList(growable: false),
        'cornerProperty': _cornerProperty,
        'priceNegotiable': _priceNegotiable,
        'maintenanceCharges': _maintenanceCharges.text,
        'bookingAmount': _bookingAmount.text,
        'propertyHighlights': _propertyHighlights.toList(growable: false),
        'whatsappUpdates': _whatsappUpdates,
        'promotionTags': _promotionTags.toList(growable: false),
        'rentAdditionalRooms': _rentAdditionalRooms.toList(growable: false),
        'rentCornerProperty': _rentCornerProperty,
        'petFriendly': _petFriendly,
        'wheelchairFriendly': _wheelchairFriendly,
        'rentGatedSociety': _rentGatedSociety,
        'securityDeposit': _securityDeposit.text,
        'rentMaintenanceCharges': _rentMaintenanceCharges.text,
        'brokerage': _brokerage.text,
        'rentNegotiable': _rentNegotiable,
        'availableFrom': _availableFrom.text,
        'leaseDurationMonths': _leaseDurationMonths.text,
        'lockInMonths': _lockInMonths.text,
        'noticePeriodValue': _noticePeriodValue.text,
        'noticePeriodUnit': _noticePeriodUnit,
        'preferredTenant': _preferredTenant,
        'foodPreference': _foodPreference,
        'rentPromotionTypes': _rentPromotionTypes.toList(growable: false),
        'pgGenderBased': _pgGenderBased,
        'pgOccupancyType': _pgOccupancyType,
        'pgTenantTypes': _pgTenantTypes.toList(growable: false),
        'pgFoodAvailability': _pgFoodAvailability,
        'pgPropertyType': _pgPropertyType,
        'pgBathroomType': _pgBathroomType,
        'pgSuitableFor': _pgSuitableFor,
        'pgBuildingName': _pgBuildingName.text,
        'pgTotalBeds': _pgTotalBeds.text,
        'pgAvailableBeds': _pgAvailableBeds.text,
        'pgRoomType': _pgRoomType,
        'pgAttachedBathroom': _pgAttachedBathroom,
        'pgBalcony': _pgBalcony,
        'pgRoomSize': _pgRoomSize.text,
        'pgBedType': _pgBedType,
        'pgCupboardAvailable': _pgCupboardAvailable,
        'pgStudyTableAvailable': _pgStudyTableAvailable,
        'pgSecurityDepositAmount': _pgSecurityDeposit.text,
        'pgMaintenanceChargesAmount': _pgMaintenanceCharges.text,
        'pgElectricityIncluded': _pgElectricityIncluded,
        'pgWaterIncluded': _pgWaterIncluded,
        'pgFoodChargesIncluded': _pgFoodChargesIncluded,
        'pgBrokerageRequired': _pgBrokerageRequired,
        'pgCoupleFriendly': _pgCoupleFriendly,
        'pgIdProofRequired': _pgIdProofRequired,
        'pgAvailableFrom': _pgAvailableFrom.text,
        'pgMinStayDays': _pgMinStayDays.text,
        'pgNoticePeriodDays': _pgNoticePeriodDays.text,
        'pgPreferredTenantAge': _pgPreferredTenantAge.text,
        'pgSmokingAllowed': _pgSmokingAllowed,
        'pgDrinkingAllowed': _pgDrinkingAllowed,
        'pgPetsAllowed': _pgPetsAllowed,
        'pgVisitorsAllowed': _pgVisitorsAllowed,
        'pgCurfewTime': _pgCurfewTime.text,
        'pgGateLockedAtNight': _pgGateLockedAtNight,
        'pgNearbyPreferences': _pgNearbyPreferences.toList(growable: false),
        'pgAvailability': _pgAvailability,
        'pgSharing': _pgSharing,
        'pgSecurity': _pgSecurity,
        'rentVillaOutdoors': _rentVillaOutdoors.toList(growable: false),
        'rentVillaWaterSource': _rentVillaWaterSource,
        'rentSolarPower': _rentSolarPower,
        'rentIndependentEntry': _rentIndependentEntry,
        'rentLiftAvailable': _rentLiftAvailable,
        'societyName': _societyName.text,
        'rentTenantTypes': _rentTenantTypes.toList(growable: false),
        'studioConfig': _studioConfig,
        'kitchenType': _kitchenType,
        'studioTenantPrefs': _studioTenantPrefs.toList(growable: false),
        'rentFarmLandArea': _rentFarmLandArea.text,
        'rentFarmRooms': _rentFarmRooms.text,
        'rentFarmPool': _rentFarmPool,
        'rentFarmFencing': _rentFarmFencing,
        'rentFarmUseCases': _rentFarmUseCases.toList(growable: false),
        'farmMonthlyCharges': _farmMonthlyCharges.text,
        'farmDailyCharges': _farmDailyCharges.text,
        'farmEventCharges': _farmEventCharges.text,
        'minStayDays': _minStayDays.text,
        'villaAdditionalRooms': _villaAdditionalRooms.toList(growable: false),
        'villaCornerProperty': _villaCornerProperty,
        'gatedCommunity': _gatedCommunity,
        'villaParking': _villaParking.toList(growable: false),
        'outdoors': _outdoors.toList(growable: false),
        'waterSource': _waterSource,
        'connections': _connections.toList(growable: false),
        'villaPriceNegotiable': _villaPriceNegotiable,
        'villaMaintenanceCharges': _villaMaintenanceCharges.text,
        'villaBookingAmount': _villaBookingAmount.text,
        'builderCornerProperty': _builderCornerProperty,
        'builderGatedSociety': _builderGatedSociety,
        'constructionAllowed': _constructionAllowed,
        'builderUtilities': _builderUtilities.toList(growable: false),
        'pricePerSqft': _pricePerSqft.text,
        'builderNegotiable': _builderNegotiable,
        'duplexCornerPlot': _duplexCornerPlot,
        'duplexGatedCommunity': _duplexGatedCommunity,
        'duplexConstructionAllowed': _duplexConstructionAllowed,
        'duplexWaterConnection': _duplexWaterConnection,
        'duplexElectricityConnection': _duplexElectricityConnection,
        'duplexNegotiable': _duplexNegotiable,
        'duplexRoadAccess': _duplexRoadAccess,
        'duplexNearbyFacilities': _duplexNearbyFacilities.toList(
          growable: false,
        ),
        'farmLandArea': _farmLandArea.text,
        'farmBuiltUpArea': _farmBuiltUpArea.text,
        'farmUtilities': _farmUtilities.toList(growable: false),
        'farmRooms': _farmRooms.text,
        'farmGarden': _farmGarden,
        'farmSwimmingPool': _farmSwimmingPool,
        'village': _village.text,
        'landmark': _landmark.text,
        'ownerName': _ownerName.text,
        'ownerPhone': _ownerPhone.text,
        'selectedAmenityIds': _selectedAmenityIds.toList(),
        'selectedFurnishingIds': _selectedFurnishingIds.toList(),
        'furnishingQuantities': _furnishingQuantities.map(
          (k, v) => MapEntry(k.toString(), v),
        ),
        'address': _address.text,
        'city': _city.text,
        'state': _state.text,
        'pincode': _pincode.text,
        'latitude': _latitudeController.text,
        'longitude': _longitudeController.text,
        'primaryImageIndex': _primaryImageIndex,
        'images': _images
            .map((m) => {'path': m.path, 'type': m.type.name, 'tag': m.tag})
            .toList(),
      };
      // Encode off the main thread to avoid jank on large forms.
      final encoded = await compute(jsonEncode, data);
      await prefs.setString(_draftPrefsKey, encoded);
    } catch (_) {
      // ignore draft save failures
    }
  }

  Future<void> _clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftPrefsKey);
    } catch (_) {
      // ignore
    }
  }

  Future<void> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_draftPrefsKey);
      if (raw == null || raw.trim().isEmpty) return;
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return;
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final map = Map<String, dynamic>.from(decoded);
        if (widget.autoRestoreDraft) {
          _applyDraft(map);
        } else {
          _promptRestoreDraft(map);
        }
      });
    } catch (_) {
      // ignore draft load failures
    }
  }

  void _promptRestoreDraft(Map<String, dynamic> decoded) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Draft found. Continue where you left off?'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                TextButton(
                  onPressed: () {
                    messenger.hideCurrentSnackBar();
                    _applyDraft(decoded);
                  },
                  child: const Text('YES'),
                ),
                TextButton(
                  onPressed: () async {
                    messenger.hideCurrentSnackBar();
                    await _clearDraft();
                  },
                  child: const Text('NO'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _applyDraft(Map<String, dynamic> decoded) {
    setState(() {
      _title.text = (decoded['title'] as String?) ?? '';
      _description.text = (decoded['description'] as String?) ?? '';
      _price.text = (decoded['price'] as String?) ?? '';
      _area.text = (decoded['area'] as String?) ?? '';
      _areaUnit = (decoded['areaUnit'] as String?) ?? _areaUnit;

      final kindName = decoded['propertyKind'] as String?;
      _propertyKind = kindName == null
          ? null
          : _CreatePropertyKind.values
                .where((e) => e.name == kindName)
                .cast<_CreatePropertyKind?>()
                .first;

      final typeName = decoded['type'] as String?;
      if (typeName != null) {
        _type = PropertyType.values.firstWhere(
          (e) => e.name == typeName,
          orElse: () => _type,
        );
      }
      _listingType = (decoded['listingType'] as String?) ?? _listingType;

      _selectedParentCategoryId = decoded['parentCategoryId'] as int?;
      _selectedCategoryId = decoded['categoryId'] as int?;
      _selectedParentCategorySlug = decoded['parentCategorySlug'] as String?;
      _selectedCategorySlug = decoded['categorySlug'] as String?;
      if (_selectedParentCategorySlug != null) {
        _selectedParentCategorySlug = _normalizeParentSlug(
          rawSlug: _selectedParentCategorySlug!,
          name: _selectedParentCategorySlug!,
        );
      }
      _syncTypeAndResetInvalidCategorySelection();

      _bedrooms = (decoded['bedrooms'] as int?) ?? _bedrooms;
      _bathrooms = (decoded['bathrooms'] as int?) ?? _bathrooms;
      _balconies = (decoded['balconies'] as int?) ?? _balconies;
      _parking = (decoded['parking'] as int?) ?? _parking;
      _furnishing = (decoded['furnishing'] as String?) ?? _furnishing;
      _facing = (decoded['facing'] as String?) ?? _facing;
      _floor.text = (decoded['floor'] as String?) ?? '';
      _totalFloors.text = (decoded['totalFloors'] as String?) ?? '';
      _carpetArea.text = (decoded['carpetArea'] as String?) ?? '';
      _builtUpArea.text = (decoded['builtUpArea'] as String?) ?? '';
      _superBuiltUpArea.text = (decoded['superBuiltUpArea'] as String?) ?? '';
      _plotArea.text = (decoded['plotArea'] as String?) ?? '';
      _length.text = (decoded['length'] as String?) ?? '';
      _breadth.text = (decoded['breadth'] as String?) ?? '';
      _floorsAllowed.text = (decoded['floorsAllowed'] as String?) ?? '';
      _openSides = (decoded['openSides'] as int?) ?? _openSides;
      _boundaryWall = (decoded['boundaryWall'] as bool?) ?? _boundaryWall;
      _constructionDone =
          (decoded['constructionDone'] as bool?) ?? _constructionDone;
      _availability = (decoded['availability'] as String?) ?? _availability;
      _readyTimeframe =
          (decoded['readyTimeframe'] as String?) ?? _readyTimeframe;
      _possessionBy.text = (decoded['possessionBy'] as String?) ?? '';
      _ownership = (decoded['ownership'] as String?) ?? _ownership;
      _commercialType =
          (decoded['commercialType'] as String?) ?? _commercialType;
      _floorPlateArea.text = (decoded['floorPlateArea'] as String?) ?? '';
      _cabins.text = (decoded['cabins'] as String?) ?? '';
      _meetingRooms.text = (decoded['meetingRooms'] as String?) ?? '';
      _seats.text = (decoded['seats'] as String?) ?? '';
      _maxSeats.text = (decoded['maxSeats'] as String?) ?? '';
      _conferenceRooms.text = (decoded['conferenceRooms'] as String?) ?? '';
      _liftAvailable = (decoded['liftAvailable'] as bool?) ?? _liftAvailable;
      _preLeased = (decoded['preLeased'] as bool?) ?? _preLeased;
      _officeType = (decoded['officeType'] as String?) ?? _officeType;
      _receptionArea = (decoded['receptionArea'] as bool?) ?? _receptionArea;
      _pantry = (decoded['pantry'] as bool?) ?? _pantry;
      _cafeteria = (decoded['cafeteria'] as bool?) ?? _cafeteria;
      _serverRoom = (decoded['serverRoom'] as bool?) ?? _serverRoom;
      _fireSafetyInstalled =
          (decoded['fireSafetyInstalled'] as bool?) ?? _fireSafetyInstalled;
      _centralAC = (decoded['centralAC'] as bool?) ?? _centralAC;
      _visitorParking = (decoded['visitorParking'] as bool?) ?? _visitorParking;
      _numberOfLifts.text = (decoded['numberOfLifts'] as String?) ?? '';
      _taxIncluded = (decoded['taxIncluded'] as bool?) ?? _taxIncluded;
      _officeNegotiable =
          (decoded['officeNegotiable'] as bool?) ?? _officeNegotiable;
      _officeMaintenanceCharges.text =
          (decoded['officeMaintenanceCharges'] as String?) ?? '';
      _officeBookingAmount.text =
          (decoded['officeBookingAmount'] as String?) ?? '';
      _shopType = (decoded['shopType'] as String?) ?? _shopType;
      _shopArea.text = (decoded['shopArea'] as String?) ?? '';
      _shopAreaUnit = (decoded['shopAreaUnit'] as String?) ?? _shopAreaUnit;
      _frontageWidth.text = (decoded['frontageWidth'] as String?) ?? '';
      _ceilingHeight.text = (decoded['ceilingHeight'] as String?) ?? '';
      _mainRoadFacing = (decoded['mainRoadFacing'] as bool?) ?? _mainRoadFacing;
      _cornerShop = (decoded['cornerShop'] as bool?) ?? _cornerShop;
      _washroomAvailable =
          (decoded['washroomAvailable'] as bool?) ?? _washroomAvailable;
      _floorType = (decoded['floorType'] as String?) ?? _floorType;
      _marketName.text = (decoded['marketName'] as String?) ?? '';
      _locality.text = (decoded['locality'] as String?) ?? '';
      _showroomArea.text = (decoded['showroomArea'] as String?) ?? '';
      _showroomAreaUnit =
          (decoded['showroomAreaUnit'] as String?) ?? _showroomAreaUnit;
      _showroomFrontageWidth.text =
          (decoded['showroomFrontageWidth'] as String?) ?? '';
      _showroomCeilingHeight.text =
          (decoded['showroomCeilingHeight'] as String?) ?? '';
      _showroomMainRoadFacing =
          (decoded['showroomMainRoadFacing'] as bool?) ??
          _showroomMainRoadFacing;
      _showroomCorner = (decoded['showroomCorner'] as bool?) ?? _showroomCorner;
      _showroomWashroom =
          (decoded['showroomWashroom'] as bool?) ?? _showroomWashroom;
      _showroomParkingSlots.text =
          (decoded['showroomParkingSlots'] as String?) ?? '';
      _showroomFurnishing =
          (decoded['showroomFurnishing'] as String?) ?? _showroomFurnishing;
      _showroomFloorType =
          (decoded['showroomFloorType'] as String?) ?? _showroomFloorType;
      _showroomMarketName.text =
          (decoded['showroomMarketName'] as String?) ?? '';
      _showroomLocality.text = (decoded['showroomLocality'] as String?) ?? '';
      _showroomOwnerName.text = (decoded['showroomOwnerName'] as String?) ?? '';
      _showroomOwnerMobile.text =
          (decoded['showroomOwnerMobile'] as String?) ?? '';
      _warehouseType = (decoded['warehouseType'] as String?) ?? _warehouseType;
      _warehousePlotArea.text = (decoded['warehousePlotArea'] as String?) ?? '';
      _warehousePlotAreaUnit =
          (decoded['warehousePlotAreaUnit'] as String?) ??
          _warehousePlotAreaUnit;
      _warehouseCeilingHeight.text =
          (decoded['warehouseCeilingHeight'] as String?) ?? '';
      _warehouseLoadingBays.text =
          (decoded['warehouseLoadingBays'] as String?) ?? '';
      _warehouseDockLevelers.text =
          (decoded['warehouseDockLevelers'] as String?) ?? '';
      _warehousePowerSupply.text =
          (decoded['warehousePowerSupply'] as String?) ?? '';
      _warehouseIndustrialLicense =
          (decoded['warehouseIndustrialLicense'] as bool?) ??
          _warehouseIndustrialLicense;
      _warehouseTruckAccess =
          (decoded['warehouseTruckAccess'] as String?) ?? _warehouseTruckAccess;
      _warehouseAreaName.text = (decoded['warehouseAreaName'] as String?) ?? '';
      _warehouseCity.text = (decoded['warehouseCity'] as String?) ?? '';
      _shopFacade.text = (decoded['shopFacade'] as String?) ?? '';
      _washrooms.text = (decoded['washrooms'] as String?) ?? '';
      _parkingType = (decoded['parkingType'] as String?) ?? _parkingType;
      _plotType.text = (decoded['plotType'] as String?) ?? '';
      _rooms.text = (decoded['rooms'] as String?) ?? '';
      _qualityRating.text = (decoded['qualityRating'] as String?) ?? '';
      _landType = (decoded['landType'] as String?) ?? _landType;
      _roadWidth.text = (decoded['roadWidth'] as String?) ?? '';
      _plotAreaUnit = (decoded['plotAreaUnit'] as String?) ?? _plotAreaUnit;
      _plotCorner = (decoded['plotCorner'] as bool?) ?? _plotCorner;
      _plotRoadAccess = (decoded['plotRoadAccess'] as bool?) ?? _plotRoadAccess;
      _agriFencing = (decoded['agriFencing'] as bool?) ?? _agriFencing;
      _agriWaterSource =
          (decoded['agriWaterSource'] as String?) ?? _agriWaterSource;
      _additionalRooms
        ..clear()
        ..addAll(
          (decoded['additionalRooms'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _cornerProperty = (decoded['cornerProperty'] as bool?) ?? _cornerProperty;
      _priceNegotiable =
          (decoded['priceNegotiable'] as bool?) ?? _priceNegotiable;
      _maintenanceCharges.text =
          (decoded['maintenanceCharges'] as String?) ?? '';
      _bookingAmount.text = (decoded['bookingAmount'] as String?) ?? '';
      _propertyHighlights
        ..clear()
        ..addAll(
          (decoded['propertyHighlights'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _whatsappUpdates =
          (decoded['whatsappUpdates'] as bool?) ?? _whatsappUpdates;
      _promotionTags
        ..clear()
        ..addAll(
          (decoded['promotionTags'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _rentAdditionalRooms
        ..clear()
        ..addAll(
          (decoded['rentAdditionalRooms'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _rentCornerProperty =
          (decoded['rentCornerProperty'] as bool?) ?? _rentCornerProperty;
      _petFriendly = (decoded['petFriendly'] as bool?) ?? _petFriendly;
      _wheelchairFriendly =
          (decoded['wheelchairFriendly'] as bool?) ?? _wheelchairFriendly;
      _rentGatedSociety =
          (decoded['rentGatedSociety'] as bool?) ?? _rentGatedSociety;
      _securityDeposit.text = (decoded['securityDeposit'] as String?) ?? '';
      _rentMaintenanceCharges.text =
          (decoded['rentMaintenanceCharges'] as String?) ?? '';
      _brokerage.text = (decoded['brokerage'] as String?) ?? '';
      _rentNegotiable = (decoded['rentNegotiable'] as bool?) ?? _rentNegotiable;
      _availableFrom.text = (decoded['availableFrom'] as String?) ?? '';
      _leaseDurationMonths.text =
          (decoded['leaseDurationMonths'] as String?) ??
          _leaseDurationMonths.text;
      _lockInMonths.text =
          (decoded['lockInMonths'] as String?) ?? _lockInMonths.text;
      _noticePeriodValue.text =
          (decoded['noticePeriodValue'] as String?) ?? _noticePeriodValue.text;
      _noticePeriodUnit =
          (decoded['noticePeriodUnit'] as String?) ?? _noticePeriodUnit;
      _preferredTenant =
          (decoded['preferredTenant'] as String?) ?? _preferredTenant;
      _foodPreference =
          (decoded['foodPreference'] as String?) ?? _foodPreference;
      _pgGenderBased = (decoded['pgGenderBased'] as String?) ?? _pgGenderBased;
      _pgOccupancyType =
          (decoded['pgOccupancyType'] as String?) ?? _pgOccupancyType;
      _pgTenantTypes
        ..clear()
        ..addAll(
          (decoded['pgTenantTypes'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _pgFoodAvailability =
          (decoded['pgFoodAvailability'] as String?) ?? _pgFoodAvailability;
      _pgPropertyType =
          (decoded['pgPropertyType'] as String?) ?? _pgPropertyType;
      _pgBathroomType =
          (decoded['pgBathroomType'] as String?) ?? _pgBathroomType;
      _pgSuitableFor = (decoded['pgSuitableFor'] as String?) ?? _pgSuitableFor;
      _pgBuildingName.text = (decoded['pgBuildingName'] as String?) ?? '';
      _pgTotalBeds.text = (decoded['pgTotalBeds'] as String?) ?? '';
      _pgAvailableBeds.text = (decoded['pgAvailableBeds'] as String?) ?? '';
      _pgRoomType = (decoded['pgRoomType'] as String?) ?? _pgRoomType;
      _pgAttachedBathroom =
          (decoded['pgAttachedBathroom'] as bool?) ?? _pgAttachedBathroom;
      _pgBalcony = (decoded['pgBalcony'] as bool?) ?? _pgBalcony;
      _pgRoomSize.text = (decoded['pgRoomSize'] as String?) ?? '';
      _pgBedType = (decoded['pgBedType'] as String?) ?? _pgBedType;
      _pgCupboardAvailable =
          (decoded['pgCupboardAvailable'] as bool?) ?? _pgCupboardAvailable;
      _pgStudyTableAvailable =
          (decoded['pgStudyTableAvailable'] as bool?) ?? _pgStudyTableAvailable;
      _pgSecurityDeposit.text =
          (decoded['pgSecurityDepositAmount'] as String?) ?? '';
      _pgMaintenanceCharges.text =
          (decoded['pgMaintenanceChargesAmount'] as String?) ?? '';
      _pgElectricityIncluded =
          (decoded['pgElectricityIncluded'] as bool?) ?? _pgElectricityIncluded;
      _pgWaterIncluded =
          (decoded['pgWaterIncluded'] as bool?) ?? _pgWaterIncluded;
      _pgFoodChargesIncluded =
          (decoded['pgFoodChargesIncluded'] as bool?) ?? _pgFoodChargesIncluded;
      _pgBrokerageRequired =
          (decoded['pgBrokerageRequired'] as bool?) ?? _pgBrokerageRequired;
      _pgCoupleFriendly =
          (decoded['pgCoupleFriendly'] as bool?) ?? _pgCoupleFriendly;
      _pgIdProofRequired =
          (decoded['pgIdProofRequired'] as bool?) ?? _pgIdProofRequired;
      _pgAvailableFrom.text = (decoded['pgAvailableFrom'] as String?) ?? '';
      _pgMinStayDays.text = (decoded['pgMinStayDays'] as String?) ?? '';
      _pgNoticePeriodDays.text =
          (decoded['pgNoticePeriodDays'] as String?) ?? '';
      _pgPreferredTenantAge.text =
          (decoded['pgPreferredTenantAge'] as String?) ?? '';
      _pgSmokingAllowed =
          (decoded['pgSmokingAllowed'] as bool?) ?? _pgSmokingAllowed;
      _pgDrinkingAllowed =
          (decoded['pgDrinkingAllowed'] as bool?) ?? _pgDrinkingAllowed;
      _pgPetsAllowed = (decoded['pgPetsAllowed'] as bool?) ?? _pgPetsAllowed;
      _pgVisitorsAllowed =
          (decoded['pgVisitorsAllowed'] as bool?) ?? _pgVisitorsAllowed;
      _pgCurfewTime.text = (decoded['pgCurfewTime'] as String?) ?? '';
      _pgGateLockedAtNight =
          (decoded['pgGateLockedAtNight'] as bool?) ?? _pgGateLockedAtNight;
      _pgNearbyPreferences
        ..clear()
        ..addAll(
          (decoded['pgNearbyPreferences'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _pgAvailability =
          (decoded['pgAvailability'] as String?) ?? _pgAvailability;
      _pgSharing = (decoded['pgSharing'] as int?) ?? _pgSharing;
      _pgSecurity = (decoded['pgSecurity'] as bool?) ?? _pgSecurity;
      _rentPromotionTypes
        ..clear()
        ..addAll(
          (decoded['rentPromotionTypes'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _rentVillaOutdoors
        ..clear()
        ..addAll(
          (decoded['rentVillaOutdoors'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _rentVillaWaterSource =
          (decoded['rentVillaWaterSource'] as String?) ?? _rentVillaWaterSource;
      _rentSolarPower = (decoded['rentSolarPower'] as bool?) ?? _rentSolarPower;
      _rentIndependentEntry =
          (decoded['rentIndependentEntry'] as bool?) ?? _rentIndependentEntry;
      _rentLiftAvailable =
          (decoded['rentLiftAvailable'] as bool?) ?? _rentLiftAvailable;
      _societyName.text = (decoded['societyName'] as String?) ?? '';
      _rentTenantTypes
        ..clear()
        ..addAll(
          (decoded['rentTenantTypes'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _studioConfig = (decoded['studioConfig'] as String?) ?? _studioConfig;
      _kitchenType = (decoded['kitchenType'] as String?) ?? _kitchenType;
      _studioTenantPrefs
        ..clear()
        ..addAll(
          (decoded['studioTenantPrefs'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _rentFarmLandArea.text = (decoded['rentFarmLandArea'] as String?) ?? '';
      _rentFarmRooms.text = (decoded['rentFarmRooms'] as String?) ?? '';
      _rentFarmPool = (decoded['rentFarmPool'] as bool?) ?? _rentFarmPool;
      _rentFarmFencing =
          (decoded['rentFarmFencing'] as bool?) ?? _rentFarmFencing;
      _rentFarmUseCases
        ..clear()
        ..addAll(
          (decoded['rentFarmUseCases'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _farmMonthlyCharges.text =
          (decoded['farmMonthlyCharges'] as String?) ?? '';
      _farmDailyCharges.text = (decoded['farmDailyCharges'] as String?) ?? '';
      _farmEventCharges.text = (decoded['farmEventCharges'] as String?) ?? '';
      _minStayDays.text =
          (decoded['minStayDays'] as String?) ?? _minStayDays.text;
      _villaAdditionalRooms
        ..clear()
        ..addAll(
          (decoded['villaAdditionalRooms'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _villaCornerProperty =
          (decoded['villaCornerProperty'] as bool?) ?? _villaCornerProperty;
      _gatedCommunity = (decoded['gatedCommunity'] as bool?) ?? _gatedCommunity;
      _villaParking
        ..clear()
        ..addAll(
          (decoded['villaParking'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _outdoors
        ..clear()
        ..addAll(
          (decoded['outdoors'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _waterSource = (decoded['waterSource'] as String?) ?? _waterSource;
      _connections
        ..clear()
        ..addAll(
          (decoded['connections'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _villaPriceNegotiable =
          (decoded['villaPriceNegotiable'] as bool?) ?? _villaPriceNegotiable;
      _villaMaintenanceCharges.text =
          (decoded['villaMaintenanceCharges'] as String?) ?? '';
      _villaBookingAmount.text =
          (decoded['villaBookingAmount'] as String?) ?? '';
      _builderCornerProperty =
          (decoded['builderCornerProperty'] as bool?) ?? _builderCornerProperty;
      _builderGatedSociety =
          (decoded['builderGatedSociety'] as bool?) ?? _builderGatedSociety;
      _constructionAllowed =
          (decoded['constructionAllowed'] as bool?) ?? _constructionAllowed;
      _builderUtilities
        ..clear()
        ..addAll(
          (decoded['builderUtilities'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _pricePerSqft.text = (decoded['pricePerSqft'] as String?) ?? '';
      _builderNegotiable =
          (decoded['builderNegotiable'] as bool?) ?? _builderNegotiable;
      _duplexCornerPlot =
          (decoded['duplexCornerPlot'] as bool?) ?? _duplexCornerPlot;
      _duplexGatedCommunity =
          (decoded['duplexGatedCommunity'] as bool?) ?? _duplexGatedCommunity;
      _duplexConstructionAllowed =
          (decoded['duplexConstructionAllowed'] as bool?) ??
          _duplexConstructionAllowed;
      _duplexWaterConnection =
          (decoded['duplexWaterConnection'] as bool?) ?? _duplexWaterConnection;
      _duplexElectricityConnection =
          (decoded['duplexElectricityConnection'] as bool?) ??
          _duplexElectricityConnection;
      _duplexNegotiable =
          (decoded['duplexNegotiable'] as bool?) ?? _duplexNegotiable;
      _duplexRoadAccess =
          (decoded['duplexRoadAccess'] as bool?) ?? _duplexRoadAccess;
      _duplexNearbyFacilities
        ..clear()
        ..addAll(
          (decoded['duplexNearbyFacilities'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _farmLandArea.text = (decoded['farmLandArea'] as String?) ?? '';
      _farmBuiltUpArea.text = (decoded['farmBuiltUpArea'] as String?) ?? '';
      _farmUtilities
        ..clear()
        ..addAll(
          (decoded['farmUtilities'] as List?)
                  ?.whereType<String>()
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty) ??
              const <String>[],
        );
      _farmRooms.text = (decoded['farmRooms'] as String?) ?? '';
      _farmGarden = (decoded['farmGarden'] as bool?) ?? _farmGarden;
      _farmSwimmingPool =
          (decoded['farmSwimmingPool'] as bool?) ?? _farmSwimmingPool;
      _village.text = (decoded['village'] as String?) ?? '';
      _landmark.text = (decoded['landmark'] as String?) ?? '';
      _ownerName.text = (decoded['ownerName'] as String?) ?? '';
      _ownerPhone.text = (decoded['ownerPhone'] as String?) ?? '';

      _selectedAmenityIds
        ..clear()
        ..addAll(
          (decoded['selectedAmenityIds'] as List?)?.whereType<num>().map(
                (e) => e.toInt(),
              ) ??
              const [],
        );
      _selectedFurnishingIds
        ..clear()
        ..addAll(
          (decoded['selectedFurnishingIds'] as List?)?.whereType<num>().map(
                (e) => e.toInt(),
              ) ??
              const [],
        );

      _furnishingQuantities
        ..clear()
        ..addAll(
          (decoded['furnishingQuantities'] as Map?)?.entries
                  .map(
                    (e) => MapEntry(
                      int.tryParse(e.key.toString()) ?? 0,
                      (e.value as num).toInt(),
                    ),
                  )
                  .where((e) => e.key >= 0)
                  .fold<Map<int, int>>(
                    <int, int>{},
                    (m, e) => m..[e.key] = e.value,
                  ) ??
              const <int, int>{},
        );

      _address.text = (decoded['address'] as String?) ?? '';
      _city.text = (decoded['city'] as String?) ?? '';
      _state.text = (decoded['state'] as String?) ?? '';
      _pincode.text = (decoded['pincode'] as String?) ?? '';
      _latitudeController.text = (decoded['latitude'] as String?) ?? '';
      _longitudeController.text = (decoded['longitude'] as String?) ?? '';

      _images
        ..clear()
        ..addAll(
          (decoded['images'] as List?)
                  ?.whereType<Map>()
                  .map(
                    (m) => MediaItem(
                      path: (m['path'] as String?) ?? '',
                      type: MediaType.values.firstWhere(
                        (e) => e.name == (m['type'] as String?),
                        orElse: () => MediaType.image,
                      ),
                      tag: m['tag'] as String?,
                    ),
                  )
                  .where((m) => m.path.isNotEmpty) ??
              const <MediaItem>[],
        );
      _primaryImageIndex =
          ((decoded['primaryImageIndex'] as num?)?.toInt() ?? 0).clamp(
            0,
            _images.isEmpty ? 0 : _images.length - 1,
          );
    });
    _handleTotalFloorsChanged();
  }

  int? get _totalFloorsValue {
    final n = int.tryParse(_totalFloors.text.trim());
    if (n == null || n <= 0) return null;
    return n;
  }

  void _handleTotalFloorsChanged() {
    final total = _totalFloorsValue;
    if (total != _lastTotalFloorsValue) {
      _lastTotalFloorsValue = total;
      setState(() {});
    }
    if (total == null) {
      if (_floor.text.isNotEmpty) setState(() => _floor.clear());
      return;
    }
    final current = int.tryParse(_floor.text.trim());
    if (current != null && (current < 1 || current > total)) {
      setState(() => _floor.clear());
    }
  }

  Future<void> _pickAvailableFrom() async {
    final picked = await _pickDateString(_availableFrom.text.trim());
    if (picked == null || !mounted) return;
    setState(() => _availableFrom.text = picked);
    _scheduleSaveDraft();
  }

  Future<void> _pickDateForController(TextEditingController controller) async {
    final picked = await _pickDateString(controller.text.trim());
    if (picked == null || !mounted) return;
    setState(() => controller.text = picked);
    _scheduleSaveDraft();
  }

  Future<String?> _pickDateString(String currentValue) async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(currentValue) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return null;
    final mm = picked.month.toString().padLeft(2, '0');
    final dd = picked.day.toString().padLeft(2, '0');
    return '${picked.year}-$mm-$dd';
  }

  Future<void> _autoFillLocation({bool showUserErrors = false}) async {
    if (_didAttemptAutoLocationFill) return;
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        // Don't mark as attempted; user may grant permission later.
        return;
      }
      _didAttemptAutoLocationFill = true;
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        if (!mounted) return;
        setState(() {
          if (_latitudeController.text.trim().isEmpty) {
            _latitudeController.text = pos.latitude.toStringAsFixed(6);
          }
          if (_longitudeController.text.trim().isEmpty) {
            _longitudeController.text = pos.longitude.toStringAsFixed(6);
          }
        });

        // Reverse geocode to prefill address fields (best-effort).
        try {
          final resolved = await _places.reverseGeocode(
            latitude: pos.latitude,
            longitude: pos.longitude,
          );
          if (!mounted) return;
          setState(() {
            _suppressAddressAutocomplete = true;
            if (_address.text.trim().isEmpty) {
              _address.text = resolved.formattedAddress;
            }
            if ((resolved.locality ?? '').trim().isNotEmpty &&
                _city.text.trim().isEmpty) {
              _city.text = resolved.locality!.trim();
            }
            if ((resolved.administrativeAreaLevel1 ?? '').trim().isNotEmpty &&
                _state.text.trim().isEmpty) {
              _state.text = resolved.administrativeAreaLevel1!.trim();
            }
            if ((resolved.postalCode ?? '').trim().isNotEmpty &&
                _pincode.text.trim().isEmpty) {
              _pincode.text = resolved.postalCode!.trim();
            }
            _suppressAddressAutocomplete = false;
          });
          _validateField('address');
          _validateField('city');
          _validateField('state');
          _validateField('pincode');
        } catch (e) {
          if (showUserErrors &&
              mounted &&
              widget.initialProperty == null &&
              !_didShowPlacesError) {
            _didShowPlacesError = true;
            AppSnackbar.show(
              context,
              'Could not auto-fill address. (${e.toString()})',
            );
          }
          // ignore geocode failures
        }
      }
    } catch (e) {
      // Silent fail - user can enter manually
      _didAttemptAutoLocationFill = false;
    }
  }

  Future<void> _forceAutoFillLocation() async {
    _didAttemptAutoLocationFill = false;
    await _autoFillLocation(showUserErrors: true);
    if (!mounted) return;
    FocusScope.of(context).unfocus();
  }

  void _onAddressChanged(String _) {
    if (_suppressAddressAutocomplete) return;
    _validateField('address');
    _addressDebounce?.cancel();
    _addressDebounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return;
      final q = _address.text.trim();
      if (q.length < 3 || !_addressFocus.hasFocus) {
        setState(() => _addressPredictions = const []);
        return;
      }
      setState(() => _isFetchingAddress = true);
      try {
        final preds = await _places.autocomplete(
          input: q,
          country: 'in',
          language: 'en',
        );
        if (!mounted) return;
        setState(() => _addressPredictions = preds);
      } catch (e) {
        if (!mounted) return;
        setState(() => _addressPredictions = const []);
        if (!_didShowPlacesError && _addressFocus.hasFocus) {
          _didShowPlacesError = true;
          AppSnackbar.show(
            context,
            'Address suggestions not available: ${e.toString()}',
          );
        }
      } finally {
        if (!mounted) return;
        setState(() => _isFetchingAddress = false);
      }
    });
  }

  Future<void> _selectAddressPrediction(PlacePrediction p) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isFetchingAddress = true;
      _addressPredictions = const [];
    });
    try {
      final resolved = await _places.placeDetails(placeId: p.placeId);
      if (!mounted) return;
      setState(() {
        _suppressAddressAutocomplete = true;
        _address.text = resolved.formattedAddress;
        _latitudeController.text = resolved.latitude.toStringAsFixed(6);
        _longitudeController.text = resolved.longitude.toStringAsFixed(6);
        if ((resolved.locality ?? '').trim().isNotEmpty) {
          _city.text = resolved.locality!.trim();
        }
        if ((resolved.administrativeAreaLevel1 ?? '').trim().isNotEmpty) {
          _state.text = resolved.administrativeAreaLevel1!.trim();
        }
        if ((resolved.postalCode ?? '').trim().isNotEmpty) {
          _pincode.text = resolved.postalCode!.trim();
        }
        _suppressAddressAutocomplete = false;
      });
      _validateField('address');
      _validateField('city');
      _validateField('state');
      _validateField('pincode');
    } catch (e) {
      if (mounted) AppSnackbar.show(context, e.toString());
    } finally {
      if (!mounted) return;
      setState(() => _isFetchingAddress = false);
    }
  }

  void _validateField(String field) {
    setState(() {
      switch (field) {
        case 'price':
          _priceErr = Validators.positiveNum(_price.text, label: 'Price');
          break;
        case 'area':
          _areaErr = Validators.positiveNum(_area.text, label: 'Area');
          break;
        case 'desc':
          _descErr = Validators.minLen(
            _description.text,
            15,
            label: 'Description',
          );
          break;
        case 'address':
          _addressErr = Validators.requiredText(
            _address.text,
            label: 'Address',
          );
          break;
        case 'city':
          _cityErr = Validators.requiredText(_city.text, label: 'City');
          break;
        case 'state':
          _stateErr = Validators.requiredText(_state.text, label: 'State');
          break;
        case 'pincode':
          _pincodeErr = Validators.requiredText(
            _pincode.text,
            label: 'Pincode',
          );
          break;
      }
    });
    _maybeAutoAdvanceSections();
  }

  bool get _isBasicSectionComplete {
    final isPgCoLiving =
        _propertyKind == _CreatePropertyKind.pg ||
        _propertyKind == _CreatePropertyKind.coLiving;
    final hasCategory = isPgCoLiving
        ? (_selectedParentCategoryId != null &&
              (_selectedCategorySlug ?? '').trim().isNotEmpty)
        : (_selectedParentCategoryId != null &&
              ((_selectedCategoryId != null) ||
                  ((_selectedCategorySlug ?? '').trim().isNotEmpty)));
    // Basic info should only depend on the top-level selections.
    // Price/Area/Description are validated in their own sections.
    final ok = _propertyKind != null && hasCategory;
    if (kDebugMode) {
      debugPrint(
        'BasicComplete=$ok kind=${_propertyKind?.name} parentId=$_selectedParentCategoryId catId=$_selectedCategoryId parentSlug=${_selectedParentCategorySlug ?? ''} catSlug=${_selectedCategorySlug ?? ''}',
      );
    }
    return ok;
  }

  bool get _isDetailsSectionComplete {
    if (_propertyKind == null) return false;

    final isLandPlot = _isLandPlotContext;
    final isCommercial = _isCommercialContext;
    final isPgCoLiving =
        _propertyKind == _CreatePropertyKind.pg ||
        _propertyKind == _CreatePropertyKind.coLiving;
    final shopAreaValue = double.tryParse(_shopArea.text.trim());
    final showroomAreaValue = double.tryParse(_showroomArea.text.trim());
    final resolvedShopArea = shopAreaValue ?? showroomAreaValue;
    final resolvedShopAreaUnit = _shopAreaUnit.trim().isNotEmpty
        ? _shopAreaUnit
        : (_showroomAreaUnit.trim().isNotEmpty ? _showroomAreaUnit : _areaUnit);

    if (isPgCoLiving) {
      // Minimal required details for PG/Co-living.
      return int.tryParse(_rooms.text.trim()) != null;
    }

    if (isLandPlot) {
      // Plot area should be provided.
      return Validators.positiveNum(_plotArea.text, label: 'Plot Area') == null;
    }

    // If total floors is entered, floor (if entered) must be within range.
    final total = _totalFloorsValue;
    final floor = int.tryParse(_floor.text.trim());
    if (total != null && floor != null && (floor < 1 || floor > total)) {
      return false;
    }

    if (isCommercial) {
      // Require at least commercial type and a valid area (floor plate / area handled in pricing).
      return true;
    }

    // Residential: BHK already maps to bedrooms; bathrooms required.
    return _bathrooms > 0;
  }

  bool get _isPricingSectionComplete {
    final isLandPlot = _isLandPlotContext;
    final priceOk = Validators.positiveNum(_price.text, label: 'Price') == null;
    final areaOk = isLandPlot
        ? true
        : (Validators.positiveNum(_area.text, label: 'Area') == null);
    return priceOk && areaOk;
  }

  bool get _isMediaSectionComplete => _images.isNotEmpty;

  bool get _isDescriptionSectionComplete =>
      Validators.minLen(_description.text, 15, label: 'Description') == null;

  bool get _isLocationSectionComplete =>
      Validators.requiredText(_address.text, label: 'Address') == null &&
      Validators.requiredText(_city.text, label: 'City') == null &&
      Validators.requiredText(_state.text, label: 'State') == null &&
      Validators.requiredText(_pincode.text, label: 'Pincode') == null;

  void _maybeAutoAdvanceSections() {
    if (!mounted) return;
    // Auto-advance disabled: user navigates via the "Next" button.
    return;
    final steps = <({String key, bool Function() done})>[
      (key: 'basic', done: () => _isBasicSectionComplete),
      (key: 'details', done: () => _isDetailsSectionComplete),
      (key: 'pricing', done: () => _isPricingSectionComplete),
      // Amenities/Furnishings are optional; keep them manual (no auto close).
      (key: 'media', done: () => _isMediaSectionComplete),
      (key: 'location', done: () => _isLocationSectionComplete),
      (key: 'description', done: () => _isDescriptionSectionComplete),
    ];

    for (var i = 0; i < steps.length; i++) {
      final step = steps[i];
      if (_expandedSections[step.key] == true && step.done()) {
        final nextKey = i + 1 < steps.length ? steps[i + 1].key : null;
        setState(() {
          _expandedSections[step.key] = false;
          if (nextKey != null) _expandedSections[nextKey] = true;
        });
        return;
      }
    }
  }

  // Auto-advance is intentionally disabled; navigation is via the "Next" button.

  bool get _isFormValid {
    final isLandPlot = _isLandPlotContext;
    final isCommercial = _isCommercialContext;
    final isShopOrShowroom =
        isCommercial &&
        (_commercialType == 'shop' || _commercialType == 'showroom');
    final hasShopOrShowroomArea =
        double.tryParse(_shopArea.text.trim()) != null ||
        double.tryParse(_showroomArea.text.trim()) != null;
    final areaOk = isLandPlot || (isShopOrShowroom && hasShopOrShowroomArea)
        ? true
        : (_areaErr == null);

    _validateField('price');
    if (!(isLandPlot || (isShopOrShowroom && hasShopOrShowroomArea))) {
      _validateField('area');
    } else {
      _areaErr = null;
    }
    _validateField('desc');
    _validateField('address');
    _validateField('city');
    _validateField('state');
    _validateField('pincode');
    return _priceErr == null &&
        areaOk &&
        _descErr == null &&
        _addressErr == null &&
        _cityErr == null &&
        _stateErr == null &&
        _pincodeErr == null &&
        _images.isNotEmpty;
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage(imageQuality: 85);
    if (files.isEmpty) return;

    setState(() {
      for (final f in files) {
        if (_images.length >= 20) break;
        _images.add(
          MediaItem(
            path: f.path,
            type: MediaType.image,
            tag: _getDefaultTagForIndex(_images.length),
          ),
        );
      }
      if (_primaryImageIndex >= _images.length && _images.isNotEmpty)
        _primaryImageIndex = 0;
    });
    _scheduleSaveDraft();
  }

  Future<void> _pickImageCamera() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (file != null) {
      setState(() {
        if (_images.length < 20) {
          _images.add(
            MediaItem(
              path: file.path,
              type: MediaType.image,
              tag: _getDefaultTagForIndex(_images.length),
            ),
          );
        }
      });
      _scheduleSaveDraft();
    }
  }

  Future<void> _pickVideos() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiVideo();
    if (files.isEmpty) return;

    setState(() {
      for (final f in files) {
        if (_videos.length >= 5) break;
        _videos.add(
          MediaItem(path: f.path, type: MediaType.video, tag: 'property_video'),
        );
      }
    });
  }

  Future<void> _pickVideoCamera() async {
    final picker = ImagePicker();
    final file = await picker.pickVideo(source: ImageSource.camera);
    if (file != null && _videos.length < 5) {
      setState(() {
        _videos.add(
          MediaItem(
            path: file.path,
            type: MediaType.video,
            tag: 'property_video',
          ),
        );
      });
    }
  }

  String _getDefaultTagForIndex(int index) {
    if (index < _bedrooms) return 'Bedroom ${index + 1}';
    if (index < _bedrooms + _bathrooms)
      return 'Bathroom ${index - _bedrooms + 1}';
    if (index == _bedrooms + _bathrooms) return 'Living Room';
    if (index == _bedrooms + _bathrooms + 1) return 'Kitchen';
    return 'Exterior';
  }

  List<String> _getAvailableTags() {
    final tags = <String>['general'];
    for (var i = 1; i <= _bedrooms; i++) {
      tags.add('Bedroom $i');
    }
    for (var i = 1; i <= _bathrooms; i++) {
      tags.add('Bathroom $i');
    }
    tags.addAll([
      'Living Room',
      'Kitchen',
      'Balcony',
      'Terrace',
      'Garden',
      'Parking',
      'Drone',
      'Swimming Pool',
      'Gym',
      'Clubhouse',
      'Exterior',
      'Entrance',
    ]);
    // Ensure DropdownButton values are unique.
    return tags.toSet().toList(growable: false);
  }

  void _updateImageTag(int index, String newTag) {
    setState(() {
      _images[index].tag = newTag;
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      if (_primaryImageIndex >= _images.length && _images.isNotEmpty)
        _primaryImageIndex = _images.length - 1;
    });
  }

  void _removeVideo(int index) {
    setState(() {
      _videos.removeAt(index);
    });
  }

  Future<void> _create() async {
    if (!_isFormValid) {
      final issues = <String>[];
      if (_images.isEmpty) issues.add('add at least one image');
      if (_priceErr != null) issues.add('enter valid price');
      if (_areaErr != null) issues.add('enter valid area');
      if (_descErr != null) issues.add('enter description (min 15 chars)');
      if (_addressErr != null ||
          _cityErr != null ||
          _stateErr != null ||
          _pincodeErr != null) {
        issues.add('complete location details');
      }
      AppSnackbar.show(
        context,
        issues.isEmpty
            ? 'Please fill all required fields'
            : 'Please ${issues.join(', ')}',
      );
      return;
    }

    final isEdit = widget.initialProperty != null;
    await _ensureLatLngBeforeSubmit();
    final ensuredLat = double.tryParse(_latitudeController.text.trim());
    final ensuredLng = double.tryParse(_longitudeController.text.trim());
    if (ensuredLat == null || ensuredLng == null) {
      if (mounted) {
        AppSnackbar.show(
          context,
          'Latitude/Longitude required. Please select address from suggestions or use Auto Fill Location.',
        );
      }
      return;
    }
    final id = isEdit
        ? widget.initialProperty!.id
        : 'prop_${DateTime.now().millisecondsSinceEpoch}';
    final generatedTitle = _title.text.trim().isNotEmpty
        ? _title.text.trim()
        : 'Property $id';
    final price = double.tryParse(_price.text.trim()) ?? 0;
    final area = double.tryParse(_area.text.trim());
    final floor = int.tryParse(_floor.text.trim());
    final totalFloors = int.tryParse(_totalFloors.text.trim());

    if (floor != null && totalFloors != null && totalFloors < floor) {
      if (mounted) {
        AppSnackbar.show(
          context,
          'The total floors field must be greater than or equal to floor.',
        );
      }
      return;
    }

    final lat = ensuredLat;
    final lng = ensuredLng;

    final isLandPlot = _isLandPlotContext;
    final isCommercial = _isCommercialContext;
    final isPgCoLiving =
        _propertyKind == _CreatePropertyKind.pg ||
        _propertyKind == _CreatePropertyKind.coLiving;

    final property = Property(
      id: id,
      name: generatedTitle,
      ownerName: '',
      location: '${_city.text.trim()}, ${_state.text.trim()}',
      price: price,
      type: _type,
      amenities: const [],
      images: _images.map((e) => e.path).toList(),
      videos: const [],
      description: _description.text.trim(),
      status: PropertyStatus.pending,
      area: area,
      areaUnit: _areaUnit,
      slug: generatedTitle.toLowerCase().replaceAll(' ', '-'),
      listingType: _listingType,
      facing: _facing,
      floor: isLandPlot ? null : floor,
      totalFloors: isLandPlot ? null : totalFloors,
      balconies: _isResidential ? (_balconies >= 0 ? _balconies : 0) : null,
      builtUpArea: double.tryParse(_builtUpArea.text.trim()),
      availability: _availability,
      possessionBy: _possessionBy.text.trim().isEmpty
          ? null
          : _possessionBy.text.trim(),
      ownership: _ownership.isEmpty ? null : _ownership,
      additionalRooms: () {
        if (!_isResidential) return null;
        final rooms =
            (_isSellResidentialApartment
                    ? _additionalRooms
                    : _isSellResidentialVillaHouse
                    ? _villaAdditionalRooms
                    : _isRentLeaseResidentialApartment
                    ? _rentAdditionalRooms
                    : <String>{})
                .toList(growable: false);
        return rooms.isNotEmpty ? rooms : null;
      }(),
      bookingAmount: (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeBookingAmount.text.trim())
          : _isResidential
          ? double.tryParse(
              (_isSellResidentialVillaHouse
                      ? _villaBookingAmount
                      : _bookingAmount)
                  .text
                  .trim(),
            )
          : double.tryParse(_bookingAmount.text.trim()),

      maintenanceCharges: isPgCoLiving
          ? double.tryParse(_pgMaintenanceCharges.text.trim())
          : (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeMaintenanceCharges.text.trim())
          : _isResidential
          ? double.tryParse(
              ((_propertyKind == _CreatePropertyKind.rent ||
                          _propertyKind == _CreatePropertyKind.lease)
                      ? _rentMaintenanceCharges
                      : _isSellResidentialVillaHouse
                      ? _villaMaintenanceCharges
                      : _maintenanceCharges)
                  .text
                  .trim(),
            )
          : double.tryParse(_maintenanceCharges.text.trim()),

      possessionStatus: 'ready',
      bedrooms: (isLandPlot || isCommercial) ? null : _bedrooms,
      bathrooms: (isLandPlot || isCommercial) ? null : _bathrooms,
      furnishing: (isLandPlot || isCommercial) ? null : _furnishing,
      parking: _parking,
      address: _address.text.trim(),
      city: _city.text.trim(),
      state: _state.text.trim(),
      pincode: _pincode.text.trim(),
      latitude: lat,
      longitude: lng,
      primaryImageIndex: _primaryImageIndex,
      updatedAt: DateTime.now(),
      amenityIds: _selectedAmenityIds.toList(growable: false),
      categoryId: (_selectedCategorySlug == 'farmhouse')
          ? null
          : _selectedCategoryId?.toString(),
      apiFields: _buildApiFields(),
      sectionImagePaths: _buildSectionImages(),
      documentPaths: _videos.map((e) => e.path).toList(),
      furnishingSelections: _selectedFurnishingIds
          .map(
            (id) => PropertyFurnishingSelection(
              id: id,
              quantity: _furnishingQuantities[id] ?? 1,
            ),
          )
          .toList(growable: false),
    );

    debugPrint(
      '[PropertyCreateScreen] _submit() '
      'isSellVillaHouse=$_isSellResidentialVillaHouse '
      'isSellBuilderFloor=$_isSellResidentialBuilderFloor '
      'controllerText="${_maintenanceCharges.text}" '
      'parsedMaintenanceCharges=${property.maintenanceCharges} '
      'apiFieldsMaintenanceCharges=${property.apiFields?['maintenance_charges']}',
    );

    try {
      if (isEdit) {
        await ref.read(propertyActionsProvider.notifier).update(property);
      } else {
        await ref.read(propertyActionsProvider.notifier).create(property);
        await _clearDraft();
      }
      if (!mounted) return;
      AppSnackbar.show(
        context,
        isEdit
            ? 'Property updated successfully!'
            : 'Property listed successfully!',
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) AppSnackbar.show(context, e.toString());
    }
  }

  Future<void> _ensureLatLngBeforeSubmit() async {
    final hasLatLng =
        _latitudeController.text.trim().isNotEmpty &&
        _longitudeController.text.trim().isNotEmpty;
    if (hasLatLng) return;
    await _autoFillLocation(showUserErrors: false);
  }

  Map<String, dynamic> _buildApiFields() {
    final isLandPlot = _isLandPlotContext;
    final isCommercial = _isCommercialContext;
    final isPgCoLiving =
        _propertyKind == _CreatePropertyKind.pg ||
        _propertyKind == _CreatePropertyKind.coLiving;
    final seatsValue = int.tryParse(_seats.text.trim());
    final maxSeatsValue = int.tryParse(_maxSeats.text.trim());
    final normalizedMaxSeats = (isCommercial && _commercialType == 'office')
        ? _normalizeOfficeMaxSeats(
            seatsValue: seatsValue,
            maxSeatsValue: maxSeatsValue,
          )
        : maxSeatsValue;
    final shopAreaValue = double.tryParse(_shopArea.text.trim());
    final showroomAreaValue = double.tryParse(_showroomArea.text.trim());
    final resolvedShopArea = shopAreaValue ?? showroomAreaValue;
    final resolvedShopAreaUnit = _shopAreaUnit.trim().isNotEmpty
        ? _shopAreaUnit
        : (_showroomAreaUnit.trim().isNotEmpty ? _showroomAreaUnit : _areaUnit);

    final String resolvedType;
    switch (_propertyKind) {
      case _CreatePropertyKind.sale:
        resolvedType = 'sale';
        break;
      case _CreatePropertyKind.rent:
        resolvedType = 'rent';
        break;
      case _CreatePropertyKind.lease:
        resolvedType = 'lease';
        break;
      case _CreatePropertyKind.pg:
        resolvedType = 'pg';
        break;
      case _CreatePropertyKind.coLiving:
        resolvedType = 'co_living';
        break;
      default:
        resolvedType = _type.name;
    }

    return {
      'type': resolvedType,
      'property_kind': isPgCoLiving
          ? 'pg'
          : (isLandPlot
                ? 'plot'
                : (isCommercial ? 'commercial' : 'residential')),
      'pg_food_availability': isPgCoLiving
          ? _normalizePgFoodAvailabilityForApi(_pgFoodAvailability)
          : null,
      'pg_sharing': isPgCoLiving ? _pgSharing : null,
      'pg_gender_based': isPgCoLiving
          ? _normalizePgGenderForApi(_pgGenderBased)
          : null,
      'pg_occupancy_type': isPgCoLiving
          ? _normalizePgOccupancyForApi(_pgOccupancyType)
          : null,
      'pg_tenant_types': isPgCoLiving ? _pgTenantTypes.toList() : null,
      'pg_property_type': isPgCoLiving
          ? _normalizePgPropertyTypeForApi(_pgPropertyType)
          : null,
      'pg_furnishing_type': isPgCoLiving
          ? _normalizePgFurnishingTypeForApi(_furnishing)
          : null,
      'pg_bathroom_type': isPgCoLiving ? _pgBathroomType : null,
      'pg_suitable_for': isPgCoLiving ? _pgSuitableFor : null,
      'pg_building_name': isPgCoLiving && _pgBuildingName.text.trim().isNotEmpty
          ? _pgBuildingName.text.trim()
          : null,
      'pg_total_beds': isPgCoLiving
          ? int.tryParse(_pgTotalBeds.text.trim())
          : null,
      'pg_available_beds': isPgCoLiving
          ? int.tryParse(_pgAvailableBeds.text.trim())
          : null,
      'pg_total_rooms': isPgCoLiving ? int.tryParse(_rooms.text.trim()) : null,
      'pg_room_type': isPgCoLiving ? _pgRoomType : null,
      'pg_attached_bathroom': isPgCoLiving ? _pgAttachedBathroom : null,
      'attached_bathroom': isPgCoLiving ? _pgAttachedBathroom : null,
      'attached_washroom': isPgCoLiving ? (_pgAttachedBathroom ? 1 : 0) : null,
      'pg_balcony': isPgCoLiving ? _pgBalcony : null,
      'balcony': isPgCoLiving ? _pgBalcony : null,
      'pg_room_size': isPgCoLiving && _pgRoomSize.text.trim().isNotEmpty
          ? _pgRoomSize.text.trim()
          : null,
      'room_size': isPgCoLiving && _pgRoomSize.text.trim().isNotEmpty
          ? _pgRoomSize.text.trim()
          : null,
      'pg_room_size_unit': isPgCoLiving ? _areaUnit : null,
      'room_size_unit': isPgCoLiving ? _areaUnit : null,
      'pg_bed_type': isPgCoLiving ? _pgBedType : null,
      'bed_type': isPgCoLiving ? _pgBedType : null,
      'pg_cupboard_available': isPgCoLiving ? _pgCupboardAvailable : null,
      'cupboard_available': isPgCoLiving ? _pgCupboardAvailable : null,
      'pg_study_table_available': isPgCoLiving ? _pgStudyTableAvailable : null,
      'study_table_available': isPgCoLiving ? _pgStudyTableAvailable : null,
      'pg_security_deposit': isPgCoLiving
          ? double.tryParse(_pgSecurityDeposit.text.trim())
          : null,
      'security_deposit': isPgCoLiving
          ? double.tryParse(_pgSecurityDeposit.text.trim())
          : (((_propertyKind == _CreatePropertyKind.rent ||
                        _propertyKind == _CreatePropertyKind.lease) &&
                    _isResidential)
                ? double.tryParse(_securityDeposit.text.trim())
                : null),
      'pg_maintenance_charges': isPgCoLiving
          ? double.tryParse(_pgMaintenanceCharges.text.trim())
          : null,
      'maintenance_charges': isPgCoLiving
          ? double.tryParse(_pgMaintenanceCharges.text.trim())
          : (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeMaintenanceCharges.text.trim())
          : _isResidential
          ? double.tryParse(
              ((_propertyKind == _CreatePropertyKind.rent ||
                          _propertyKind == _CreatePropertyKind.lease)
                      ? _rentMaintenanceCharges
                      : _isSellResidentialVillaHouse
                      ? _villaMaintenanceCharges
                      : _maintenanceCharges)
                  .text
                  .trim(),
            )
          : double.tryParse(_maintenanceCharges.text.trim()),
      'pg_electricity_included': isPgCoLiving ? _pgElectricityIncluded : null,
      'electricity_included': isPgCoLiving ? _pgElectricityIncluded : null,
      'pg_water_included': isPgCoLiving ? _pgWaterIncluded : null,
      'water_included': isPgCoLiving ? _pgWaterIncluded : null,
      'pg_food_charges_included': isPgCoLiving ? _pgFoodChargesIncluded : null,
      'food_charges_included': isPgCoLiving ? _pgFoodChargesIncluded : null,
      'food_preference': isPgCoLiving
          ? _normalizePgFoodPreferenceForApi(_pgFoodAvailability)
          : (_isRentLeaseResidentialApartment ? _foodPreference : null),
      'pg_brokerage_required': isPgCoLiving ? _pgBrokerageRequired : null,
      'pg_couple_friendly': isPgCoLiving ? _pgCoupleFriendly : null,
      'pg_id_proof_required': isPgCoLiving ? _pgIdProofRequired : null,
      'pg_available_from': isPgCoLiving ? _pgAvailableFrom.text.trim() : null,
      'pg_min_stay_days': isPgCoLiving
          ? int.tryParse(_pgMinStayDays.text.trim())
          : null,
      'pg_notice_period_days': isPgCoLiving
          ? int.tryParse(_pgNoticePeriodDays.text.trim())
          : null,
      'pg_preferred_tenant_age': isPgCoLiving
          ? int.tryParse(_pgPreferredTenantAge.text.trim())
          : null,
      'pg_smoking_allowed': isPgCoLiving ? _pgSmokingAllowed : null,
      'pg_drinking_allowed': isPgCoLiving ? _pgDrinkingAllowed : null,
      'pg_pets_allowed': isPgCoLiving ? _pgPetsAllowed : null,
      'pg_visitors_allowed': isPgCoLiving ? _pgVisitorsAllowed : null,
      'pg_curfew_time': isPgCoLiving ? _pgCurfewTime.text.trim() : null,
      'pg_gate_locked_at_night': isPgCoLiving ? _pgGateLockedAtNight : null,
      'pg_nearby_preferences': isPgCoLiving
          ? _pgNearbyPreferences.toList()
          : null,
      'pg_availability': isPgCoLiving ? _pgAvailability : null,
      'pg_security': isPgCoLiving ? _pgSecurity : null,
      'carpet_area': double.tryParse(_carpetArea.text.trim()),
      'built_up_area': double.tryParse(_builtUpArea.text.trim()),
      'super_built_up_area': double.tryParse(_superBuiltUpArea.text.trim()),
      'plot_area': double.tryParse(_plotArea.text.trim()),
      'plot_length': double.tryParse(_length.text.trim()),
      'plot_width': double.tryParse(_breadth.text.trim()),
      'floors_allowed': int.tryParse(_floorsAllowed.text.trim()),
      'open_sides': _openSides,
      'boundary_wall': _boundaryWall,
      'construction_done': _constructionDone,
      'availability': _availability,
      'ready_timeframe': _readyTimeframe,
      'property_age_range': _readyTimeframe,
      'property_age': () {
        switch (_readyTimeframe) {
          case '0_1':
            return 1;
          case '1_5':
            return 3;
          case '5_10':
            return 7;
          case '10_plus':
            return 10;
          default:
            return null;
        }
      }(),
      'property_age_years': () {
        switch (_readyTimeframe) {
          case '0_1':
            return 1;
          case '1_5':
            return 3;
          case '5_10':
            return 7;
          case '10_plus':
            return 10;
          default:
            return null;
        }
      }(),
      'possession_by': _possessionBy.text.trim().isEmpty
          ? null
          : _possessionBy.text.trim(),
      'ownership': _ownership.isEmpty ? null : _ownership,
      'balconies': _isResidential ? (_balconies >= 0 ? _balconies : 0) : null,
      'commercial_type': isCommercial ? _commercialType : null,
      'floor_plate_area': isCommercial
          ? double.tryParse(_floorPlateArea.text.trim())
          : null,
      'cabins': isCommercial ? int.tryParse(_cabins.text.trim()) : null,
      'meeting_rooms': isCommercial
          ? int.tryParse(_meetingRooms.text.trim())
          : null,
      'seats': isCommercial ? seatsValue : null,
      'max_seats': isCommercial ? normalizedMaxSeats : null,
      'conference_rooms': isCommercial
          ? int.tryParse(_conferenceRooms.text.trim())
          : null,
      'lift_available': isCommercial ? _liftAvailable : null,
      'goods_lift': isCommercial ? _liftAvailable : null,
      'loading_dock': (isCommercial && _commercialType == 'office')
          ? _liftAvailable
          : null,
      'commercial_parking': (isCommercial && _commercialType == 'office')
          ? _visitorParking
          : null,
      'pre_leased': isCommercial ? _preLeased : null,
      'office_type': (isCommercial && _commercialType == 'office')
          ? _normalizeOfficeTypeForApi(_officeType)
          : null,
      'reception_area': (isCommercial && _commercialType == 'office')
          ? _receptionArea
          : null,
      'pantry': (isCommercial && _commercialType == 'office') ? _pantry : null,
      'cafeteria': (isCommercial && _commercialType == 'office')
          ? _cafeteria
          : null,
      'server_room': (isCommercial && _commercialType == 'office')
          ? _serverRoom
          : null,
      'fire_safety_installed': (isCommercial && _commercialType == 'office')
          ? _fireSafetyInstalled
          : null,
      'central_ac': (isCommercial && _commercialType == 'office')
          ? _centralAC
          : null,
      'visitor_parking': (isCommercial && _commercialType == 'office')
          ? _visitorParking
          : null,
      'number_of_lifts': (isCommercial && _commercialType == 'office')
          ? int.tryParse(_numberOfLifts.text.trim())
          : null,
      'tax_included': (isCommercial && _commercialType == 'office')
          ? _taxIncluded
          : null,
      'price_negotiable_office': (isCommercial && _commercialType == 'office')
          ? (_officeNegotiable == null ? null : (_officeNegotiable! ? 1 : 0))
          : null,
      'negotiable': (isCommercial && _commercialType == 'office')
          ? (_officeNegotiable == null ? null : (_officeNegotiable! ? 1 : 0))
          : (_isSellResidentialBuilderFloor
                ? (_builderNegotiable == null
                      ? null
                      : (_builderNegotiable! ? 1 : 0))
                : null),
      'office_maintenance_charges':
          (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeMaintenanceCharges.text.trim())
          : null,
      'maintenance_charges_office':
          (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeMaintenanceCharges.text.trim())
          : null,
      'office_booking_amount': (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeBookingAmount.text.trim())
          : null,
      'booking_amount_office': (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeBookingAmount.text.trim())
          : null,
      'booking_amount': (isCommercial && _commercialType == 'office')
          ? double.tryParse(_officeBookingAmount.text.trim())
          : _isResidential
          ? double.tryParse(
              (_isSellResidentialVillaHouse
                      ? _villaBookingAmount
                      : _bookingAmount)
                  .text
                  .trim(),
            )
          : null,
      'floor_plate_area_unit': (isCommercial && _commercialType == 'office')
          ? _areaUnit
          : null,
      'shop_type': (isCommercial && _commercialType == 'shop')
          ? _shopType
          : null,
      'shop_area':
          (isCommercial &&
              (_commercialType == 'shop' || _commercialType == 'showroom'))
          ? resolvedShopArea
          : null,
      'shop_area_unit':
          (isCommercial &&
              (_commercialType == 'shop' || _commercialType == 'showroom'))
          ? resolvedShopAreaUnit
          : null,
      'showroom_area': (isCommercial && _commercialType == 'shop')
          ? double.tryParse(_shopArea.text.trim())
          : ((isCommercial && _commercialType == 'showroom')
                ? double.tryParse(_showroomArea.text.trim())
                : null),
      'showroom_area_unit': (isCommercial && _commercialType == 'shop')
          ? _shopAreaUnit
          : ((isCommercial && _commercialType == 'showroom')
                ? _showroomAreaUnit
                : null),
      'frontage_width_ft': (isCommercial && _commercialType == 'shop')
          ? double.tryParse(_frontageWidth.text.trim())
          : null,
      'frontage_width': (isCommercial && _commercialType == 'shop')
          ? double.tryParse(_frontageWidth.text.trim())
          : null,
      'ceiling_height_ft': (isCommercial && _commercialType == 'shop')
          ? double.tryParse(_ceilingHeight.text.trim())
          : null,
      'ceiling_height': (isCommercial && _commercialType == 'shop')
          ? (_ceilingHeight.text.trim().isEmpty
                ? null
                : _ceilingHeight.text.trim())
          : null,
      'main_road_facing': (isCommercial && _commercialType == 'shop' && _mainRoadFacing != null)
          ? (_mainRoadFacing! ? 1 : 0)
          : null,
      'corner_shop': (isCommercial && _commercialType == 'shop' && _cornerShop != null)
          ? (_cornerShop! ? 1 : 0)
          : null,
      'washroom_available': (isCommercial && _commercialType == 'shop' && _washroomAvailable != null)
          ? (_washroomAvailable! ? 1 : 0)
          : null,
      'floor_type': (isCommercial && _commercialType == 'shop' && _floorType.trim().isNotEmpty)
          ? _floorType.trim()
          : (isCommercial && _commercialType == 'showroom' && _showroomFloorType.trim().isNotEmpty)
              ? _showroomFloorType.trim()
              : null,
      'parking_slots': (isCommercial && _commercialType == 'shop')
          ? _parking
          : null,
      'market_name': (isCommercial && _commercialType == 'shop')
          ? (_marketName.text.trim().isEmpty ? null : _marketName.text.trim())
          : null,
      'locality': (isCommercial && _commercialType == 'shop')
          ? (_locality.text.trim().isEmpty ? null : _locality.text.trim())
          : null,
      'owner_name': () {
        final val = _ownerName.text.trim();
        if (val.isNotEmpty) return val;
        if (isCommercial && _commercialType == 'shop') {
          return _showroomOwnerName.text.trim().isEmpty
              ? null
              : _showroomOwnerName.text.trim();
        }
        if (isCommercial && _commercialType == 'showroom') {
          return _showroomOwnerName.text.trim().isEmpty
              ? null
              : _showroomOwnerName.text.trim();
        }
        return null;
      }(),
      'owner_phone': () {
        final val = _ownerPhone.text.trim();
        if (val.isNotEmpty) return val;
        if (isCommercial && _commercialType == 'shop') {
          return _showroomOwnerMobile.text.trim().isEmpty
              ? null
              : _showroomOwnerMobile.text.trim();
        }
        if (isCommercial && _commercialType == 'showroom') {
          return _showroomOwnerMobile.text.trim().isEmpty
              ? null
              : _showroomOwnerMobile.text.trim();
        }
        return null;
      }(),
      'owner_mobile': () {
        final val = _ownerPhone.text.trim();
        if (val.isNotEmpty) return val;
        if (isCommercial && _commercialType == 'shop') {
          return _showroomOwnerMobile.text.trim().isEmpty
              ? null
              : _showroomOwnerMobile.text.trim();
        }
        if (isCommercial && _commercialType == 'showroom') {
          return _showroomOwnerMobile.text.trim().isEmpty
              ? null
              : _showroomOwnerMobile.text.trim();
        }
        return null;
      }(),
      'showroom_frontage_width_ft':
          (isCommercial && _commercialType == 'showroom')
          ? double.tryParse(_showroomFrontageWidth.text.trim())
          : null,
      'showroom_ceiling_height_ft':
          (isCommercial && _commercialType == 'showroom')
          ? double.tryParse(_showroomCeilingHeight.text.trim())
          : null,
      'showroom_main_road_facing':
          (isCommercial && _commercialType == 'showroom' && _showroomMainRoadFacing != null)
          ? (_showroomMainRoadFacing! ? 1 : 0)
          : null,
      'corner_showroom': (isCommercial && _commercialType == 'showroom' && _showroomCorner != null)
          ? (_showroomCorner! ? 1 : 0)
          : null,
      'showroom_washroom_available':
          (isCommercial && _commercialType == 'showroom' && _showroomWashroom != null)
          ? (_showroomWashroom! ? 1 : 0)
          : null,
      'showroom_parking_slots': (isCommercial && _commercialType == 'showroom')
          ? int.tryParse(_showroomParkingSlots.text.trim())
          : null,
      'showroom_furnishing_status':
          (isCommercial && _commercialType == 'showroom')
          ? _showroomFurnishing
          : null,
      'showroom_floor_type': (isCommercial && _commercialType == 'showroom' && _showroomFloorType.trim().isNotEmpty)
          ? _showroomFloorType.trim()
          : null,
      'showroom_market_name': (isCommercial && _commercialType == 'showroom')
          ? (_showroomMarketName.text.trim().isEmpty
                ? null
                : _showroomMarketName.text.trim())
          : null,
      'showroom_locality': (isCommercial && _commercialType == 'showroom')
          ? (_showroomLocality.text.trim().isEmpty
                ? null
                : _showroomLocality.text.trim())
          : null,
      'showroom_owner_name': (isCommercial && _commercialType == 'showroom')
          ? (_showroomOwnerName.text.trim().isEmpty
                ? null
                : _showroomOwnerName.text.trim())
          : null,
      'showroom_owner_mobile': (isCommercial && _commercialType == 'showroom')
          ? (_showroomOwnerMobile.text.trim().isEmpty
                ? null
                : _showroomOwnerMobile.text.trim())
          : null,
      'warehouse_type': (isCommercial && _commercialType == 'warehouse')
          ? _warehouseType
          : null,
      'warehouse_plot_area': (isCommercial && _commercialType == 'warehouse')
          ? double.tryParse(_warehousePlotArea.text.trim())
          : null,
      'warehouse_plot_area_unit':
          (isCommercial && _commercialType == 'warehouse')
          ? _warehousePlotAreaUnit
          : null,
      'warehouse_ceiling_height_ft':
          (isCommercial && _commercialType == 'warehouse')
          ? double.tryParse(_warehouseCeilingHeight.text.trim())
          : null,
      'loading_bays': (isCommercial && _commercialType == 'warehouse')
          ? int.tryParse(_warehouseLoadingBays.text.trim())
          : null,
      'dock_levelers': (isCommercial && _commercialType == 'warehouse')
          ? int.tryParse(_warehouseDockLevelers.text.trim())
          : null,
      'power_supply': (isCommercial && _commercialType == 'warehouse')
          ? (_warehousePowerSupply.text.trim().isEmpty
                ? null
                : _warehousePowerSupply.text.trim())
          : null,
      'industrial_license': (isCommercial && _commercialType == 'warehouse')
          ? _warehouseIndustrialLicense
          : null,
      'truck_access': (isCommercial && _commercialType == 'warehouse')
          ? _warehouseTruckAccess
          : null,
      'industrial_area_name': (isCommercial && _commercialType == 'warehouse')
          ? (_warehouseAreaName.text.trim().isEmpty
                ? null
                : _warehouseAreaName.text.trim())
          : null,
      'industrial_area_city': (isCommercial && _commercialType == 'warehouse')
          ? (_warehouseCity.text.trim().isEmpty
                ? null
                : _warehouseCity.text.trim())
          : null,
      'shop_facade': isCommercial
          ? (_shopFacade.text.trim().isEmpty ? null : _shopFacade.text.trim())
          : null,
      'washrooms': isCommercial ? int.tryParse(_washrooms.text.trim()) : null,
      'parking_type': isCommercial ? _parkingType : null,
      'plot_type': isCommercial
          ? (_plotType.text.trim().isEmpty ? null : _plotType.text.trim())
          : null,
      'rooms': (isCommercial || isPgCoLiving)
          ? int.tryParse(_rooms.text.trim())
          : null,
      'quality_rating': isCommercial
          ? double.tryParse(_qualityRating.text.trim())
          : null,
      'land_type': isLandPlot ? _landType : null,
      'road_width_ft': isLandPlot
          ? double.tryParse(_roadWidth.text.trim())
          : null,
      'plot_area_unit': isLandPlot ? _plotAreaUnit : null,
      'road_access': isLandPlot ? _plotRoadAccess : null,
      'fencing': (isLandPlot && _landType == 'agricultural')
          ? _agriFencing
          : null,
      'agri_fencing': (isLandPlot && _landType == 'agricultural')
          ? _agriFencing
          : null,
      'water_source': (isLandPlot && _landType == 'agricultural')
          ? _agriWaterSource
          : (_isSellResidentialVillaHouse ? _waterSource : null),
      'agri_water_source': (isLandPlot && _landType == 'agricultural')
          ? _agriWaterSource
          : null,
      'farm_land_area': isLandPlot
          ? double.tryParse(_plotArea.text.trim())
          : (_isSellResidentialFarmhouse
                ? double.tryParse(_farmLandArea.text.trim())
                : null),
      'farm_built_up_area': isLandPlot
          ? double.tryParse(_builtUpArea.text.trim())
          : (_isSellResidentialFarmhouse
                ? double.tryParse(_farmBuiltUpArea.text.trim())
                : null),
      'farm_rooms': isLandPlot
          ? int.tryParse(_rooms.text.trim())
          : (_isSellResidentialFarmhouse
                ? int.tryParse(_farmRooms.text.trim())
                : null),
      'farm_garden': isLandPlot
          ? _boundaryWall
          : (_isSellResidentialFarmhouse ? _farmGarden : null),
      'farm_swimming_pool': isLandPlot
          ? false
          : (_isSellResidentialFarmhouse ? _farmSwimmingPool : null),
      'farm_utilities': isLandPlot
          ? <String>[]
          : (_isSellResidentialFarmhouse
                ? _farmUtilities.toList(growable: false)
                : null),
      'farm_monthly_charges': isLandPlot
          ? double.tryParse(_maintenanceCharges.text.trim())
          : (_isSellResidentialFarmhouse
                ? double.tryParse(_farmMonthlyCharges.text.trim())
                : (_isRentLeaseResidentialFarmhouse
                      ? double.tryParse(_farmMonthlyCharges.text.trim())
                      : null)),
      'farm_daily_charges': _isRentLeaseResidentialFarmhouse
          ? double.tryParse(_farmDailyCharges.text.trim())
          : null,
      'farm_event_charges': _isRentLeaseResidentialFarmhouse
          ? double.tryParse(_farmEventCharges.text.trim())
          : null,
      'min_stay_days': isLandPlot
          ? int.tryParse(_pgMinStayDays.text.trim())
          : (_isRentLeaseResidentialFarmhouse
                ? int.tryParse(_minStayDays.text.trim())
                : null),

      // Sell -> Residential -> Flat/Apartment extra fields
      'corner_property':
          ((_cornerProperty ?? false) ||
              (_rentCornerProperty ?? false) ||
              (_villaCornerProperty ?? false) ||
              (_builderCornerProperty ?? false) ||
              (_duplexCornerPlot ?? false) ||
              (_cornerShop ?? false) ||
              (_showroomCorner ?? false) ||
              (_plotCorner ?? false))
          ? 1
          : 0,
      'price_negotiable': (_propertyKind == _CreatePropertyKind.sale)
          ? (_isSellResidentialVillaHouse
                ? (_villaPriceNegotiable == null
                      ? null
                      : (_villaPriceNegotiable! ? 1 : 0))
                : (_priceNegotiable == null
                      ? null
                      : (_priceNegotiable! ? 1 : 0)))
          : null,
      'additional_rooms': () {
        if (!_isResidential) return null;
        final rooms =
            (_isSellResidentialApartment
                    ? _additionalRooms
                    : _isSellResidentialVillaHouse
                    ? _villaAdditionalRooms
                    : _isRentLeaseResidentialApartment
                    ? _rentAdditionalRooms
                    : <String>{})
                .toList(growable: false);
        return rooms.isNotEmpty ? rooms : null;
      }(),
      'property_highlights': _isSellResidentialApartment
          ? _propertyHighlights.toList(growable: false)
          : null,
      'whatsapp_updates': _isSellResidentialApartment ? _whatsappUpdates : null,
      'promotion': _isSellResidentialApartment
          ? _promotionTags.toList(growable: false)
          : null,
      'pet_friendly': _isRentLeaseResidentialApartment ? _petFriendly : null,
      'wheelchair_friendly': _isRentLeaseResidentialApartment
          ? _wheelchairFriendly
          : null,
      'gated_society_rent': _isRentLeaseResidentialApartment
          ? _rentGatedSociety
          : null,
      'brokerage':
          ((_propertyKind == _CreatePropertyKind.rent ||
                  _propertyKind == _CreatePropertyKind.lease) &&
              _isResidential)
          ? double.tryParse(_brokerage.text.trim())
          : null,
      'rent_negotiable':
          ((_propertyKind == _CreatePropertyKind.rent ||
                  _propertyKind == _CreatePropertyKind.lease) &&
              _isResidential)
          ? _rentNegotiable
          : null,
      'available_from':
          ((_propertyKind == _CreatePropertyKind.rent ||
                  _propertyKind == _CreatePropertyKind.lease) &&
              _isResidential)
          ? (_availableFrom.text.trim().isEmpty
                ? null
                : _availableFrom.text.trim())
          : null,
      'lease_duration_months': _isRentLeaseResidentialApartment
          ? int.tryParse(_leaseDurationMonths.text.trim())
          : null,
      'lock_in_months': _isRentLeaseResidentialApartment
          ? int.tryParse(_lockInMonths.text.trim())
          : null,
      'notice_period_value': _isRentLeaseResidentialApartment
          ? int.tryParse(_noticePeriodValue.text.trim())
          : null,
      'notice_period_unit': _isRentLeaseResidentialApartment
          ? _noticePeriodUnit
          : null,
      'preferred_tenant': _isRentLeaseResidentialApartment
          ? _preferredTenant
          : null,
      'rent_promotion': _isRentLeaseResidentialApartment
          ? _rentPromotionTypes.toList(growable: false)
          : null,
      'rent_villa_outdoors': _isRentLeaseResidentialVillaHouse
          ? _rentVillaOutdoors.toList(growable: false)
          : null,
      'rent_villa_water_source': _isRentLeaseResidentialVillaHouse
          ? _rentVillaWaterSource
          : null,
      'solar_power': _isRentLeaseResidentialVillaHouse ? _rentSolarPower : null,
      'independent_entry': _isRentLeaseResidentialVillaHouse
          ? _rentIndependentEntry
          : null,
      'lift_available_rent': _isRentLeaseResidentialBuilderFloor
          ? _rentLiftAvailable
          : null,
      'society_name': _isRentLeaseResidentialBuilderFloor
          ? (_societyName.text.trim().isEmpty ? null : _societyName.text.trim())
          : null,
      'tenant_types': _isRentLeaseResidentialBuilderFloor
          ? _rentTenantTypes.toList(growable: false)
          : null,
      'studio_config': _isRentLeaseResidentialStudioApartment
          ? _studioConfig
          : null,
      'kitchen_type': _isRentLeaseResidentialStudioApartment
          ? _kitchenType
          : null,
      'studio_tenant_preferences': _isRentLeaseResidentialStudioApartment
          ? _studioTenantPrefs.toList(growable: false)
          : null,
      'farm_land_area_rent': _isRentLeaseResidentialFarmhouse
          ? double.tryParse(_rentFarmLandArea.text.trim())
          : null,
      'farm_rooms_rent': _isRentLeaseResidentialFarmhouse
          ? int.tryParse(_rentFarmRooms.text.trim())
          : null,
      'farm_pool_rent': _isRentLeaseResidentialFarmhouse ? _rentFarmPool : null,
      'farm_fencing_rent': _isRentLeaseResidentialFarmhouse
          ? _rentFarmFencing
          : null,
      'farm_use_cases': _isRentLeaseResidentialFarmhouse
          ? _rentFarmUseCases.toList(growable: false)
          : null,

      // Sell -> Residential -> Independent House / Villa extra fields
      'gated_society': _isSellResidentialVillaHouse
          ? _gatedCommunity
          : (_isSellResidentialBuilderFloor ? _builderGatedSociety : null),
      'parking_types': _isSellResidentialVillaHouse
          ? _villaParking.toList(growable: false)
          : null,
      'outdoors': _isSellResidentialVillaHouse
          ? _outdoors.toList(growable: false)
          : null,
      'connections': _isSellResidentialVillaHouse
          ? _connections.toList(growable: false)
          : null,

      // Sell -> Residential -> Builder Floor extra fields
      'construction_allowed': _isSellResidentialBuilderFloor
          ? _constructionAllowed
          : null,
      'utilities': _isSellResidentialBuilderFloor
          ? _builderUtilities.toList(growable: false)
          : null,
      'price_per_sqft': _isSellResidentialBuilderFloor
          ? double.tryParse(_pricePerSqft.text.trim())
          : null,

      // Sell -> Residential -> Duplex extra fields
      'duplex_gated_community': _isSellResidentialDuplex
          ? _duplexGatedCommunity
          : null,
      'duplex_construction_allowed': _isSellResidentialDuplex
          ? _duplexConstructionAllowed
          : null,
      'duplex_water_connection': _isSellResidentialDuplex
          ? _duplexWaterConnection
          : null,
      'duplex_electricity_connection': _isSellResidentialDuplex
          ? _duplexElectricityConnection
          : null,
      'duplex_negotiable': _isSellResidentialDuplex
          ? (_duplexNegotiable == null ? null : (_duplexNegotiable! ? 1 : 0))
          : null,
      'duplex_road_access': _isSellResidentialDuplex ? _duplexRoadAccess : null,
      'duplex_nearby_facilities': _isSellResidentialDuplex
          ? _duplexNearbyFacilities.toList(growable: false)
          : null,

      // Sell -> Residential -> Farmhouse extra fields
      'village': _isSellResidentialFarmhouse
          ? (_village.text.trim().isEmpty ? null : _village.text.trim())
          : null,
      'landmark': _isSellResidentialFarmhouse
          ? (_landmark.text.trim().isEmpty ? null : _landmark.text.trim())
          : null,
      'owner_details': {
        'name': _ownerName.text.trim().isEmpty ? null : _ownerName.text.trim(),
        'phone': _ownerPhone.text.trim().isEmpty
            ? null
            : _ownerPhone.text.trim(),
      },
    };
  }

  String _normalizePgGenderForApi(String value) {
    switch (value) {
      case 'boys_pg':
        return 'male';
      case 'girls_pg':
        return 'female';
      case 'co_living':
      case 'unisex_pg':
      default:
        return 'unisex';
    }
  }

  String _normalizePgOccupancyForApi(String value) {
    switch (value) {
      case 'single_sharing':
        return 'single';
      case 'double_sharing':
      case 'triple_sharing':
      case 'four_plus_sharing':
      case 'dormitory':
      default:
        return 'multiple';
    }
  }

  String _normalizePgPropertyTypeForApi(String value) {
    switch (value) {
      case 'independent_house_pg':
        return 'independent_house';
      case 'apartment_pg':
        return 'apartment';
      case 'co_living_space':
        return 'co_living';
      case 'service_apartment':
        return 'service_apartment';
      case 'hostel':
      default:
        return 'hostel';
    }
  }

  String _normalizePgFurnishingTypeForApi(String value) {
    switch (value.trim().toLowerCase()) {
      case 'semi-furnished':
      case 'semi_furnished':
        return 'semi_furnished';
      case 'fully furnished':
      case 'fully-furnished':
      case 'fully_furnished':
      case 'furnished':
        return 'furnished';
      case 'unfurnished':
      default:
        return 'unfurnished';
    }
  }

  String _normalizeOfficeTypeForApi(String value) {
    final norm = value
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    const validTypes = {
      'bare_shell',
      'warm_shell',
      'fully_furnished',
      'semi_furnished',
      'plug_and_play',
      'customizable',
      'co_working',
      'private',
      'managed',
      'virtual',
      'corporate',
    };
    if (validTypes.contains(norm)) {
      return norm;
    }
    return 'bare_shell';
  }

  int? _normalizeOfficeMaxSeats({
    required int? seatsValue,
    required int? maxSeatsValue,
  }) {
    final maxBase = (maxSeatsValue ?? seatsValue);
    if (maxBase == null) return null;
    final atLeastTen = maxBase < 10 ? 10 : maxBase;
    if (seatsValue == null) return atLeastTen;
    return atLeastTen < seatsValue ? seatsValue : atLeastTen;
  }

  int _normalizePgFoodAvailabilityForApi(String value) {
    return value == 'without_food' ? 0 : 1;
  }

  String? _normalizePgFoodPreferenceForApi(String value) {
    switch (value) {
      case 'veg_only':
        return 'veg';
      case 'non_veg_allowed':
        return 'non_veg';
      default:
        return null;
    }
  }

  Map<String, List<String>> _buildSectionImages() {
    final sections = <String, List<String>>{};
    for (final img in _images) {
      final tag = img.tag ?? 'general';
      sections.putIfAbsent(tag, () => []).add(img.path);
    }
    return sections;
  }

  @override
  void dispose() {
    _totalFloors.removeListener(_handleTotalFloorsChanged);
    _draftSaveTimer?.cancel();
    _addressDebounce?.cancel();
    // Remove draft listeners before disposing controllers to prevent dangling
    // references. This mirrors the list in _attachDraftListeners().
    for (final c in [
      _title,
      _description,
      _price,
      _area,
      _floor,
      _totalFloors,
      _carpetArea,
      _builtUpArea,
      _superBuiltUpArea,
      _plotArea,
      _length,
      _breadth,
      _floorsAllowed,
      _possessionBy,
      _cabins,
      _meetingRooms,
      _seats,
      _maxSeats,
      _conferenceRooms,
      _shopFacade,
      _washrooms,
      _plotType,
      _qualityRating,
      _rooms,
      _numberOfLifts,
      _floorPlateArea,
      _roadWidth,
      _maintenanceCharges,
      _bookingAmount,
      _securityDeposit,
      _rentMaintenanceCharges,
      _brokerage,
      _availableFrom,
      _leaseDurationMonths,
      _lockInMonths,
      _noticePeriodValue,
      _societyName,
      _rentFarmLandArea,
      _rentFarmRooms,
      _farmMonthlyCharges,
      _farmDailyCharges,
      _farmEventCharges,
      _minStayDays,
      _villaMaintenanceCharges,
      _villaBookingAmount,
      _pricePerSqft,
      _officeMaintenanceCharges,
      _officeBookingAmount,
      _shopArea,
      _frontageWidth,
      _ceilingHeight,
      _marketName,
      _locality,
      _showroomArea,
      _showroomFrontageWidth,
      _showroomCeilingHeight,
      _showroomParkingSlots,
      _showroomMarketName,
      _showroomLocality,
      _showroomOwnerName,
      _showroomOwnerMobile,
      _warehousePlotArea,
      _warehouseCeilingHeight,
      _warehouseLoadingBays,
      _warehouseDockLevelers,
      _warehousePowerSupply,
      _warehouseAreaName,
      _warehouseCity,
      _farmLandArea,
      _farmBuiltUpArea,
      _farmRooms,
      _village,
      _landmark,
      _ownerName,
      _ownerPhone,
      _address,
      _city,
      _state,
      _pincode,
      _pgCurfewTime,
      _pgBuildingName,
      _pgTotalBeds,
      _pgAvailableBeds,
      _pgRoomSize,
      _pgSecurityDeposit,
      _pgMaintenanceCharges,
      _pgAvailableFrom,
      _pgMinStayDays,
      _pgNoticePeriodDays,
      _pgPreferredTenantAge,
    ]) {
      c.removeListener(_scheduleSaveDraft);
    }
    _addressFocus.removeListener(_onAddressFocusChange);
    _addressFocus.dispose();
    _title.dispose();
    _description.dispose();
    _price.dispose();
    _area.dispose();
    _floor.dispose();
    _totalFloors.dispose();
    _carpetArea.dispose();
    _builtUpArea.dispose();
    _superBuiltUpArea.dispose();
    _plotArea.dispose();
    _length.dispose();
    _breadth.dispose();
    _floorsAllowed.dispose();
    _possessionBy.dispose();
    _floorPlateArea.dispose();
    _cabins.dispose();
    _meetingRooms.dispose();
    _seats.dispose();
    _maxSeats.dispose();
    _conferenceRooms.dispose();
    _numberOfLifts.dispose();
    _officeMaintenanceCharges.dispose();
    _officeBookingAmount.dispose();
    _shopArea.dispose();
    _frontageWidth.dispose();
    _ceilingHeight.dispose();
    _marketName.dispose();
    _locality.dispose();
    _showroomArea.dispose();
    _showroomFrontageWidth.dispose();
    _showroomCeilingHeight.dispose();
    _showroomParkingSlots.dispose();
    _showroomMarketName.dispose();
    _showroomLocality.dispose();
    _showroomOwnerName.dispose();
    _showroomOwnerMobile.dispose();
    _warehousePlotArea.dispose();
    _warehouseCeilingHeight.dispose();
    _warehouseLoadingBays.dispose();
    _warehouseDockLevelers.dispose();
    _warehousePowerSupply.dispose();
    _warehouseAreaName.dispose();
    _warehouseCity.dispose();
    _shopFacade.dispose();
    _washrooms.dispose();
    _plotType.dispose();
    _rooms.dispose();
    _qualityRating.dispose();
    _roadWidth.dispose();
    _maintenanceCharges.dispose();
    _bookingAmount.dispose();
    _securityDeposit.dispose();
    _rentMaintenanceCharges.dispose();
    _brokerage.dispose();
    _availableFrom.dispose();
    _leaseDurationMonths.dispose();
    _lockInMonths.dispose();
    _noticePeriodValue.dispose();
    _societyName.dispose();
    _rentFarmLandArea.dispose();
    _rentFarmRooms.dispose();
    _farmMonthlyCharges.dispose();
    _farmDailyCharges.dispose();
    _farmEventCharges.dispose();
    _minStayDays.dispose();
    _villaMaintenanceCharges.dispose();
    _villaBookingAmount.dispose();
    _pricePerSqft.dispose();
    _farmLandArea.dispose();
    _farmBuiltUpArea.dispose();
    _farmRooms.dispose();
    _village.dispose();
    _landmark.dispose();
    _ownerName.dispose();
    _ownerPhone.dispose();
    _address.dispose();
    _city.dispose();
    _state.dispose();
    _pincode.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _pgCurfewTime.dispose();
    _pgBuildingName.dispose();
    _pgTotalBeds.dispose();
    _pgAvailableBeds.dispose();
    _pgRoomSize.dispose();
    _pgSecurityDeposit.dispose();
    _pgMaintenanceCharges.dispose();
    _pgAvailableFrom.dispose();
    _pgMinStayDays.dispose();
    _pgNoticePeriodDays.dispose();
    _pgPreferredTenantAge.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(propertyActionsProvider).isLoading;
    final isEdit = widget.initialProperty != null;
    final isLandPlot = _parentKind == 'land-plot';

    // In edit mode, resolve parent/child category IDs as soon as the
    // categories list finishes loading. This is the only place we can do it
    // because categories are loaded asynchronously after initState.
    if (isEdit && !_categoryResolved) {
      ref.listen<AsyncValue<List<Category>>>(categoriesProvider, (_, next) {
        next.whenData((cats) {
          if (mounted) _resolveCategoryFromList(cats);
        });
      });
      // Also try immediately in case categories are already cached.
      final catsAsync = ref.read(categoriesProvider);
      catsAsync.whenData((cats) {
        if (mounted) _resolveCategoryFromList(cats);
      });
    }

    final theme = Theme.of(context);
    final formTheme = _formTheme(theme);
    const screenBg = Color(0xFF1F2937); // grey (slate)

    return Theme(
      data: formTheme,
      child: Scaffold(
        backgroundColor: screenBg,
        appBar: AppBar(
          backgroundColor: screenBg,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: Text(isEdit ? 'Edit Property' : 'List Property'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = MediaQuery.sizeOf(context).width;
                  final compact = w < 360;

                  if (compact) {
                    return IconButton(
                      tooltip: isEdit ? 'Save' : 'Publish',
                      onPressed: saving ? null : _create,
                      icon: saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              isEdit
                                  ? Icons.save_outlined
                                  : Icons.publish_outlined,
                            ),
                    );
                  }

                  return FilledButton.icon(
                    onPressed: saving ? null : _create,
                    icon: saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            isEdit
                                ? Icons.save_outlined
                                : Icons.publish_outlined,
                            size: 18,
                          ),
                    label: Text(
                      saving
                          ? (isEdit ? 'Saving…' : 'Publishing…')
                          : (isEdit ? 'Save' : 'Publish'),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      shape: const StadiumBorder(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  children: [
                    _buildSection(
                      'Basic Info',
                      'basic',
                      Icons.info_outline,
                      _buildBasicInfo(),
                    ),
                    const SizedBox(height: 12),
                    if (_propertyKind != null)
                      _buildSection(
                        'Property Details',
                        'details',
                        Icons.apartment_outlined,
                        _buildPropertyDetails(),
                      ),
                    const SizedBox(height: 12),
                    _buildSection(
                      'Pricing & Area',
                      'pricing',
                      Icons.payments_outlined,
                      _buildPricingAndArea(),
                    ),
                    const SizedBox(height: 12),
                    if (!isLandPlot)
                      _buildSection(
                        'Amenities',
                        'amenities',
                        Icons.checklist,
                        _buildAmenities(),
                      ),
                    const SizedBox(height: 12),
                    if (!isLandPlot)
                      _buildSection(
                        'Furnishings',
                        'furnishings',
                        Icons.chair_alt_outlined,
                        _buildFurnishings(),
                      ),
                    const SizedBox(height: 12),
                    // if (_isSellResidentialApartment)
                    //   _buildSection(
                    //     'Promotion',
                    //     'promotion',
                    //     Icons.campaign_outlined,
                    //     _buildPromotion(),
                    //   ),
                    if (_isSellResidentialApartment) const SizedBox(height: 12),
                    _buildSection(
                      'Photos',
                      'media',
                      Icons.photo_library_outlined,
                      _buildMediaSection(),
                    ),
                    if (_videos.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildSection(
                        'Videos',
                        'videos',
                        Icons.video_library_outlined,
                        _buildVideoSection(),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildSection(
                      'Location',
                      'location',
                      Icons.location_on_outlined,
                      _buildLocation(),
                    ),
                    const SizedBox(height: 12),
                    _buildSection(
                      'About Your Property',
                      'description',
                      Icons.description_outlined,
                      _buildDescriptionField(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _create,
                        icon: saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                isEdit
                                    ? Icons.save_outlined
                                    : Icons.publish_outlined,
                                size: 18,
                              ),
                        label: Text(
                          saving
                              ? (isEdit ? 'Saving…' : 'Publishing…')
                              : (isEdit ? 'Save Property' : 'Publish Property'),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Tip: You can collapse sections to focus.',
                      style: formTheme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ThemeData _formTheme(ThemeData base) {
    const bg = Color(0xFF070B14);
    const textPrimary = Colors.white;
    const textSecondary = Color(0xFFCBD5E1);
    const surface = Color(0xFF0B1220);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppTheme.gold.withValues(alpha: 0.35)),
    );

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: AppTheme.gold,
        onPrimary: const Color(0xFF070B14),
        surface: surface,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.06),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 13),
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.38)),
        prefixIconColor: AppTheme.gold.withValues(alpha: 0.95),
        suffixIconColor: textSecondary,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: AppTheme.gold.withValues(alpha: 0.80)),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(
            color: Colors.redAccent.withValues(alpha: 0.85),
          ),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(
            color: Colors.redAccent.withValues(alpha: 0.95),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(surface),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        textStyle: const TextStyle(color: textPrimary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.gold,
          foregroundColor: const Color(0xFF070B14),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: AppTheme.gold.withValues(alpha: 0.45)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppTheme.gold
              : Colors.white.withValues(alpha: 0.10),
        ),
        checkColor: const WidgetStatePropertyAll(Color(0xFF070B14)),
        side: BorderSide(color: AppTheme.gold.withValues(alpha: 0.55)),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white.withValues(alpha: 0.08),
        side: BorderSide(color: AppTheme.gold.withValues(alpha: 0.30)),
        labelStyle: const TextStyle(color: textPrimary),
        deleteIconColor: textSecondary,
        selectedColor: AppTheme.gold,
        secondaryLabelStyle: const TextStyle(
          color: Color(0xFF070B14),
          fontWeight: FontWeight.w800,
        ),
      ),
      dividerColor: Colors.white.withValues(alpha: 0.10),
    );
  }

  String? _nextSectionKey(String key) {
    switch (key) {
      case 'basic':
        return 'details';
      case 'details':
        return 'pricing';
      case 'pricing':
        return 'amenities';
      case 'amenities':
        return 'furnishings';
      case 'furnishings':
        return _isSellResidentialApartment ? 'promotion' : 'media';
      case 'promotion':
        return 'media';
      case 'media':
        return _videos.isNotEmpty ? 'videos' : 'location';
      case 'videos':
        return 'location';
      case 'location':
        return 'description';
      default:
        return null;
    }
  }

  bool _isSectionComplete(String key) {
    switch (key) {
      case 'basic':
        return _isBasicSectionComplete;
      case 'details':
        return _isDetailsSectionComplete;
      case 'pricing':
        return _isPricingSectionComplete;
      case 'amenities':
        return true; // optional
      case 'furnishings':
        return true; // optional
      case 'promotion':
        return true; // optional
      case 'media':
        return _isMediaSectionComplete;
      case 'videos':
        return true; // optional
      case 'location':
        return _isLocationSectionComplete;
      case 'description':
        return _isDescriptionSectionComplete;
      default:
        return false;
    }
  }

  void _goNextFromSection(String key) {
    final next = _nextSectionKey(key);
    if (next == null) return;
    if (kDebugMode) {
      debugPrint('Next pressed: $key -> $next');
    }
    setState(() {
      _expandedSections[key] = false;
      _expandedSections[next] = true;
    });
  }

  Widget _buildSection(String title, String key, IconData icon, Widget child) {
    final theme = Theme.of(context);
    final expanded = _expandedSections[key] ?? true;
    final canNext = expanded && _isSectionComplete(key);
    if (kDebugMode && expanded) {
      debugPrint(
        'Section "$key" expanded=$expanded complete=${_isSectionComplete(key)} canNext=$canNext',
      );
    }

    return GlassContainer(
      blur: false, // Fix ANR in scroll views
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: ValueKey('section_${key}_$expanded'),
            iconColor: AppTheme.gold,
            collapsedIconColor: AppColors.textPrimary,
            initiallyExpanded: expanded,
            onExpansionChanged: (expanded) =>
                setState(() => _expandedSections[key] = expanded),
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            title: Row(
              children: [
                Icon(icon, size: 20, color: AppTheme.gold),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    child,
                    if (canNext) ...[
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () => _goNextFromSection(key),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.gold,
                            foregroundColor: const Color(0xFF070B14),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Next'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChoiceGrid<_CreatePropertyKind>(
          label: 'What are you listing?',
          values: _CreatePropertyKind.values,
          value: _propertyKind,
          labelFor: (v) => v.label,
          onChanged: (next) {
            setState(() {
              _propertyKind = next;
              _syncTypeAndResetInvalidCategorySelection();
              _selectedParentCategoryId = null;
              _selectedCategoryId = null;
            });
            _scheduleSaveDraft();
          },
        ),
        const SizedBox(height: 16),
        if (_propertyKind != null) _buildCategorySelector(),
      ],
    );
  }

  Widget _buildPricingAndArea() {
    final isLandPlot = _isLandPlotContext;
    final isCommercial = _isCommercialContext;
    final isPgCoLiving =
        _propertyKind == _CreatePropertyKind.pg ||
        _propertyKind == _CreatePropertyKind.coLiving;

    final priceLabel = isPgCoLiving
        ? 'Monthly Rent'
        : (_type == PropertyType.rent ? 'Monthly Rent' : 'Price');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          _price,
          priceLabel,
          'Amount',
          Icons.currency_rupee,
          keyboardType: TextInputType.number,
          onChanged: (_) => _validateField('price'),
          errorText: _priceErr,
        ),
        if (_propertyKind == _CreatePropertyKind.sale &&
            !_isSellResidentialVillaHouse &&
            !(isCommercial && _commercialType == 'office')) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _maintenanceCharges,
                  'Maintenance Charges (Optional)',
                  '₹ 3500/month',
                  Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _bookingAmount,
                  'Booking Amount (Optional)',
                  '₹ 2,00,000',
                  Icons.account_balance_wallet_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
        if (_isSellResidentialVillaHouse) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _villaMaintenanceCharges,
                  'Maintenance Charges (Optional)',
                  '₹ 3500/month',
                  Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _villaBookingAmount,
                  'Booking Amount (Optional)',
                  '₹ 2,00,000',
                  Icons.account_balance_wallet_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
        if (_propertyKind == _CreatePropertyKind.sale) ...[
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Price Negotiable',
            const ['yes', 'no'],
            _priceNegotiable == null ? '' : (_priceNegotiable! ? 'yes' : 'no'),
            (v) {
              setState(() => _priceNegotiable = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
        ],
        if ((_propertyKind == _CreatePropertyKind.rent ||
                _propertyKind == _CreatePropertyKind.lease) &&
            _isResidential) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _securityDeposit,
                  'Security Deposit',
                  'e.g., 50000',
                  Icons.account_balance_wallet_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _scheduleSaveDraft(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _rentMaintenanceCharges,
                  'Maintenance Charges',
                  'e.g., 3500',
                  Icons.receipt_long_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _scheduleSaveDraft(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _brokerage,
            'Brokerage (Optional)',
            'e.g., 1 month rent',
            Icons.handshake_outlined,
            keyboardType: TextInputType.number,
            onChanged: (_) => _scheduleSaveDraft(),
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Rent Negotiable',
            const ['yes', 'no'],
            _rentNegotiable == null ? '' : (_rentNegotiable! ? 'yes' : 'no'),
            (v) {
              setState(() => _rentNegotiable = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
        ],
        const SizedBox(height: 12),
        if (!isLandPlot) ...[
          // For Land/Plot, Plot Area is already collected in plot details, so
          // avoid showing a duplicate "Area" here.
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Area',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _area,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _validateField('area'),
                      decoration: InputDecoration(
                        hintText: isCommercial ? 'Built-up area' : 'Size',
                        errorText: _areaErr,
                        suffixIcon: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _areaUnit,
                              isDense: true,
                              dropdownColor: Colors.white,
                              iconEnabledColor: Colors.black,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              items: _areaUnits
                                  .map(
                                    (u) => DropdownMenuItem<String>(
                                      value: u,
                                      child: Text(
                                        u,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                setState(() => _areaUnit = v ?? _areaUnit);
                                _scheduleSaveDraft();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDescriptionField() {
    return _buildTextField(
      _description,
      'About Your Property',
      'About the property...',
      Icons.description,
      maxLines: 4,
      onChanged: (_) => _validateField('desc'),
      errorText: _descErr,
      helperText: 'Min 15 characters',
    );
  }

  Widget _buildCategorySelector() {
    return ref
        .watch(categoriesProvider)
        .when(
          data: (cats) {
            final filtered = _segmentLockedToResidential
                ? cats
                      .where(
                        (c) =>
                            c.slug != 'commercial' &&
                            c.slug != 'land-plot' &&
                            c.slug != 'agriculture' &&
                            c.slug != 'agricultural',
                      )
                      .toList()
                : cats;

            // For PG/Co-Living, default parent category to Residential.
            if (_segmentLockedToResidential &&
                _selectedParentCategoryId == null) {
              final residential = filtered.cast<Category?>().firstWhere(
                (c) => (c?.slug ?? '').toLowerCase() == 'residential',
                orElse: () => null,
              );
              if (residential != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  if (_selectedParentCategoryId != null) return;
                  setState(() {
                    _selectedParentCategoryId = residential.id;
                    _selectedParentCategorySlug = _normalizeParentSlug(
                      rawSlug: residential.slug,
                      name: residential.name,
                    );
                    _selectedCategoryId = null;
                    _selectedCategorySlug = null;
                  });
                });
              }
            }

            Category? selectedParent;
            if (_selectedParentCategoryId != null) {
              selectedParent = filtered.cast<Category?>().firstWhere(
                (c) => c?.id == _selectedParentCategoryId,
                orElse: () => null,
              );
            }

            final children = selectedParent?.children ?? [];
            final parentSlug = (selectedParent?.slug ?? '').toLowerCase();
            final isPgCoLiving =
                _propertyKind == _CreatePropertyKind.pg ||
                _propertyKind == _CreatePropertyKind.coLiving;
            final effectiveChildren = parentSlug == 'residential'
                ? [
                    ...children,
                    const Category(
                      id: -9999,
                      name: 'Farmhouse',
                      slug: 'farmhouse',
                      parentId: null,
                      status: null,
                      children: <Category>[],
                    ),
                  ]
                : children;

            return Column(
              children: [
                _buildChoiceGrid<int>(
                  label: 'Property Category',
                  values: filtered.map((c) => c.id).toList(),
                  value: _selectedParentCategoryId,
                  labelFor: (id) => filtered.firstWhere((c) => c.id == id).name,
                  onChanged: (id) {
                    final parent = filtered.firstWhere((c) => c.id == id);
                    final parentChildren = parent.children;
                    setState(() {
                      _selectedParentCategoryId = id;
                      _selectedParentCategorySlug = _normalizeParentSlug(
                        rawSlug: parent.slug,
                        name: parent.name,
                      );

                      // If the parent has no children, treat it as the leaf
                      // category so users don't get stuck without options.
                      if (parentChildren.isEmpty) {
                        _selectedCategoryId = id;
                        _selectedCategorySlug = parent.slug;
                      } else {
                        _selectedCategoryId = null;
                        _selectedCategorySlug = null;
                      }

                      _syncDetailsFromSelectedCategorySlugs();
                    });
                    debugPrint(
                      'Category selected: parentName=${parent.name} parentSlug=${parent.slug} normalized=${_selectedParentCategorySlug} children=${parentChildren.length}',
                    );
                    _scheduleSaveDraft();
                  },
                ),
                if (isPgCoLiving && parentSlug == 'residential') ...[
                  const SizedBox(height: 12),
                  _buildChoiceGrid<String>(
                    label: 'PG / Hostel Type',
                    values: _pgResidentialSubcategories,
                    value: _selectedCategorySlug,
                    labelFor: (s) => s.replaceAll('_', ' ').toUpperCase(),
                    onChanged: (slug) {
                      setState(() {
                        _selectedCategoryId = null;
                        _selectedCategorySlug = slug;
                        for (final child in children) {
                          if (child.slug == slug) {
                            _selectedCategoryId = child.id;
                            break;
                          }
                        }
                        _syncDetailsFromSelectedCategorySlugs();
                      });
                      _scheduleSaveDraft();
                    },
                  ),
                ] else if (children.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildChoiceGrid<int>(
                    label: 'Sub Category',
                    values: effectiveChildren.map((c) => c.id).toList(),
                    value: (_selectedCategorySlug == 'farmhouse')
                        ? -9999
                        : _selectedCategoryId,
                    labelFor: (id) =>
                        effectiveChildren.firstWhere((c) => c.id == id).name,
                    onChanged: (id) {
                      setState(() {
                        if (id == -9999) {
                          _selectedCategoryId =
                              null; // backend doesn't know it yet
                          _selectedCategorySlug = 'farmhouse';
                        } else {
                          final child = effectiveChildren.firstWhere(
                            (c) => c.id == id,
                          );
                          _selectedCategoryId = id;
                          _selectedCategorySlug = child.slug;
                        }
                        _syncDetailsFromSelectedCategorySlugs();

                        // Studio apartment is strictly 1 bed / 1 bath.
                        final slug = (_selectedCategorySlug ?? '')
                            .toLowerCase();
                        final isRentLease =
                            _propertyKind == _CreatePropertyKind.rent ||
                            _propertyKind == _CreatePropertyKind.lease;
                        if (isRentLease && slug.contains('studio')) {
                          _bedrooms = 1;
                          _bathrooms = 1;
                        }
                      });
                      debugPrint(
                        'Subcategory selected: parentKind=$_parentKind parentSlug=${_selectedParentCategorySlug ?? ''} childSlug=${_selectedCategorySlug ?? ''} commercialType=$_commercialType landType=$_landType',
                      );
                      _scheduleSaveDraft();
                    },
                  ),
                ],
              ],
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
        );
  }

  Widget _buildPropertyDetails() {
    final isLandPlot = _isLandPlotContext;
    final isCommercial = _isCommercialContext;
    final isResidential = !isLandPlot && !isCommercial;
    final isVilla = _selectedCategorySlug == 'villa';
    final isSale = _propertyKind == _CreatePropertyKind.sale;
    final isRentLease =
        _propertyKind == _CreatePropertyKind.rent ||
        _propertyKind == _CreatePropertyKind.lease;
    final isPgCoLiving =
        _propertyKind == _CreatePropertyKind.pg ||
        _propertyKind == _CreatePropertyKind.coLiving;

    if (isPgCoLiving) {
      return Column(
        children: [
          _buildChoiceChipRow(
            'Gender Based',
            _pgGenderBasedOptions,
            _pgGenderBased,
            (v) {
              setState(() => _pgGenderBased = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Occupancy Type',
            _pgOccupancyTypeOptions,
            _pgOccupancyType,
            (v) {
              setState(() => _pgOccupancyType = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tenant Type',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,

            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: _pgTenantTypeOptions
                  .map(
                    (k) => _simpleFilterChip(
                      label: k.replaceAll('_', ' ').toUpperCase(),
                      selected: _pgTenantTypes.contains(k),
                      onSelected: (s) {
                        setState(() {
                          if (s)
                            _pgTenantTypes.add(k);
                          else
                            _pgTenantTypes.remove(k);
                        });
                        _scheduleSaveDraft();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Food Availability',
            _pgFoodAvailabilityOptions,
            _pgFoodAvailability,
            (v) {
              setState(() => _pgFoodAvailability = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Property Type',
            _pgPropertyTypeOptions,
            _pgPropertyType,
            (v) {
              setState(() => _pgPropertyType = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow('Furnishing Type', _furnishings, _furnishing, (
            v,
          ) {
            setState(() => _furnishing = v);
            _scheduleSaveDraft();
          }),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Bathroom Type',
            _pgBathroomTypeOptions,
            _pgBathroomType,
            (v) {
              setState(() => _pgBathroomType = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,

            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: [
                _simpleFilterChip(
                  label: 'SMOKING ALLOWED',
                  selected: _pgSmokingAllowed,
                  onSelected: (s) {
                    setState(() => _pgSmokingAllowed = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'DRINKING ALLOWED',
                  selected: _pgDrinkingAllowed,
                  onSelected: (s) {
                    setState(() => _pgDrinkingAllowed = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'PETS ALLOWED',
                  selected: _pgPetsAllowed,
                  onSelected: (s) {
                    setState(() => _pgPetsAllowed = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'VISITOR ALLOWED',
                  selected: _pgVisitorsAllowed,
                  onSelected: (s) {
                    setState(() => _pgVisitorsAllowed = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'GATE LOCKED AT NIGHT',
                  selected: _pgGateLockedAtNight,
                  onSelected: (s) {
                    setState(() => _pgGateLockedAtNight = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'SECURITY',
                  selected: _pgSecurity,
                  onSelected: (s) {
                    setState(() => _pgSecurity = s);
                    _scheduleSaveDraft();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _pgCurfewTime,
            'Curfew Timing (Optional)',
            'Enter curfew time manually (e.g. 10:00 PM)',
            Icons.schedule,
            readOnly: false,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,

            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: _pgNearbyPreferenceOptions
                  .map(
                    (k) => _simpleFilterChip(
                      label: k.replaceAll('_', ' ').toUpperCase(),
                      selected: _pgNearbyPreferences.contains(k),
                      onSelected: (s) {
                        setState(() {
                          if (s)
                            _pgNearbyPreferences.add(k);
                          else
                            _pgNearbyPreferences.remove(k);
                        });
                        _scheduleSaveDraft();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Availability',
            _pgAvailabilityOptions,
            _pgAvailability,
            (v) {
              setState(() => _pgAvailability = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Suitable For',
            const ['students', 'working_professionals', 'both'],
            _pgSuitableFor,
            (v) {
              setState(() => _pgSuitableFor = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _pgBuildingName,
            'Building Name (Optional)',
            'e.g., Sunshine Residency',
            Icons.apartment_outlined,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _pgTotalBeds,
                  'Total Beds',
                  'e.g., 30',
                  Icons.bed_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final total = int.tryParse(val.trim()) ?? 0;
                    final avail =
                        int.tryParse(_pgAvailableBeds.text.trim()) ?? 0;
                    if (total > 0 && avail > total) {
                      setState(() {
                        _pgAvailableBeds.text = total.toString();
                      });
                    }
                    _scheduleSaveDraft();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _pgAvailableBeds,
                  'Available Beds',
                  'e.g., 5',
                  Icons.event_available_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final total = int.tryParse(_pgTotalBeds.text.trim()) ?? 0;
                    final avail = int.tryParse(val.trim()) ?? 0;
                    if (total > 0 && avail > total) {
                      setState(() {
                        _pgAvailableBeds.text = total.toString();
                        _pgAvailableBeds.selection = TextSelection.fromPosition(
                          TextPosition(offset: _pgAvailableBeds.text.length),
                        );
                      });
                    }
                    _scheduleSaveDraft();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Room Type',
            const [
              'private_room',
              'twin_sharing',
              'triple_sharing',
              'dormitory',
            ],
            _pgRoomType,
            (v) {
              setState(() => _pgRoomType = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Bed Type',
            const ['single', 'bunk'],
            _pgBedType,
            (v) {
              setState(() => _pgBedType = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,

            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: [
                _simpleFilterChip(
                  label: 'ATTACHED BATHROOM',
                  selected: _pgAttachedBathroom,
                  onSelected: (s) {
                    setState(() => _pgAttachedBathroom = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'BALCONY',
                  selected: _pgBalcony,
                  onSelected: (s) {
                    setState(() => _pgBalcony = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'CUPBOARD',
                  selected: _pgCupboardAvailable,
                  onSelected: (s) {
                    setState(() => _pgCupboardAvailable = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'STUDY TABLE',
                  selected: _pgStudyTableAvailable,
                  onSelected: (s) {
                    setState(() => _pgStudyTableAvailable = s);
                    _scheduleSaveDraft();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _pgRoomSize,
            'Room Size (Optional)',
            'e.g., 120 sqft',
            Icons.straighten_outlined,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _pgSecurityDeposit,
                  'Security Deposit (Optional)',
                  'e.g., 5000',
                  Icons.lock_outline,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _pgMaintenanceCharges,
                  'Maintenance (Optional)',
                  'e.g., 500',
                  Icons.build_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,

            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: [
                _simpleFilterChip(
                  label: 'ELECTRICITY INCLUDED',
                  selected: _pgElectricityIncluded,
                  onSelected: (s) {
                    setState(() => _pgElectricityIncluded = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'WATER INCLUDED',
                  selected: _pgWaterIncluded,
                  onSelected: (s) {
                    setState(() => _pgWaterIncluded = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'FOOD CHARGES INCLUDED',
                  selected: _pgFoodChargesIncluded,
                  onSelected: (s) {
                    setState(() => _pgFoodChargesIncluded = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'BROKERAGE REQUIRED',
                  selected: _pgBrokerageRequired,
                  onSelected: (s) {
                    setState(() => _pgBrokerageRequired = s);
                    _scheduleSaveDraft();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: [
                _simpleFilterChip(
                  label: 'COUPLE FRIENDLY',
                  selected: _pgCoupleFriendly,
                  onSelected: (s) {
                    setState(() => _pgCoupleFriendly = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'ID PROOF REQUIRED',
                  selected: _pgIdProofRequired,
                  onSelected: (s) {
                    setState(() => _pgIdProofRequired = s);
                    _scheduleSaveDraft();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _pgAvailableFrom,
                  'Available From (Optional)',
                  'YYYY-MM-DD',
                  Icons.event_available_outlined,
                  readOnly: true,
                  onTap: () => _pickDateForController(_pgAvailableFrom),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _pgMinStayDays,
                  'Min Stay (Days)',
                  'e.g., 30',
                  Icons.timelapse_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _pgNoticePeriodDays,
                  'Notice Period (Days)',
                  'e.g., 15',
                  Icons.notifications_active_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _pgPreferredTenantAge,
                  'Preferred Age (Optional)',
                  'e.g., 18-30',
                  Icons.cake_outlined,
                ),
              ),
            ],
          ),
          _buildStepper('Sharing', _pgSharing, 1, 6, (v) {
            setState(() => _pgSharing = v);
            _scheduleSaveDraft();
          }),
          const SizedBox(height: 12),
          _buildIntDropdownField(
            label: 'Rooms',
            controller: _rooms,
            min: 1,
            max: 200,
            hint: 'Select rooms',
            icon: Icons.bedroom_parent_outlined,
            allowEmpty: false,
          ),
          const SizedBox(height: 12),
          _buildStepper('Bathrooms', _bathrooms, 1, 50, (v) {
            setState(() => _bathrooms = v);
            _scheduleSaveDraft();
          }),
          const SizedBox(height: 12),
          _buildChoiceChipRow('Furnishing', _furnishings, _furnishing, (v) {
            setState(() => _furnishing = v);
            _scheduleSaveDraft();
          }),
          const SizedBox(height: 12),
          _buildStepper('Parking', _parking, 0, 10, (v) {
            setState(() => _parking = v);
            _scheduleSaveDraft();
          }),
        ],
      );
    }

    return Column(
      children: [
        if (!isCommercial && !isLandPlot && !isResidential)
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select a sub-category to see details.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
        if (isLandPlot) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _landType == 'commercial'
                  ? 'Commercial Plot Details'
                  : (_landType == 'agricultural'
                        ? 'Agriculture Plot Details'
                        : 'Residential Plot Details'),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _plotArea,
            keyboardType: TextInputType.number,
            onChanged: (_) => _scheduleSaveDraft(),
            decoration: InputDecoration(
              labelText: 'Plot Area',
              hintText: 'Area',
              prefixIcon: const Icon(Icons.terrain, size: 18),
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _plotAreaUnit,
                    isDense: true,
                    dropdownColor: Colors.white,
                    iconEnabledColor: Colors.black,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                    items:
                        (_landType == 'agricultural'
                                ? _areaUnits
                                : _areaUnits.where((u) => u != 'acre'))
                            .map(
                              (u) => DropdownMenuItem<String>(
                                value: u,
                                child: Text(
                                  u,
                                  style: const TextStyle(color: AppColors.dark),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (v) {
                      setState(() => _plotAreaUnit = v ?? _plotAreaUnit);
                      _scheduleSaveDraft();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _length,
                  'Length (ft)',
                  'e.g., 60',
                  Icons.straighten,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _breadth,
                  'Breadth (ft)',
                  'e.g., 40',
                  Icons.straighten,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildIntDropdownField(
            label: 'Floors Allowed (Optional)',
            controller: _floorsAllowed,
            min: 0,
            max: 50,
            hint: 'Select floors',
            icon: Icons.layers_outlined,
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Corner Plot',
            const ['yes', 'no'],
            _plotCorner == null ? '' : (_plotCorner! ? 'yes' : 'no'),
            (v) {
              setState(() => _plotCorner = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Boundary Wall',
            const ['yes', 'no'],
            _boundaryWall == null ? '' : (_boundaryWall! ? 'yes' : 'no'),
            (v) {
              setState(() => _boundaryWall = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildStepper(
            'Open Sides',
            _openSides,
            1,
            4,
            (v) => setState(() => _openSides = v),
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Construction Done',
            const ['yes', 'no'],
            _constructionDone == null ? '' : (_constructionDone! ? 'yes' : 'no'),
            (v) {
              setState(() => _constructionDone = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _roadWidth,
            'Road Width',
            'Width in feet',
            Icons.straighten,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Road Access',
            const ['yes', 'no'],
            _plotRoadAccess == null ? '' : (_plotRoadAccess! ? 'yes' : 'no'),
            (v) {
              setState(() => _plotRoadAccess = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
          if (_landType == 'agricultural') ...[
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Water Source',
              _agriWaterSources,
              _agriWaterSource,
              (v) {
                setState(() => _agriWaterSource = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Fencing',
              const ['yes', 'no'],
              _agriFencing ? 'yes' : 'no',
              (v) {
                setState(() => _agriFencing = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
          ],
          if (isSale || isRentLease) ...[
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Ownership',
              _ownershipTypes,
              _ownership,
              (v) => setState(() => _ownership = v),
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Availability',
              _availabilityTypes,
              _availability,
              (v) => setState(() => _availability = v),
            ),
            if (_availability != 'ready_to_move' &&
                _availability != 'immediate') ...[
              const SizedBox(height: 12),
              _buildTextField(
                _possessionBy,
                'Possession By',
                'YYYY-MM-DD',
                Icons.event,
                readOnly: true,
                onTap: () => _pickDateForController(_possessionBy),
              ),
            ],
          ],
        ],
        if (isCommercial) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _commercialType == 'shop'
                  ? 'Shop Details'
                  : (_commercialType == 'showroom'
                        ? 'Showroom Details'
                        : (_commercialType == 'warehouse'
                              ? 'Warehouse Details'
                              : 'Office Space Details')),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_commercialType == 'office') ...[
            _buildChoiceChipRow('Office Type', _officeTypes, _officeType, (v) {
              setState(() => _officeType = v);
              _scheduleSaveDraft();
            }),
            const SizedBox(height: 12),
            _buildTextField(
              _floorPlateArea,
              'Office Area (Optional)',
              'Area in sqft',
              Icons.crop_square,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildIntDropdownField(
                    label: 'Cabins',
                    controller: _cabins,
                    min: 0,
                    max: 50,
                    hint: 'Select cabins',
                    icon: Icons.meeting_room_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildIntDropdownField(
                    label: 'Meeting Rooms',
                    controller: _meetingRooms,
                    min: 0,
                    max: 30,
                    hint: 'Select rooms',
                    icon: Icons.groups_2_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildIntDropdownField(
                    label: 'Seats',
                    controller: _seats,
                    min: 0,
                    max: 500,
                    hint: 'Select seats',
                    icon: Icons.event_seat_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildIntDropdownField(
                    label: 'Max Seats',
                    controller: _maxSeats,
                    min: 0,
                    max: 500,
                    hint: 'Select max',
                    icon: Icons.event_seat_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildIntDropdownField(
              label: 'Conference Rooms',
              controller: _conferenceRooms,
              min: 0,
              max: 20,
              hint: 'Select rooms',
              icon: Icons.co_present_outlined,
            ),
          ],
          if (_commercialType == 'showroom') ...[
            TextField(
              controller: _showroomArea,
              keyboardType: TextInputType.number,
              onChanged: (_) => _scheduleSaveDraft(),
              decoration: InputDecoration(
                labelText: 'Showroom Area',
                hintText: 'Area',
                prefixIcon: const Icon(Icons.crop_square, size: 18),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _showroomAreaUnit,
                      isDense: true,
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      items: _showroomAreaUnits
                          .map(
                            (u) => DropdownMenuItem<String>(
                              value: u,
                              child: Text(
                                u,
                                style: const TextStyle(color: AppColors.dark),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(
                          () => _showroomAreaUnit = v ?? _showroomAreaUnit,
                        );
                        _scheduleSaveDraft();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _showroomFrontageWidth,
                    'Frontage Width (ft)',
                    'e.g., 30',
                    Icons.straighten,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _showroomCeilingHeight,
                    'Ceiling Height (ft)',
                    'e.g., 15',
                    Icons.height,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Main Road Facing',
              const ['yes', 'no'],
              _showroomMainRoadFacing == null ? '' : (_showroomMainRoadFacing! ? 'yes' : 'no'),
              (v) {
                setState(() => _showroomMainRoadFacing = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Corner Showroom',
              const ['yes', 'no'],
              _showroomCorner == null ? '' : (_showroomCorner! ? 'yes' : 'no'),
              (v) {
                setState(() => _showroomCorner = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Washroom Available',
              const ['yes', 'no'],
              _showroomWashroom == null ? '' : (_showroomWashroom! ? 'yes' : 'no'),
              (v) {
                setState(() => _showroomWashroom = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _showroomParkingSlots,
              'Parking Slots (Optional)',
              'e.g., 5',
              Icons.local_parking_outlined,
              keyboardType: TextInputType.number,
              onChanged: (_) => _scheduleSaveDraft(),
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Furnishing Status',
              _furnishings,
              _showroomFurnishing,
              (v) {
                setState(() => _showroomFurnishing = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Floor Type',
              _showroomFloorTypes,
              _showroomFloorType,
              (v) {
                setState(() => _showroomFloorType = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _showroomMarketName,
                    'Market Name (Optional)',
                    'Market name',
                    Icons.storefront_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _showroomLocality,
                    'Locality (Optional)',
                    'Area/locality',
                    Icons.location_on_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _showroomOwnerName,
                    'Owner Name (Optional)',
                    'Name',
                    Icons.person_outline,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _showroomOwnerMobile,
                    'Owner Mobile (Optional)',
                    'Mobile number',
                    Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
          ],
          if (_commercialType == 'warehouse') ...[
            _buildChoiceChipRow('Type', _warehouseTypes, _warehouseType, (v) {
              setState(() => _warehouseType = v);
              _scheduleSaveDraft();
            }),
            const SizedBox(height: 12),
            TextField(
              controller: _warehousePlotArea,
              keyboardType: TextInputType.number,
              onChanged: (_) => _scheduleSaveDraft(),
              decoration: InputDecoration(
                labelText: 'Plot Area',
                hintText: 'Area',
                prefixIcon: const Icon(Icons.terrain, size: 18),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _warehousePlotAreaUnit,
                      isDense: true,
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      items: _areaUnits
                          .where((u) => u != 'acre')
                          .map(
                            (u) => DropdownMenuItem<String>(
                              value: u,
                              child: Text(
                                u,
                                style: const TextStyle(color: AppColors.dark),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(
                          () => _warehousePlotAreaUnit =
                              v ?? _warehousePlotAreaUnit,
                        );
                        _scheduleSaveDraft();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _warehouseCeilingHeight,
                    'Ceiling Height (ft)',
                    'e.g., 20',
                    Icons.height,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _warehouseLoadingBays,
                    'Loading Bays',
                    'e.g., 2',
                    Icons.local_shipping_outlined,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _warehouseDockLevelers,
                    'Dock Levelers',
                    'e.g., 1',
                    Icons.format_line_spacing,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _warehousePowerSupply,
                    'Power Supply (Optional)',
                    'e.g., 100 KVA',
                    Icons.power_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Industrial License',
              const ['yes', 'no'],
              _warehouseIndustrialLicense == null ? '' : (_warehouseIndustrialLicense! ? 'yes' : 'no'),
              (v) {
                setState(() => _warehouseIndustrialLicense = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Truck Access',
              _truckAccessTypes,
              _warehouseTruckAccess,
              (v) {
                setState(() => _warehouseTruckAccess = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _warehouseAreaName,
                    'Industrial Area (Optional)',
                    'Area name',
                    Icons.location_city_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _warehouseCity,
                    'City (Optional)',
                    'City',
                    Icons.location_on_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
          ],
          if (_commercialType == 'shop') ...[
            _buildChoiceChipRow('Shop Type', _shopTypes, _shopType, (v) {
              setState(() => _shopType = v);
              _scheduleSaveDraft();
            }),
            const SizedBox(height: 12),
            TextField(
              controller: _shopArea,
              keyboardType: TextInputType.number,
              onChanged: (_) => _scheduleSaveDraft(),
              decoration: InputDecoration(
                labelText: 'Shop Area',
                hintText: 'Area',
                prefixIcon: const Icon(Icons.crop_square, size: 18),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _shopAreaUnit,
                      isDense: true,
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      items: _areaUnits
                          .map(
                            (u) => DropdownMenuItem<String>(
                              value: u,
                              child: Text(
                                u,
                                style: const TextStyle(color: AppColors.dark),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() => _shopAreaUnit = v ?? _shopAreaUnit);
                        _scheduleSaveDraft();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _frontageWidth,
                    'Frontage Width (ft)',
                    'e.g., 20',
                    Icons.straighten,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _ceilingHeight,
                    'Ceiling Height (ft)',
                    'e.g., 12',
                    Icons.height,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Main Road Facing',
              const ['yes', 'no'],
              _mainRoadFacing == null ? '' : (_mainRoadFacing! ? 'yes' : 'no'),
              (v) {
                setState(() => _mainRoadFacing = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Corner Shop',
              const ['yes', 'no'],
              _cornerShop == null ? '' : (_cornerShop! ? 'yes' : 'no'),
              (v) {
                setState(() => _cornerShop = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Washroom Available',
              const ['yes', 'no'],
              _washroomAvailable == null ? '' : (_washroomAvailable! ? 'yes' : 'no'),
              (v) {
                setState(() => _washroomAvailable = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow('Floor Type', _floorTypes, _floorType, (v) {
              setState(() => _floorType = v);
              _scheduleSaveDraft();
            }),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _marketName,
                    'Market Name (Optional)',
                    'e.g., Main Bazaar',
                    Icons.storefront_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _locality,
                    'Locality (Optional)',
                    'Area/locality',
                    Icons.location_on_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
          ],
        ],
        if (isResidential) ...[
          if (_isSellResidentialFarmhouse) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Farmhouse Details',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _farmLandArea,
                    'Land Area',
                    'Area in sqft',
                    Icons.terrain,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _farmBuiltUpArea,
                    'Built-up Area',
                    'Area in sqft',
                    Icons.crop_square,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Utilities',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                spacing: 8,
                runSpacing: 8,
                children: _farmUtilitiesOptions.map((u) {
                  final selected = _farmUtilities.contains(u);
                  final label = switch (u) {
                    'water_source' => 'Water Source',
                    'borewell' => 'Borewell',
                    'road_access' => 'Road Access',
                    _ => 'Fencing',
                  };
                  return FilterChip(
                    selected: selected,
                    showCheckmark: false,
                    selectedColor: AppTheme.gold,
                    label: Text(label),
                    labelStyle: TextStyle(
                      color: AppColors.dark,
                      fontWeight: FontWeight.w700,
                    ),
                    onSelected: (v) {
                      setState(() {
                        v ? _farmUtilities.add(u) : _farmUtilities.remove(u);
                      });
                      _scheduleSaveDraft();
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            _buildIntDropdownField(
              label: 'Number of Rooms',
              controller: _farmRooms,
              min: 0,
              max: 30,
              hint: 'Select rooms',
              icon: Icons.bed_outlined,
            ),
            const SizedBox(height: 12),
            _buildIntDropdownField(
              label: 'Number of Washrooms',
              controller: _washrooms,
              min: 0,
              max: 20,
              hint: 'Select washrooms',
              icon: Icons.wc_outlined,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _floor,
                    'Floor No. (Optional)',
                    'e.g., 1',
                    Icons.apartment_outlined,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _totalFloors,
                    'Total Floors (Optional)',
                    'e.g., 2',
                    Icons.layers_outlined,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Balconies',
              const ['0', '1', '2', '3', '4', '5+'],
              _balconies >= 5 ? '5+' : _balconies.toString(),
              (v) {
                setState(() {
                  _balconies = v == '5+' ? 5 : int.parse(v);
                });
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Garden',
              const ['yes', 'no'],
              _farmGarden == null ? '' : (_farmGarden! ? 'yes' : 'no'),
              (v) {
                setState(() => _farmGarden = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Swimming Pool',
              const ['yes', 'no'],
              _farmSwimmingPool == null ? '' : (_farmSwimmingPool! ? 'yes' : 'no'),
              (v) {
                setState(() => _farmSwimmingPool = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
          ],

          if (!_isSellResidentialFarmhouse) ...[
            if (_isSellResidentialDuplex) ...[
              // Duplex plot details removed.
              _buildChoiceChipRow(
                'Construction Allowed',
                const ['yes', 'no'],
                _duplexConstructionAllowed == null
                    ? ''
                    : (_duplexConstructionAllowed! ? 'yes' : 'no'),
                (v) {
                  setState(() => _duplexConstructionAllowed = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Water Connection',
                const ['available', 'not_available'],
                _duplexWaterConnection == null
                    ? ''
                    : (_duplexWaterConnection! ? 'available' : 'not_available'),
                (v) {
                  setState(() => _duplexWaterConnection = v == 'available');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Electricity Connection',
                const ['available', 'not_available'],
                _duplexElectricityConnection == null
                    ? ''
                    : (_duplexElectricityConnection!
                          ? 'available'
                          : 'not_available'),
                (v) {
                  setState(
                    () => _duplexElectricityConnection = v == 'available',
                  );
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Road Access',
                const ['yes', 'no'],
                _duplexRoadAccess == null
                    ? ''
                    : (_duplexRoadAccess! ? 'yes' : 'no'),
                (v) {
                  setState(() => _duplexRoadAccess = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),

              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nearby Facilities',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _nearbyFacilitiesOptions.map((f) {
                    final selected = _duplexNearbyFacilities.contains(f);
                    final label = switch (f) {
                      'metro' => 'Metro',
                      'bus_stop' => 'Bus Stop',
                      'market' => 'Market',
                      'school' => 'School',
                      'hospital' => 'Hospital',
                      'park' => 'Park',
                      'mall' => 'Mall',
                      _ => 'Highway',
                    };
                    return FilterChip(
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppTheme.gold,
                      label: Text(label),
                      labelStyle: TextStyle(
                        color: AppColors.dark,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (v) {
                        setState(() {
                          v
                              ? _duplexNearbyFacilities.add(f)
                              : _duplexNearbyFacilities.remove(f);
                        });
                        _scheduleSaveDraft();
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],

            if (!_isSellResidentialDuplex) ...[
              if (_isRentLeaseResidentialStudioApartment) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Studio Apartment: Bedrooms=1 and Bathrooms=1 (fixed).',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 12),
              ] else ...[
                _buildChoiceChipRow(
                  'BHK',
                  const ['1', '2', '3', '4', '5', '6+'],
                  _bedrooms >= 6 ? '6+' : _bedrooms.toString(),
                  (v) {
                    setState(() {
                      _bedrooms = v == '6+' ? 6 : int.parse(v);
                    });
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Bathrooms',
                  const ['1', '2', '3', '4', '5', '6+'],
                  _bathrooms >= 6 ? '6+' : _bathrooms.toString(),
                  (v) {
                    setState(() {
                      _bathrooms = v == '6+' ? 6 : int.parse(v);
                    });
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Balconies',
                  const ['0', '1', '2', '3', '4', '5+'],
                  _balconies >= 5 ? '5+' : _balconies.toString(),
                  (v) {
                    setState(() {
                      _balconies = v == '5+' ? 5 : int.parse(v);
                    });
                    _scheduleSaveDraft();
                  },
                ),
              ],
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _buildStepper(
                      'Parking',
                      _parking,
                      0,
                      5,
                      (v) => setState(() => _parking = v),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCompactNumberField(
                      label: 'Total Floors',
                      controller: _totalFloors,
                      hint: 'Building floors',
                      icon: Icons.business,
                      onChanged: (_) => _handleTotalFloorsChanged(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildFloorNumberField(),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Furnishing',
                _furnishings,
                _furnishing,
                (v) => setState(() => _furnishing = v),
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Facing',
                _facings,
                _facing,
                (v) => setState(() => _facing = v),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _carpetArea,
                'Carpet Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _builtUpArea,
                'Built-up Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _superBuiltUpArea,
                'Super Built-up Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              // Villa plot area removed from here (handled elsewhere if needed).
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Availability',
                _availabilityTypes,
                _availability,
                (v) => setState(() => _availability = v),
              ),
              if (_availability == 'ready_to_move' ||
                  _availability == 'immediate') ...[
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Property Age',
                  _readyTimeframes,
                  _readyTimeframe,
                  (v) => setState(() => _readyTimeframe = v),
                  displayFor: (v) {
                    switch (v) {
                      case '0_1':
                        return '0-1 year';
                      case '1_5':
                        return '1-5 years';
                      case '5_10':
                        return '5-10 years';
                      case '10_plus':
                        return '10+ years';
                      default:
                        return v.replaceAll('_', ' ');
                    }
                  },
                ),
              ] else ...[
                const SizedBox(height: 12),
                _buildTextField(
                  _possessionBy,
                  'Possession By',
                  'YYYY-MM-DD',
                  Icons.event,
                  readOnly: true,
                  onTap: () => _pickDateForController(_possessionBy),
                ),
              ],
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Ownership',
                _ownershipTypes,
                _ownership,
                (v) => setState(() => _ownership = v),
              ),

              if (_isSellResidentialApartment) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Apartment Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional Rooms',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _apartmentAdditionalRooms.map((r) {
                      final selected = _additionalRooms.contains(r);
                      final label = r[0].toUpperCase() + r.substring(1);
                      return FilterChip(
                        selected: selected,
                        showCheckmark: false,
                        label: Text(
                          label,
                          style: TextStyle(color: AppColors.dark),
                        ),
                        selectedColor: AppTheme.gold,
                        labelStyle: TextStyle(
                          color: selected
                              ? const Color(0xFF070B14)
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (v) {
                          setState(() {
                            v
                                ? _additionalRooms.add(r)
                                : _additionalRooms.remove(r);
                          });
                          _scheduleSaveDraft();
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Corner Property',
                  const ['yes', 'no'],
                  _cornerProperty == null ? '' : (_cornerProperty! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _cornerProperty = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                // Property highlights removed (not needed).
              ],

              if (_isRentLeaseResidentialApartment) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyKind == _CreatePropertyKind.lease
                        ? 'Lease Apartment Details'
                        : 'Rent Apartment Details',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional Rooms',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _roomOptions.map((r) {
                    final selected = _rentAdditionalRooms.contains(r);
                    final label = r
                        .replaceAll('_', ' ')
                        .split(' ')
                        .map(
                          (w) => w.isEmpty
                              ? w
                              : (w[0].toUpperCase() + w.substring(1)),
                        )
                        .join(' ');
                    return FilterChip(
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppTheme.gold,
                      label: Text(
                        label,
                        style: TextStyle(color: AppColors.dark),
                      ),
                      labelStyle: TextStyle(
                        color: selected
                            ? const Color(0xFF070B14)
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (v) {
                        setState(() {
                          v
                              ? _rentAdditionalRooms.add(r)
                              : _rentAdditionalRooms.remove(r);
                        });
                        _scheduleSaveDraft();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Furnishing Status',
                  _furnishings,
                  _furnishing,
                  (v) {
                    setState(() => _furnishing = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Corner Property',
                  const ['yes', 'no'],
                  _rentCornerProperty == null ? '' : (_rentCornerProperty! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _rentCornerProperty = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Pet Friendly',
                  const ['yes', 'no'],
                  _petFriendly ? 'yes' : 'no',
                  (v) {
                    setState(() => _petFriendly = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Wheelchair Friendly',
                  const ['yes', 'no'],
                  _wheelchairFriendly ? 'yes' : 'no',
                  (v) {
                    setState(() => _wheelchairFriendly = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Gated Society',
                  const ['yes', 'no'],
                  _rentGatedSociety == null ? '' : (_rentGatedSociety! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _rentGatedSociety = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _availableFrom,
                  readOnly: true,
                  onTap: _pickAvailableFrom,
                  decoration: const InputDecoration(
                    labelText: 'Available From',
                    hintText: 'Select date',
                    prefixIcon: Icon(Icons.calendar_month_outlined, size: 18),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildIntDropdownField(
                        label: 'Lease Duration (Months)',
                        controller: _leaseDurationMonths,
                        min: 1,
                        max: 60,
                        hint: 'Select months',
                        icon: Icons.timelapse_outlined,
                        allowEmpty: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildIntDropdownField(
                        label: 'Lock-in (Months)',
                        controller: _lockInMonths,
                        min: 0,
                        max: 36,
                        hint: 'Select months',
                        icon: Icons.lock_clock_outlined,
                        allowEmpty: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildIntDropdownField(
                        label: 'Notice Period',
                        controller: _noticePeriodValue,
                        min: 0,
                        max: 180,
                        hint: 'Select',
                        icon: Icons.notifications_active_outlined,
                        allowEmpty: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Unit',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _noticeUnits.contains(_noticePeriodUnit)
                                ? _noticePeriodUnit
                                : _noticeUnits.first,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              hintText: 'Select unit',
                              prefixIcon: Icon(
                                Icons.straighten_outlined,
                                size: 18,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.white,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                            items: _noticeUnits
                                .map(
                                  (u) => DropdownMenuItem<String>(
                                    value: u,
                                    child: Text(
                                      u.toUpperCase(),
                                      style: const TextStyle(
                                        color: AppColors.dark,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              setState(() => _noticePeriodUnit = v ?? 'days');
                              _scheduleSaveDraft();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Preferred Tenant',
                  _preferredTenants,
                  _preferredTenant,
                  (v) {
                    setState(() => _preferredTenant = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Food Preference',
                  _foodPreferences,
                  _foodPreference,
                  (v) {
                    setState(() => _foodPreference = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Promotion Type',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _rentPromotionOptions.map((p) {
                    final selected = _rentPromotionTypes.contains(p);
                    final label = p
                        .replaceAll('_', ' ')
                        .split(' ')
                        .map(
                          (w) => w.isEmpty
                              ? w
                              : (w[0].toUpperCase() + w.substring(1)),
                        )
                        .join(' ');
                    return FilterChip(
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppTheme.gold,
                      label: Text(
                        label,
                        style: TextStyle(color: AppColors.dark),
                      ),
                      labelStyle: TextStyle(
                        color: selected
                            ? const Color(0xFF070B14)
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (v) {
                        setState(() {
                          v
                              ? _rentPromotionTypes.add(p)
                              : _rentPromotionTypes.remove(p);
                        });
                        _scheduleSaveDraft();
                      },
                    );
                  }).toList(),
                ),
              ],

              if (_isRentLeaseResidentialVillaHouse) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyKind == _CreatePropertyKind.lease
                        ? 'Lease $_rentLeaseHouseVillaTitle'
                        : 'Rent $_rentLeaseHouseVillaTitle',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  _plotArea,
                  'Plot Area (Optional)',
                  'Area in sqft',
                  Icons.terrain,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _scheduleSaveDraft(),
                ),
                const SizedBox(height: 12),
                _buildStepper('Parking Spots', _parking, 0, 10, (v) {
                  setState(() => _parking = v);
                  _scheduleSaveDraft();
                }),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Outdoors',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _villaOutdoorsOptions.map((o) {
                    final selected = _rentVillaOutdoors.contains(o);
                    final label = o
                        .replaceAll('_', ' ')
                        .split(' ')
                        .map(
                          (w) => w.isEmpty
                              ? w
                              : (w[0].toUpperCase() + w.substring(1)),
                        )
                        .join(' ');
                    return FilterChip(
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppTheme.gold,
                      label: Text(
                        label,
                        style: TextStyle(color: AppColors.dark),
                      ),
                      labelStyle: TextStyle(
                        color: selected
                            ? const Color(0xFF070B14)
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (v) {
                        setState(() {
                          v
                              ? _rentVillaOutdoors.add(o)
                              : _rentVillaOutdoors.remove(o);
                        });
                        _scheduleSaveDraft();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Water Source',
                  _waterSourceOptions,
                  _rentVillaWaterSource,
                  (v) {
                    setState(() => _rentVillaWaterSource = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Solar Power',
                  const ['yes', 'no'],
                  _rentSolarPower ? 'yes' : 'no',
                  (v) {
                    setState(() => _rentSolarPower = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Independent Entry',
                  const ['yes', 'no'],
                  _rentIndependentEntry ? 'yes' : 'no',
                  (v) {
                    setState(() => _rentIndependentEntry = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
              ],

              if (_isRentLeaseResidentialBuilderFloor) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyKind == _CreatePropertyKind.lease
                        ? 'Lease Builder Floor Details'
                        : 'Rent Builder Floor Details',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Lift',
                  const ['available', 'not_available'],
                  _rentLiftAvailable ? 'available' : 'not_available',
                  (v) {
                    setState(() => _rentLiftAvailable = v == 'available');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Gated Society',
                  const ['yes', 'no'],
                  _rentGatedSociety == null ? '' : (_rentGatedSociety! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _rentGatedSociety = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  _societyName,
                  'Society Name (Optional)',
                  'e.g., Green Heights',
                  Icons.apartment_outlined,
                  onChanged: (_) => _scheduleSaveDraft(),
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tenant Preference',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _tenantTypeOptions.map((t) {
                    final selected = _rentTenantTypes.contains(t);
                    final label = t[0].toUpperCase() + t.substring(1);
                    return FilterChip(
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppTheme.gold,
                      label: Text(
                        label,
                        style: TextStyle(color: AppColors.dark),
                      ),
                      labelStyle: TextStyle(
                        color: selected
                            ? const Color(0xFF070B14)
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (v) {
                        setState(() {
                          v
                              ? _rentTenantTypes.add(t)
                              : _rentTenantTypes.remove(t);
                        });
                        _scheduleSaveDraft();
                      },
                    );
                  }).toList(),
                ),
              ],

              if (_isRentLeaseResidentialStudioApartment) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyKind == _CreatePropertyKind.lease
                        ? 'Lease Studio Details'
                        : 'Rent Studio Details',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Room Type',
                  const ['1rk', 'studio'],
                  _studioConfig,
                  (v) {
                    setState(() => _studioConfig = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Kitchen Type',
                  _kitchenTypes,
                  _kitchenType,
                  (v) {
                    setState(() => _kitchenType = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tenant Preference',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _studioTenantOptions.map((t) {
                    final selected = _studioTenantPrefs.contains(t);
                    final label = t[0].toUpperCase() + t.substring(1);
                    return FilterChip(
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppTheme.gold,
                      label: Text(
                        label,
                        style: TextStyle(color: AppColors.dark),
                      ),
                      labelStyle: TextStyle(
                        color: selected
                            ? const Color(0xFF070B14)
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (v) {
                        setState(() {
                          v
                              ? _studioTenantPrefs.add(t)
                              : _studioTenantPrefs.remove(t);
                        });
                        _scheduleSaveDraft();
                      },
                    );
                  }).toList(),
                ),
              ],

              if (_isRentLeaseResidentialFarmhouse) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyKind == _CreatePropertyKind.lease
                        ? 'Lease Farmhouse Details'
                        : 'Rent Farmhouse Details',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _rentFarmLandArea,
                        'Land Area (Optional)',
                        'Area in sqft',
                        Icons.terrain,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _scheduleSaveDraft(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        _rentFarmRooms,
                        'Rooms (Optional)',
                        'e.g., 3',
                        Icons.meeting_room_outlined,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _scheduleSaveDraft(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Swimming Pool',
                  const ['yes', 'no'],
                  _rentFarmPool ? 'yes' : 'no',
                  (v) {
                    setState(() => _rentFarmPool = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Fencing',
                  const ['yes', 'no'],
                  _rentFarmFencing ? 'yes' : 'no',
                  (v) {
                    setState(() => _rentFarmFencing = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Event Options',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _farmUseCaseOptions.map((u) {
                    final selected = _rentFarmUseCases.contains(u);
                    final label = u[0].toUpperCase() + u.substring(1);
                    return FilterChip(
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppTheme.gold,
                      label: Text(
                        label,
                        style: TextStyle(color: AppColors.dark),
                      ),
                      labelStyle: TextStyle(
                        color: selected
                            ? const Color(0xFF070B14)
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (v) {
                        setState(() {
                          v
                              ? _rentFarmUseCases.add(u)
                              : _rentFarmUseCases.remove(u);
                        });
                        _scheduleSaveDraft();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _farmMonthlyCharges,
                        'Monthly Charges (Optional)',
                        'e.g., 50000',
                        Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _scheduleSaveDraft(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        _farmDailyCharges,
                        'Daily Charges (Optional)',
                        'e.g., 5000',
                        Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _scheduleSaveDraft(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _farmEventCharges,
                        'Event Charges (Optional)',
                        'e.g., 20000',
                        Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _scheduleSaveDraft(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildIntDropdownField(
                        label: 'Min Stay (Days)',
                        controller: _minStayDays,
                        min: 1,
                        max: 60,
                        hint: 'Select days',
                        icon: Icons.timelapse_outlined,
                        allowEmpty: false,
                      ),
                    ),
                  ],
                ),
              ],

              if (_isRentLeaseResidentialDuplex) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyKind == _CreatePropertyKind.lease
                        ? 'Lease Duplex Details'
                        : 'Rent Duplex Details',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  _plotArea,
                  'Plot Area (Optional)',
                  'Area in sqft',
                  Icons.terrain,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _scheduleSaveDraft(),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Gated Society',
                  const ['yes', 'no'],
                  _rentGatedSociety == null ? '' : (_rentGatedSociety! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _rentGatedSociety = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Water Source',
                  _waterSourceOptions,
                  _rentVillaWaterSource,
                  (v) {
                    setState(() => _rentVillaWaterSource = v);
                    _scheduleSaveDraft();
                  },
                ),
              ],

              if (_isSellResidentialVillaHouse) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Villa / Independent House Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional Rooms',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _apartmentAdditionalRooms.map((r) {
                      final selected = _villaAdditionalRooms.contains(r);
                      final label = r[0].toUpperCase() + r.substring(1);
                      return FilterChip(
                        selected: selected,
                        showCheckmark: false,
                        selectedColor: AppTheme.gold,
                        label: Text(
                          label,
                          style: TextStyle(color: AppColors.dark),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? const Color(0xFF070B14)
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (v) {
                          setState(() {
                            v
                                ? _villaAdditionalRooms.add(r)
                                : _villaAdditionalRooms.remove(r);
                          });
                          _scheduleSaveDraft();
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Corner Property',
                  const ['yes', 'no'],
                  _villaCornerProperty == null ? '' : (_villaCornerProperty! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _villaCornerProperty = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Parking',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _villaParkingOptions.map((p) {
                      final selected = _villaParking.contains(p);
                      final label = p == 'open'
                          ? 'Open Parking'
                          : 'Covered Parking';
                      return FilterChip(
                        selected: selected,
                        showCheckmark: false,
                        selectedColor: AppTheme.gold,
                        label: Text(
                          label,
                          style: TextStyle(color: AppColors.dark),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? const Color(0xFF070B14)
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (v) {
                          setState(() {
                            if (v) {
                              _villaParking
                                ..clear()
                                ..add(p);
                            } else {
                              _villaParking.remove(p);
                            }
                          });
                          _scheduleSaveDraft();
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Outdoors',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _outdoorsOptions.map((o) {
                      final selected = _outdoors.contains(o);
                      final label = switch (o) {
                        'garden_lawn' => 'Garden/Lawn',
                        'terrace' => 'Terrace',
                        _ => 'Boundary Wall',
                      };
                      return FilterChip(
                        selected: selected,
                        showCheckmark: false,
                        selectedColor: AppTheme.gold,
                        label: Text(
                          label,
                          style: TextStyle(color: AppColors.dark),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? const Color(0xFF070B14)
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (v) {
                          setState(() {
                            v ? _outdoors.add(o) : _outdoors.remove(o);
                          });
                          _scheduleSaveDraft();
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Water Source',
                  _waterSourceOptions,
                  _waterSource,
                  (v) {
                    setState(() => _waterSource = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Connections',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _connectionOptions.map((c) {
                      final selected = _connections.contains(c);
                      final label = switch (c) {
                        'electricity_connection' => 'Electricity Connection',
                        'solar_power' => 'Solar Power',
                        _ => 'Rainwater Harvesting',
                      };
                      return FilterChip(
                        selected: selected,
                        showCheckmark: false,
                        selectedColor: AppTheme.gold,
                        label: Text(
                          label,
                          style: TextStyle(color: AppColors.dark),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? const Color(0xFF070B14)
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (v) {
                          setState(() {
                            v ? _connections.add(c) : _connections.remove(c);
                          });
                          _scheduleSaveDraft();
                        },
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 12),
                // Booking/Maintenance moved to Pricing & Area.
              ],

              if (_isSellResidentialBuilderFloor) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Builder Floor Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Corner Property',
                  const ['yes', 'no'],
                  _builderCornerProperty == null ? '' : (_builderCornerProperty! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _builderCornerProperty = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Gated Society',
                  const ['yes', 'no'],
                  _builderGatedSociety == null ? '' : (_builderGatedSociety! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _builderGatedSociety = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _plotArea,
                        'Plot Area (Optional)',
                        'Area in sqft',
                        Icons.terrain,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _breadth,
                        'Width (ft)',
                        'e.g., 40',
                        Icons.straighten,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        _length,
                        'Length (ft)',
                        'e.g., 60',
                        Icons.straighten,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildStepper(
                  'Open Sides',
                  _openSides,
                  1,
                  4,
                  (v) => setState(() => _openSides = v),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Boundary Wall',
                  const ['yes', 'no'],
                  _boundaryWall == null ? '' : (_boundaryWall! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _boundaryWall = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Construction Allowed',
                  const ['yes', 'no'],
                  _constructionAllowed == null
                      ? ''
                      : (_constructionAllowed! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _constructionAllowed = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Utilities',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _builderUtilitiesOptions.map((u) {
                      final selected = _builderUtilities.contains(u);
                      final label = switch (u) {
                        'water' => 'Water',
                        'electricity' => 'Electricity',
                        'sewerage' => 'Sewerage',
                        _ => 'Road Access',
                      };
                      return FilterChip(
                        selected: selected,
                        showCheckmark: false,
                        selectedColor: AppTheme.gold,
                        label: Text(
                          label,
                          style: TextStyle(color: AppColors.dark),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? const Color(0xFF070B14)
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (v) {
                          setState(() {
                            v
                                ? _builderUtilities.add(u)
                                : _builderUtilities.remove(u);
                          });
                          _scheduleSaveDraft();
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _pricePerSqft,
                        'Price per Sq.ft (Optional)',
                        'e.g., 9500',
                        Icons.calculate_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
          if (false) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Office Space Details',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_commercialType == 'office') ...[
              _buildChoiceChipRow('Office Type', _officeTypes, _officeType, (
                v,
              ) {
                setState(() => _officeType = v);
                _scheduleSaveDraft();
              }),
              const SizedBox(height: 12),
              _buildTextField(
                _floorPlateArea,
                'Office Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildIntDropdownField(
                      label: 'Cabins',
                      controller: _cabins,
                      min: 0,
                      max: 50,
                      hint: 'Select cabins',
                      icon: Icons.meeting_room_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildIntDropdownField(
                      label: 'Meeting Rooms',
                      controller: _meetingRooms,
                      min: 0,
                      max: 30,
                      hint: 'Select rooms',
                      icon: Icons.groups_2_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildIntDropdownField(
                      label: 'Seats',
                      controller: _seats,
                      min: 0,
                      max: 500,
                      hint: 'Select seats',
                      icon: Icons.event_seat_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildIntDropdownField(
                      label: 'Max Seats',
                      controller: _maxSeats,
                      min: 0,
                      max: 500,
                      hint: 'Select max',
                      icon: Icons.event_seat_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildIntDropdownField(
                label: 'Conference Rooms',
                controller: _conferenceRooms,
                min: 0,
                max: 20,
                hint: 'Select rooms',
                icon: Icons.co_present_outlined,
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Lift',
                const ['available', 'not_available'],
                _liftAvailable ? 'available' : 'not_available',
                (v) => setState(() => _liftAvailable = v == 'available'),
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Reception Area',
                const ['yes', 'no'],
                _receptionArea ? 'yes' : 'no',
                (v) {
                  setState(() => _receptionArea = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Pantry',
                const ['yes', 'no'],
                _pantry ? 'yes' : 'no',
                (v) {
                  setState(() => _pantry = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildIntDropdownField(
                label: 'Washrooms (Optional)',
                controller: _washrooms,
                min: 0,
                max: 30,
                hint: 'Select washrooms',
                icon: Icons.wc_outlined,
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Cafeteria',
                const ['yes', 'no'],
                _cafeteria ? 'yes' : 'no',
                (v) {
                  setState(() => _cafeteria = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Server Room',
                const ['yes', 'no'],
                _serverRoom ? 'yes' : 'no',
                (v) {
                  setState(() => _serverRoom = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Fire Safety Installed',
                const ['yes', 'no'],
                _fireSafetyInstalled ? 'yes' : 'no',
                (v) {
                  setState(() => _fireSafetyInstalled = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Central AC',
                const ['yes', 'no'],
                _centralAC ? 'yes' : 'no',
                (v) {
                  setState(() => _centralAC = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Furnishing Status',
                _furnishings,
                _furnishing,
                (v) => setState(() => _furnishing = v),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildCompactNumberField(
                      label: 'Office on Floor',
                      controller: _floor,
                      hint: 'e.g., 5',
                      icon: Icons.stairs_outlined,
                      onChanged: (_) => _scheduleSaveDraft(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildCompactNumberField(
                      label: 'Total Floors',
                      controller: _totalFloors,
                      hint: 'e.g., 20',
                      icon: Icons.business,
                      onChanged: (_) => _handleTotalFloorsChanged(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildIntDropdownField(
                label: 'Number of Lifts (Optional)',
                controller: _numberOfLifts,
                min: 0,
                max: 20,
                hint: 'Select lifts',
                icon: Icons.elevator_outlined,
              ),
              const SizedBox(height: 12),
              _buildStepper(
                'Parking Available (Spots)',
                _parking,
                0,
                50,
                (v) => setState(() => _parking = v),
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Visitor Parking',
                const ['yes', 'no'],
                _visitorParking ? 'yes' : 'no',
                (v) {
                  setState(() => _visitorParking = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Facing',
                _facings,
                _facing,
                (v) => setState(() => _facing = v),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _superBuiltUpArea,
                'Super Built-up Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _builtUpArea,
                'Built-up Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _carpetArea,
                'Carpet Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Ownership Type',
                _ownershipTypes,
                _ownership,
                (v) => setState(() => _ownership = v),
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Tax Included',
                const ['yes', 'no'],
                _taxIncluded ? 'yes' : 'no',
                (v) {
                  setState(() => _taxIncluded = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Price Negotiable',
                const ['yes', 'no'],
                _officeNegotiable == null
                    ? ''
                    : (_officeNegotiable! ? 'yes' : 'no'),
                (v) {
                  setState(() => _officeNegotiable = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      _officeMaintenanceCharges,
                      'Maintenance Charges (Optional)',
                      '₹ 3500/month',
                      Icons.payments_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      _officeBookingAmount,
                      'Booking Amount (Optional)',
                      '₹ 2,00,000',
                      Icons.account_balance_wallet_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ] else if (_commercialType == 'warehouse') ...[
              _buildTextField(
                _floorPlateArea,
                'Storage Area',
                'Area in sqft',
                Icons.warehouse_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildIntDropdownField(
                label: 'Washrooms',
                controller: _washrooms,
                min: 0,
                max: 30,
                hint: 'Select washrooms',
                icon: Icons.wc_outlined,
              ),
            ] else ...[
              _buildTextField(
                _floorPlateArea,
                'Area',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _shopFacade,
                'Facade (Optional)',
                'Front width / facade size',
                Icons.storefront_outlined,
              ),
              const SizedBox(height: 12),
              _buildIntDropdownField(
                label: 'Washrooms (Optional)',
                controller: _washrooms,
                min: 0,
                max: 30,
                hint: 'Select washrooms',
                icon: Icons.wc_outlined,
              ),
            ],
            if (!_commercialTypes.contains(_commercialType)) ...[
              const SizedBox(height: 8),
              Text(
                'Select a Commercial sub-category to see details.',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Parking Type',
              _parkingTypes,
              _parkingType,
              (v) => setState(() => _parkingType = v),
            ),
            const SizedBox(height: 12),
            _buildStepper(
              'Parking Spots',
              _parking,
              0,
              20,
              (v) => setState(() => _parking = v),
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Pre-leased',
              const ['yes', 'no'],
              _preLeased ? 'yes' : 'no',
              (v) => setState(() => _preLeased = v == 'yes'),
            ),
            if (_commercialType == 'showroom') ...[
              const SizedBox(height: 12),
              _buildRatingDropdown(
                label: 'Quality Rating (Optional)',
                controller: _qualityRating,
              ),
            ],
          ],
          // NOTE: Land/Plot details render above (outside commercial block).
          if (false) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _landType == 'commercial'
                    ? 'Commercial Plot Details'
                    : (_landType == 'agricultural'
                          ? 'Agriculture Plot Details'
                          : 'Residential Plot Details'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _plotArea,
              keyboardType: TextInputType.number,
              onChanged: (_) => _scheduleSaveDraft(),
              decoration: InputDecoration(
                labelText: 'Plot Area',
                hintText: 'Area',
                prefixIcon: const Icon(Icons.terrain, size: 18),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _plotAreaUnit,
                      isDense: true,
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      items:
                          (_landType == 'agricultural'
                                  ? _areaUnits
                                  : _areaUnits.where((u) => u != 'acre'))
                              .map(
                                (u) => DropdownMenuItem<String>(
                                  value: u,
                                  child: Text(
                                    u,
                                    style: const TextStyle(
                                      color: AppColors.dark,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (v) {
                        setState(() => _plotAreaUnit = v ?? _plotAreaUnit);
                        _scheduleSaveDraft();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _length,
                    'Length (ft)',
                    'e.g., 60',
                    Icons.straighten,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _breadth,
                    'Breadth (ft)',
                    'e.g., 40',
                    Icons.straighten,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildIntDropdownField(
              label: 'Floors Allowed (Optional)',
              controller: _floorsAllowed,
              min: 0,
              max: 50,
              hint: 'Select floors',
              icon: Icons.layers_outlined,
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Corner Plot',
              const ['yes', 'no'],
              _plotCorner == null ? '' : (_plotCorner! ? 'yes' : 'no'),
              (v) {
                setState(() => _plotCorner = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Boundary Wall',
              const ['yes', 'no'],
              _boundaryWall == null ? '' : (_boundaryWall! ? 'yes' : 'no'),
              (v) {
                setState(() => _boundaryWall = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildStepper(
              'Open Sides',
              _openSides,
              1,
              4,
              (v) => setState(() => _openSides = v),
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Construction Done',
              const ['yes', 'no'],
              _constructionDone == null ? '' : (_constructionDone! ? 'yes' : 'no'),
              (v) {
                setState(() => _constructionDone = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _roadWidth,
              'Road Width',
              'Width in feet',
              Icons.straighten,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Road Access',
              const ['yes', 'no'],
              _plotRoadAccess == null ? '' : (_plotRoadAccess! ? 'yes' : 'no'),
              (v) {
                setState(() => _plotRoadAccess = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            if (_landType == 'agricultural') ...[
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Water Source',
                _agriWaterSources,
                _agriWaterSource,
                (v) {
                  setState(() => _agriWaterSource = v);
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Fencing',
                const ['yes', 'no'],
                _agriFencing ? 'yes' : 'no',
                (v) {
                  setState(() => _agriFencing = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
            ],
            if (isSale || isRentLease) ...[
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Ownership',
                _ownershipTypes,
                _ownership,
                (v) => setState(() => _ownership = v),
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Availability',
                _availabilityTypes,
                _availability,
                (v) => setState(() => _availability = v),
              ),
              if (_availability != 'ready_to_move' &&
                  _availability != 'immediate') ...[
                const SizedBox(height: 12),
                _buildTextField(
                  _possessionBy,
                  'Possession By',
                  'YYYY-MM-DD',
                  Icons.event,
                  readOnly: true,
                  onTap: () => _pickDateForController(_possessionBy),
                ),
              ],
            ],
          ],
          if (isPgCoLiving) ...[
            const SizedBox(height: 12),
            Text(
              'PG / Co-living usually needs room-wise details. Fill bedrooms/bathrooms and add room photos.',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildFloorDropdown() {
    final total = _totalFloorsValue;
    final selected = int.tryParse(_floor.text.trim());
    final items = total == null
        ? const <int>[]
        : List<int>.generate(total, (i) => i + 1);

    return AppDropdown<int>(
      label: 'Floor No.',
      hintText: total == null
          ? 'Enter total floors first'
          : 'Select your floor',
      prefixIcon: Icons.flood,
      value: (selected != null && items.contains(selected)) ? selected : null,
      items: items
          .map(
            (n) => DropdownMenuItem<int>(
              value: n,
              child: Text(
                '$n',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
          )
          .toList(),
      onChanged: total == null
          ? null
          : (v) {
              setState(() {
                _floor.text = v?.toString() ?? '';
                _validateField('floor');
              });
              _scheduleSaveDraft();
            },
    );
  }

  Future<void> _showCurfewTimePicker() async {
    int selectedHour = 10;
    String selectedPeriod = 'PM';

    final existing = _pgCurfewTime.text.trim().toUpperCase();
    if (existing.isNotEmpty) {
      final parts = existing.split(' ');
      if (parts.isNotEmpty) {
        final timePart = parts[0];
        final hourPart = timePart.split(':')[0];
        selectedHour = int.tryParse(hourPart) ?? 10;
        if (parts.length > 1) {
          selectedPeriod = parts[1].startsWith('A') ? 'AM' : 'PM';
        }
      }
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.dark2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: AppColors.dark2,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1.5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textSubtle.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Curfew Hour',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Select the hour on the clock face below.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ['AM', 'PM'].map((period) {
                      final active = selectedPeriod == period;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() => selectedPeriod = period);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: active ? AppColors.gold : AppColors.dark3,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active ? AppColors.gold : AppColors.border,
                            ),
                          ),
                          child: Text(
                            period,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: active
                                  ? AppColors.dark
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.04),
                        border: Border.all(
                          color: AppColors.border.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Positioned.fill(
                          //   // child: CustomPaint(
                          //   //   painter: ClockHandPainter(selectedHour: selectedHour),
                          //   // ),
                          // ),
                          ...List.generate(12, (index) {
                            final hour = index + 1;
                            final active = selectedHour == hour;
                            final angle = (hour * 30 - 90) * math.pi / 180;
                            const radius = 84.0;
                            final x = 110 + radius * math.cos(angle) - 20;
                            final y = 110 + radius * math.sin(angle) - 20;

                            return Positioned(
                              left: x,
                              top: y,
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () {
                                  setModalState(() => selectedHour = hour);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: active
                                        ? AppTheme.gold
                                        : AppColors.dark3,
                                    border: Border.all(
                                      color: active
                                          ? AppTheme.gold
                                          : AppColors.border,
                                      width: active ? 2 : 1,
                                    ),
                                    boxShadow: active
                                        ? [
                                            BoxShadow(
                                              color: AppTheme.gold.withValues(
                                                alpha: 0.4,
                                              ),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$hour',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: active
                                          ? const Color(0xFF070B14)
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              _pgCurfewTime.text =
                                  '${selectedHour.toString().padLeft(2, '0')}:00 $selectedPeriod';
                            });
                            _scheduleSaveDraft();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.dark,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFloorNumberField() {
    final total = _totalFloorsValue;
    final value = int.tryParse(_floor.text.trim());
    final invalid =
        total != null && value != null && (value < 1 || value > total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Floor No.',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _floor,
          keyboardType: TextInputType.number,
          onChanged: (_) {
            setState(() {});
            _scheduleSaveDraft();
          },
          decoration: InputDecoration(
            hintText: total == null ? 'Enter total floors first' : '1 - $total',
            prefixIcon: const Icon(Icons.flood, size: 18),
            errorText: (total == null)
                ? null
                : (invalid ? 'Floor must be between 1 and $total' : null),
          ),
        ),
      ],
    );
  }

  Widget _buildAmenities() {
    return ref
        .watch(amenitiesProvider)
        .when(
          data: (items) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _openAmenitiesPicker(items),
                  icon: const Icon(Icons.tune, color: AppTheme.gold),
                  label: const Text(
                    'Select Amenities',
                    style: TextStyle(color: AppTheme.gold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_selectedAmenityIds.isEmpty)
                Text(
                  'No amenities selected',
                  style: const TextStyle(color: Color(0xFFCBD5E1)),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedAmenityIds.map((id) {
                    final name =
                        items
                                .cast<dynamic>()
                                .firstWhere(
                                  (a) => a.id == id,
                                  orElse: () => null,
                                )
                                ?.name
                            as String?;
                    return Chip(
                      label: Text(name ?? 'Amenity $id'),
                      onDeleted: () => setState(() {
                        _selectedAmenityIds.remove(id);
                        _scheduleSaveDraft();
                      }),
                    );
                  }).toList(),
                ),
            ],
          ),
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
        );
  }

  Future<void> _openAmenitiesPicker(List items) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF070B14),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final tempSelected = Set<int>.of(_selectedAmenityIds);
        return StatefulBuilder(
          builder: (context, setSheetState) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Amenities',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: items
                            .map(
                              (a) => FilterChip(
                                label: Text(
                                  a.name,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                selected: tempSelected.contains(a.id),
                                onSelected: (selected) => setSheetState(() {
                                  if (selected)
                                    tempSelected.add(a.id);
                                  else
                                    tempSelected.remove(a.id);
                                }),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedAmenityIds
                              ..clear()
                              ..addAll(tempSelected);
                          });
                          _scheduleSaveDraft();
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFurnishings() {
    return ref
        .watch(furnishingsProvider)
        .when(
          data: (items) {
            final sorted = List.of(items)
              ..sort((a, b) => a.name.compareTo(b.name));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openFurnishingsPicker(sorted),
                    icon: const Icon(Icons.tune, color: AppTheme.gold),
                    label: const Text(
                      'Select Furnishings',
                      style: TextStyle(color: AppTheme.gold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_selectedFurnishingIds.isEmpty)
                  Text(
                    'No furnishings selected',
                    style: const TextStyle(color: Color(0xFFCBD5E1)),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedFurnishingIds.map((id) {
                      final item = sorted.cast<dynamic>().firstWhere(
                        (f) => f.id == id,
                        orElse: () => null,
                      );
                      final label = item == null ? 'Item $id' : item.name;
                      final qty = _furnishingQuantities[id];
                      return Chip(
                        label: Text(qty == null ? label : '$label x$qty'),
                        onDeleted: () => setState(() {
                          _selectedFurnishingIds.remove(id);
                          _furnishingQuantities.remove(id);
                          _scheduleSaveDraft();
                        }),
                      );
                    }).toList(),
                  ),
              ],
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
        );
  }

  Future<void> _openFurnishingsPicker(List items) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF070B14),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final tempSelected = Set<int>.of(_selectedFurnishingIds);
        final tempQty = Map<int, int>.of(_furnishingQuantities);
        return StatefulBuilder(
          builder: (context, setSheetState) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Furnishings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final f = items[i];
                        final selected = tempSelected.contains(f.id);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Checkbox(
                                value: selected,
                                onChanged: (v) => setSheetState(() {
                                  if (v == true) {
                                    tempSelected.add(f.id);
                                    if (f.isCountable) {
                                      tempQty.putIfAbsent(f.id, () => 1);
                                    }
                                  } else {
                                    tempSelected.remove(f.id);
                                    tempQty.remove(f.id);
                                  }
                                }),
                              ),
                              Expanded(
                                child: Text(
                                  f.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (f.isCountable)
                                _QuantityStepper(
                                  value: tempQty[f.id] ?? 1,
                                  enabled: selected,
                                  onChanged: (next) => setSheetState(() {
                                    tempQty[f.id] = next;
                                  }),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFurnishingIds
                              ..clear()
                              ..addAll(tempSelected);
                            _furnishingQuantities
                              ..clear()
                              ..addAll(tempQty);
                          });
                          _scheduleSaveDraft();
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocation() {
    return Column(
      children: [
        Stack(
          children: [
            _buildTextField(
              _address,
              'Address',
              'Street address',
              Icons.location_on,
              onChanged: _onAddressChanged,
              errorText: _addressErr,
            ),
            if (_isFetchingAddress)
              const Positioned(
                right: 12,
                top: 12,
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            if (_addressFocus.hasFocus && _addressPredictions.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                top: 72,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF0B1220),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _addressPredictions.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final pred = _addressPredictions[i];
                        return ListTile(
                          dense: true,
                          title: Text(
                            pred.description,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(
                            Icons.north_west_rounded,
                            size: 16,
                            color: AppTheme.gold.withValues(alpha: 0.9),
                          ),
                          onTap: () => _selectAddressPrediction(pred),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (_isSellResidentialFarmhouse) ...[
          _buildTextField(
            _village,
            'Village',
            'Village name',
            Icons.location_city_outlined,
            onChanged: (_) => _scheduleSaveDraft(),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _landmark,
            'Landmark (Optional)',
            'Near ...',
            Icons.place_outlined,
            onChanged: (_) => _scheduleSaveDraft(),
          ),
          const SizedBox(height: 12),
        ],

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                _city,
                'City',
                'City name',
                Icons.location_city,
                onChanged: (_) => _validateField('city'),
                errorText: _cityErr,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                _state,
                'State',
                'State name',
                Icons.map,
                onChanged: (_) => _validateField('state'),
                errorText: _stateErr,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _pincode,
          'Pincode',
          '6-digit code',
          Icons.mail,
          keyboardType: TextInputType.number,
          onChanged: (_) => _validateField('pincode'),
          errorText: _pincodeErr,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _ownerName,
          'Owner Name (Optional)',
          'Owner full name',
          Icons.person_outline,
          onChanged: (_) => _scheduleSaveDraft(),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _ownerPhone,
          'Phone Number (Optional)',
          '10-digit phone',
          Icons.call_outlined,
          keyboardType: TextInputType.phone,
          onChanged: (_) => _scheduleSaveDraft(),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _forceAutoFillLocation,
            icon: const Icon(Icons.my_location, size: 16),
            label: const Text('Use current location'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.gold,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Lat/Lng are auto-filled and sent to API, but hidden from UI by design.
        if (_isSellResidentialApartment) ...[
          const SizedBox(height: 6),
          _buildChoiceChipRow(
            'WhatsApp Updates',
            const ['yes', 'no'],
            _whatsappUpdates ? 'yes' : 'no',
            (v) {
              setState(() => _whatsappUpdates = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
        ],
      ],
    );
  }

  // Widget _buildPromotion() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Boost Listing',
  //         style: TextStyle(
  //           fontSize: 13,
  //           fontWeight: FontWeight.w800,
  //           color: AppColors.textPrimary,
  //         ),
  //       ),
  //       const SizedBox(height: 6),
  //       const Text(
  //         'Select promotions to get more visibility.',
  //         style: TextStyle(fontSize: 12, color: AppColors.textMuted),
  //       ),
  //       const SizedBox(height: 10),
  //       ..._promotionOptions.map((p) {
  //         final selected = _promotionTags.contains(p);
  //         final label = p[0].toUpperCase() + p.substring(1);
  //         return CheckboxListTile(
  //           value: selected,
  //           fillColor: WidgetStateProperty.all(AppTheme.gold),
  //           // selectedTileColor: AppTheme.gold,
  //           onChanged: (v) {
  //             setState(() {
  //               if (v == true) {
  //                 _promotionTags.add(p);
  //               } else {
  //                 _promotionTags.remove(p);
  //               }
  //             });
  //             _scheduleSaveDraft();
  //           },
  //           dense: true,
  //           controlAffinity: ListTileControlAffinity.leading,
  //           title: Text(
  //             label,
  //             style: const TextStyle(color: AppColors.textPrimary),
  //           ),
  //           contentPadding: EdgeInsets.zero,
  //         );
  //       }),
  //     ],
  //   );
  // }

  Widget _buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMediaButton(
                Icons.photo_camera,
                'Camera',
                Colors.blue,
                _pickImageCamera,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMediaButton(
                Icons.photo_library,
                'Gallery',
                Colors.green,
                _pickImages,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMediaButton(
                Icons.videocam,
                'Video',
                Colors.orange,
                _pickVideoCamera,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_images.isEmpty)
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 40,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add photos to showcase your property',
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  Text(
                    '${_images.length}/20 photos',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1, // This forces square aspect ratio
            ),
            itemBuilder: (context, i) => Stack(
              clipBehavior: Clip.none,
              children: [
                // Image with fixed square box
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey.shade200,
                    child: _PreviewImage(src: _images[i].path),
                  ),
                ),

                // PRIMARY Badge - Top Left
                if (i == _primaryImageIndex)
                  Positioned(
                    top: 3,
                    left: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'PRIMARY',
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                // Star Button - Top Right
                Positioned(
                  top: 3,
                  right: 3,
                  child: GestureDetector(
                    onTap: () => setState(() => _primaryImageIndex = i),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.star, size: 11, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                // Delete Button - Bottom Right
                Positioned(
                  bottom: 3,
                  right: 3,
                  child: GestureDetector(
                    onTap: () => _removeImage(i),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.close, size: 11, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                // Tag Dropdown - Bottom Left
                Positioned(
                  bottom: 3,
                  left: 3,
                  right: 40,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1220).withValues(alpha: 0.92),
                      border: Border.all(
                        color: AppTheme.gold.withValues(alpha: 0.22),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButton<String>(
                      value: _getAvailableTags().contains(_images[i].tag)
                          ? _images[i].tag
                          : 'general',
                      dropdownColor: Colors.white,
                      underline: const SizedBox(),
                      isExpanded: true,
                      isDense: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 14,
                        color: AppTheme.gold.withValues(alpha: 0.95),
                      ),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 9,
                      ),
                      onChanged: (newTag) => _updateImageTag(i, newTag!),
                      items: _getAvailableTags().map((tag) {
                        return DropdownMenuItem<String>(
                          value: tag,
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildVideoSection() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _videos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) => Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (_) => _VideoPlayerDialog(src: _videos[i].path),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.black,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.play_circle_filled,
                            color: Colors.white,
                            size: 40,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              color: Colors.black54,
                              child: Text(
                                _videos[i].tag ?? 'Video',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      onPressed: () => _removeVideo(i),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== UI Helper Widgets ====================

  FilterChip _simpleFilterChip({
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      selectedColor: AppTheme.gold,
      backgroundColor: Colors.white.withValues(alpha: 0.08),
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: selected ? const Color(0xFF070B14) : AppColors.dark2,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      onSelected: onSelected,
    );
  }

  Widget _buildTextField(
    TextEditingController c,
    String label,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? suffixText,
    String? errorText,
    String? helperText,
    bool readOnly = false,
    VoidCallback? onTap,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          focusNode: c == _address ? _addressFocus : null,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            helperText: helperText,
            prefixIcon: Icon(icon, size: 18),
            suffixText: suffixText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceGrid<T>({
    required String label,
    required List<T> values,
    required T? value,
    required String Function(T) labelFor,
    required ValueChanged<T> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            children: values
                .map(
                  (v) => ChoiceChip(
                    showCheckmark: false,
                    label: Text(
                      labelFor(v),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: value == v
                            ? const Color(0xFF070B14)
                            : AppColors.dark2,
                      ),
                    ),
                    selected: value == v,
                    onSelected: (_) => onChanged(v),
                    selectedColor: AppTheme.gold,
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceChipRow(
    String label,
    List<String> options,
    String selected,
    ValueChanged<String> onChanged, {
    String Function(String opt)? displayFor,
  }) {
    bool isSelected(String opt) {
      final normSel = selected.trim().toLowerCase().replaceAll('-', '_');
      final normOpt = opt.trim().toLowerCase().replaceAll('-', '_');
      return normSel == normOpt;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            spacing: 6,
            children: options
                .map(
                  (opt) => Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        (displayFor != null)
                            ? displayFor(opt)
                            : opt.replaceAll('_', ' ').toUpperCase(),
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected(opt)
                              ? const Color(0xFF070B14)
                              : AppColors.dark2,
                        ),
                      ),
                      selected: isSelected(opt),
                      onSelected: (_) => onChanged(opt),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      selectedColor: AppTheme.gold,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStepper(
    String label,
    int value,
    int min,
    int max,
    ValueChanged<int> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => onChanged((value - 1).clamp(min, max)),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.remove,
                    size: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: () => onChanged((value + 1).clamp(min, max)),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactNumberField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textPrimary),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hint,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIntDropdownField({
    required String label,
    required TextEditingController controller,
    required int min,
    required int max,
    required String hint,
    required IconData icon,
    bool allowEmpty = true,
  }) {
    final raw = controller.text.trim();
    final selected = int.tryParse(raw);
    final values = List<int>.generate(max - min + 1, (i) => min + i);

    return AppDropdown<int>(
      label: label,
      hintText: hint,
      prefixIcon: icon,
      value: (selected != null && values.contains(selected)) ? selected : null,
      items: [
        if (allowEmpty)
          const DropdownMenuItem<int>(
            value: null,
            child: Text('Select', style: TextStyle(color: AppColors.textMuted)),
          ),
        ...values.map(
          (v) => DropdownMenuItem<int>(
            value: v,
            child: Text(
              '$v',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ),
      ],
      onChanged: (v) {
        setState(() => controller.text = v?.toString() ?? '');
        _scheduleSaveDraft();
      },
    );
  }

  Widget _buildRatingDropdown({
    required String label,
    required TextEditingController controller,
    int min = 1,
    int max = 5,
  }) {
    final raw = controller.text.trim();
    final selected = int.tryParse(raw);
    final values = List<int>.generate(max - min + 1, (i) => min + i);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          value: (selected != null && values.contains(selected))
              ? selected
              : null,
          isExpanded: true,
          decoration: const InputDecoration(
            hintText: 'Select rating',
            prefixIcon: Icon(Icons.star_border_rounded, size: 18),
          ),
          dropdownColor: Colors.white,
          iconEnabledColor: Colors.white,
          style: const TextStyle(color: AppColors.textPrimary),
          items: [
            const DropdownMenuItem<int>(
              value: null,
              child: Text(
                'Select',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            ...values.map(
              (v) => DropdownMenuItem<int>(
                value: v,
                child: Text(
                  '$v ★',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ),
          ],
          onChanged: (v) {
            setState(() => controller.text = v?.toString() ?? '');
            _scheduleSaveDraft();
          },
        ),
      ],
    );
  }

  Widget _buildMediaButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: AppTheme.gold),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, color: AppTheme.gold),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: color.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ==================== Helper Classes ====================

enum _CreatePropertyKind { sale, rent, lease, pg, coLiving }

extension _CreatePropertyKindX on _CreatePropertyKind {
  String get label {
    switch (this) {
      case _CreatePropertyKind.sale:
        return 'Sale';
      case _CreatePropertyKind.rent:
        return 'Rent';
      case _CreatePropertyKind.lease:
        return 'Lease';
      case _CreatePropertyKind.pg:
        return 'PG';
      case _CreatePropertyKind.coLiving:
        return 'Co-Living';
    }
  }
}

enum MediaType { image, video }

class MediaItem {
  final String path;
  final MediaType type;
  String? tag;

  MediaItem({required this.path, required this.type, this.tag});
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({required this.src});
  final String src;

  @override
  Widget build(BuildContext context) {
    if (src.startsWith('http')) {
      return Image.network(
        src,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return buildLocalImage(src, fit: BoxFit.cover);
  }
}

class _VideoPlayerDialog extends StatefulWidget {
  const _VideoPlayerDialog({required this.src});

  final String src;

  @override
  State<_VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<_VideoPlayerDialog> {
  VideoPlayerController? _controller;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final ctrl = widget.src.startsWith('http')
          ? VideoPlayerController.networkUrl(Uri.parse(widget.src))
          : VideoPlayerController.file(File(widget.src));
      await ctrl.initialize();
      await ctrl.setLooping(true);
      await ctrl.play();
      if (!mounted) {
        await ctrl.dispose();
        return;
      }
      setState(() => _controller = ctrl);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: (_controller?.value.aspectRatio ?? 16 / 9),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_error.toString(), textAlign: TextAlign.center),
                ),
              )
            else if (_controller == null)
              const Center(child: CircularProgressIndicator())
            else
              VideoPlayer(_controller!),
            if (_controller != null)
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton.filled(
                  onPressed: () {
                    final c = _controller!;
                    setState(() {
                      c.value.isPlaying ? c.pause() : c.play();
                    });
                  },
                  icon: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });
  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 16,
            icon: const Icon(Icons.remove, color: AppTheme.gold),
            onPressed: enabled
                ? () => onChanged((value - 1).clamp(1, 99))
                : null,
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.gold,
            ),
          ),
          IconButton(
            iconSize: 16,
            icon: const Icon(Icons.add, color: AppTheme.gold),
            onPressed: enabled
                ? () => onChanged((value + 1).clamp(1, 99))
                : null,
          ),
        ],
      ),
    );
  }
}
