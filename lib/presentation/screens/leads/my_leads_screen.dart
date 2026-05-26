import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/lead.dart';
import '../../../providers/lead_provider.dart';

/// =======================
/// SCREEN
/// =======================

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
              'DASHBOARD',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.5,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'My Leads',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
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
        onRefresh: () async {
          ref.invalidate(myLeadsProvider);
          await ref.read(myLeadsProvider.future);
        },
        color: AppColors.gold,
        backgroundColor: AppColors.dark2,
        child: asyncLeads.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.gold),
          ),
          error: (e, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 120),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.dark2,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.danger.withOpacity(0.3)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 40),
                        const SizedBox(height: 12),
                        Text(
                          e.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => ref.invalidate(myLeadsProvider),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      'No leads found',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              );
            }

            final totalLeads = leads.length;
            final highLeads = leads.where((l) => l.priority.toLowerCase() == 'high').length;
            final newLeads = leads.where((l) => l.status.toLowerCase() == 'new').length;

            return Column(
              children: [
                // Top Metrics stats bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Total Leads',
                          value: '$totalLeads',
                          color: AppColors.gold,
                          icon: Icons.people_alt_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatCard(
                          title: 'High Priority',
                          value: '$highLeads',
                          color: AppColors.danger,
                          icon: Icons.campaign_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatCard(
                          title: 'New Leads',
                          value: '$newLeads',
                          color: const Color(0xFF60A5FA),
                          icon: Icons.star_rounded,
                        ),
                      ),
                    ],
                  ),
                ),

                // Leads Scrollable List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: leads.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final lead = leads[index];
                      return _LeadTile(lead: lead);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// =======================
/// STAT CARD WIDGET
/// =======================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.dark2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textSubtle,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, size: 13, color: color),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// LEAD TILE WIDGET
/// =======================

class _LeadTile extends StatelessWidget {
  final Lead lead;

  const _LeadTile({required this.lead});

