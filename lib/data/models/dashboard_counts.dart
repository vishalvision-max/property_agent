class DashboardCounts {
  const DashboardCounts({
    required this.assigned,
    required this.listed,
    required this.pending,
    required this.rejected,
  });

  final int assigned;
  final int listed;
  final int pending;
  final int rejected;

  factory DashboardCounts.zero() {
    return const DashboardCounts(
      assigned: 0,
      listed: 0,
      pending: 0,
      rejected: 0,
    );
  }
}
