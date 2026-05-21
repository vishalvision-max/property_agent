import '../models/lead.dart';
import '../services/lead_service.dart';

class LeadRepository {
  LeadRepository({required LeadService leadService}) : _leadService = leadService;

  final LeadService _leadService;

  Future<List<Lead>> getMyLeads({int page = 1}) {
    return _leadService.getMyLeads(page: page);
  }
}