  @override
  Widget build(BuildContext context) {
    // 1. Requirement formatting
    final typeLabel = lead.type.isNotEmpty ? lead.type.toUpperCase() : 'REQ';
    final propLabel = lead.propertyType.isNotEmpty ? lead.propertyType : 'Property';
    final requirement = '$typeLabel • $propLabel';

    // 2. Priority visual tags
    Color priorityColor;
    Color priorityBg;
    switch (lead.priority.toLowerCase()) {
      case 'high':
        priorityColor = AppColors.danger;
        priorityBg = AppColors.danger.withOpacity(0.12);
        break;
      case 'medium':
        priorityColor = AppColors.warning;
        priorityBg = AppColors.warning.withOpacity(0.12);
        break;
      default:
        priorityColor = AppColors.success;
        priorityBg = AppColors.success.withOpacity(0.12);
    }

    // 3. Status visual tags
    Color statusColor;
    Color statusBg;
    switch (lead.status.toLowerCase()) {
      case 'new':
        statusColor = const Color(0xFF60A5FA);
        statusBg = const Color(0xFF60A5FA).withOpacity(0.12);
        break;
      case 'assigned':
        statusColor = const Color(0xFFC084FC);
        statusBg = const Color(0xFFC084FC).withOpacity(0.12);
        break;
      default:
        statusColor = AppColors.goldLight;
        statusBg = AppColors.gold.withOpacity(0.12);
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.dark2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showLeadDetailsBottomSheet(context, lead),
            splashColor: AppColors.gold.withOpacity(0.15),
            highlightColor: AppColors.gold.withOpacity(0.08),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Beautiful Custom Gradient Avatar
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.goldDark, AppColors.gold],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          lead.name.isNotEmpty ? lead.name[0].toUpperCase() : '#',
                          style: const TextStyle(
                            color: AppColors.cream,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Content Details Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name + Priority Row
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lead.name.isEmpty ? 'Lead #${lead.id}' : lead.name,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Priority badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: priorityBg,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    lead.priority.toUpperCase(),
                                    style: TextStyle(
                                      color: priorityColor,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Requirement detail row
                            Row(
                              children: [
                                const Icon(Icons.home_work_outlined, size: 14, color: AppColors.textMuted),
                                const SizedBox(width: 6),
                                Text(
                                  requirement,
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Location detail row
                            if (lead.city.isNotEmpty || lead.state.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSubtle),
                                  const SizedBox(width: 6),
                                  Text(
                                    [if (lead.city.isNotEmpty) lead.city, if (lead.state.isNotEmpty) lead.state].join(', '),
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Subtle divider line
                Container(
                  height: 1,
                  color: AppColors.border,
                ),

                // Card footer row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tactile call pill button
                      if (lead.phone.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.dark3,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.phone_in_talk_rounded, size: 12, color: AppColors.goldLight),
                              const SizedBox(width: 6),
                              Text(
                                lead.phone,
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        const SizedBox.shrink(),

                      // Status and Created Date Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              lead.status.toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (lead.createdAt != null)
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, size: 11, color: AppColors.textSubtle),
                                const SizedBox(width: 4),
                                Text(
                                  '${lead.createdAt!.day}/${lead.createdAt!.month}',
                                  style: const TextStyle(
                                    color: AppColors.textSubtle,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// =======================
/// LEAD DETAIL BOTTOM SHEET
/// =======================

void _showLeadDetailsBottomSheet(BuildContext context, Lead lead) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.dark,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              border: Border(
                top: BorderSide(color: AppColors.border, width: 1.5),
              ),
            ),
            child: Column(
              children: [
                // Handle Bar
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Main Scrollable Content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      // Header: Lead Avatar + Name + Badges
                      Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.goldDark, AppColors.gold],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              lead.name.isNotEmpty ? lead.name[0].toUpperCase() : '#',
                              style: const TextStyle(
                                color: AppColors.cream,
                                fontWeight: FontWeight.w900,
                                fontSize: 26,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lead.name.isEmpty ? 'Lead #${lead.id}' : lead.name,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lead.phone,
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Section Title: Message
                      _buildSectionTitle(Icons.chat_bubble_outline_rounded, 'Message from Customer'),
                      const SizedBox(height: 10),

                      // Message Bubble Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.dark2,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          lead.message != null && lead.message!.isNotEmpty
                              ? '"${lead.message}"'
                              : '"hello there can we talk"',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section Title: Property Detail
                      _buildSectionTitle(Icons.apartment_rounded, 'Associated Property'),
                      const SizedBox(height: 10),

                      if (lead.property != null) ...[
                        _buildPropertyCard(lead.property!)
                      ] else ...[
                        // Fallback Placeholder if property is null
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.dark2,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.home_work_rounded, color: AppColors.textSubtle, size: 40),
                              SizedBox(height: 8),
                              Text(
                                'No specific property associated with this buyer lead.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildSectionTitle(IconData icon, String title) {
  return Row(
    children: [
      Icon(icon, size: 18, color: AppColors.gold),
      const SizedBox(width: 8),
      Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    ],
  );
}

Widget _buildPropertyCard(LeadProperty prop) {
  final priceFormatted = prop.type.toLowerCase() == 'rent'
      ? '₹${prop.price.toStringAsFixed(0)}/month'
      : '₹${prop.price.toStringAsFixed(0)}';

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.dark2,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border, width: 1.2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Type tag
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                prop.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                prop.type.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.goldLight,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Price
        Text(
          priceFormatted,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 14),

        // Specifications chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (prop.bedrooms != null)
              _buildSpecChip(Icons.king_bed_rounded, '${prop.bedrooms} Beds'),
            if (prop.bathrooms != null)
              _buildSpecChip(Icons.bathtub_rounded, '${prop.bathrooms} Baths'),
            if (prop.area != null)
              _buildSpecChip(Icons.square_foot_rounded, '${prop.area!.toStringAsFixed(0)} ${prop.areaUnit ?? "sqft"}'),
            if (prop.furnishing != null && prop.furnishing!.isNotEmpty)
              _buildSpecChip(Icons.chair_rounded, prop.furnishing!),
          ],
        ),
        const SizedBox(height: 16),

        // Address
        if (prop.address.isNotEmpty) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  prop.address,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        // Description
        if (prop.description.isNotEmpty) ...[
          const Text(
            'DESCRIPTION',
            style: TextStyle(
              color: AppColors.textSubtle,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            prop.description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ],
    ),
  );
}

Widget _buildSpecChip(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.dark3,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
