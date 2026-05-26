import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_agent/core/theme/app_colors.dart';
import 'package:property_agent/providers/property_form/property_form_provider.dart';
import 'package:property_agent/providers/property_form/property_form_state.dart';
import 'package:property_agent/providers/property_form/state/modular_states.dart';

class AreaField extends ConsumerWidget {
  final bool isCommercial;

  const AreaField({super.key, required this.isCommercial});

  static const _areaUnits = <String>['sqft', 'sqm', 'sqyd', 'acre'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyFormProvider);
    final notifier = ref.read(propertyFormProvider.notifier);
    final areaUnit = state.basicInfo.areaUnit.trim().isNotEmpty ? state.basicInfo.areaUnit : 'sqft';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Area',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: state.basicInfo.area,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: isCommercial ? 'Built-up area' : 'Size',
            errorText: state.validationErrors['area'],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _areaUnits.contains(areaUnit) ? areaUnit : 'sqft',
                  isDense: true,
                  icon: const Icon(Icons.arrow_drop_down, size: 20),
                  items: _areaUnits.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      notifier.setAreaUnit(val);
                    }
                  },
                ),
              ),
            ),
          ),
          onChanged: (val) {
            notifier.setArea(val);
          },
        ),
      ],
    );
  }
}
