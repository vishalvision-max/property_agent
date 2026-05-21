import 'package:dio/dio.dart';

import 'api_dio.dart';
import '../models/category.dart';
import '../models/lookup_item.dart';

class LookupService {
  LookupService({Dio? dio}) : _dio = dio ?? ApiDio.unAuthed();

  final Dio _dio;

  Future<List<LookupItem>> getAmenities() async {
    final res = await _dio.get<List<dynamic>>('/amenities');
    final data = res.data ?? const [];
    return data
        .whereType<Map>()
        .map((e) => LookupItem.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false);
  }

  Future<List<LookupItem>> getFurnishings() async {
    final res = await _dio.get<List<dynamic>>('/furnishings');
    final data = res.data ?? const [];
    return data
        .whereType<Map>()
        .map((e) => LookupItem.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false);
  }

  Future<List<Category>> getCategories() async {
    final res = await _dio.get<List<dynamic>>('/categories');
    final data = res.data ?? const [];
    return data
        .whereType<Map>()
        .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false);
  }
}
