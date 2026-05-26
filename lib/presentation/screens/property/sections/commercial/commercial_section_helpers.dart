import 'package:flutter/material.dart';
import 'package:property_agent/core/theme/app_colors.dart';

/// Shared UI helpers for commercial section widgets.
/// Kept in one file so all sections stay thin and consistent.

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSubtle,
          ),
        ),
      );
}

class SectionField extends StatelessWidget {
  const SectionField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint = '',
    this.keyboard = TextInputType.text,
    this.icon,
    this.errorText,
  });

  final String label;
  final String value;
  final String hint;
  final TextInputType keyboard;
  final ValueChanged<String> onChanged;
  final IconData? icon;
  final String? errorText;

  @override
  Widget build(BuildContext context) => TextFormField(
        initialValue: value,
        keyboardType: keyboard,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
          prefixIcon: icon != null ? Icon(icon, size: 20, color: AppColors.textSubtle) : null,
          labelStyle:
              const TextStyle(fontSize: 13, color: AppColors.textSubtle),
          hintStyle:
              const TextStyle(fontSize: 13, color: AppColors.textMuted),
          filled: true,
          fillColor: AppColors.dark2,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
          ),
        ),
      );
}

class SectionChips extends StatelessWidget {
  const SectionChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 6,
        children: options.map((opt) {
          final active = opt == selected;
          return ChoiceChip(
            label: Text(
              opt.replaceAll('_', ' '),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? Colors.black : AppColors.textSubtle,
              ),
            ),
            selected: active,
            onSelected: (_) => onChanged(opt),
            selectedColor: AppColors.gold,
            backgroundColor: AppColors.dark2,
            side: BorderSide(
              color: active ? AppColors.gold : AppColors.border,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          );
        }).toList(),
      );
}

class SectionSwitch extends StatelessWidget {
  const SectionSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary)),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.gold,
            ),
          ],
        ),
      );
}

class SectionUnitDropdown extends StatelessWidget {
  const SectionUnitDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
        value: options.contains(value) ? value : options.first,
        items: options
            .map((u) => DropdownMenuItem(value: u, child: Text(u)))
            .toList(),
        onChanged: (v) => onChanged(v ?? options.first),
        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        dropdownColor: AppColors.dark2,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.dark2,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      );
}
