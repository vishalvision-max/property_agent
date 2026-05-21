import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/account_repository.dart';
import '../data/repositories/lead_repository.dart';
import '../data/repositories/property_repository.dart';
import '../data/services/staff_auth_service.dart';
import '../data/services/staff_account_service.dart';
import '../data/services/staff_lead_service.dart';
import '../data/services/staff_property_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(authService: StaffAuthService());
});

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  return PropertyRepository(propertyService: StaffPropertyService());
});

final leadRepositoryProvider = Provider<LeadRepository>((ref) {
  return LeadRepository(leadService: StaffLeadService());
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository(accountService: StaffAccountService());
});
