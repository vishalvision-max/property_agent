// ignore_for_file: invalid_use_of_protected_member
part of 'property_create_screen.dart';

extension PropertyCreateScreenDetails on _PropertyCreateScreenState {
  Widget buildPropertyDetails() {
    final isLandPlot = _isLandPlotContext;
    final isCommercial = _isCommercialContext;
    final isResidential = !isLandPlot && !isCommercial;
    final isVilla = _selectedCategorySlug == 'villa';
    final isSale = _propertyKind == _CreatePropertyKind.sale;
    final isRentLease =
        _propertyKind == _CreatePropertyKind.rent ||
        _propertyKind == _CreatePropertyKind.lease;
    final isPgCoLiving =
        _propertyKind == _CreatePropertyKind.pg ||
        _propertyKind == _CreatePropertyKind.coLiving;

    if (isPgCoLiving) {
      return Column(
        children: [
          // _buildChoiceChipRow(
          //   'Gender Based',
          //   _PropertyCreateScreenState._pgGenderBasedOptions,
          //   _pgGenderBased,
          //   (v) {
          //     setState(() => _pgGenderBased = v);
          //     _scheduleSaveDraft();
          //   },
          // ),
          // const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Occupancy Type',
            _PropertyCreateScreenState._pgOccupancyTypeOptions,
            _pgOccupancyType,
            (v) {
              setState(() => _pgOccupancyType = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tenant Type',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,

            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: _PropertyCreateScreenState._pgTenantTypeOptions
                  .map(
                    (k) => _simpleFilterChip(
                      label: toTitleCase(k),
                      selected: _pgTenantTypes.contains(k),
                      onSelected: (s) {
                        setState(() {
                          if (s)
                            _pgTenantTypes.add(k);
                          else
                            _pgTenantTypes.remove(k);
                        });
                        _scheduleSaveDraft();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _buildSectionLabel('Food Availability'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: _PropertyCreateScreenState._pgFoodAvailabilityOptions
                  .map(
                    (k) => _simpleFilterChip(
                      label: toTitleCase(k),
                      selected: _pgFoodAvailability.contains(k),
                      onSelected: (s) {
                        setState(() {
                          if (s)
                            _pgFoodAvailability.add(k);
                          else
                            _pgFoodAvailability.remove(k);
                        });
                        _scheduleSaveDraft();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Property Type',
            _PropertyCreateScreenState._pgPropertyTypeOptions,
            _pgPropertyType,
            (v) {
              setState(() => _pgPropertyType = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Bathroom Type',
            _PropertyCreateScreenState._pgBathroomTypeOptions,
            _pgBathroomType,
            (v) {
              setState(() => _pgBathroomType = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Smoking Allowed',
            const ['yes', 'no'],
            _pgSmokingAllowed == null
                ? null
                : (_pgSmokingAllowed! ? 'yes' : 'no'),
            (v) {
              setState(() => _pgSmokingAllowed = v == 'yes');
              _scheduleSaveDraft();
            },
          ),

          const SizedBox(height: 12),

          _buildChoiceChipRow(
            'Drinking Allowed',
            const ['yes', 'no'],
            _pgDrinkingAllowed == null
                ? null
                : (_pgDrinkingAllowed! ? 'yes' : 'no'),
            (v) {
              setState(() => _pgDrinkingAllowed = v == 'yes');
              _scheduleSaveDraft();
            },
          ),

          const SizedBox(height: 12),

          _buildChoiceChipRow(
            'Pets Allowed',
            const ['yes', 'no'],
            _pgPetsAllowed == null ? null : (_pgPetsAllowed! ? 'yes' : 'no'),
            (v) {
              setState(() => _pgPetsAllowed = v == 'yes');
              _scheduleSaveDraft();
            },
          ),

          const SizedBox(height: 12),

          _buildChoiceChipRow(
            'Visitor Allowed',
            const ['yes', 'no'],
            _pgVisitorsAllowed == null
                ? null
                : (_pgVisitorsAllowed! ? 'yes' : 'no'),
            (v) {
              setState(() => _pgVisitorsAllowed = v == 'yes');
              _scheduleSaveDraft();
            },
          ),

          const SizedBox(height: 12),

          _buildChoiceChipRow(
            'Gate Locked At Night',
            const ['yes', 'no'],
            _pgGateLockedAtNight == null
                ? null
                : (_pgGateLockedAtNight! ? 'yes' : 'no'),
            (v) {
              setState(() => _pgGateLockedAtNight = v == 'yes');
              _scheduleSaveDraft();
            },
          ),

          const SizedBox(height: 12),

          _buildChoiceChipRow(
            'Security',
            const ['yes', 'no'],
            _pgSecurity == null ? null : (_pgSecurity! ? 'yes' : 'no'),
            (v) {
              setState(() => _pgSecurity = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _pgCurfewTime,
            'Curfew Timing (Optional)',
            'Enter curfew time manually (e.g. 10:00 PM)',
            Icons.schedule,
            readOnly: false,
          ),
          const SizedBox(height: 12),
          _buildSectionLabel('Nearby'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,

            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: _PropertyCreateScreenState._pgNearbyPreferenceOptions
                  .map(
                    (k) => _simpleFilterChip(
                      label: toTitleCase(k),
                      selected: _pgNearbyPreferences.contains(k),
                      onSelected: (s) {
                        setState(() {
                          if (s)
                            _pgNearbyPreferences.add(k);
                          else
                            _pgNearbyPreferences.remove(k);
                        });
                        _scheduleSaveDraft();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Availability',
            _PropertyCreateScreenState._pgAvailabilityOptions,
            _pgAvailability,
            (v) {
              setState(() => _pgAvailability = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Suitable For',
            const ['students', 'working_professionals', 'both'],
            _pgSuitableFor,
            (v) {
              setState(() => _pgSuitableFor = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _pgBuildingName,
            'Building Name (Optional)',
            'e.g., Sunshine Residency',
            Icons.apartment_outlined,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _pgTotalBeds,
                  'Total Beds',
                  'e.g., 30',
                  Icons.bed_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final total = int.tryParse(val.trim()) ?? 0;
                    final avail =
                        int.tryParse(_pgAvailableBeds.text.trim()) ?? 0;
                    if (total > 0 && avail > total) {
                      setState(() {
                        _pgAvailableBeds.text = total.toString();
                      });
                    }
                    _scheduleSaveDraft();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _pgAvailableBeds,
                  'Available Beds',
                  'e.g., 5',
                  Icons.event_available_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final total = int.tryParse(_pgTotalBeds.text.trim()) ?? 0;
                    final avail = int.tryParse(val.trim()) ?? 0;
                    if (total > 0 && avail > total) {
                      setState(() {
                        _pgAvailableBeds.text = total.toString();
                        _pgAvailableBeds.selection = TextSelection.fromPosition(
                          TextPosition(offset: _pgAvailableBeds.text.length),
                        );
                      });
                    }
                    _scheduleSaveDraft();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Room Type',
            const [
              'private_room',
              'twin_sharing',
              'triple_sharing',
              'dormitory',
            ],
            _pgRoomType,
            (v) {
              setState(() => _pgRoomType = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Bed Type',
            const ['single', 'bunk'],
            _pgBedType,
            (v) {
              setState(() => _pgBedType = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,

            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: [
                _simpleFilterChip(
                  label: 'ATTACHED BATHROOM',
                  selected: _pgAttachedBathroom,
                  onSelected: (s) {
                    setState(() => _pgAttachedBathroom = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'BALCONY',
                  selected: _pgBalcony,
                  onSelected: (s) {
                    setState(() => _pgBalcony = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'CUPBOARD',
                  selected: _pgCupboardAvailable,
                  onSelected: (s) {
                    setState(() => _pgCupboardAvailable = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'STUDY TABLE',
                  selected: _pgStudyTableAvailable,
                  onSelected: (s) {
                    setState(() => _pgStudyTableAvailable = s);
                    _scheduleSaveDraft();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _pgRoomSize,
            'Room Size (Optional)',
            'e.g., 120 sqft',
            Icons.straighten_outlined,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _pgSecurityDeposit,
                  'Security Deposit (Optional)',
                  'e.g., 5000',
                  Icons.lock_outline,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _pgMaintenanceCharges,
                  'Maintenance (Optional)',
                  'e.g., 500',
                  Icons.build_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSectionLabel('House Rules & Policies'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,

            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: [
                _simpleFilterChip(
                  label: 'ELECTRICITY INCLUDED',
                  selected: _pgElectricityIncluded,
                  onSelected: (s) {
                    setState(() => _pgElectricityIncluded = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'WATER INCLUDED',
                  selected: _pgWaterIncluded,
                  onSelected: (s) {
                    setState(() => _pgWaterIncluded = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'FOOD CHARGES INCLUDED',
                  selected: _pgFoodChargesIncluded,
                  onSelected: (s) {
                    setState(() => _pgFoodChargesIncluded = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'BROKERAGE REQUIRED',
                  selected: _pgBrokerageRequired,
                  onSelected: (s) {
                    setState(() => _pgBrokerageRequired = s);
                    _scheduleSaveDraft();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: [
                _simpleFilterChip(
                  label: 'COUPLE FRIENDLY',
                  selected: _pgCoupleFriendly,
                  onSelected: (s) {
                    setState(() => _pgCoupleFriendly = s);
                    _scheduleSaveDraft();
                  },
                ),
                _simpleFilterChip(
                  label: 'ID PROOF REQUIRED',
                  selected: _pgIdProofRequired,
                  onSelected: (s) {
                    setState(() => _pgIdProofRequired = s);
                    _scheduleSaveDraft();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _pgAvailableFrom,
                  'Available From (Optional)',
                  'YYYY-MM-DD',
                  Icons.event_available_outlined,
                  readOnly: true,
                  onTap: () => _pickDateForController(_pgAvailableFrom),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _pgMinStayDays,
                  'Min Stay (Days)',
                  'e.g., 30',
                  Icons.timelapse_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _pgNoticePeriodDays,
                  'Notice Period (Days)',
                  'e.g., 15',
                  Icons.notifications_active_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _pgPreferredTenantAge,
                  'Preferred Age (Optional)',
                  'e.g., 18-30',
                  Icons.cake_outlined,
                ),
              ),
            ],
          ),
          _buildStepper('Sharing', _pgSharing, 1, 6, (v) {
            setState(() => _pgSharing = v);
            _scheduleSaveDraft();
          }),
          const SizedBox(height: 12),
          _buildIntDropdownField(
            label: 'Rooms',
            controller: _rooms,
            min: 1,
            max: 200,
            hint: 'Select rooms',
            icon: Icons.bedroom_parent_outlined,
            allowEmpty: false,
          ),
          const SizedBox(height: 12),
          _buildStepper('Bathrooms', _bathrooms, 1, 50, (v) {
            setState(() => _bathrooms = v);
            _scheduleSaveDraft();
          }),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Furnishing',
            _PropertyCreateScreenState._furnishings,
            _furnishing,
            (v) {
              setState(() => _furnishing = v);
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildStepper('Parking', _parking, 0, 10, (v) {
            setState(() => _parking = v);
            _scheduleSaveDraft();
          }),
        ],
      );
    }

    return Column(
      children: [
        if (!isCommercial && !isLandPlot && !isResidential)
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select a sub-category to see details.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
        if (isLandPlot) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _landType == 'commercial'
                  ? 'Commercial Plot Details'
                  : (_landType == 'agricultural'
                        ? 'Agriculture Plot Details'
                        : 'Residential Plot Details'),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _plotArea,
            keyboardType: TextInputType.number,
            onChanged: (_) => _scheduleSaveDraft(),
            decoration: InputDecoration(
              labelText: 'Plot Area',
              hintText: 'Area',
              prefixIcon: const Icon(Icons.terrain, size: 18),
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _plotAreaUnit,
                    isDense: true,
                    dropdownColor: Colors.white,
                    iconEnabledColor: Colors.black,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                    items:
                        (_landType == 'agricultural'
                                ? _PropertyCreateScreenState._areaUnits
                                : _PropertyCreateScreenState._areaUnits.where(
                                    (u) => u != 'acre',
                                  ))
                            .map(
                              (u) => DropdownMenuItem<String>(
                                value: u,
                                child: Text(
                                  toTitleCase(u),
                                  style: const TextStyle(color: AppColors.dark),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (v) {
                      setState(() => _plotAreaUnit = v ?? _plotAreaUnit);
                      _scheduleSaveDraft();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _length,
                  'Length (ft)',
                  'e.g., 60',
                  Icons.straighten,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _breadth,
                  'Breadth (ft)',
                  'e.g., 40',
                  Icons.straighten,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildIntDropdownField(
            label: 'Floors Allowed (Optional)',
            controller: _floorsAllowed,
            min: 0,
            max: 50,
            hint: 'Select floors',
            icon: Icons.layers_outlined,
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Corner Plot',
            const ['yes', 'no'],
            _plotCorner == null ? '' : (_plotCorner! ? 'yes' : 'no'),
            (v) {
              setState(() => _plotCorner = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Boundary Wall',
            const ['yes', 'no'],
            _boundaryWall == null ? '' : (_boundaryWall! ? 'yes' : 'no'),
            (v) {
              setState(() => _boundaryWall = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildStepper(
            'Open Sides',
            _openSides,
            1,
            4,
            (v) => setState(() => _openSides = v),
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Construction Done',
            const ['yes', 'no'],
            _constructionDone == null
                ? ''
                : (_constructionDone! ? 'yes' : 'no'),
            (v) {
              setState(() => _constructionDone = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _roadWidth,
            'Road Width',
            'Width in feet',
            Icons.straighten,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Road Access',
            const ['yes', 'no'],
            _plotRoadAccess == null ? '' : (_plotRoadAccess! ? 'yes' : 'no'),
            (v) {
              setState(() => _plotRoadAccess = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
          if (_landType == 'agricultural') ...[
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Water Source',
              _PropertyCreateScreenState._agriWaterSources,
              _agriWaterSource,
              (v) {
                setState(() => _agriWaterSource = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Fencing',
              const ['yes', 'no'],
              _agriFencing == null ? null : (_agriFencing! ? 'yes' : 'no'),
              (v) {
                setState(() => _agriFencing = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
          ],
          if (isSale || isRentLease) ...[
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Ownership',
              _PropertyCreateScreenState._ownershipTypes,
              _ownership,
              (v) => setState(() => _ownership = v),
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Availability',
              _PropertyCreateScreenState._availabilityTypes,
              _availability,
              (v) => setState(() => _availability = v),
            ),
            if (_availability != 'ready_to_move' &&
                _availability != 'immediate') ...[
              const SizedBox(height: 12),
              _buildTextField(
                _possessionBy,
                'Possession By',
                'YYYY-MM-DD',
                Icons.event,
                readOnly: true,
                onTap: () => _pickDateForController(_possessionBy),
              ),
            ],
          ],
        ],
        if (isCommercial) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _commercialType == 'shop'
                  ? 'Shop Details'
                  : (_commercialType == 'showroom'
                        ? 'Showroom Details'
                        : (_commercialType == 'warehouse'
                              ? 'Warehouse Details'
                              : (_commercialType == 'industrial_shed'
                                    ? 'Industrial Shed Details'
                                    : 'Office Space Details'))),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_commercialType == 'office') ...[
            _buildChoiceChipRow(
              'Office Type',
              _PropertyCreateScreenState._officeTypes,
              _officeType,
              (v) {
                setState(() => _officeType = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _floorPlateArea,
              'Office Area (Optional)',
              'Area in sqft',
              Icons.crop_square,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildIntDropdownField(
                    label: 'Cabins',
                    controller: _cabins,
                    min: 0,
                    max: 50,
                    hint: 'Select cabins',
                    icon: Icons.meeting_room_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildIntDropdownField(
                    label: 'Meeting Rooms',
                    controller: _meetingRooms,
                    min: 0,
                    max: 30,
                    hint: 'Select rooms',
                    icon: Icons.groups_2_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildIntDropdownField(
                    label: 'Seats',
                    controller: _seats,
                    min: 0,
                    max: 500,
                    hint: 'Select seats',
                    icon: Icons.event_seat_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildIntDropdownField(
                    label: 'Max Seats',
                    controller: _maxSeats,
                    min: 0,
                    max: 500,
                    hint: 'Select max',
                    icon: Icons.event_seat_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildIntDropdownField(
              label: 'Conference Rooms',
              controller: _conferenceRooms,
              min: 0,
              max: 20,
              hint: 'Select rooms',
              icon: Icons.co_present_outlined,
            ),
          ],
          if (_commercialType == 'showroom') ...[
            TextField(
              controller: _showroomArea,
              keyboardType: TextInputType.number,
              onChanged: (_) => _scheduleSaveDraft(),
              decoration: InputDecoration(
                labelText: 'Showroom Area',
                hintText: 'Area',
                prefixIcon: const Icon(Icons.crop_square, size: 18),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _showroomAreaUnit,
                      isDense: true,
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      items: _PropertyCreateScreenState._showroomAreaUnits
                          .map(
                            (u) => DropdownMenuItem<String>(
                              value: u,
                              child: Text(
                                toTitleCase(u),
                                style: const TextStyle(color: AppColors.dark),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(
                          () => _showroomAreaUnit = v ?? _showroomAreaUnit,
                        );
                        _scheduleSaveDraft();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _showroomFrontageWidth,
                    'Frontage Width (ft)',
                    'e.g., 30',
                    Icons.straighten,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _showroomCeilingHeight,
                    'Ceiling Height (ft)',
                    'e.g., 15',
                    Icons.height,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Main Road Facing',
              const ['yes', 'no'],
              _showroomMainRoadFacing == null
                  ? ''
                  : (_showroomMainRoadFacing! ? 'yes' : 'no'),
              (v) {
                setState(() => _showroomMainRoadFacing = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Corner Showroom',
              const ['yes', 'no'],
              _showroomCorner == null ? '' : (_showroomCorner! ? 'yes' : 'no'),
              (v) {
                setState(() => _showroomCorner = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Washroom Available',
              const ['yes', 'no'],
              _showroomWashroom == null
                  ? ''
                  : (_showroomWashroom! ? 'yes' : 'no'),
              (v) {
                setState(() => _showroomWashroom = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _showroomParkingSlots,
              'Parking Slots (Optional)',
              'e.g., 5',
              Icons.local_parking_outlined,
              keyboardType: TextInputType.number,
              onChanged: (_) => _scheduleSaveDraft(),
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Furnishing Status',
              _PropertyCreateScreenState._furnishings,
              _showroomFurnishing,
              (v) {
                setState(() => _showroomFurnishing = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Floor Type',
              _PropertyCreateScreenState._showroomFloorTypes,
              _showroomFloorType,
              (v) {
                setState(() => _showroomFloorType = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _showroomMarketName,
                    'Market Name (Optional)',
                    'Market name',
                    Icons.storefront_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _showroomLocality,
                    'Locality (Optional)',
                    'Area/locality',
                    Icons.location_on_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _showroomOwnerName,
                    'Owner Name (Optional)',
                    'Name',
                    Icons.person_outline,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _showroomOwnerMobile,
                    'Owner Mobile (Optional)',
                    'Mobile number',
                    Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
          ],
          if (_commercialType == 'warehouse') ...[
            _buildChoiceChipRow(
              'Type',
              _PropertyCreateScreenState._warehouseTypes,
              _warehouseType,
              (v) {
                setState(() => _warehouseType = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _warehousePlotArea,
              keyboardType: TextInputType.number,
              onChanged: (_) => _scheduleSaveDraft(),
              decoration: InputDecoration(
                labelText: 'Plot Area',
                hintText: 'Area',
                prefixIcon: const Icon(Icons.terrain, size: 18),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _warehousePlotAreaUnit,
                      isDense: true,
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      items: _PropertyCreateScreenState._areaUnits
                          .where((u) => u != 'acre')
                          .map(
                            (u) => DropdownMenuItem<String>(
                              value: u,
                              child: Text(
                                toTitleCase(u),
                                style: const TextStyle(color: AppColors.dark),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(
                          () => _warehousePlotAreaUnit =
                              v ?? _warehousePlotAreaUnit,
                        );
                        _scheduleSaveDraft();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _warehouseCeilingHeight,
                    'Ceiling Height (ft)',
                    'e.g., 20',
                    Icons.height,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _warehouseLoadingBays,
                    'Loading Bays',
                    'e.g., 2',
                    Icons.local_shipping_outlined,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _warehouseDockLevelers,
                    'Dock Levelers',
                    'e.g., 1',
                    Icons.format_line_spacing,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _warehousePowerSupply,
                    'Power Supply (Optional)',
                    'e.g., 100 KVA',
                    Icons.power_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Industrial License',
              const ['yes', 'no'],
              _warehouseIndustrialLicense == null
                  ? ''
                  : (_warehouseIndustrialLicense! ? 'yes' : 'no'),
              (v) {
                setState(() => _warehouseIndustrialLicense = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Truck Access',
              _PropertyCreateScreenState._truckAccessTypes,
              _warehouseTruckAccess,
              (v) {
                setState(() => _warehouseTruckAccess = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _warehouseAreaName,
                    'Industrial Area (Optional)',
                    'Area name',
                    Icons.location_city_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _warehouseCity,
                    'City (Optional)',
                    'City',
                    Icons.location_on_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
          ],
          if (_commercialType == 'industrial_shed') ...[
            _buildSectionLabel('Area Details'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _shedCarpetArea,
                    'Carpet Area (sqft)',
                    'e.g., 5000',
                    Icons.crop_square,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _shedBuiltUpArea,
                    'Built-up Area (sqft)',
                    'e.g., 6000',
                    Icons.crop_square,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _shedSuperBuiltUpArea,
                    'Super Built-up (sqft)',
                    'e.g., 7000',
                    Icons.crop_square,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _shedPlotArea,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                    decoration: InputDecoration(
                      labelText: 'Plot Area',
                      hintText: 'e.g., 10000',
                      prefixIcon: const Icon(Icons.terrain, size: 18),
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _shedAreaUnit,
                            isDense: true,
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.black,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                            ),
                            items: _PropertyCreateScreenState._areaUnits
                                .map(
                                  (u) => DropdownMenuItem<String>(
                                    value: u,
                                    child: Text(
                                      toTitleCase(u),
                                      style: const TextStyle(color: AppColors.dark),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              setState(() => _shedAreaUnit = v ?? _shedAreaUnit);
                              _scheduleSaveDraft();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Property Details'),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Ownership Type',
              const ['freehold', 'leasehold', 'co-operative_society', 'power_of_attorney'],
              _shedOwnership,
              (v) {
                setState(() => _shedOwnership = v);
                _scheduleSaveDraft();
              },
              displayFor: (v) {
                switch (v) {
                  case 'freehold':
                    return 'Freehold';
                  case 'leasehold':
                    return 'Leasehold';
                  case 'co-operative_society':
                    return 'Co-operative Society';
                  case 'power_of_attorney':
                    return 'Power of Attorney';
                  default:
                    return v;
                }
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Property Age',
              _PropertyCreateScreenState._readyTimeframes,
              _shedPropertyAge,
              (v) {
                setState(() => _shedPropertyAge = v);
                _scheduleSaveDraft();
              },
              displayFor: (v) {
                switch (v) {
                  case '0_1':
                    return '0-1 year';
                  case '1_5':
                    return '1-5 years';
                  case '5_10':
                    return '5-10 years';
                  case '10_plus':
                    return '10+ years';
                  default:
                    return v.replaceAll('_', ' ');
                }
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Facing',
              _PropertyCreateScreenState._facings,
              _shedFacing,
              (v) {
                setState(() => _shedFacing = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _shedCeilingHeight,
                    'Ceiling Height (ft)',
                    'e.g., 25',
                    Icons.height,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _shedFloorLoadCapacity,
                    'Floor Load Capacity (tons/sqm)',
                    'e.g., 5',
                    Icons.fitness_center,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Infrastructure & Utilities'),
            const SizedBox(height: 12),
            _buildTextField(
              _shedPowerLoad,
              'Power Load (KW)',
              'e.g., 50',
              Icons.bolt,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Three Phase Electricity',
              const ['yes', 'no'],
              _shedThreePhaseElectricity == null ? '' : (_shedThreePhaseElectricity! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedThreePhaseElectricity = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Water Connection',
              const ['yes', 'no'],
              _shedWaterConnection == null ? '' : (_shedWaterConnection! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedWaterConnection = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Borewell Available',
              const ['yes', 'no'],
              _shedBorewellAvailable == null ? '' : (_shedBorewellAvailable! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedBorewellAvailable = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Industrial Operations'),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Loading Bay',
              const ['yes', 'no'],
              _shedLoadingBay == null ? '' : (_shedLoadingBay! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedLoadingBay = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Dock Leveler',
              const ['yes', 'no'],
              _shedDockLeveler == null ? '' : (_shedDockLeveler! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedDockLeveler = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Truck Access',
              _PropertyCreateScreenState._shedTruckAccessOptions,
              _shedTruckAccess,
              (v) {
                setState(() => _shedTruckAccess = v);
                _scheduleSaveDraft();
              },
              displayFor: (v) {
                switch (v) {
                  case 'heavy_vehicle':
                    return 'Heavy Vehicle';
                  case 'medium_vehicle':
                    return 'Medium Vehicle';
                  case 'small_vehicle':
                    return 'Small Vehicle';
                  default:
                    return v;
                }
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Container Access',
              const ['yes', 'no'],
              _shedContainerAccess == null ? '' : (_shedContainerAccess! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedContainerAccess = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Amenities & Facilities'),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Parking Available',
              const ['yes', 'no'],
              _shedParkingAvailable == null ? '' : (_shedParkingAvailable! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedParkingAvailable = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Visitor Parking',
              const ['yes', 'no'],
              _shedVisitorParking == null ? '' : (_shedVisitorParking! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedVisitorParking = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Security Cabin',
              const ['yes', 'no'],
              _shedSecurityCabin == null ? '' : (_shedSecurityCabin! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedSecurityCabin = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Boundary Wall',
              const ['yes', 'no'],
              _shedBoundaryWall == null ? '' : (_shedBoundaryWall! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedBoundaryWall = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'CCTV Surveillance',
              const ['yes', 'no'],
              _shedCctvSurveillance == null ? '' : (_shedCctvSurveillance! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedCctvSurveillance = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Office Space Available',
              const ['yes', 'no'],
              _shedOfficeSpaceAvailable == null ? '' : (_shedOfficeSpaceAvailable! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedOfficeSpaceAvailable = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Pantry',
              const ['yes', 'no'],
              _shedPantry == null ? '' : (_shedPantry! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedPantry = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Washrooms',
              const ['yes', 'no'],
              _shedWashrooms == null ? '' : (_shedWashrooms! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedWashrooms = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Labour Accommodation',
              const ['yes', 'no'],
              _shedLabourAccommodation == null ? '' : (_shedLabourAccommodation! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedLabourAccommodation = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Location Characteristics'),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Main Road Facing',
              const ['yes', 'no'],
              _shedMainRoadFacing == null ? '' : (_shedMainRoadFacing! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedMainRoadFacing = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Corner Property',
              const ['yes', 'no'],
              _shedCornerProperty == null ? '' : (_shedCornerProperty! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedCornerProperty = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Gated Industrial Estate',
              const ['yes', 'no'],
              _shedGatedIndustrialEstate == null ? '' : (_shedGatedIndustrialEstate! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedGatedIndustrialEstate = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Legal & Compliance'),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Industrial License',
              const ['yes', 'no'],
              _shedIndustrialLicense == null ? '' : (_shedIndustrialLicense! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedIndustrialLicense = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Factory License',
              const ['yes', 'no'],
              _shedFactoryLicense == null ? '' : (_shedFactoryLicense! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedFactoryLicense = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Fire NOC',
              const ['yes', 'no'],
              _shedFireNoc == null ? '' : (_shedFireNoc! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedFireNoc = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Pollution Clearance',
              const ['yes', 'no'],
              _shedPollutionClearance == null ? '' : (_shedPollutionClearance! ? 'yes' : 'no'),
              (v) {
                setState(() => _shedPollutionClearance = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Transaction Details'),
            const SizedBox(height: 12),
            if (isSale) ...[
              _buildTextField(
                _shedBookingAmount,
                'Booking Amount (Optional)',
                'e.g., 100000',
                Icons.currency_rupee,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _shedMaintenanceCharges,
                'Maintenance Charges (Monthly)',
                'e.g., 5000',
                Icons.handyman_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Price Negotiable',
                const ['yes', 'no'],
                _shedPriceNegotiable == null ? '' : (_shedPriceNegotiable! ? 'yes' : 'no'),
                (v) {
                  setState(() => _shedPriceNegotiable = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Possession Status',
                const ['ready_to_move', 'under_construction'],
                _shedPossessionStatus,
                (v) {
                  setState(() => _shedPossessionStatus = v);
                  _scheduleSaveDraft();
                },
                displayFor: (v) {
                  switch (v) {
                    case 'ready_to_move':
                      return 'Ready to Move';
                    case 'under_construction':
                      return 'Under Construction';
                    default:
                      return v;
                  }
                },
              ),
            ],
            if (isRentLease) ...[
              _buildTextField(
                _shedSecurityDeposit,
                'Security Deposit',
                'e.g., 300000',
                Icons.payments,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _shedMaintenanceCharges,
                'Maintenance Charges (Monthly)',
                'e.g., 5000',
                Icons.handyman_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _shedBrokerage,
                'Brokerage Charges (Optional)',
                'e.g., 50000',
                Icons.badge_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _shedAvailableFrom,
                'Available From (Optional)',
                'YYYY-MM-DD',
                Icons.event_available_outlined,
                readOnly: true,
                onTap: () => _pickDateForController(_shedAvailableFrom),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      _shedLockInMonths,
                      'Lock-in Period (Months)',
                      'e.g., 12',
                      Icons.lock_clock,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      _shedNoticePeriodValue,
                      'Notice Period (Months)',
                      'e.g., 3',
                      Icons.campaign,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_propertyKind == _CreatePropertyKind.rent) ...[
                _buildChoiceChipRow(
                  'Rent Negotiable',
                  const ['yes', 'no'],
                  _shedRentNegotiable == null ? '' : (_shedRentNegotiable! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _shedRentNegotiable = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
              ],
              if (_propertyKind == _CreatePropertyKind.lease) ...[
                _buildTextField(
                  _shedLeaseDuration,
                  'Lease Duration (Years)',
                  'e.g., 5',
                  Icons.assignment,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Escalation Clause',
                  const ['yes', 'no'],
                  _shedEscalationClause == null ? '' : (_shedEscalationClause! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _shedEscalationClause = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Renewal Option',
                  const ['yes', 'no'],
                  _shedRenewalOption == null ? '' : (_shedRenewalOption! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _shedRenewalOption = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
              ],
            ],
            const SizedBox(height: 12),
          ],
          if (_commercialType == 'shop') ...[
            _buildChoiceChipRow(
              'Shop Type',
              _PropertyCreateScreenState._shopTypes,
              _shopType,
              (v) {
                setState(() => _shopType = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _shopArea,
              keyboardType: TextInputType.number,
              onChanged: (_) => _scheduleSaveDraft(),
              decoration: InputDecoration(
                labelText: 'Shop Area',
                hintText: 'Area',
                prefixIcon: const Icon(Icons.crop_square, size: 18),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _shopAreaUnit,
                      isDense: true,
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      items: _PropertyCreateScreenState._areaUnits
                          .map(
                            (u) => DropdownMenuItem<String>(
                              value: u,
                              child: Text(
                                toTitleCase(u),
                                style: const TextStyle(color: AppColors.dark),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() => _shopAreaUnit = v ?? _shopAreaUnit);
                        _scheduleSaveDraft();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _frontageWidth,
                    'Frontage Width (ft)',
                    'e.g., 20',
                    Icons.straighten,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _ceilingHeight,
                    'Ceiling Height (ft)',
                    'e.g., 12',
                    Icons.height,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Main Road Facing',
              const ['yes', 'no'],
              _mainRoadFacing == null ? '' : (_mainRoadFacing! ? 'yes' : 'no'),
              (v) {
                setState(() => _mainRoadFacing = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Corner Shop',
              const ['yes', 'no'],
              _cornerShop == null ? '' : (_cornerShop! ? 'yes' : 'no'),
              (v) {
                setState(() => _cornerShop = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Washroom Available',
              const ['yes', 'no'],
              _washroomAvailable == null
                  ? ''
                  : (_washroomAvailable! ? 'yes' : 'no'),
              (v) {
                setState(() => _washroomAvailable = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Floor Type',
              _PropertyCreateScreenState._floorTypes,
              _floorType,
              (v) {
                setState(() => _floorType = v);
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _marketName,
                    'Market Name (Optional)',
                    'e.g., Main Bazaar',
                    Icons.storefront_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _locality,
                    'Locality (Optional)',
                    'Area/locality',
                    Icons.location_on_outlined,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
          ],
        ],
        if (isResidential) ...[
          if (_isSellResidentialFarmhouse) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Farmhouse Details',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _farmLandArea,
                    'Land Area',
                    'Area in sqft',
                    Icons.terrain,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _farmBuiltUpArea,
                    'Built-up Area',
                    'Area in sqft',
                    Icons.crop_square,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Utilities',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                spacing: 8,
                runSpacing: 8,
                children: _PropertyCreateScreenState._farmUtilitiesOptions.map((
                  u,
                ) {
                  final selected = _farmUtilities.contains(u);
                  final label = switch (u) {
                    'water_source' => 'Water Source',
                    'borewell' => 'Borewell',
                    'road_access' => 'Road Access',
                    _ => 'Fencing',
                  };
                  return FilterChip(
                    selected: selected,
                    showCheckmark: false,
                    selectedColor: AppTheme.gold,
                    label: Text(label),
                    labelStyle: TextStyle(
                      color: AppColors.dark,
                      fontWeight: FontWeight.w700,
                    ),
                    onSelected: (v) {
                      setState(() {
                        v ? _farmUtilities.add(u) : _farmUtilities.remove(u);
                      });
                      _scheduleSaveDraft();
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            _buildIntDropdownField(
              label: 'Number of Rooms',
              controller: _farmRooms,
              min: 0,
              max: 30,
              hint: 'Select rooms',
              icon: Icons.bed_outlined,
            ),
            const SizedBox(height: 12),
            _buildIntDropdownField(
              label: 'Number of Washrooms',
              controller: _washrooms,
              min: 0,
              max: 20,
              hint: 'Select washrooms',
              icon: Icons.wc_outlined,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _floor,
                    'Floor No. (Optional)',
                    'e.g., 1',
                    Icons.apartment_outlined,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _totalFloors,
                    'Total Floors (Optional)',
                    'e.g., 2',
                    Icons.layers_outlined,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _scheduleSaveDraft(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Balconies',
              const ['0', '1', '2', '3', '4', '5+'],
              _balconies >= 5 ? '5+' : _balconies.toString(),
              (v) {
                setState(() {
                  _balconies = v == '5+' ? 5 : int.parse(v);
                });
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Garden',
              const ['yes', 'no'],
              _farmGarden == null ? '' : (_farmGarden! ? 'yes' : 'no'),
              (v) {
                setState(() => _farmGarden = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Swimming Pool',
              const ['yes', 'no'],
              _farmSwimmingPool == null
                  ? ''
                  : (_farmSwimmingPool! ? 'yes' : 'no'),
              (v) {
                setState(() => _farmSwimmingPool = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
          ],

          if (!_isSellResidentialFarmhouse) ...[
            if (_isSellResidentialDuplex) ...[
              // Duplex plot details removed.
              _buildChoiceChipRow(
                'Construction Allowed',
                const ['yes', 'no'],
                _duplexConstructionAllowed == null
                    ? ''
                    : (_duplexConstructionAllowed! ? 'yes' : 'no'),
                (v) {
                  setState(() => _duplexConstructionAllowed = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Water Connection',
                const ['available', 'not_available'],
                _duplexWaterConnection == null
                    ? ''
                    : (_duplexWaterConnection! ? 'available' : 'not_available'),
                (v) {
                  setState(() => _duplexWaterConnection = v == 'available');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Electricity Connection',
                const ['available', 'not_available'],
                _duplexElectricityConnection == null
                    ? ''
                    : (_duplexElectricityConnection!
                          ? 'available'
                          : 'not_available'),
                (v) {
                  setState(
                    () => _duplexElectricityConnection = v == 'available',
                  );
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Road Access',
                const ['yes', 'no'],
                _duplexRoadAccess == null
                    ? ''
                    : (_duplexRoadAccess! ? 'yes' : 'no'),
                (v) {
                  setState(() => _duplexRoadAccess = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),

              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nearby Facilities',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _PropertyCreateScreenState._nearbyFacilitiesOptions
                      .map((f) {
                        final selected = _duplexNearbyFacilities.contains(f);
                        final label = switch (f) {
                          'metro' => 'Metro',
                          'bus_stop' => 'Bus Stop',
                          'market' => 'Market',
                          'school' => 'School',
                          'hospital' => 'Hospital',
                          'park' => 'Park',
                          'mall' => 'Mall',
                          _ => 'Highway',
                        };
                        return FilterChip(
                          selected: selected,
                          showCheckmark: false,
                          selectedColor: AppTheme.gold,
                          label: Text(label),
                          labelStyle: TextStyle(
                            color: AppColors.dark,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (v) {
                            setState(() {
                              v
                                  ? _duplexNearbyFacilities.add(f)
                                  : _duplexNearbyFacilities.remove(f);
                            });
                            _scheduleSaveDraft();
                          },
                        );
                      })
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],

            if (!_isSellResidentialDuplex) ...[
              if (_isRentLeaseResidentialStudioApartment) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Studio Apartment: Bedrooms=1 and Bathrooms=1 (fixed).',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 12),
              ] else ...[
                _buildChoiceChipRow(
                  'BHK',
                  const ['1', '2', '3', '4', '5', '6+'],
                  _bedrooms >= 6 ? '6+' : _bedrooms.toString(),
                  (v) {
                    setState(() {
                      _bedrooms = v == '6+' ? 6 : int.parse(v);
                    });
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Bathrooms',
                  const ['1', '2', '3', '4', '5', '6+'],
                  _bathrooms >= 6 ? '6+' : _bathrooms.toString(),
                  (v) {
                    setState(() {
                      _bathrooms = v == '6+' ? 6 : int.parse(v);
                    });
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Balconies',
                  const ['0', '1', '2', '3', '4', '5+'],
                  _balconies >= 5 ? '5+' : _balconies.toString(),
                  (v) {
                    setState(() {
                      _balconies = v == '5+' ? 5 : int.parse(v);
                    });
                    _scheduleSaveDraft();
                  },
                ),
              ],
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _buildStepper(
                      'Parking',
                      _parking,
                      0,
                      5,
                      (v) => setState(() => _parking = v),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCompactNumberField(
                      label: 'Total Floors',
                      controller: _totalFloors,
                      hint: 'Building floors',
                      icon: Icons.business,
                      onChanged: (_) => _handleTotalFloorsChanged(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildFloorNumberField(),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Furnishing',
                _PropertyCreateScreenState._furnishings,
                _furnishing,
                (v) => setState(() => _furnishing = v),
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Facing',
                _PropertyCreateScreenState._facings,
                _facing,
                (v) => setState(() => _facing = v),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _carpetArea,
                'Carpet Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _builtUpArea,
                'Built-up Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _superBuiltUpArea,
                'Super Built-up Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              // Villa plot area removed from here (handled elsewhere if needed).
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Availability',
                _PropertyCreateScreenState._availabilityTypes,
                _availability,
                (v) => setState(() => _availability = v),
              ),
              if (_availability == 'ready_to_move' ||
                  _availability == 'immediate') ...[
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Property Age',
                  _PropertyCreateScreenState._readyTimeframes,
                  _readyTimeframe,
                  (v) => setState(() => _readyTimeframe = v),
                  displayFor: (v) {
                    switch (v) {
                      case '0_1':
                        return '0-1 year';
                      case '1_5':
                        return '1-5 years';
                      case '5_10':
                        return '5-10 years';
                      case '10_plus':
                        return '10+ years';
                      default:
                        return v.replaceAll('_', ' ');
                    }
                  },
                ),
              ] else ...[
                const SizedBox(height: 12),
                _buildTextField(
                  _possessionBy,
                  'Possession By',
                  'YYYY-MM-DD',
                  Icons.event,
                  readOnly: true,
                  onTap: () => _pickDateForController(_possessionBy),
                ),
              ],
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Ownership',
                _PropertyCreateScreenState._ownershipTypes,
                _ownership,
                (v) => setState(() => _ownership = v),
              ),

              if (_isSellResidentialApartment) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Apartment Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional Rooms',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _PropertyCreateScreenState
                        ._apartmentAdditionalRooms
                        .map((r) {
                          final selected = _additionalRooms.contains(r);
                          final label = toTitleCase(r);
                          return FilterChip(
                            selected: selected,
                            showCheckmark: false,
                            label: Text(
                              label,
                              style: TextStyle(color: AppColors.dark),
                            ),
                            selectedColor: AppTheme.gold,
                            labelStyle: TextStyle(
                              color: selected
                                  ? const Color(0xFF070B14)
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            onSelected: (v) {
                              setState(() {
                                v
                                    ? _additionalRooms.add(r)
                                    : _additionalRooms.remove(r);
                              });
                              _scheduleSaveDraft();
                            },
                          );
                        })
                        .toList(),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Corner Property',
                  const ['yes', 'no'],
                  _cornerProperty == null
                      ? ''
                      : (_cornerProperty! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _cornerProperty = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 12),
                _buildSectionLabel('Near by'),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _PropertyCreateScreenState._apartmentHighlights
                        .map(
                          (h) => _simpleFilterChip(
                            label: toTitleCase(h),
                            selected: _propertyHighlights.contains(h),
                            onSelected: (s) {
                              setState(() {
                                if (s) {
                                  _propertyHighlights.add(h);
                                } else {
                                  _propertyHighlights.remove(h);
                                }
                              });
                              _scheduleSaveDraft();
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],

              if (_isRentLeaseResidentialApartment) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyKind == _CreatePropertyKind.lease
                        ? 'Lease Apartment Details'
                        : 'Rent Apartment Details',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional Rooms',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _PropertyCreateScreenState._roomOptions.map((r) {
                    final selected = _rentAdditionalRooms.contains(r);
                    final label = toTitleCase(r);
                    return FilterChip(
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppTheme.gold,
                      label: Text(
                        label,
                        style: TextStyle(color: AppColors.dark),
                      ),
                      labelStyle: TextStyle(
                        color: selected
                            ? const Color(0xFF070B14)
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (v) {
                        setState(() {
                          v
                              ? _rentAdditionalRooms.add(r)
                              : _rentAdditionalRooms.remove(r);
                        });
                        _scheduleSaveDraft();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Furnishing Status',
                  _PropertyCreateScreenState._furnishings,
                  _furnishing,
                  (v) {
                    setState(() => _furnishing = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Corner Property',
                  const ['yes', 'no'],
                  _rentCornerProperty == null
                      ? ''
                      : (_rentCornerProperty! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _rentCornerProperty = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Pet Friendly',
                  const ['yes', 'no'],
                  _petFriendly == null ? null : (_petFriendly! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _petFriendly = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Wheelchair Friendly',
                  const ['yes', 'no'],
                  _wheelchairFriendly == null
                      ? null
                      : (_wheelchairFriendly! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _wheelchairFriendly = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Gated Society',
                  const ['yes', 'no'],
                  _rentGatedSociety == null
                      ? ''
                      : (_rentGatedSociety! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _rentGatedSociety = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildSectionLabel('Near by'),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _PropertyCreateScreenState._apartmentHighlights
                        .map(
                          (h) => _simpleFilterChip(
                            label: toTitleCase(h),
                            selected: _propertyHighlights.contains(h),
                            onSelected: (s) {
                              setState(() {
                                if (s) {
                                  _propertyHighlights.add(h);
                                } else {
                                  _propertyHighlights.remove(h);
                                }
                              });
                              _scheduleSaveDraft();
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _availableFrom,
                  readOnly: true,
                  onTap: _pickAvailableFrom,
                  decoration: const InputDecoration(
                    labelText: 'Available From',
                    hintText: 'Select date',
                    prefixIcon: Icon(Icons.calendar_month_outlined, size: 18),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildIntDropdownField(
                        label: 'Lease Duration (Months)',
                        controller: _leaseDurationMonths,
                        min: 1,
                        max: 60,
                        hint: 'Select months',
                        icon: Icons.timelapse_outlined,
                        allowEmpty: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildIntDropdownField(
                        label: 'Lock-in (Months)',
                        controller: _lockInMonths,
                        min: 0,
                        max: 36,
                        hint: 'Select months',
                        icon: Icons.lock_clock_outlined,
                        allowEmpty: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildIntDropdownField(
                        label: 'Notice Period',
                        controller: _noticePeriodValue,
                        min: 0,
                        max: 180,
                        hint: 'Select',
                        icon: Icons.notifications_active_outlined,
                        allowEmpty: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Unit',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value:
                                _PropertyCreateScreenState._noticeUnits
                                    .contains(_noticePeriodUnit)
                                ? _noticePeriodUnit
                                : _PropertyCreateScreenState._noticeUnits.first,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              hintText: 'Select unit',
                              prefixIcon: Icon(
                                Icons.straighten_outlined,
                                size: 18,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.white,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                            items: _PropertyCreateScreenState._noticeUnits
                                .map(
                                  (u) => DropdownMenuItem<String>(
                                    value: u,
                                    child: Text(
                                      toTitleCase(u),
                                      style: const TextStyle(
                                        color: AppColors.dark,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              setState(() => _noticePeriodUnit = v ?? 'days');
                              _scheduleSaveDraft();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Preferred Tenant',
                  _PropertyCreateScreenState._preferredTenants,
                  _preferredTenant,
                  (v) {
                    setState(() => _preferredTenant = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Food Preference',
                  _PropertyCreateScreenState._foodPreferences,
                  _foodPreference,
                  (v) {
                    setState(() => _foodPreference = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Promotion Type',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _PropertyCreateScreenState._rentPromotionOptions
                      .map((p) {
                        final selected = _rentPromotionTypes.contains(p);
                        final label = toTitleCase(p);
                        return FilterChip(
                          selected: selected,
                          showCheckmark: false,
                          selectedColor: AppTheme.gold,
                          label: Text(
                            label,
                            style: TextStyle(color: AppColors.dark),
                          ),
                          labelStyle: TextStyle(
                            color: selected
                                ? const Color(0xFF070B14)
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (v) {
                            setState(() {
                              v
                                  ? _rentPromotionTypes.add(p)
                                  : _rentPromotionTypes.remove(p);
                            });
                            _scheduleSaveDraft();
                          },
                        );
                      })
                      .toList(),
                ),
              ],

              if (_isRentLeaseResidentialVillaHouse) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyKind == _CreatePropertyKind.lease
                        ? 'Lease $_rentLeaseHouseVillaTitle'
                        : 'Rent $_rentLeaseHouseVillaTitle',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  _plotArea,
                  'Plot Area (Optional)',
                  'Area in sqft',
                  Icons.terrain,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _scheduleSaveDraft(),
                ),
                const SizedBox(height: 12),
                _buildStepper('Parking Spots', _parking, 0, 10, (v) {
                  setState(() => _parking = v);
                  _scheduleSaveDraft();
                }),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Outdoors',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _PropertyCreateScreenState._villaOutdoorsOptions
                      .map((o) {
                        final selected = _rentVillaOutdoors.contains(o);
                        final label = toTitleCase(o);
                        return FilterChip(
                          selected: selected,
                          showCheckmark: false,
                          selectedColor: AppTheme.gold,
                          label: Text(
                            label,
                            style: TextStyle(color: AppColors.dark),
                          ),
                          labelStyle: TextStyle(
                            color: selected
                                ? const Color(0xFF070B14)
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (v) {
                            setState(() {
                              v
                                  ? _rentVillaOutdoors.add(o)
                                  : _rentVillaOutdoors.remove(o);
                            });
                            _scheduleSaveDraft();
                          },
                        );
                      })
                      .toList(),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Water Source',
                  _PropertyCreateScreenState._waterSourceOptions,
                  _rentVillaWaterSource,
                  (v) {
                    setState(() => _rentVillaWaterSource = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Solar Power',
                  const ['yes', 'no'],
                  _rentSolarPower ? 'yes' : 'no',
                  (v) {
                    setState(() => _rentSolarPower = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Independent Entry',
                  const ['yes', 'no'],
                  _rentIndependentEntry ? 'yes' : 'no',
                  (v) {
                    setState(() => _rentIndependentEntry = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
              ],

              if (_isRentLeaseResidentialBuilderFloor) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyKind == _CreatePropertyKind.lease
                        ? 'Lease Builder Floor Details'
                        : 'Rent Builder Floor Details',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Lift',
                  const ['available', 'not_available'],
                  _rentLiftAvailable ? 'available' : 'not_available',
                  (v) {
                    setState(() => _rentLiftAvailable = v == 'available');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Gated Society',
                  const ['yes', 'no'],
                  _rentGatedSociety == null
                      ? ''
                      : (_rentGatedSociety! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _rentGatedSociety = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  _societyName,
                  'Society Name (Optional)',
                  'e.g., Green Heights',
                  Icons.apartment_outlined,
                  onChanged: (_) => _scheduleSaveDraft(),
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tenant Preference',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _PropertyCreateScreenState._tenantTypeOptions.map((
                    t,
                  ) {
                    final selected = _rentTenantTypes.contains(t);
                    final label = toTitleCase(t);
                    return FilterChip(
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppTheme.gold,
                      label: Text(
                        label,
                        style: TextStyle(color: AppColors.dark),
                      ),
                      labelStyle: TextStyle(
                        color: selected
                            ? const Color(0xFF070B14)
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (v) {
                        setState(() {
                          v
                              ? _rentTenantTypes.add(t)
                              : _rentTenantTypes.remove(t);
                        });
                        _scheduleSaveDraft();
                      },
                    );
                  }).toList(),
                ),
              ],

              if (_isRentLeaseResidentialStudioApartment) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyKind == _CreatePropertyKind.lease
                        ? 'Lease Studio Details'
                        : 'Rent Studio Details',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Room Type',
                  const ['1rk', 'studio'],
                  _studioConfig,
                  (v) {
                    setState(() => _studioConfig = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Kitchen Type',
                  _PropertyCreateScreenState._kitchenTypes,
                  _kitchenType,
                  (v) {
                    setState(() => _kitchenType = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tenant Preference',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _PropertyCreateScreenState._studioTenantOptions.map(
                    (t) {
                      final selected = _studioTenantPrefs.contains(t);
                      final label = toTitleCase(t);
                      return FilterChip(
                        selected: selected,
                        showCheckmark: false,
                        selectedColor: AppTheme.gold,
                        label: Text(
                          label,
                          style: TextStyle(color: AppColors.dark),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? const Color(0xFF070B14)
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (v) {
                          setState(() {
                            v
                                ? _studioTenantPrefs.add(t)
                                : _studioTenantPrefs.remove(t);
                          });
                          _scheduleSaveDraft();
                        },
                      );
                    },
                  ).toList(),
                ),
              ],

              if (_isRentLeaseResidentialFarmhouse) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyKind == _CreatePropertyKind.lease
                        ? 'Lease Farmhouse Details'
                        : 'Rent Farmhouse Details',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _rentFarmLandArea,
                        'Land Area (Optional)',
                        'Area in sqft',
                        Icons.terrain,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _scheduleSaveDraft(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        _rentFarmRooms,
                        'Rooms (Optional)',
                        'e.g., 3',
                        Icons.meeting_room_outlined,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _scheduleSaveDraft(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Swimming Pool',
                  const ['yes', 'no'],
                  _rentFarmPool ? 'yes' : 'no',
                  (v) {
                    setState(() => _rentFarmPool = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Fencing',
                  const ['yes', 'no'],
                  _rentFarmFencing ? 'yes' : 'no',
                  (v) {
                    setState(() => _rentFarmFencing = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Event Options',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _PropertyCreateScreenState._farmUseCaseOptions.map((
                    u,
                  ) {
                    final selected = _rentFarmUseCases.contains(u);
                    final label = toTitleCase(u);
                    return FilterChip(
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppTheme.gold,
                      label: Text(
                        label,
                        style: TextStyle(color: AppColors.dark),
                      ),
                      labelStyle: TextStyle(
                        color: selected
                            ? const Color(0xFF070B14)
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (v) {
                        setState(() {
                          v
                              ? _rentFarmUseCases.add(u)
                              : _rentFarmUseCases.remove(u);
                        });
                        _scheduleSaveDraft();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _farmMonthlyCharges,
                        'Monthly Charges (Optional)',
                        'e.g., 50000',
                        Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _scheduleSaveDraft(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        _farmDailyCharges,
                        'Daily Charges (Optional)',
                        'e.g., 5000',
                        Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _scheduleSaveDraft(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _farmEventCharges,
                        'Event Charges (Optional)',
                        'e.g., 20000',
                        Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _scheduleSaveDraft(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildIntDropdownField(
                        label: 'Min Stay (Days)',
                        controller: _minStayDays,
                        min: 1,
                        max: 60,
                        hint: 'Select days',
                        icon: Icons.timelapse_outlined,
                        allowEmpty: false,
                      ),
                    ),
                  ],
                ),
              ],

              if (_isRentLeaseResidentialDuplex) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyKind == _CreatePropertyKind.lease
                        ? 'Lease Duplex Details'
                        : 'Rent Duplex Details',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  _plotArea,
                  'Plot Area (Optional)',
                  'Area in sqft',
                  Icons.terrain,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _scheduleSaveDraft(),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Gated Society',
                  const ['yes', 'no'],
                  _rentGatedSociety == null
                      ? ''
                      : (_rentGatedSociety! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _rentGatedSociety = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Water Source',
                  _PropertyCreateScreenState._waterSourceOptions,
                  _rentVillaWaterSource,
                  (v) {
                    setState(() => _rentVillaWaterSource = v);
                    _scheduleSaveDraft();
                  },
                ),
              ],

              if (_isSellResidentialVillaHouse) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Villa / Independent House Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional Rooms',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _PropertyCreateScreenState
                        ._apartmentAdditionalRooms
                        .map((r) {
                          final selected = _villaAdditionalRooms.contains(r);
                          final label = toTitleCase(r);
                          return FilterChip(
                            selected: selected,
                            showCheckmark: false,
                            selectedColor: AppTheme.gold,
                            label: Text(
                              label,
                              style: TextStyle(color: AppColors.dark),
                            ),
                            labelStyle: TextStyle(
                              color: selected
                                  ? const Color(0xFF070B14)
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            onSelected: (v) {
                              setState(() {
                                v
                                    ? _villaAdditionalRooms.add(r)
                                    : _villaAdditionalRooms.remove(r);
                              });
                              _scheduleSaveDraft();
                            },
                          );
                        })
                        .toList(),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Corner Property',
                  const ['yes', 'no'],
                  _villaCornerProperty == null
                      ? ''
                      : (_villaCornerProperty! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _villaCornerProperty = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Parking',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _PropertyCreateScreenState._villaParkingOptions
                        .map((p) {
                          final selected = _villaParking.contains(p);
                          final label = p == 'open'
                              ? 'Open Parking'
                              : 'Covered Parking';
                          return FilterChip(
                            selected: selected,
                            showCheckmark: false,
                            selectedColor: AppTheme.gold,
                            label: Text(
                              label,
                              style: TextStyle(color: AppColors.dark),
                            ),
                            labelStyle: TextStyle(
                              color: selected
                                  ? const Color(0xFF070B14)
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            onSelected: (v) {
                              setState(() {
                                if (v) {
                                  _villaParking
                                    ..clear()
                                    ..add(p);
                                } else {
                                  _villaParking.remove(p);
                                }
                              });
                              _scheduleSaveDraft();
                            },
                          );
                        })
                        .toList(),
                  ),
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Outdoors',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _PropertyCreateScreenState._outdoorsOptions.map((
                      o,
                    ) {
                      final selected = _outdoors.contains(o);
                      final label = switch (o) {
                        'garden_lawn' => 'Garden/Lawn',
                        'terrace' => 'Terrace',
                        _ => 'Boundary Wall',
                      };
                      return FilterChip(
                        selected: selected,
                        showCheckmark: false,
                        selectedColor: AppTheme.gold,
                        label: Text(
                          label,
                          style: TextStyle(color: AppColors.dark),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? const Color(0xFF070B14)
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (v) {
                          setState(() {
                            v ? _outdoors.add(o) : _outdoors.remove(o);
                          });
                          _scheduleSaveDraft();
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Water Source',
                  _PropertyCreateScreenState._waterSourceOptions,
                  _waterSource,
                  (v) {
                    setState(() => _waterSource = v);
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Connections',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _PropertyCreateScreenState._connectionOptions.map(
                      (c) {
                        final selected = _connections.contains(c);
                        final label = switch (c) {
                          'electricity_connection' => 'Electricity Connection',
                          'solar_power' => 'Solar Power',
                          _ => 'Rainwater Harvesting',
                        };
                        return FilterChip(
                          selected: selected,
                          showCheckmark: false,
                          selectedColor: AppTheme.gold,
                          label: Text(
                            label,
                            style: TextStyle(color: AppColors.dark),
                          ),
                          labelStyle: TextStyle(
                            color: selected
                                ? const Color(0xFF070B14)
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (v) {
                            setState(() {
                              v ? _connections.add(c) : _connections.remove(c);
                            });
                            _scheduleSaveDraft();
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),

                const SizedBox(height: 12),
                // Booking/Maintenance moved to Pricing & Area.
              ],

              if (_isSellResidentialBuilderFloor) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Builder Floor Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Corner Property',
                  const ['yes', 'no'],
                  _builderCornerProperty == null
                      ? ''
                      : (_builderCornerProperty! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _builderCornerProperty = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Gated Society',
                  const ['yes', 'no'],
                  _builderGatedSociety == null
                      ? ''
                      : (_builderGatedSociety! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _builderGatedSociety = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _plotArea,
                        'Plot Area (Optional)',
                        'Area in sqft',
                        Icons.terrain,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _breadth,
                        'Width (ft)',
                        'e.g., 40',
                        Icons.straighten,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        _length,
                        'Length (ft)',
                        'e.g., 60',
                        Icons.straighten,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildStepper(
                  'Open Sides',
                  _openSides,
                  1,
                  4,
                  (v) => setState(() => _openSides = v),
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Boundary Wall',
                  const ['yes', 'no'],
                  _boundaryWall == null ? '' : (_boundaryWall! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _boundaryWall = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                _buildChoiceChipRow(
                  'Construction Allowed',
                  const ['yes', 'no'],
                  _constructionAllowed == null
                      ? ''
                      : (_constructionAllowed! ? 'yes' : 'no'),
                  (v) {
                    setState(() => _constructionAllowed = v == 'yes');
                    _scheduleSaveDraft();
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Utilities',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _PropertyCreateScreenState
                        ._builderUtilitiesOptions
                        .map((u) {
                          final selected = _builderUtilities.contains(u);
                          final label = switch (u) {
                            'water' => 'Water',
                            'electricity' => 'Electricity',
                            'sewerage' => 'Sewerage',
                            _ => 'Road Access',
                          };
                          return FilterChip(
                            selected: selected,
                            showCheckmark: false,
                            selectedColor: AppTheme.gold,
                            label: Text(
                              label,
                              style: TextStyle(color: AppColors.dark),
                            ),
                            labelStyle: TextStyle(
                              color: selected
                                  ? const Color(0xFF070B14)
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            onSelected: (v) {
                              setState(() {
                                v
                                    ? _builderUtilities.add(u)
                                    : _builderUtilities.remove(u);
                              });
                              _scheduleSaveDraft();
                            },
                          );
                        })
                        .toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _pricePerSqft,
                        'Price per Sq.ft (Optional)',
                        'e.g., 9500',
                        Icons.calculate_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
          if (false) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Office Space Details',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_commercialType == 'office') ...[
              _buildChoiceChipRow(
                'Office Type',
                _PropertyCreateScreenState._officeTypes,
                _officeType,
                (v) {
                  setState(() => _officeType = v);
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _floorPlateArea,
                'Office Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildIntDropdownField(
                      label: 'Cabins',
                      controller: _cabins,
                      min: 0,
                      max: 50,
                      hint: 'Select cabins',
                      icon: Icons.meeting_room_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildIntDropdownField(
                      label: 'Meeting Rooms',
                      controller: _meetingRooms,
                      min: 0,
                      max: 30,
                      hint: 'Select rooms',
                      icon: Icons.groups_2_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildIntDropdownField(
                      label: 'Seats',
                      controller: _seats,
                      min: 0,
                      max: 500,
                      hint: 'Select seats',
                      icon: Icons.event_seat_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildIntDropdownField(
                      label: 'Max Seats',
                      controller: _maxSeats,
                      min: 0,
                      max: 500,
                      hint: 'Select max',
                      icon: Icons.event_seat_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildIntDropdownField(
                label: 'Conference Rooms',
                controller: _conferenceRooms,
                min: 0,
                max: 20,
                hint: 'Select rooms',
                icon: Icons.co_present_outlined,
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Lift',
                const ['available', 'not_available'],
                _liftAvailable == null
                    ? null
                    : (_liftAvailable! ? 'available' : 'not_available'),
                (v) => setState(() => _liftAvailable = v == 'available'),
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Reception Area',
                const ['yes', 'no'],
                _receptionArea == null
                    ? null
                    : (_receptionArea! ? 'yes' : 'no'),
                (v) {
                  setState(() => _receptionArea = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Pantry',
                const ['yes', 'no'],
                _pantry == null ? null : (_pantry! ? 'yes' : 'no'),
                (v) {
                  setState(() => _pantry = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildIntDropdownField(
                label: 'Washrooms (Optional)',
                controller: _washrooms,
                min: 0,
                max: 30,
                hint: 'Select washrooms',
                icon: Icons.wc_outlined,
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Cafeteria',
                const ['yes', 'no'],
                _cafeteria == null ? null : (_cafeteria! ? 'yes' : 'no'),
                (v) {
                  setState(() => _cafeteria = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Server Room',
                const ['yes', 'no'],
                _serverRoom == null ? null : (_serverRoom! ? 'yes' : 'no'),
                (v) {
                  setState(() => _serverRoom = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Fire Safety Installed',
                const ['yes', 'no'],
                _fireSafetyInstalled == null
                    ? null
                    : (_fireSafetyInstalled! ? 'yes' : 'no'),
                (v) {
                  setState(() => _fireSafetyInstalled = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Central AC',
                const ['yes', 'no'],
                _centralAC == null ? null : (_centralAC! ? 'yes' : 'no'),
                (v) {
                  setState(() => _centralAC = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Furnishing Status',
                _PropertyCreateScreenState._furnishings,
                _furnishing,
                (v) => setState(() => _furnishing = v),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildCompactNumberField(
                      label: 'Office on Floor',
                      controller: _floor,
                      hint: 'e.g., 5',
                      icon: Icons.stairs_outlined,
                      onChanged: (_) => _scheduleSaveDraft(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildCompactNumberField(
                      label: 'Total Floors',
                      controller: _totalFloors,
                      hint: 'e.g., 20',
                      icon: Icons.business,
                      onChanged: (_) => _handleTotalFloorsChanged(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildIntDropdownField(
                label: 'Number of Lifts (Optional)',
                controller: _numberOfLifts,
                min: 0,
                max: 20,
                hint: 'Select lifts',
                icon: Icons.elevator_outlined,
              ),
              const SizedBox(height: 12),
              _buildStepper(
                'Parking Available (Spots)',
                _parking,
                0,
                50,
                (v) => setState(() => _parking = v),
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Visitor Parking',
                const ['yes', 'no'],
                _visitorParking == null
                    ? null
                    : (_visitorParking! ? 'yes' : 'no'),
                (v) {
                  setState(() => _visitorParking = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Facing',
                _PropertyCreateScreenState._facings,
                _facing,
                (v) => setState(() => _facing = v),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _superBuiltUpArea,
                'Super Built-up Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _builtUpArea,
                'Built-up Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _carpetArea,
                'Carpet Area (Optional)',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Ownership Type',
                _PropertyCreateScreenState._ownershipTypes,
                _ownership,
                (v) => setState(() => _ownership = v),
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Tax Included',
                const ['yes', 'no'],
                _taxIncluded == null ? null : (_taxIncluded! ? 'yes' : 'no'),
                (v) {
                  setState(() => _taxIncluded = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Price Negotiable',
                const ['yes', 'no'],
                _officeNegotiable == null
                    ? ''
                    : (_officeNegotiable! ? 'yes' : 'no'),
                (v) {
                  setState(() => _officeNegotiable = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      _officeMaintenanceCharges,
                      'Maintenance Charges (Optional)',
                      '₹ 3500/month',
                      Icons.payments_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      _officeBookingAmount,
                      'Booking Amount (Optional)',
                      '₹ 2,00,000',
                      Icons.account_balance_wallet_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ] else if (_commercialType == 'warehouse') ...[
              _buildTextField(
                _floorPlateArea,
                'Storage Area',
                'Area in sqft',
                Icons.warehouse_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildIntDropdownField(
                label: 'Washrooms',
                controller: _washrooms,
                min: 0,
                max: 30,
                hint: 'Select washrooms',
                icon: Icons.wc_outlined,
              ),
            ] else ...[
              _buildTextField(
                _floorPlateArea,
                'Area',
                'Area in sqft',
                Icons.crop_square,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _shopFacade,
                'Facade (Optional)',
                'Front width / facade size',
                Icons.storefront_outlined,
              ),
              const SizedBox(height: 12),
              _buildIntDropdownField(
                label: 'Washrooms (Optional)',
                controller: _washrooms,
                min: 0,
                max: 30,
                hint: 'Select washrooms',
                icon: Icons.wc_outlined,
              ),
            ],
            if (!_PropertyCreateScreenState._commercialTypes.contains(
              _commercialType,
            )) ...[
              const SizedBox(height: 8),
              Text(
                'Select a Commercial sub-category to see details.',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Parking Type',
              _PropertyCreateScreenState._parkingTypes,
              _parkingType,
              (v) => setState(() => _parkingType = v),
            ),
            const SizedBox(height: 12),
            _buildStepper(
              'Parking Spots',
              _parking,
              0,
              20,
              (v) => setState(() => _parking = v),
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Pre-leased',
              const ['yes', 'no'],
              _preLeased == null ? null : (_preLeased! ? 'yes' : 'no'),
              (v) => setState(() => _preLeased = v == 'yes'),
            ),
            if (_commercialType == 'showroom') ...[
              const SizedBox(height: 12),
              _buildRatingDropdown(
                label: 'Quality Rating (Optional)',
                controller: _qualityRating,
              ),
            ],
          ],
          // NOTE: Land/Plot details render above (outside commercial block).
          if (false) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _landType == 'commercial'
                    ? 'Commercial Plot Details'
                    : (_landType == 'agricultural'
                          ? 'Agriculture Plot Details'
                          : 'Residential Plot Details'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _plotArea,
              keyboardType: TextInputType.number,
              onChanged: (_) => _scheduleSaveDraft(),
              decoration: InputDecoration(
                labelText: 'Plot Area',
                hintText: 'Area',
                prefixIcon: const Icon(Icons.terrain, size: 18),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _plotAreaUnit,
                      isDense: true,
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      items:
                          (_landType == 'agricultural'
                                  ? _PropertyCreateScreenState._areaUnits
                                  : _PropertyCreateScreenState._areaUnits.where(
                                      (u) => u != 'acre',
                                    ))
                              .map(
                                (u) => DropdownMenuItem<String>(
                                  value: u,
                                  child: Text(
                                    toTitleCase(u),
                                    style: const TextStyle(
                                      color: AppColors.dark,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (v) {
                        setState(() => _plotAreaUnit = v ?? _plotAreaUnit);
                        _scheduleSaveDraft();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _length,
                    'Length (ft)',
                    'e.g., 60',
                    Icons.straighten,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _breadth,
                    'Breadth (ft)',
                    'e.g., 40',
                    Icons.straighten,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildIntDropdownField(
              label: 'Floors Allowed (Optional)',
              controller: _floorsAllowed,
              min: 0,
              max: 50,
              hint: 'Select floors',
              icon: Icons.layers_outlined,
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Corner Plot',
              const ['yes', 'no'],
              _plotCorner == null ? '' : (_plotCorner! ? 'yes' : 'no'),
              (v) {
                setState(() => _plotCorner = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Boundary Wall',
              const ['yes', 'no'],
              _boundaryWall == null ? '' : (_boundaryWall! ? 'yes' : 'no'),
              (v) {
                setState(() => _boundaryWall = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildStepper(
              'Open Sides',
              _openSides,
              1,
              4,
              (v) => setState(() => _openSides = v),
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Construction Done',
              const ['yes', 'no'],
              _constructionDone == null
                  ? ''
                  : (_constructionDone! ? 'yes' : 'no'),
              (v) {
                setState(() => _constructionDone = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _roadWidth,
              'Road Width',
              'Width in feet',
              Icons.straighten,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _buildChoiceChipRow(
              'Road Access',
              const ['yes', 'no'],
              _plotRoadAccess == null ? '' : (_plotRoadAccess! ? 'yes' : 'no'),
              (v) {
                setState(() => _plotRoadAccess = v == 'yes');
                _scheduleSaveDraft();
              },
            ),
            if (_landType == 'agricultural') ...[
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Water Source',
                _PropertyCreateScreenState._agriWaterSources,
                _agriWaterSource,
                (v) {
                  setState(() => _agriWaterSource = v);
                  _scheduleSaveDraft();
                },
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Fencing',
                const ['yes', 'no'],
                _agriFencing == null ? null : (_agriFencing! ? 'yes' : 'no'),
                (v) {
                  setState(() => _agriFencing = v == 'yes');
                  _scheduleSaveDraft();
                },
              ),
            ],
            if (isSale || isRentLease) ...[
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Ownership',
                _PropertyCreateScreenState._ownershipTypes,
                _ownership,
                (v) => setState(() => _ownership = v),
              ),
              const SizedBox(height: 12),
              _buildChoiceChipRow(
                'Availability',
                _PropertyCreateScreenState._availabilityTypes,
                _availability,
                (v) => setState(() => _availability = v),
              ),
              if (_availability != 'ready_to_move' &&
                  _availability != 'immediate') ...[
                const SizedBox(height: 12),
                _buildTextField(
                  _possessionBy,
                  'Possession By',
                  'YYYY-MM-DD',
                  Icons.event,
                  readOnly: true,
                  onTap: () => _pickDateForController(_possessionBy),
                ),
              ],
            ],
          ],
          if (isPgCoLiving) ...[
            const SizedBox(height: 12),
            Text(
              'PG / Co-living usually needs room-wise details. Fill bedrooms/bathrooms and add room photos.',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ],
      ],
    );
  }
}
