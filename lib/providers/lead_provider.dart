import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/lead.dart';
import 'app_providers.dart';

final myLeadsProvider = FutureProvider<List<Lead>>((ref) async {
  return ref.read(leadRepositoryProvider).getMyLeads();
});

