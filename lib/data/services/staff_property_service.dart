import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/api_constants.dart';
import '../models/activity.dart';
import '../models/property.dart';
import '../models/property_enums.dart';
import '../models/property_video.dart';
import '../models/property_furnishing_selection.dart';
import '../models/dashboard_counts.dart';
import 'api_dio.dart';
import 'property_service.dart';

class StaffPropertyService implements PropertyService {
  StaffPropertyService({Dio? dio})
    : _dioFuture = (dio != null) ? Future.value(dio) : ApiDio.authed();

  final Future<Dio> _dioFuture;

  // Debug logging (yellow highlight).
  // Note: Logging auth tokens is sensitive; keep masked by default.
  static const bool _logFullAuthToken = false;

  Future<File> compressImage(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filename = file.path.split(Platform.pathSeparator).last;
      final dotIndex = filename.lastIndexOf('.');
      final ext = dotIndex != -1
          ? filename.substring(dotIndex).toLowerCase()
          : '.jpg';
      final nameWithoutExt = dotIndex != -1
          ? filename.substring(0, dotIndex)
          : filename;

      CompressFormat format = CompressFormat.jpeg;
      String targetExt = '.jpg';
      if (ext == '.webp') {
        format = CompressFormat.webp;
        targetExt = '.webp';
      } else if (ext == '.heic') {
        format = CompressFormat.heic;
        targetExt = '.heic';
      } else if (ext == '.png') {
        format = CompressFormat.png;
        targetExt = '.png';
      }

      final targetPath =
          '${tempDir.path}/${nameWithoutExt}_compressed_${DateTime.now().millisecondsSinceEpoch}$targetExt';
      final originalSize = await file.length();

      final XFile? compressedXFile =
          await FlutterImageCompress.compressAndGetFile(
            file.absolute.path,
            targetPath,
            quality: 50,
            minWidth: 1280,
            minHeight: 720,
            format: format,
          );

      if (compressedXFile == null) {
        debugPrint(
          '[ImageCompress] Compression returned null for: ${file.path}. Using original.',
        );
        return file;
      }

      final compressedFile = File(compressedXFile.path);
      final compressedSize = await compressedFile.length();

      if (kDebugMode) {
        debugPrint('[ImageCompress] Success: ${file.path}');
        debugPrint(
          '[ImageCompress] Original size: ${(originalSize / 1024).toStringAsFixed(2)} KB',
        );
        debugPrint(
          '[ImageCompress] Compressed size: ${(compressedSize / 1024).toStringAsFixed(2)} KB',
        );
        debugPrint('[ImageCompress] Saved to: $targetPath');
      }

      return compressedFile;
    } catch (e) {
      debugPrint(
        '[ImageCompress] Error compressing ${file.path}: $e. Using original.',
      );
      return file;
    }
  }

  String _yellow(String s) => '\x1B[33m$s\x1B[0m';

  String? _maskToken(String? authHeader) {
    final raw = authHeader?.trim();
    if (raw == null || raw.isEmpty) return raw;
    if (_logFullAuthToken) return raw;
    if (!raw.toLowerCase().startsWith('bearer ')) return raw;
    final token = raw.substring('bearer '.length);
    if (token.length <= 10) return 'Bearer ****';
    final tail = token.substring(token.length - 6);
    return 'Bearer ****$tail';
  }

  DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    final s = value.toString();
    return DateTime.tryParse(s) ?? DateTime.now();
  }

  ActivityItem _activityFromLead(Map<String, dynamic> json) {
    final name = (json['name'] ?? 'Lead').toString();
    final phone = (json['phone'] ?? '').toString();
    final type = (json['type'] ?? '').toString();
    final at = _parseDateTime(json['created_at'] ?? json['updated_at']);
    final subtitleParts = <String>[
      if (type.isNotEmpty) type,
      if (phone.isNotEmpty) phone,
    ];
    return ActivityItem(
      title: 'New lead: $name',
      subtitle: subtitleParts.isEmpty
          ? 'Lead assigned'
          : subtitleParts.join(' • '),
      at: at,
    );
  }

  ActivityItem _activityFromProperty(Map<String, dynamic> json) {
    final title = (json['title'] ?? 'Property').toString();
    final city = (json['city'] ?? '').toString();
    final type = (json['type'] ?? '').toString();
    final at = _parseDateTime(json['created_at'] ?? json['updated_at']);
    final subtitleParts = <String>[
      if (type.isNotEmpty) type,
      if (city.isNotEmpty) city,
    ];
    return ActivityItem(
      title: title,
      subtitle: subtitleParts.isEmpty
          ? 'Property updated'
          : subtitleParts.join(' • '),
      at: at,
    );
  }

  String _cityFromLocation(String location) {
    final trimmed = location.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed.split(',').first.trim();
  }

  String? _normalizeListingType(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return null;
    final lowered = v.toLowerCase();
    // Backend validation appears stricter than UI. Keep safe defaults.
    if (lowered == 'agent') return 'owner';
    return lowered.replaceAll('-', '_');
  }

  String? _normalizeFacing(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return null;
    return v.toLowerCase().replaceAll('_', '-');
  }

  String? _extractImagePathFromString(String s) {
    if (s.contains('image_path:')) {
      final match = RegExp(r'image_path:\s*([^,}]+)').firstMatch(s);
      return match?.group(1)?.trim();
    }
    return null;
  }

  Property _fromApi(Map<String, dynamic> json) {
    try {
      final copy = Map<String, dynamic>.from(json);

      final title = (json['title'] ?? json['name'] ?? '').toString();
      copy['title'] = title.isEmpty ? 'Property' : title;

      final city = (json['city'] ?? '').toString();
      copy['city'] = city;

      final price =
          (json['price'] as num?)?.toDouble() ??
          double.tryParse((json['price'] ?? '0').toString()) ??
          0;
      copy['price'] = price;

      final typeStr = (json['type'] ?? 'rent').toString();
      final type = PropertyType.values.any((e) => e.name == typeStr)
          ? PropertyType.values.byName(typeStr)
          : PropertyType.rent;
      copy['type'] = type.name;

      final imagesRaw = json['images'] is List
          ? (json['images'] as List)
          : const [];
      final images = imagesRaw
          .map((e) {
            if (e is Map) {
              final m = Map<String, dynamic>.from(e);
              final path = (m['image_path'] ?? m['url'] ?? '').toString();
              if (path.startsWith('http')) return path;
              if (path.isEmpty) return '';
              final normalized = path.startsWith('/')
                  ? path.substring(1)
                  : path;
              return '${ApiConstants.publicOrigin}/storage/$normalized';
            }
            final s = e.toString();
            if (s.startsWith('http')) return s;

            // Defensive: some layers may stringify the image object map.
            if (s.contains('image_path:')) {
              final match = RegExp(r'image_path:\s*([^,}]+)').firstMatch(s);
              final extracted = match?.group(1)?.trim();
              if (extracted != null && extracted.isNotEmpty) {
                final normalized = extracted.startsWith('/')
                    ? extracted.substring(1)
                    : extracted;
                return '${ApiConstants.publicOrigin}/storage/$normalized';
              }
            }

            // If backend returns a relative path string.
            if (s.startsWith('properties/')) {
              return '${ApiConstants.publicOrigin}/storage/$s';
            }

            return s;
          })
          .where((s) => s.trim().isNotEmpty)
          .toList(growable: false);
      copy['images'] = images;

      final videosRaw = json['videos'] is List
          ? (json['videos'] as List)
          : const [];
      final videos = videosRaw
          .map((e) {
            if (e is Map) {
              final m = Map<String, dynamic>.from(e);
              final rawPath = (m['video_path'] ?? m['url'] ?? '').toString();
              String url = rawPath;
              if (!url.startsWith('http') && url.isNotEmpty) {
                final normalized = url.startsWith('/') ? url.substring(1) : url;
                url = '${ApiConstants.publicOrigin}/storage/$normalized';
              }
              final thumbRaw = (m['thumbnail'] ?? m['thumb_url'] ?? '')
                  .toString();
              String? thumbUrl = thumbRaw.isEmpty ? null : thumbRaw;
              if (thumbUrl != null && !thumbUrl.startsWith('http')) {
                final normalized = thumbUrl.startsWith('/')
                    ? thumbUrl.substring(1)
                    : thumbUrl;
                thumbUrl = '${ApiConstants.publicOrigin}/storage/$normalized';
              }
              return {
                'id': (m['id'] ?? '').toString(),
                'url': url,
                'type': m['type']?.toString(),
                'title': m['title']?.toString(),
                'thumbnail': thumbUrl,
                'is_featured': m['is_featured'] is bool
                    ? m['is_featured'] as bool
                    : (m['is_featured'] == 1 ||
                          m['is_featured'] == '1' ||
                          m['is_featured']?.toString().toLowerCase() == 'true'),
              };
            }
            final s = e.toString();
            if (s.isEmpty) return null;
            final url = s.startsWith('http')
                ? s
                : '${ApiConstants.publicOrigin}/storage/${s.startsWith('/') ? s.substring(1) : s}';
            return {'id': '', 'url': url};
          })
          .where((v) => v != null)
          .toList();
      copy['videos'] = videos;

      final approval = (json['approval_status'] ?? json['approvalStatus'] ?? '')
          .toString();
      final rawStatus = (json['status'] ?? '').toString(); // e.g. "available"
      final status = switch (approval) {
        'approved' => PropertyStatus.approved,
        'rejected' => PropertyStatus.rejected,
        'pending' => PropertyStatus.pending,
        _ => switch (rawStatus) {
          'listed' => PropertyStatus.listed,
          _ => PropertyStatus.pending,
        },
      };
      copy['status'] = status.name;

      final amenitiesRaw = json['amenities'] is List
          ? (json['amenities'] as List)
          : const [];

      final amenityIds = amenitiesRaw
          .map((e) {
            if (e is Map) {
              final idVal = e['id'] ?? (e['pivot'] as Map?)?['feature_id'];
              return idVal is num
                  ? idVal.toInt()
                  : int.tryParse(idVal?.toString() ?? '');
            }
            return int.tryParse(e.toString());
          })
          .whereType<int>()
          .toList();
      copy['amenity_ids'] = amenityIds;

      final amenities = amenitiesRaw
          .map((e) {
            if (e is Map) {
              return (e['name'] ?? e['title'] ?? '').toString();
            }
            return e.toString();
          })
          .where((s) => s.trim().isNotEmpty)
          .toList(growable: false);
      copy['amenities'] = amenities;

      final documentsRaw = json['documents'] is List
          ? (json['documents'] as List)
          : const [];
      final documents = documentsRaw
          .map((e) {
            if (e is Map) {
              final m = Map<String, dynamic>.from(e);
              final path = (m['document_path'] ?? m['url'] ?? '').toString();
              if (path.startsWith('http')) return path;
              if (path.isEmpty) return '';
              final normalized = path.startsWith('/')
                  ? path.substring(1)
                  : path;
              return '${ApiConstants.publicOrigin}/storage/$normalized';
            }
            final s = e.toString();
            if (s.startsWith('http')) return s;
            if (s.startsWith('documents/')) {
              return '${ApiConstants.publicOrigin}/storage/$s';
            }
            return s;
          })
          .where((s) => s.trim().isNotEmpty)
          .toList(growable: false);
      copy['documents'] = documents;

      // Retain the raw API fields mapping
      copy['apiFields'] = json;

      return Property.fromJson(copy);
    } catch (e, st) {
      print('Error parsing property JSON: $e');
      print('JSON structure: $json');
      print('Stacktrace: $st');
      rethrow;
    }
  }

  Map<String, dynamic> _extractData(Response<Map<String, dynamic>> res) {
    final body = res.data ?? const <String, dynamic>{};
    if (body['data'] is Map<String, dynamic>) {
      return body['data'] as Map<String, dynamic>;
    }
    return body;
  }

  Exception _apiException(DioException e) {
    final data = e.response?.data;
    final msg = (data is Map<String, dynamic> ? data['message'] : null)
        ?.toString();
    final errors = (data is Map<String, dynamic>) ? data['errors'] : null;
    String? errorDetails;
    if (errors is Map) {
      final parts = <String>[];
      for (final entry in errors.entries) {
        final key = entry.key.toString();
        final val = entry.value;
        if (val is List && val.isNotEmpty) {
          parts.add('$key: ${val.first}');
        } else if (val != null) {
          parts.add('$key: $val');
        }
      }
      if (parts.isNotEmpty) errorDetails = parts.join(' • ');
    }
    final status = e.response?.statusCode;
    final fallback = status == null
        ? 'Request failed'
        : 'Request failed ($status)';
    final base = (msg == null || msg.isEmpty) ? fallback : msg;

    // When there's no HTTP response, Dio captures the failure in `type/message/error`.
    // Surface it; otherwise the UI only shows a generic "Request failed".
    if (status == null) {
      final type = e
          .type
          .name; // e.g. connectionTimeout, badCertificate, connectionError
      final detail = (e.message ?? e.error?.toString() ?? '').trim();
      if (detail.isNotEmpty) {
        return Exception('$base ($type: $detail)');
      }
      return Exception('$base ($type)');
    }

    return Exception(errorDetails == null ? base : '$base ($errorDetails)');
  }

  String _shellEscapeSingleQuotes(String s) => s.replaceAll("'", r"'\''");

  String _shellEscapeDoubleQuotes(String s) => s.replaceAll('"', r'\"');

  String _normalizeUploadFieldBase(String raw) {
    final trimmed = raw.trim().toLowerCase();
    if (trimmed.isEmpty) return '';
    var v = trimmed.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    v = v.replaceAll(RegExp(r'_+'), '_');
    v = v.replaceAll(RegExp(r'^_+|_+$'), '');
    return v;
  }

  List<MapEntry<String, String>> _collectCreateFilePaths(Property property) {
    final out = <MapEntry<String, String>>[];

    final primaryIndex = property.primaryImageIndex ?? 0;
    final ordered = <String>[
      if (property.images.isNotEmpty)
        property.images[primaryIndex.clamp(0, property.images.length - 1)],
      ...property.images.where((p) {
        if (property.images.isEmpty) return false;
        final primaryPath =
            property.images[primaryIndex.clamp(0, property.images.length - 1)];
        return p != primaryPath;
      }),
    ];

    String? primaryImagePath;
    for (final path in ordered) {
      if (path.startsWith('http')) continue;
      if (path.contains('image_path:')) continue;
      if (path.startsWith('properties/')) continue;
      if (path.trim().startsWith('{') &&
          _extractImagePathFromString(path) != null) {
        continue;
      }
      primaryImagePath ??= path;
      out.add(MapEntry('images[]', path));
    }

    final sectionImages = property.sectionImagePaths ?? const {};
    for (final entry in sectionImages.entries) {
      final fieldBase = _normalizeUploadFieldBase(entry.key);
      if (fieldBase.isEmpty) continue;
      for (final path in entry.value) {
        if (path.trim().isEmpty) continue;
        if (path.startsWith('http')) continue;
        if (path.contains('image_path:')) continue;
        if (path.startsWith('properties/')) continue;
        if (path.trim().startsWith('{') &&
            _extractImagePathFromString(path) != null) {
          continue;
        }
        out.add(MapEntry('${fieldBase}[]', path));
      }
    }

    final documentPaths = property.documentPaths ?? const [];
    for (final path in documentPaths) {
      if (path.trim().isEmpty) continue;
      if (path.startsWith('http')) continue;
      final filename = path.split(Platform.pathSeparator).last;
      final lower = filename.toLowerCase();
      if (lower.endsWith('.mp4') ||
          lower.endsWith('.mov') ||
          lower.endsWith('.m4v') ||
          lower.endsWith('.avi') ||
          lower.endsWith('.mkv')) {
        out.add(MapEntry('videos[]', path));
      } else {
        out.add(MapEntry('documents[]', path));
      }
    }

    if (primaryImagePath != null) {
      out.add(MapEntry('primary_image_index[]', primaryImagePath));
    }

    return out;
  }

  String _toCurlMultipart({
    required Dio dio,
    required String method,
    required String path,
    required FormData form,
    List<MapEntry<String, String>>? filePaths,
  }) {
    final baseUrl = dio.options.baseUrl;
    final url = baseUrl.endsWith('/') || path.startsWith('/')
        ? '$baseUrl$path'
        : '$baseUrl/$path';

    final parts = <String>[
      'curl',
      '--location',
      "'$url'",
      '--request',
      method.toUpperCase(),
    ];

    final headers = Map<String, dynamic>.from(dio.options.headers);
    // Avoid sending curl a raw boundary; let it compute it.
    headers.removeWhere((k, _) => k.toLowerCase() == 'content-type');

    for (final entry in headers.entries) {
      final key = entry.key.toString();
      final val = entry.value?.toString() ?? '';
      if (val.isEmpty) continue;
      final safeVal = (key.toLowerCase() == 'authorization')
          ? (_maskToken(val) ?? '')
          : val;
      parts.add("--header '${_shellEscapeSingleQuotes('$key: $safeVal')}'");
    }

    for (final entry in form.fields) {
      final k = entry.key;
      final v = entry.value;
      final vStr = v.toString();
      parts.add(
        "--form '${_shellEscapeSingleQuotes('$k=\"${_shellEscapeDoubleQuotes(vStr)}\"')}'",
      );
    }

    final remainingPaths = List<MapEntry<String, String>>.from(
      filePaths ?? const [],
    );
    for (final entry in form.files) {
      final k = entry.key;
      final file = entry.value;
      String? originalPath;
      final idx = remainingPaths.indexWhere((e) => e.key == k);
      if (idx != -1) {
        originalPath = remainingPaths.removeAt(idx).value;
      }
      final fallbackName = file.filename ?? 'file';
      final fileRef = originalPath ?? fallbackName;
      parts.add("--form '${_shellEscapeSingleQuotes("$k=@\"$fileRef\"")}'");
    }

    return parts.join(' \\\n');
  }

  void _debugLogMultipart({
    required Dio dio,
    required String method,
    required String path,
    required FormData form,
    List<MapEntry<String, String>>? filePaths,
  }) {
    final fields = <String, dynamic>{};
    for (final entry in form.fields) {
      fields[entry.key] = entry.value;
    }

    final files = <Map<String, dynamic>>[];
    for (final entry in form.files) {
      final file = entry.value;
      files.add({
        'field': entry.key,
        'filename': file.filename,
        'contentType': file.contentType?.toString(),
        'length': file.length,
      });
    }

    debugPrint(
      _yellow(
        '[StaffPropertyService] $path multipart fields=${fields.keys.toList()}',
      ),
    );
    debugPrint(
      _yellow('[StaffPropertyService] $path multipart fieldsData=$fields'),
    );
    debugPrint(_yellow('[StaffPropertyService] $path multipart files=$files'));
    debugPrint(
      _yellow(
        '[StaffPropertyService] $path curl=${_toCurlMultipart(dio: dio, method: method, path: path, form: form, filePaths: filePaths)}',
      ),
    );
  }

  Future<FormData> _toCreateForm(Property property) async {
    final images = <MultipartFile>[];
    MultipartFile? primaryImageFile;
    final primaryIndex = property.primaryImageIndex ?? 0;
    final ordered = <String>[
      if (property.images.isNotEmpty)
        property.images[primaryIndex.clamp(0, property.images.length - 1)],
      ...property.images.where((p) {
        if (property.images.isEmpty) return false;
        final primaryPath =
            property.images[primaryIndex.clamp(0, property.images.length - 1)];
        return p != primaryPath;
      }),
    ];

    // Collect ordered paths to compress
    final orderedPathsToCompress = <String>[];
    for (final path in ordered) {
      if (path.startsWith('http')) continue;
      if (path.contains('image_path:')) continue;
      if (path.startsWith('properties/')) continue;
      if (path.trim().startsWith('{') &&
          _extractImagePathFromString(path) != null) {
        continue;
      }
      orderedPathsToCompress.add(path);
    }

    // Compress in parallel
    final compressedOrderedFiles = await Future.wait(
      orderedPathsToCompress.map((path) => compressImage(File(path))),
    );

    for (var i = 0; i < orderedPathsToCompress.length; i++) {
      final originalPath = orderedPathsToCompress[i];
      final filename = originalPath.split(Platform.pathSeparator).last;
      final compressedFile = compressedOrderedFiles[i];
      final file = await MultipartFile.fromFile(
        compressedFile.path,
        filename: filename,
      );
      primaryImageFile ??= file;
      images.add(file);
    }

    final sectionImageFiles = <MapEntry<String, MultipartFile>>[];
    final sectionImages = property.sectionImagePaths ?? const {};

    // Flatten and collect section paths
    final sectionPathsToCompress = <MapEntry<String, String>>[];
    for (final entry in sectionImages.entries) {
      final fieldBase = _normalizeUploadFieldBase(entry.key);
      if (fieldBase.isEmpty) continue;
      for (final path in entry.value) {
        if (path.trim().isEmpty) continue;
        if (path.startsWith('http')) continue;
        if (path.contains('image_path:')) continue;
        if (path.startsWith('properties/')) continue;
        if (path.trim().startsWith('{') &&
            _extractImagePathFromString(path) != null) {
          continue;
        }
        sectionPathsToCompress.add(MapEntry(fieldBase, path));
      }
    }

    // Compress section images in parallel
    final compressedSectionFiles = await Future.wait(
      sectionPathsToCompress.map((entry) => compressImage(File(entry.value))),
    );

    for (var i = 0; i < sectionPathsToCompress.length; i++) {
      final fieldBase = sectionPathsToCompress[i].key;
      final originalPath = sectionPathsToCompress[i].value;
      final filename = originalPath.split(Platform.pathSeparator).last;
      final compressedFile = compressedSectionFiles[i];
      final file = await MultipartFile.fromFile(
        compressedFile.path,
        filename: filename,
      );
      sectionImageFiles.add(MapEntry('${fieldBase}[]', file));
    }

    final documentFiles = <MultipartFile>[];
    final videoFiles = <MultipartFile>[];
    final documentPaths = property.documentPaths ?? const [];
    for (final path in documentPaths) {
      if (path.trim().isEmpty) continue;
      if (path.startsWith('http')) continue;
      final filename = path.split(Platform.pathSeparator).last;
      final lower = filename.toLowerCase();
      final file = await MultipartFile.fromFile(path, filename: filename);
      if (lower.endsWith('.mp4') ||
          lower.endsWith('.mov') ||
          lower.endsWith('.m4v') ||
          lower.endsWith('.avi') ||
          lower.endsWith('.mkv')) {
        videoFiles.add(file);
      } else {
        documentFiles.add(file);
      }
    }

    final form = FormData.fromMap({
      'title': property.name,
      'description': property.description,
      if (property.slug != null && property.slug!.trim().isNotEmpty)
        'slug': property.slug!.trim(),
      'type': property.apiFields?['type']?.toString() ?? property.type.name,
      if (_normalizeListingType(property.listingType) != null)
        'listing_type': _normalizeListingType(property.listingType),
      'price': property.price.toStringAsFixed(0),
      if (property.area != null) 'area': property.area,
      if (property.areaUnit != null && property.areaUnit!.trim().isNotEmpty)
        'area_unit': property.areaUnit!.trim(),
      if (property.propertyAge != null) 'property_age': property.propertyAge,
      if (_normalizeFacing(property.facing) != null)
        'facing': _normalizeFacing(property.facing),
      'balconies': property.balconies?.toString() ?? '',
      'floor': property.floor?.toString() ?? '',
      'total_floors': property.totalFloors?.toString() ?? '',
      'built_up_area': property.builtUpArea?.toString() ?? '',
      if (property.availability != null &&
          property.availability!.trim().isNotEmpty)
        'availability': property.availability!.trim(),
      if (property.possessionBy != null &&
          property.possessionBy!.trim().isNotEmpty)
        'possession_by': property.possessionBy!.trim(),
      if (property.ownership != null && property.ownership!.trim().isNotEmpty)
        'ownership': property.ownership!.trim(),
      if (property.additionalRooms != null &&
          property.additionalRooms!.isNotEmpty)
        'additional_rooms': property.additionalRooms!.join(','),
      if (property.bookingAmount != null)
        'booking_amount': property.bookingAmount!.toStringAsFixed(0),
      if (property.maintenanceCharges != null)
        'maintenance_charges': property.maintenanceCharges!.toStringAsFixed(0),
      if (property.possessionStatus != null &&
          property.possessionStatus!.trim().isNotEmpty)
        'possession_status': property.possessionStatus!.trim(),
      if (property.bedrooms != null) 'bedrooms': property.bedrooms,
      if (property.bathrooms != null) 'bathrooms': property.bathrooms,
      if (property.furnishing != null && property.furnishing!.trim().isNotEmpty)
        'furnishing': property.furnishing!.trim(),
      if (property.parking != null) 'parking': property.parking,
      if (property.address != null && property.address!.trim().isNotEmpty)
        'address': property.address!.trim(),
      'city': (property.city != null && property.city!.trim().isNotEmpty)
          ? property.city!.trim()
          : _cityFromLocation(property.location),
      if (property.state != null && property.state!.trim().isNotEmpty)
        'state': property.state!.trim(),
      if (property.pincode != null && property.pincode!.trim().isNotEmpty)
        'pincode': property.pincode!.trim(),
      if (property.latitude != null) 'latitude': property.latitude,
      if (property.longitude != null) 'longitude': property.longitude,
      // If backend uses category, keep it stable for now.
      'category_id': property.categoryId ?? '2',
      if (property.isFeatured != null)
        'is_featured': property.isFeatured! ? '1' : '0',
      if (property.featuredExpiry != null)
        'featured_expiry': property.featuredExpiry!.toIso8601String(),
      if (images.isNotEmpty) 'images[]': images,
      if (documentFiles.isNotEmpty) 'documents[]': documentFiles,
      if (videoFiles.isNotEmpty) 'videos[]': videoFiles,
    });

    // Backend validation expects `primary_image_index.*` to be an image.
    if (primaryImageFile != null) {
      form.files.add(
        MapEntry('primary_image_index[]', primaryImageFile.clone()),
      );
    }

    final extra = property.apiFields ?? const <String, dynamic>{};
    // Keys that are server-managed and must never be sent back in a create/update.
    const _serverOnlyKeys = {
      'id', 'created_at', 'updated_at', 'deleted_at',
      'status', 'approval_status', 'rejection_reason',
      'user_id', 'agent_id', 'assigned_to',
      'is_featured', 'featured_expiry',
      'images', 'videos', 'documents', 'amenities',
      'amenity_ids', 'furnishing_selections', 'furnishings',
      'category', 'parent_category',
      'slug', // slug is already set from property.slug above
      'name', 'title', // already set above
      'description', // already set above
      'type', 'listing_type', 'price', 'area', 'area_unit',
      'facing', 'floor', 'total_floors', 'bedrooms', 'bathrooms',
      'furnishing', 'parking', 'address', 'city', 'state', 'pincode',
      'latitude', 'longitude', 'category_id',
      'balconies',
      'built_up_area',
      'availability',
      'possession_by',
      'ownership',
      'additional_rooms',
      'booking_amount',
      'maintenance_charges',
    };
    for (final e in extra.entries) {
      final key = e.key.trim();
      if (key.isEmpty) continue;
      if (_serverOnlyKeys.contains(key)) continue;
      if (form.fields.any((f) => f.key == key)) continue;
      final v = e.value;
      if (v == null) continue;
      if (v is String) {
        if (v.trim().isEmpty) continue;
        form.fields.add(MapEntry(key, v));
      } else if (v is num) {
        form.fields.add(MapEntry(key, v.toString()));
      } else if (v is bool) {
        form.fields.add(MapEntry(key, v ? '1' : '0'));
      } else if (v is Iterable) {
        for (final item in v) {
          if (item == null) continue;
          final itemKey = key.endsWith('[]') ? key : '$key[]';
          if (item is String) {
            if (item.trim().isEmpty) continue;
            form.fields.add(MapEntry(itemKey, item));
          } else if (item is num) {
            form.fields.add(MapEntry(itemKey, item.toString()));
          } else if (item is bool) {
            form.fields.add(MapEntry(itemKey, item ? '1' : '0'));
          }
        }
      } else if (v is Map) {
        for (final entry in v.entries) {
          final subKey = entry.key?.toString();
          final subVal = entry.value;
          if (subKey == null || subKey.trim().isEmpty || subVal == null) {
            continue;
          }
          form.fields.add(MapEntry('$key[$subKey]', subVal.toString()));
        }
      }
    }

    for (final e in sectionImageFiles) {
      form.files.add(MapEntry(e.key, e.value));
    }

    final amenityIds = property.amenityIds ?? const <int>[];
    for (final id in amenityIds) {
      // Send both amenity_ids[] and amenities[] because different backend versions/controllers
      // might look for either field. Both fields contain the exact same valid integer IDs.
      form.fields.add(MapEntry('amenity_ids[]', id.toString()));
      form.fields.add(MapEntry('amenities[]', id.toString()));
    }

    final furnishingSelections = property.furnishingSelections ?? const [];
    for (var i = 0; i < furnishingSelections.length; i++) {
      final sel = furnishingSelections[i];
      form.fields.add(MapEntry('furnishings[$i][id]', sel.id.toString()));
      form.fields.add(
        MapEntry('furnishings[$i][quantity]', sel.quantity.toString()),
      );
    }

    return form;
  }

  Future<FormData> _toUpdateForm(Property property) async {
    // Same fields as create, but allow server to keep existing if not passed.
    return _toCreateForm(property);
  }

  @override
  Future<Property> createProperty(Property property) async {
    final dio = await _dioFuture;
    final formData = await _toCreateForm(property);
    debugPrint(
      '[StaffPropertyService] createProperty fields=' +
          formData.fields
              .map((e) => '${e.key}: ${e.value}')
              .toList()
              .toString(),
    );
    if (kDebugMode) {
      // Note: Authorization is set per-request by the interceptor, not in
      // dio.options.headers. Log a reminder rather than a misleading "null".
      debugPrint(
        _yellow(
          '[StaffPropertyService] POST ${dio.options.baseUrl}/staff/properties (auth set by interceptor)',
        ),
      );
    }
    _debugLogMultipart(
      dio: dio,
      method: 'POST',
      path: '/staff/properties',
      form: formData,
      filePaths: _collectCreateFilePaths(property),
    );
    Response<Map<String, dynamic>> res;
    try {
      res = await dio.post<Map<String, dynamic>>(
        '/staff/properties',
        data: formData,
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint(
          _yellow(
            '[StaffPropertyService] POST /staff/properties ERROR ${e.response?.statusCode}: ${e.response?.data}',
          ),
        );
      }
      throw _apiException(e);
    }
    return _fromApi(_extractData(res));
  }

  @override
  Future<Property> updateProperty(Property property) async {
    final dio = await _dioFuture;
    final form = await _toUpdateForm(property);
    Response<Map<String, dynamic>> res;
    final path = '/staff/properties/${property.id}';

    // PHP/Laravel backends natively expect method override for multipart PUT/PATCH requests.
    // By using POST with '_method: PUT', we ensure robust, native PHP parsing of all fields and files.
    final formData = FormData();
    formData.fields.add(const MapEntry('_method', 'PUT'));
    formData.fields.addAll(form.fields);
    formData.files.addAll(form.files);

    debugPrint('[StaffPropertyService] updateProperty path=$path');
    debugPrint(
      '[StaffPropertyService] updateProperty fields=' +
          formData.fields
              .map((e) => '${e.key}: ${e.value}')
              .toList()
              .toString(),
    );

    _debugLogMultipart(
      dio: dio,
      method: 'POST',
      path: path,
      form: formData,
      filePaths: _collectCreateFilePaths(property),
    );
    try {
      res = await dio.post<Map<String, dynamic>>(path, data: formData);
    } on DioException catch (e) {
      throw _apiException(e);
    }
    return _fromApi(_extractData(res));
  }

  @override
  Future<Property> getPropertyById(String id) async {
    final dio = await _dioFuture;
    // Use the staff endpoint so all custom category-specific fields are
    // returned (corner_property, maintenance_charges, availability, etc.).
    // The public /properties/{id} endpoint only returns base fields.
    Response<Map<String, dynamic>> res;
    try {
      res = await dio.get<Map<String, dynamic>>('/staff/properties/$id');
    } on DioException catch (_) {
      // Fallback to public endpoint if staff endpoint is unavailable.
      res = await dio.get<Map<String, dynamic>>('/properties/$id');
    }
    final body = res.data ?? const <String, dynamic>{};
    final data = body['data'];
    final rawData = data is Map<String, dynamic> ? data : body;
    if (kDebugMode) {
      debugPrint(
        _yellow(
          '[StaffPropertyService] getPropertyById($id) keys=${rawData.keys.toList()}',
        ),
      );
    }
    return _fromApi(rawData);
  }

  @override
  Future<List<Property>> getAssignedProperties() async {
    final dio = await _dioFuture;
    // Use authed endpoint (no Cookie): `/properties/my-properties`
    final res = await dio.get<Map<String, dynamic>>(
      '/properties/my-properties',
    );
    final body = res.data ?? const <String, dynamic>{};
    final data = body['data'];
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => _fromApi(Map<String, dynamic>.from(e)))
          .toList(growable: false);
    }
    throw Exception('Unexpected properties response');
  }

  @override
  Future<List<String>> uploadImages({
    required String propertyId,
    required List<String> localPaths,
  }) async {
    throw UnimplementedError('Server upload handled in create/update');
  }

  @override
  Future<Property> publishProperty(String id) async {
    throw UnimplementedError('Publish endpoint not wired');
  }

  @override
  Future<Property> rejectProperty({
    required String id,
    required String reason,
  }) async {
    throw UnimplementedError('Reject endpoint not wired');
  }

  @override
  Future<DashboardCounts> getStatusCounts() async {
    try {
      final dio = await _dioFuture;
      final res = await dio.get<Map<String, dynamic>>('/staff/dashboard');
      final body = res.data ?? const <String, dynamic>{};
      debugPrint('[StaffPropertyService] getStatusCounts API response: $body');

      // Handle nesting: support { "data": { ... } } or raw root map
      final data = (body['data'] is Map<String, dynamic>)
          ? (body['data'] as Map<String, dynamic>)
          : body;

      final assignedCount =
          int.tryParse(
            (data['lead_assigned'] ??
                    data['assigned_properties'] ??
                    data['assignedProperties'] ??
                    data['assigned'] ??
                    data['total_properties'] ??
                    data['totalProperties'] ??
                    '0')
                .toString(),
          ) ??
          0;

      final pendingCount =
          int.tryParse(
            (data['pending'] ??
                    data['pending_properties'] ??
                    data['pendingProperties'] ??
                    '0')
                .toString(),
          ) ??
          0;

      final listedCount =
          int.tryParse(
            (data['total_listed'] ??
                    data['totalListed'] ??
                    data['listed'] ??
                    data['listed_properties'] ??
                    data['listedProperties'] ??
                    data['approved'] ??
                    data['approved_properties'] ??
                    data['approvedProperties'] ??
                    '0')
                .toString(),
          ) ??
          0;

      final rejectedCount =
          int.tryParse(
            (data['rejected'] ??
                    data['rejected_properties'] ??
                    data['rejectedProperties'] ??
                    '0')
                .toString(),
          ) ??
          0;

      return DashboardCounts(
        assigned: assignedCount,
        listed: listedCount,
        pending: pendingCount,
        rejected: rejectedCount,
      );
    } catch (e) {
      debugPrint('[StaffPropertyService] getStatusCounts error: $e');
      return DashboardCounts.zero();
    }
  }

  @override
  Future<List<ActivityItem>> getDashboardActivity() async {
    final dio = await _dioFuture;
    final res = await dio.get<Map<String, dynamic>>('/staff/activity');
    final body = res.data ?? const <String, dynamic>{};

    final items = <ActivityItem>[];

    final leads = body['leads'];
    if (leads is List) {
      for (final e in leads.whereType<Map>()) {
        items.add(_activityFromLead(Map<String, dynamic>.from(e)));
      }
    }

    final properties = body['properties'];
    if (properties is List) {
      for (final e in properties.whereType<Map>()) {
        items.add(_activityFromProperty(Map<String, dynamic>.from(e)));
      }
    }

    final views = body['views'];
    if (views is List) {
      for (final e in views.whereType<Map>()) {
        final at = _parseDateTime(e['created_at'] ?? e['updated_at']);
        final propertyTitle = (e['property_title'] ?? e['title'] ?? '')
            .toString();
        final title = propertyTitle.isEmpty
            ? 'Property viewed'
            : 'Viewed: $propertyTitle';
        items.add(ActivityItem(title: title, subtitle: 'New view', at: at));
      }
    }

    items.sort((a, b) => b.at.compareTo(a.at));
    return items.take(8).toList(growable: false);
  }
}
