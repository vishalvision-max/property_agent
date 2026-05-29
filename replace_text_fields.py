import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # 1. _buildTextField
    # Let's replace the whole body of _buildTextField
    build_tf_search = """    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          focusNode: c == _address ? _addressFocus : null,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            helperText: helperText,
            prefixIcon: Icon(icon, size: 18),
            suffixText: suffixText,
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
    );"""
    
    build_tf_replace = """    return PropertyTextField(
      controller: c,
      label: label,
      hint: hint,
      icon: icon,
      keyboardType: keyboardType,
      maxLines: maxLines,
      suffixText: suffixText,
      errorText: errorText,
      helperText: helperText,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      focusNode: c == _address ? _addressFocus : null,
    );"""
    
    if build_tf_search in content:
        content = content.replace(build_tf_search, build_tf_replace)
    else:
        print("Could not find _buildTextField body!")

    # 2. _buildCompactNumberField
    compact_search = """    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textPrimary),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hint,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );"""
    
    compact_replace = """    return PropertyTextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      label: label,
      hint: hint,
      icon: icon,
    );"""
    
    if compact_search in content:
        content = content.replace(compact_search, compact_replace)
    else:
        print("Could not find _buildCompactNumberField body!")

    # 3. _buildFloorNumberField
    floor_search = """    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Floor No.',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _floor,
          keyboardType: TextInputType.number,
          onChanged: (_) {
            setState(() {});
            _scheduleSaveDraft();
          },
          decoration: InputDecoration(
            hintText: total == null ? 'Enter total floors first' : '1 - $total',
            prefixIcon: const Icon(Icons.flood, size: 18),
            errorText: (total == null)
                ? null
                : (invalid ? 'Floor must be between 1 and $total' : null),
          ),
        ),
      ],
    );"""
    
    floor_replace = """    return PropertyTextField(
      controller: _floor,
      keyboardType: TextInputType.number,
      onChanged: (_) {
        setState(() {});
        _scheduleSaveDraft();
      },
      label: 'Floor No.',
      hint: total == null ? 'Enter total floors first' : '1 - $total',
      icon: Icons.flood,
      errorText: (total == null)
          ? null
          : (invalid ? 'Floor must be between 1 and $total' : null),
    );"""
    
    if floor_search in content:
        content = content.replace(floor_search, floor_replace)
    else:
        print("Could not find _buildFloorNumberField body!")

    # 4. _availableFrom
    avail_search = """                TextField(
                  controller: _availableFrom,
                  readOnly: true,
                  onTap: _pickAvailableFrom,
                  decoration: const InputDecoration(
                    labelText: 'Available From',
                    hintText: 'Select date',
                    prefixIcon: Icon(Icons.calendar_month_outlined, size: 18),
                  ),
                ),"""
                
    avail_replace = """                PropertyTextField(
                  controller: _availableFrom,
                  readOnly: true,
                  onTap: _pickAvailableFrom,
                  label: 'Available From',
                  hint: 'Select date',
                  icon: Icons.calendar_month_outlined,
                ),"""
                
    if avail_search in content:
        content = content.replace(avail_search, avail_replace)
    else:
        print("Could not find _availableFrom field!")

    # For other areas with Dropdowns as suffixIcon (like _plotArea, _showroomArea, _shopArea, _warehousePlotArea),
    # I'll just use regex because the structure is mostly similar.
    # We look for TextField followed by its decoration...
    # Actually, the user wants me to NOT use TextField. Let me do exact replacements for the 4 remaining areas.

    with open(filepath, 'w') as f:
        f.write(content)

process_file('lib/presentation/screens/property/property_create_screen.dart')
