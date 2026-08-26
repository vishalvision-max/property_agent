// ignore_for_file: invalid_use_of_protected_member
part of 'property_create_screen.dart';

extension PropertyCreateScreenExtras on _PropertyCreateScreenState {
  /// The subcategory id used to load category-specific features
  /// (amenities/furnishings). Null when no valid subcategory is selected yet
  /// (e.g. the farmhouse sentinel -9999), in which case the pickers prompt the
  /// user to choose a category first.
  int? get _featuresCategoryId {
    final id = _selectedCategoryId;
    if (id == null || id <= 0) return null;
    return id;
  }

  /// Whether the Amenities section should render. Hidden only once the
  /// category's features have loaded and contain no amenities (e.g. a farmhouse
  /// with none configured); kept visible while loading or when no category is
  /// selected so nothing flickers.
  bool _showAmenitiesSection() {
    final catId = _featuresCategoryId;
    if (catId == null) return true;
    final features = ref.watch(categoryFeaturesProvider(catId)).value;
    if (features == null) return true;
    return features.amenities.isNotEmpty;
  }

  /// Whether the Furnishings section should render. See [_showAmenitiesSection].
  bool _showFurnishingsSection() {
    final catId = _featuresCategoryId;
    if (catId == null) return true;
    final features = ref.watch(categoryFeaturesProvider(catId)).value;
    if (features == null) return true;
    return features.furnishings.isNotEmpty;
  }

  /// Corrects known misspellings in feature names coming from the API before
  /// they are shown to the user (e.g. the API returns "Attached Balony").
  String _featureDisplayName(String name) {
    switch (name.trim().toLowerCase()) {
      case 'attached balony':
        return 'Attached Balcony';
      default:
        return name;
    }
  }

