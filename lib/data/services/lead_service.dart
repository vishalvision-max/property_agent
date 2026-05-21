import '../models/lead.dart';

abstract class LeadService {
  Future<List<Lead>> getMyLeads({int page = 1});
}

