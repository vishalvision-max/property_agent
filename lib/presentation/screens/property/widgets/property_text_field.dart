import 'package:flutter/material.dart';
import 'package:property_agent/core/theme/app_colors.dart';

const TextStyle propertyLabelStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: AppColors.textPrimary,
);

class PropertyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? icon;
  final TextInputType keyboardType;
  final int maxLines;
  final String? suffixText;
  final Widget? suffixIcon;
  final String? errorText;
  final String? helperText;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  const PropertyTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.suffixText,
    this.suffixIcon,
    this.errorText,
    this.helperText,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: propertyLabelStyle,
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            helperText: helperText,
            prefixIcon: icon != null ? Icon(icon, size: 18) : null,
            suffixText: suffixText,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ),
      ],
    );
  }
}