  Widget buildAmenities() {
    final catId = _featuresCategoryId;
    if (catId == null) {
      return const Text(
        'Select a property category to see amenities',
        style: TextStyle(color: Color(0xFFCBD5E1)),
      );
    }
    return ref
        .watch(categoryFeaturesProvider(catId))
        .whenData((f) => f.amenities)
        .when(
          data: (items) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _amenitiesExpanded = !_amenitiesExpanded;
                  }),
                  icon: const Icon(Icons.tune, color: AppTheme.gold),
                  label: Text(
                    _amenitiesExpanded ? 'Done Selecting' : 'Select Amenities',
                    style: const TextStyle(color: AppTheme.gold),
                  ),
                ),
              ),
              // Inline picker container. Selections write straight to
              // `_selectedAmenityIds` via setState, so scrolling never resets
              // them (no temporary buffer as a bottom sheet would need).
              if (_amenitiesExpanded) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxHeight: 260),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1220),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.gold.withValues(alpha: 0.35)),
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: items
                          .map(
                            (a) => FilterChip(
                              label: Text(
                                _featureDisplayName(a.name),
                                style: const TextStyle(fontSize: 13),
                              ),
                              selected: _selectedAmenityIds.contains(a.id),
                              onSelected: (selected) => setState(() {
                                if (selected) {
                                  _selectedAmenityIds.add(a.id);
                                } else {
                                  _selectedAmenityIds.remove(a.id);
                                }
                                _scheduleSaveDraft();
                              }),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
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
                      label: Text(
                        name == null ? 'Amenity $id' : _featureDisplayName(name),
                      ),
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

  Widget buildFurnishings() {
    final catId = _featuresCategoryId;
    if (catId == null) {
      return const Text(
        'Select a property category to see furnishings',
        style: TextStyle(color: Color(0xFFCBD5E1)),
      );
    }
    return ref
        .watch(categoryFeaturesProvider(catId))
        .whenData((f) => f.furnishings)
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
                    onPressed: () => setState(() {
                      _furnishingsExpanded = !_furnishingsExpanded;
                    }),
                    icon: const Icon(Icons.tune, color: AppTheme.gold),
                    label: Text(
                      _furnishingsExpanded
                          ? 'Done Selecting'
                          : 'Select Furnishings',
                      style: const TextStyle(color: AppTheme.gold),
                    ),
                  ),
                ),
                // Inline picker container. Selections write straight to state
                // via setState, so scrolling never resets them (no temporary
                // buffer as a bottom sheet would need).
                if (_furnishingsExpanded) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1220),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.gold.withValues(alpha: 0.35),
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: sorted.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final f = sorted[i];
                        final selected = _selectedFurnishingIds.contains(f.id);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Checkbox(
                                value: selected,
                                onChanged: (v) => setState(() {
                                  if (v == true) {
                                    _selectedFurnishingIds.add(f.id);
                                    if (f.isCountable) {
                                      _furnishingQuantities.putIfAbsent(
                                        f.id,
                                        () => 1,
                                      );
                                    }
                                  } else {
                                    _selectedFurnishingIds.remove(f.id);
                                    _furnishingQuantities.remove(f.id);
                                  }
                                  _scheduleSaveDraft();
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
                                  value: _furnishingQuantities[f.id] ?? 1,
                                  enabled: selected,
                                  onChanged: (next) => setState(() {
                                    _furnishingQuantities[f.id] = next;
                                    _scheduleSaveDraft();
                                  }),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
          ],
        ),
        // Address autocomplete list. Rendered inline (not as a Positioned
        // overlay inside the Stack) so it isn't clipped by the Stack bounds and
        // reliably opens below the field while typing.
        if (_addressFocus.hasFocus &&
            (ref.watch(addressSuggestionsProvider).value ?? []).isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF0B1220),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount:
                      (ref.watch(addressSuggestionsProvider).value ?? []).length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final pred =
                        (ref.watch(addressSuggestionsProvider).value ?? [])[i];
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
                        color: AppTheme.gold.withOpacity(0.9),
                      ),
                      onTap: () => _selectAddressPrediction(pred),
                    );
                  },
                ),
              ),
            ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          onChanged: (_) => _scheduleSaveDraft(),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _fetchingLocation ? null : _forceAutoFillLocation,
            icon: _fetchingLocation
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
                    ),
                  )
                : const Icon(Icons.my_location, size: 16),
            label: Text(
              _fetchingLocation ? 'Getting location…' : 'Use current location',
            ),
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

  /// Syncs the photo/video tag options for the selected subcategory from the
  /// media-types API into state so the tag dropdowns render dynamic options.
  /// Watched here (rather than setState) so a load simply triggers a rebuild.
  void _syncMediaTypes() {
    final catId = _selectedCategoryId;
    if (catId == null || catId <= 0) return;
    final media = ref.watch(mediaTypesProvider(catId)).value;
    if (media == null) return;
    _photoMediaTypes = media.photos;
    _videoMediaTypes = media.videos;
  }

  Widget buildMediaSection() {
    _syncMediaTypes();
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
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
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
                      color: Colors.white.withOpacity(0.92),
                      border: Border.all(
                        color: AppTheme.gold.withOpacity(0.22),
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
                        color: AppTheme.gold.withOpacity(0.95),
                      ),
                      // Badge sits on a white container, so the closed-state
                      // label must be dark to stay readable.
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 9,
                      ),
                      onChanged: (newTag) => _updateImageTag(i, newTag!),
                      items: _getAvailableTags().map((tag) {
                        return DropdownMenuItem<String>(
                          value: tag,
                          // Dropdown menu opens on a white background
                          // (dropdownColor above), so item text must be dark
                          // to stay visible.
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.dark,
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              color: Colors.black54,
                              child: DropdownButton<String>(
                                value:
                                    _getAvailableVideoTags().contains(
                                      _videos[i].tag,
                                    )
                                    ? _videos[i].tag
                                    : 'general',
                                dropdownColor: Colors.black87,
                                underline: const SizedBox(),
                                isExpanded: true,
                                isDense: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                onChanged: (newTag) => setState(() {
                                  _videos[i].tag = newTag;
                                }),
                                items: _getAvailableVideoTags().map((tag) {
                                  return DropdownMenuItem<String>(
                                    value: tag,
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
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
                  ),
                ),
                // Delete control styled identically to the photo grid's
                // delete button (20x20 red circle with a white close icon).
                Positioned(
                  top: 3,
                  right: 3,
                  child: GestureDetector(
                    onTap: () => _removeVideo(i),
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
      backgroundColor: Colors.white.withOpacity(0.08),
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: (selected ?? false) ? const Color(0xFF070B14) : AppColors.dark2,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      onSelected: onSelected,
    );
  }
}
