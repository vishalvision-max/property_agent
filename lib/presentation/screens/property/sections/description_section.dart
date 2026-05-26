import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_agent/core/theme/app_colors.dart';
import 'package:property_agent/providers/property_form/property_form_provider.dart';
import 'package:property_agent/providers/property_form/property_form_state.dart';
import 'package:property_agent/providers/property_form/state/modular_states.dart';

class DescriptionSection extends ConsumerWidget {
  const DescriptionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyFormProvider);
    final notifier = ref.read(propertyFormProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Your Property',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: state.basicInfo.description,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: 'About the property...',
            prefixIcon: const Icon(Icons.description, size: 18),
            helperText: 'Min 15 characters',
            errorText: state.validationErrors['desc'],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
          ),
          onChanged: (val) {
            notifier.setDescription(val);
          },
        ),
      ],
    );
  }
}
