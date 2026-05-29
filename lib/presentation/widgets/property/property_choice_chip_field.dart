import 'package:flutter/material.dart';
import 'package:property_agent/core/theme/app_colors.dart';
import 'package:property_agent/core/theme/app_theme.dart';

class PropertyChoiceChipField extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onChanged;
  final String Function(String)? displayFor;

  const PropertyChoiceChipField({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.displayFor,
  }) : super(key: key);

  bool _isSelected(String opt) {
    final normSel = selectedValue.trim().toLowerCase().replaceAll('-', '_');
    final normOpt = opt.trim().toLowerCase().replaceAll('-', '_');
    return normSel == normOpt;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            spacing: 6,
            children: options
                .map(
                  (opt) => Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        (displayFor != null)
                            ? displayFor!(opt)
                            : opt.replaceAll('_', ' ').toUpperCase(),
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _isSelected(opt)
                              ? const Color(0xFF070B14)
                              : AppColors.dark2,
                        ),
                      ),
                      selected: _isSelected(opt),
                      onSelected: (_) => onChanged(opt),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      selectedColor: AppTheme.gold,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
