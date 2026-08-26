import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;

import 'api_dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/category.dart';
import '../models/category_features.dart';
import '../models/media_type.dart';

class LookupService {
  LookupService({Dio? dio}) : _dio = dio ?? ApiDio.unAuthed();

  final Dio _dio;

  Future<List<Category>> getCategories() async {
    // /property-categories returns the full nested tree wrapped in an
    // envelope: { "success": true, "data": [ { ..., recursive_children } ] }
    debugPrint('[categories] GET ${ApiConstants.baseUrl}/property-categories');
    try {
      final res = await _dio.get<Map<String, dynamic>>('/property-categories');
      debugPrint('[categories] status=${res.statusCode}');
      final body = res.data ?? const {};
      final data = (body['data'] as List?) ?? const [];
      final cats = data
          .whereType<Map>()
          .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
          .toList(growable: false);
      debugPrint(
        '[categories] parsed ${cats.length} top-level: '
        '${cats.map((c) => '${c.slug}(${c.children.length})').join(', ')}',
      );
      return cats;
    } catch (e, st) {
      debugPrint('[categories] ERROR: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  /// Fetches the immediate sub-categories for a given category id via
  /// /property-categories/{id}/sub-categories.
  Future<List<Category>> getSubCategories(int categoryId) async {
    debugPrint('[subcategories] GET /property-categories/$categoryId/sub-categories');
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/property-categories/$categoryId/sub-categories',
      );
      debugPrint('[subcategories] status=${res.statusCode}');
      final body = res.data ?? const {};
      final data = (body['data'] as List?) ?? const [];
      final subs = data
          .whereType<Map>()
          .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
          .toList(growable: false);
      debugPrint('[subcategories] parsed ${subs.length} for id=$categoryId');
      return subs;
    } catch (e, st) {
      debugPrint('[subcategories] ERROR: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  /// Fetches the amenities + furnishings configured for a category via
  /// /property-categories/{id}/features. Used to show category-specific
  /// features on the create screen instead of the global lookups.
  Future<CategoryFeatures> getCategoryFeatures(int categoryId) async {
    debugPrint('[features] GET /property-categories/$categoryId/features');
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/property-categories/$categoryId/features',
      );
      debugPrint('[features] status=${res.statusCode}');
      final body = res.data ?? const {};
      final data = (body['data'] as Map?) ?? const {};
      final result = CategoryFeatures.fromJson(
        Map<String, dynamic>.from(data),
      );
      debugPrint(
        '[features] parsed amenities=${result.amenities.length} '
        'furnishings=${result.furnishings.length} for id=$categoryId',
      );
      return result;
    } catch (e, st) {
      debugPrint('[features] ERROR: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  /// Fetches the photo/video media-type tags for a category via
  /// /property-categories/{id}/media-types. Used to populate the image and
  /// video tag dropdowns on the property create screen dynamically.
  Future<CategoryMediaTypes> getMediaTypes(int categoryId) async {
    debugPrint('[media-types] GET /property-categories/$categoryId/media-types');
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/property-categories/$categoryId/media-types',
      );
      debugPrint('[media-types] status=${res.statusCode}');
      final body = res.data ?? const {};
      final data = (body['data'] as Map?) ?? const {};
      final result = CategoryMediaTypes.fromJson(
        Map<String, dynamic>.from(data),
      );
      debugPrint(
        '[media-types] parsed photos=${result.photos.length} '
        'videos=${result.videos.length} for id=$categoryId',
      );
      return result;
    } catch (e, st) {
      debugPrint('[media-types] ERROR: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}
