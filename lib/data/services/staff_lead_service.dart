import 'package:dio/dio.dart';

import '../models/lead.dart';
import 'api_dio.dart';
import 'lead_service.dart';

class StaffLeadService implements LeadService {
  StaffLeadService({Dio? dio})
    : _dioFuture = (dio != null) ? Future.value(dio) : ApiDio.authed();

  final Future<Dio> _dioFuture;

  Exception _apiException(DioException e) {
    final data = e.response?.data;
    final msg = (data is Map<String, dynamic> ? data['message'] : null)
        ?.toString();
    final fallback = e.response?.statusCode == null
        ? 'Request failed'
        : 'Request failed (${e.response?.statusCode})';
    return Exception((msg == null || msg.isEmpty) ? fallback : msg);
  }

  @override
  Future<List<Lead>> getMyLeads({int page = 1}) async {
    final dio = await _dioFuture;
    Response<dynamic> res;
    try {
      res = await dio.get<dynamic>(
        '/buyer-leads',
        queryParameters: {'page': page},
      );
    } on DioException catch (e) {
      throw _apiException(e);
    }

    final decoded = res.data;
    final List leadsJson;
    if (decoded is List) {
      leadsJson = decoded;
    } else if (decoded is Map && decoded['data'] is List) {
      leadsJson = decoded['data'];
    } else {
      leadsJson = const [];
    }

    return leadsJson
        .where((e) => e is Map)
        .map((e) => Lead.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(growable: false);
  }
}

