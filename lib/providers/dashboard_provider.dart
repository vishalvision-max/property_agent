import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/activity.dart';
import '../data/models/dashboard_counts.dart';
import 'app_providers.dart';

class DashboardVm {
  const DashboardVm({required this.counts, required this.activity});

  final DashboardCounts counts;
  final List<ActivityItem> activity;
}

final dashboardProvider = FutureProvider<DashboardVm>((ref) async {
  final repo = ref.read(propertyRepositoryProvider);
  // Run both requests in parallel instead of sequentially — halves latency.
  final results = await Future.wait([
    repo.getStatusCounts(),
    repo.getDashboardActivity(),
  ]);
  return DashboardVm(
    counts: results[0] as DashboardCounts,
    activity: results[1] as List<ActivityItem>,
  );
});
