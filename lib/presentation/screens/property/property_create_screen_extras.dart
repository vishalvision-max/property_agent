part of 'property_create_screen.dart';

extension PropertyCreateScreenExtras on _PropertyCreateScreenState {
  Widget buildAmenities() {
    return ref
        .watch(amenitiesProvider)
        .when(
          data: (items) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _openAmenitiesPicker(items),
                  icon: const Icon(Icons.tune, color: AppTheme.gold),
                  label: const Text(
                    'Select Amenities',
                    style: TextStyle(color: AppTheme.gold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_selectedAmenityIds.isEmpty)
                Text(
                  'No amenities selected',
                  style: const TextStyle(color: Color(0xFFCBD5E1)),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedAmenityIds.map((id) {
                    final name =
                        items
                                .cast<dynamic>()
                                .firstWhere(
                                  (a) => a.id == id,
                                  orElse: () => null,
                                )
                                ?.name
                            as String?;
                    return Chip(
                      label: Text(name ?? 'Amenity $id'),
                      onDeleted: () => setState(() {
                        _selectedAmenityIds.remove(id);
                        _scheduleSaveDraft();
                      }),
                    );
                  }).toList(),
                ),
            ],
          ),
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
        );
  }

  Future<void> _openAmenitiesPicker(List items) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF070B14),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final tempSelected = Set<int>.of(_selectedAmenityIds);
        return StatefulBuilder(
          builder: (context, setSheetState) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Amenities',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: items
                            .map(
                              (a) => FilterChip(
                                label: Text(
                                  a.name,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                selected: tempSelected.contains(a.id),
                                onSelected: (selected) => setSheetState(() {
                                  if (selected)
                                    tempSelected.add(a.id);
                                  else
                                    tempSelected.remove(a.id);
                                }),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedAmenityIds
                              ..clear()
                              ..addAll(tempSelected);
                          });
                          _scheduleSaveDraft();
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildFurnishings() {
    return ref
        .watch(furnishingsProvider)
        .when(
          data: (items) {
            final sorted = List.of(items)
              ..sort((a, b) => a.name.compareTo(b.name));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openFurnishingsPicker(sorted),
                    icon: const Icon(Icons.tune, color: AppTheme.gold),
                    label: const Text(
                      'Select Furnishings',
                      style: TextStyle(color: AppTheme.gold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_selectedFurnishingIds.isEmpty)
                  Text(
                    'No furnishings selected',
                    style: const TextStyle(color: Color(0xFFCBD5E1)),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedFurnishingIds.map((id) {
                      final item = sorted.cast<dynamic>().firstWhere(
                        (f) => f.id == id,
                        orElse: () => null,
                      );
                      final label = item == null ? 'Item $id' : item.name;
                      final qty = _furnishingQuantities[id];
                      return Chip(
                        label: Text(qty == null ? label : '$label x$qty'),
                        onDeleted: () => setState(() {
                          _selectedFurnishingIds.remove(id);
                          _furnishingQuantities.remove(id);
                          _scheduleSaveDraft();
                        }),
                      );
                    }).toList(),
                  ),
              ],
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
        );
  }

  Future<void> _openFurnishingsPicker(List items) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF070B14),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final tempSelected = Set<int>.of(_selectedFurnishingIds);
        final tempQty = Map<int, int>.of(_furnishingQuantities);
        return StatefulBuilder(
          builder: (context, setSheetState) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Furnishings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final f = items[i];
                        final selected = tempSelected.contains(f.id);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Checkbox(
                                value: selected,
                                onChanged: (v) => setSheetState(() {
                                  if (v == true) {
                                    tempSelected.add(f.id);
                                    if (f.isCountable) {
                                      tempQty.putIfAbsent(f.id, () => 1);
                                    }
                                  } else {
                                    tempSelected.remove(f.id);
                                    tempQty.remove(f.id);
                                  }
                                }),
                              ),
                              Expanded(
                                child: Text(
                                  f.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (f.isCountable)
                                _QuantityStepper(
                                  value: tempQty[f.id] ?? 1,
                                  enabled: selected,
                                  onChanged: (next) => setSheetState(() {
                                    tempQty[f.id] = next;
                                  }),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFurnishingIds
                              ..clear()
                              ..addAll(tempSelected);
                            _furnishingQuantities
                              ..clear()
                              ..addAll(tempQty);
                          });
                          _scheduleSaveDraft();
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildLocation() {
    return Column(
      children: [
        Stack(
          children: [
            _buildTextField(
              _address,
              'Address',
              'Street address',
              Icons.location_on,
              onChanged: _onAddressChanged,
              errorText: ref.watch(propertyFormProvider).errorFor('address'),
            ),
            if (ref.watch(addressSuggestionsProvider).isLoading || ref.watch(formSubmitStateProvider))
              const Positioned(
                right: 12,
                top: 12,
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            if (_addressFocus.hasFocus && (ref.watch(addressSuggestionsProvider).valueOrNull ?? []).isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                top: 72,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF0B1220),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: (ref.watch(addressSuggestionsProvider).valueOrNull ?? []).length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final pred = (ref.watch(addressSuggestionsProvider).valueOrNull ?? [])[i];
                        return ListTile(
                          dense: true,
                          title: Text(
                            pred.description,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(
                            Icons.north_west_rounded,
                            size: 16,
                            color: AppTheme.gold.withValues(alpha: 0.9),
                          ),
                          onTap: () => _selectAddressPrediction(pred),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (_isSellResidentialFarmhouse) ...[
          _buildTextField(
            _village,
            'Village',
            'Village name',
            Icons.location_city_outlined,
            onChanged: (_) => _scheduleSaveDraft(),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _landmark,
            'Landmark (Optional)',
            'Near ...',
            Icons.place_outlined,
            onChanged: (_) => _scheduleSaveDraft(),
          ),
          const SizedBox(height: 12),
        ],

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                _city,
                'City',
                'City name',
                Icons.location_city,
                onChanged: (_) => _validateField('city'),
                errorText: ref.watch(propertyFormProvider).errorFor('city'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                _state,
                'State',
                'State name',
                Icons.map,
                onChanged: (_) => _validateField('state'),
                errorText: ref.watch(propertyFormProvider).errorFor('state'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _pincode,
          'Pincode',
          '6-digit code',
          Icons.mail,
          keyboardType: TextInputType.number,
          onChanged: (_) => _validateField('pincode'),
          errorText: ref.watch(propertyFormProvider).errorFor('pincode'),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _ownerName,
          'Owner Name (Optional)',
          'Owner full name',
          Icons.person_outline,
          onChanged: (_) => _scheduleSaveDraft(),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _ownerPhone,
          'Phone Number (Optional)',
          '10-digit phone',
          Icons.call_outlined,
          keyboardType: TextInputType.phone,
          onChanged: (_) => _scheduleSaveDraft(),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _forceAutoFillLocation,
            icon: const Icon(Icons.my_location, size: 16),
            label: const Text('Use current location'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.gold,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Lat/Lng are auto-filled and sent to API, but hidden from UI by design.
        if (_isSellResidentialApartment) ...[
          const SizedBox(height: 6),
          _buildChoiceChipRow(
            'WhatsApp Updates',
            const ['yes', 'no'],
            _whatsappUpdates ? 'yes' : 'no',
            (v) {
              setState(() => _whatsappUpdates = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
        ],
      ],
    );
  }

  // Widget _buildPromotion() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Boost Listing',
  //         style: TextStyle(
  //           fontSize: 13,
  //           fontWeight: FontWeight.w800,
  //           color: AppColors.textPrimary,
  //         ),
  //       ),
  //       const SizedBox(height: 6),
  //       const Text(
  //         'Select promotions to get more visibility.',
  //         style: TextStyle(fontSize: 12, color: AppColors.textMuted),
  //       ),
  //       const SizedBox(height: 10),
  //       ..._promotionOptions.map((p) {
  //         final selected = _promotionTags.contains(p);
  //         final label = p[0].toUpperCase() + p.substring(1);
  //         return CheckboxListTile(
  //           value: selected,
  //           fillColor: WidgetStateProperty.all(AppTheme.gold),
  //           // selectedTileColor: AppTheme.gold,
  //           onChanged: (v) {
  //             setState(() {
  //               if (v == true) {
  //                 _promotionTags.add(p);
  //               } else {
  //                 _promotionTags.remove(p);
  //               }
  //             });
  //             _scheduleSaveDraft();
  //           },
  //           dense: true,
  //           controlAffinity: ListTileControlAffinity.leading,
  //           title: Text(
  //             label,
  //             style: const TextStyle(color: AppColors.textPrimary),
  //           ),
  //           contentPadding: EdgeInsets.zero,
  //         );
  //       }),
  //     ],
  //   );
  // }

  Widget buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMediaButton(
                Icons.photo_camera,
                'Camera',
                Colors.blue,
                _pickImageCamera,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMediaButton(
                Icons.photo_library,
                'Gallery',
                Colors.green,
                _pickImages,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMediaButton(
                Icons.videocam,
                'Video',
                Colors.orange,
                _pickVideoCamera,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_images.isEmpty)
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 40,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add photos to showcase your property',
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  Text(
                    '${_images.length}/20 photos',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1, // This forces square aspect ratio
            ),
            itemBuilder: (context, i) => Stack(
              clipBehavior: Clip.none,
              children: [
                // Image with fixed square box
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey.shade200,
                    child: _PreviewImage(src: _images[i].path),
                  ),
                ),

                // PRIMARY Badge - Top Left
                if (i == _primaryImageIndex)
                  Positioned(
                    top: 3,
                    left: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'PRIMARY',
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                // Star Button - Top Right
                Positioned(
                  top: 3,
                  right: 3,
                  child: GestureDetector(
                    onTap: () => setState(() => _primaryImageIndex = i),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.star, size: 11, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                // Delete Button - Bottom Right
                Positioned(
                  bottom: 3,
                  right: 3,
                  child: GestureDetector(
                    onTap: () => _removeImage(i),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.close, size: 11, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                // Tag Dropdown - Bottom Left
                Positioned(
                  bottom: 3,
                  left: 3,
                  right: 40,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1220).withValues(alpha: 0.92),
                      border: Border.all(
                        color: AppTheme.gold.withValues(alpha: 0.22),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButton<String>(
                      value: _getAvailableTags().contains(_images[i].tag)
                          ? _images[i].tag
                          : 'general',
                      dropdownColor: Colors.white,
                      underline: const SizedBox(),
                      isExpanded: true,
                      isDense: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 14,
                        color: AppTheme.gold.withValues(alpha: 0.95),
                      ),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 9,
                      ),
                      onChanged: (newTag) => _updateImageTag(i, newTag!),
                      items: _getAvailableTags().map((tag) {
                        return DropdownMenuItem<String>(
                          value: tag,
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget buildVideoSection() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _videos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) => Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (_) => _VideoPlayerDialog(src: _videos[i].path),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.black,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.play_circle_filled,
                            color: Colors.white,
                            size: 40,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              color: Colors.black54,
                              child: Text(
                                _videos[i].tag ?? 'Video',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      onPressed: () => _removeVideo(i),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== UI Helper Widgets ====================

  FilterChip _simpleFilterChip({
    required String label,
    required bool? selected,
    required ValueChanged<bool> onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected ?? false,
      showCheckmark: false,
      selectedColor: AppTheme.gold,
      backgroundColor: Colors.white.withValues(alpha: 0.08),
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: (selected ?? false) ? const Color(0xFF070B14) : AppColors.dark2,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      onSelected: onSelected,
    );
  }
}
