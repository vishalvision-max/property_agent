import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/lead.dart';
import '../../../providers/lead_provider.dart';
import '../../widgets/glass_container.dart';

class MyLeadsScreen extends ConsumerWidget {
  const MyLeadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLeads = ref.watch(myLeadsProvider);

    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        toolbarHeight: 72,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'MANAGE',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.2,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'My Leads',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: InkWell(
              onTap: () => ref.invalidate(myLeadsProvider),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.dark3,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.gold,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(myLeadsProvider.future),
        child: asyncLeads.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 120),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFE5E7EB),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: FilledButton(
                  onPressed: () => ref.invalidate(myLeadsProvider),
                  child: const Text('Retry'),
                ),
              ),
            ],
          ),
          data: (leads) {
            if (leads.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(
                    child: Text(
                      'No leads yet',
                      style: TextStyle(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: leads.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final lead = leads[index];
                return _LeadTile(lead: lead);
              },
            );
          },
        ),
      ),
    );
  }
}

class _LeadTile extends StatelessWidget {
  const _LeadTile({required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    final subtitleParts = <String>[
      if (lead.type.trim().isNotEmpty) lead.type.trim(),
      if (lead.propertyType.trim().isNotEmpty) lead.propertyType.trim(),
      if (lead.city.trim().isNotEmpty) lead.city.trim(),
      if (lead.state.trim().isNotEmpty) lead.state.trim(),
    ];

    final metaParts = <String>[
      if (lead.phone.trim().isNotEmpty) lead.phone.trim(),
      if (lead.status.trim().isNotEmpty) 'Status: ${lead.status.trim()}',
      if (lead.priority.trim().isNotEmpty) 'Priority: ${lead.priority.trim()}',
    ];

    final t = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      blur: false, // Fix ANR in lists
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: (isDark ? AppTheme.gold : Colors.black).withValues(
                alpha: isDark ? 0.14 : 0.06,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.gold.withValues(alpha: isDark ? 0.40 : 0.22),
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.person_outline,
              size: 18,
              color: isDark
                  ? AppTheme.gold.withValues(alpha: 0.95)
                  : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lead.name.trim().isEmpty ? 'Lead #${lead.id}' : lead.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
                if (subtitleParts.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitleParts.join(' • '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
                if (metaParts.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    metaParts.join(' • '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
                if (lead.createdAt != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Created: ${lead.createdAt!.toLocal()}',
                    style: t.labelSmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
