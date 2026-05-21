import 'package:dio/dio.dart';

import '../../core/constants/google_api_keys.dart';

class PlacePrediction {
  const PlacePrediction({required this.placeId, required this.description});

  final String placeId;
  final String description;
}

class ResolvedPlace {
  const ResolvedPlace({
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    this.postalCode,
    this.locality,
    this.administrativeAreaLevel1,
  });

  final String formattedAddress;
  final double latitude;
  final double longitude;
  final String? postalCode;
  final String? locality;
  final String? administrativeAreaLevel1;
}

class GooglePlacesService {
  GooglePlacesService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  String get _apiKey => GoogleApiKeys.places;

  void _ensureKey() {
    if (_apiKey.trim().isEmpty) {
      throw Exception(
        'Missing GOOGLE_API_KEY. Provide via --dart-define=GOOGLE_API_KEY=YOUR_KEY',
      );
    }
  }

  Future<List<PlacePrediction>> autocomplete({
    required String input,
    String? language,
    String? region,
    String? country, // e.g. "in"
  }) async {
    _ensureKey();
    final q = input.trim();
    if (q.isEmpty) return const [];

    final res = await _dio.get<Map<String, dynamic>>(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json',
      queryParameters: {
        'key': _apiKey,
        'input': q,
        if (language != null) 'language': language,
        if (region != null) 'region': region,
        if (country != null) 'components': 'country:$country',
      },
    );

    final body = res.data ?? const <String, dynamic>{};
    final status = (body['status'] ?? '').toString();
    if (status != 'OK' && status != 'ZERO_RESULTS') {
      final msg = (body['error_message'] ?? status).toString();
      throw Exception('Places autocomplete failed: $msg');
    }

    final preds = (body['predictions'] as List?) ?? const [];
    return preds
        .whereType<Map>()
        .map((e) {
          final m = Map<String, dynamic>.from(e);
          return PlacePrediction(
            placeId: (m['place_id'] ?? '').toString(),
            description: (m['description'] ?? '').toString(),
          );
        })
        .where((p) => p.placeId.isNotEmpty && p.description.isNotEmpty)
        .toList(growable: false);
  }

  Future<ResolvedPlace> placeDetails({required String placeId}) async {
    _ensureKey();
    final res = await _dio.get<Map<String, dynamic>>(
      'https://maps.googleapis.com/maps/api/place/details/json',
      queryParameters: {
        'key': _apiKey,
        'place_id': placeId,
        'fields': 'formatted_address,geometry,address_component',
      },
    );
    final body = res.data ?? const <String, dynamic>{};
    final status = (body['status'] ?? '').toString();
    if (status != 'OK') {
      final msg = (body['error_message'] ?? status).toString();
      throw Exception('Place details failed: $msg');
    }

    final result = (body['result'] as Map?) ?? const {};
    final m = Map<String, dynamic>.from(result);
    final formatted = (m['formatted_address'] ?? '').toString();
    final geometry = (m['geometry'] as Map?) ?? const {};
    final location = (geometry['location'] as Map?) ?? const {};
    final lat = (location['lat'] as num?)?.toDouble();
    final lng = (location['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) {
      throw Exception('Place details missing coordinates');
    }

    String? postal;
    String? locality;
    String? admin1;
    final comps = (m['address_components'] as List?) ?? const [];
    for (final c in comps.whereType<Map>()) {
      final cm = Map<String, dynamic>.from(c);
      final types =
          (cm['types'] as List?)?.map((e) => e.toString()).toList() ??
          const <String>[];
      final longName = (cm['long_name'] ?? '').toString();
      if (types.contains('postal_code')) postal = longName;
      if (types.contains('locality')) locality = longName;
      if (types.contains('administrative_area_level_1')) admin1 = longName;
    }

    return ResolvedPlace(
      formattedAddress: formatted,
      latitude: lat,
      longitude: lng,
      postalCode: postal,
      locality: locality,
      administrativeAreaLevel1: admin1,
    );
  }

  Future<ResolvedPlace> reverseGeocode({
    required double latitude,
    required double longitude,
    String? language,
  }) async {
    _ensureKey();
    final res = await _dio.get<Map<String, dynamic>>(
      'https://maps.googleapis.com/maps/api/geocode/json',
      queryParameters: {
        'key': _apiKey,
        'latlng': '$latitude,$longitude',
        if (language != null) 'language': language,
      },
    );
    final body = res.data ?? const <String, dynamic>{};
    final status = (body['status'] ?? '').toString();
    if (status != 'OK') {
      final msg = (body['error_message'] ?? status).toString();
      throw Exception('Reverse geocode failed: $msg');
    }

    final results = (body['results'] as List?) ?? const [];
    if (results.isEmpty) {
      throw Exception('Reverse geocode returned empty results');
    }
    final top = Map<String, dynamic>.from(results.first as Map);
    final formatted = (top['formatted_address'] ?? '').toString();

    String? postal;
    String? locality;
    String? admin1;
    final comps = (top['address_components'] as List?) ?? const [];
    for (final c in comps.whereType<Map>()) {
      final cm = Map<String, dynamic>.from(c);
      final types =
          (cm['types'] as List?)?.map((e) => e.toString()).toList() ??
          const <String>[];
      final longName = (cm['long_name'] ?? '').toString();
      if (types.contains('postal_code')) postal = longName;
      if (types.contains('locality')) locality = longName;
      if (types.contains('administrative_area_level_1')) admin1 = longName;
    }

    return ResolvedPlace(
      formattedAddress: formatted,
      latitude: latitude,
      longitude: longitude,
      postalCode: postal,
      locality: locality,
      administrativeAreaLevel1: admin1,
    );
  }
}
