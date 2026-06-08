import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_agent/core/theme/app_colors.dart';
import 'package:property_agent/core/theme/app_theme.dart';
import 'package:property_agent/data/models/category.dart';
import 'package:property_agent/providers/lookup_provider.dart';

class BasicInfoSection extends ConsumerWidget {
  const BasicInfoSection({
    super.key,
    required this.propertyKindValues,
    required this.propertyKind,
    required this.onPropertyKindChanged,
    required this.selectedParentCategoryId,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.buildChoiceGridString,
    required this.buildChoiceGridInt,
    required this.buildChoiceGridKind,
    required this.normalizeParentSlug,
    required this.syncDetails,
    required this.scheduleSaveDraft,
    required this.segmentLockedToResidential,
  });

  final List<dynamic> propertyKindValues;
  final dynamic propertyKind;
  final ValueChanged<dynamic> onPropertyKindChanged;

  final int? selectedParentCategoryId;
  final int? selectedCategoryId;
  final Function(int? parentId, String? parentSlug, int? childId, String? childSlug) onCategorySelected;

  final Widget Function({
    required String label,
    required List<dynamic> values,
    required dynamic value,
    required String Function(dynamic) labelFor,
    required ValueChanged<dynamic> onChanged,
  }) buildChoiceGridKind;

  final Widget Function({
    required String label,
    required List<int> values,
    required int? value,
    required String Function(int) labelFor,
    required ValueChanged<int?> onChanged,
  }) buildChoiceGridInt;

  final Widget Function({
    required String label,
    required List<String> values,
    required String? value,
    required String Function(String) labelFor,
    required ValueChanged<String?> onChanged,
  }) buildChoiceGridString;

  final String? Function({required String? rawSlug, required String name}) normalizeParentSlug;
  final VoidCallback syncDetails;
  final VoidCallback scheduleSaveDraft;
  final bool segmentLockedToResidential;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildChoiceGridKind(
          label: 'What are you listing?',
          values: propertyKindValues,
          value: propertyKind,
          labelFor: (v) => v.toString().split('.').last, // Fallback label
          onChanged: onPropertyKindChanged,
        ),
        const SizedBox(height: 16),
        if (propertyKind != null) _buildCategorySelector(ref),
      ],
    );
  }

  Widget _buildCategorySelector(WidgetRef ref) {
    return ref.watch(categoriesProvider).when(
      data: (cats) {
        return const Text('Category Selector Extracted');
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
