part of 'property_create_screen.dart';

extension PropertyCreateScreenBasics on _PropertyCreateScreenState {
  Widget buildSection(String title, String key, IconData icon, Widget child) {
    final theme = Theme.of(context);
    final expanded = _expandedSections[key] ?? true;
    final canNext = expanded && key != 'description' && _isSectionComplete(key);
    _sectionKeys[key] ??= GlobalKey();
    if (kDebugMode && expanded) {
      debugPrint(
        'Section "$key" expanded=$expanded complete=${_isSectionComplete(key)} canNext=$canNext',
      );
    }

    return GlassContainer(
      key: _sectionKeys[key],
      blur: false, // Fix ANR in scroll views
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: ValueKey('section_${key}_$expanded'),
            iconColor: AppTheme.gold,
            collapsedIconColor: AppColors.textPrimary,
            initiallyExpanded: expanded,
            onExpansionChanged: (expanded) =>
                setState(() => _expandedSections[key] = expanded),
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            title: Row(
              children: [
                Icon(icon, size: 20, color: AppTheme.gold),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    child,
                    if (canNext) ...[
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () => _goNextFromSection(key),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.gold,
                            foregroundColor: const Color(0xFF070B14),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Next'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChoiceGrid<_CreatePropertyKind>(
          label: 'What are you listing?',
          values: _CreatePropertyKind.values,
          value: _propertyKind,
          labelFor: (v) => v.label,
          onChanged: (next) {
            setState(() {
              _propertyKind = next;
              _syncTypeAndResetInvalidCategorySelection();
              _selectedParentCategoryId = null;
              _selectedCategoryId = null;
            });
            _scheduleSaveDraft();
          },
        ),
        const SizedBox(height: 16),
        if (_propertyKind != null) buildCategorySelector(),
      ],
    );
  }

  Widget buildPricingAndArea() {
    final isLandPlot = _isLandPlotContext;
    final isCommercial = _isCommercialContext;
    final isPgCoLiving =
        _propertyKind == _CreatePropertyKind.pg ||
        _propertyKind == _CreatePropertyKind.coLiving;

    final priceLabel = isPgCoLiving
        ? 'Monthly Rent'
        : (_type == PropertyType.rent ? 'Monthly Rent' : 'Price');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          _price,
          priceLabel,
          'Amount',
          Icons.currency_rupee,
          keyboardType: TextInputType.number,
          onChanged: (_) => _validateField('price'),
          errorText: ref.watch(propertyFormProvider).errorFor('price'),
        ),
        if (_propertyKind == _CreatePropertyKind.sale &&
            !_isSellResidentialVillaHouse &&
            !(isCommercial && _commercialType == 'office')) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _maintenanceCharges,
                  'Maintenance Charges (Optional)',
                  '₹ 3500/month',
                  Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _bookingAmount,
                  'Booking Amount (Optional)',
                  '₹ 2,00,000',
                  Icons.account_balance_wallet_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
        if (_isSellResidentialVillaHouse) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _villaMaintenanceCharges,
                  'Maintenance Charges (Optional)',
                  '₹ 3500/month',
                  Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _villaBookingAmount,
                  'Booking Amount (Optional)',
                  '₹ 2,00,000',
                  Icons.account_balance_wallet_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
        if (_propertyKind == _CreatePropertyKind.sale) ...[
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Price Negotiable',
            const ['yes', 'no'],
            _priceNegotiable == null ? '' : (_priceNegotiable! ? 'yes' : 'no'),
            (v) {
              setState(() => _priceNegotiable = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
        ],
        if ((_propertyKind == _CreatePropertyKind.rent ||
                _propertyKind == _CreatePropertyKind.lease) &&
            _isResidential) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _securityDeposit,
                  'Security Deposit',
                  'e.g., 50000',
                  Icons.account_balance_wallet_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _scheduleSaveDraft(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _rentMaintenanceCharges,
                  'Maintenance Charges',
                  'e.g., 3500',
                  Icons.receipt_long_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _scheduleSaveDraft(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            _brokerage,
            'Brokerage (Optional)',
            'e.g., 1 month rent',
            Icons.handshake_outlined,
            keyboardType: TextInputType.number,
            onChanged: (_) => _scheduleSaveDraft(),
          ),
          const SizedBox(height: 12),
          _buildChoiceChipRow(
            'Rent Negotiable',
            const ['yes', 'no'],
            _rentNegotiable == null ? '' : (_rentNegotiable! ? 'yes' : 'no'),
            (v) {
              setState(() => _rentNegotiable = v == 'yes');
              _scheduleSaveDraft();
            },
          ),
        ],
        const SizedBox(height: 12),
        if (!isLandPlot) ...[
          // For Land/Plot, Plot Area is already collected in plot details, so
          // avoid showing a duplicate "Area" here.
          Row(
            children: [
              Expanded(
                child: Column(
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
                    TextField(
                      controller: _area,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _validateField('area'),
                      decoration: InputDecoration(
                        hintText: isCommercial ? 'Built-up area' : 'Size',
                        errorText: ref.watch(propertyFormProvider).errorFor('area'),
                        suffixIcon: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _areaUnit,
                              isDense: true,
                              dropdownColor: Colors.white,
                              iconEnabledColor: Colors.black,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              items: _PropertyCreateScreenState._areaUnits
                                  .map(
                                    (u) => DropdownMenuItem<String>(
                                      value: u,
                                      child: Text(
                                        u,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                setState(() => _areaUnit = v ?? _areaUnit);
                                _scheduleSaveDraft();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget buildDescriptionField() {
    return _buildTextField(
      _description,
      'About Your Property',
      'About the property...',
      Icons.description,
      maxLines: 4,
      onChanged: (_) => _validateField('desc'),
      errorText: ref.watch(propertyFormProvider).errorFor('desc'),
      helperText: 'Min 15 characters',
    );
  }

  Widget buildCategorySelector() {
    return ref
        .watch(categoriesProvider)
        .when(
          data: (cats) {
            final isRent = _propertyKind == _CreatePropertyKind.rent;
            final filtered = cats.where((c) {
              if (_segmentLockedToResidential) {
                return c.slug != 'commercial' &&
                       c.slug != 'land-plot' &&
                       c.slug != 'agriculture' &&
                       c.slug != 'agricultural';
              }
              if (isRent) {
                return c.slug != 'land-plot' &&
                       c.slug != 'agriculture' &&
                       c.slug != 'agricultural';
              }
              return true;
            }).toList();

            // For PG/Co-Living, default parent category to Residential.
            if (_segmentLockedToResidential &&
                _selectedParentCategoryId == null) {
              final residential = filtered.cast<Category?>().firstWhere(
                (c) => (c?.slug ?? '').toLowerCase() == 'residential',
                orElse: () => null,
              );
              if (residential != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  if (_selectedParentCategoryId != null) return;
                  setState(() {
                    _selectedParentCategoryId = residential.id;
                    _selectedParentCategorySlug = _normalizeParentSlug(
                      rawSlug: residential.slug,
                      name: residential.name,
                    );
                    _selectedCategoryId = null;
                    _selectedCategorySlug = null;
                  });
                });
              }
            }

            Category? selectedParent;
            if (_selectedParentCategoryId != null) {
              selectedParent = filtered.cast<Category?>().firstWhere(
                (c) => c?.id == _selectedParentCategoryId,
                orElse: () => null,
              );
            }

            final children = selectedParent?.children ?? [];
            final parentSlug = (selectedParent?.slug ?? '').toLowerCase();
            final isPgCoLiving =
                _propertyKind == _CreatePropertyKind.pg ||
                _propertyKind == _CreatePropertyKind.coLiving;
            var effectiveChildren = children.toList();

            if (!isPgCoLiving) {
              effectiveChildren = effectiveChildren.where((c) {
                final slug = (c.slug ?? '').toLowerCase();
                return !slug.contains('pg') &&
                       !slug.contains('guest-house') &&
                       !slug.contains('hostel') &&
                       !slug.contains('co-living') &&
                       !slug.contains('coliving') &&
                       !slug.contains('dormitory');
              }).toList();
            }

            return Column(
              children: [
                _buildChoiceGrid<int>(
                  label: 'Property Category',
                  values: filtered.map((c) => c.id).toList(),
                  value: _selectedParentCategoryId,
                  labelFor: (id) => filtered.firstWhere((c) => c.id == id).name,
                  onChanged: (id) {
                    final parent = filtered.firstWhere((c) => c.id == id);
                    final parentChildren = parent.children;
                    setState(() {
                      _selectedParentCategoryId = id;
                      _selectedParentCategorySlug = _normalizeParentSlug(
                        rawSlug: parent.slug,
                        name: parent.name,
                      );

                      // If the parent has no children, treat it as the leaf
                      // category so users don't get stuck without options.
                      if (parentChildren.isEmpty) {
                        _selectedCategoryId = id;
                        _selectedCategorySlug = parent.slug;
                      } else {
                        _selectedCategoryId = null;
                        _selectedCategorySlug = null;
                      }

                      _syncDetailsFromSelectedCategorySlugs();
                    });
                    debugPrint(
                      'Category selected: parentName=${parent.name} parentSlug=${parent.slug} normalized=${_selectedParentCategorySlug} children=${parentChildren.length}',
                    );
                    _scheduleSaveDraft();
                  },
                ),
                if (isPgCoLiving && parentSlug == 'residential') ...[
                  const SizedBox(height: 12),
                  _buildChoiceGrid<String>(
                    label: 'PG / Hostel Type',
                    values: _PropertyCreateScreenState._pgResidentialSubcategories,
                    value: _selectedCategorySlug,
                    labelFor: (s) => s.replaceAll('_', ' ').toUpperCase(),
                    onChanged: (slug) {
                      setState(() {
                        _selectedCategoryId = null;
                        _selectedCategorySlug = slug;
                        for (final child in children) {
                          if (child.slug == slug) {
                            _selectedCategoryId = child.id;
                            break;
                          }
                        }
                        _syncDetailsFromSelectedCategorySlugs();
                      });
                      _scheduleSaveDraft();
                    },
                  ),
                ] else if (children.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildChoiceGrid<int>(
                    label: 'Sub Category',
                    values: effectiveChildren.map((c) => c.id).toList(),
                    value: (_selectedCategorySlug == 'farmhouse')
                        ? -9999
                        : _selectedCategoryId,
                    labelFor: (id) =>
                        effectiveChildren.firstWhere((c) => c.id == id).name,
                    onChanged: (id) {
                      setState(() {
                        if (id == -9999) {
                          _selectedCategoryId =
                              null; // backend doesn't know it yet
                          _selectedCategorySlug = 'farmhouse';
                        } else {
                          final child = effectiveChildren.firstWhere(
                            (c) => c.id == id,
                          );
                          _selectedCategoryId = id;
                          _selectedCategorySlug = child.slug;
                        }
                        _syncDetailsFromSelectedCategorySlugs();

                        // Studio apartment is strictly 1 bed / 1 bath.
                        final slug = (_selectedCategorySlug ?? '')
                            .toLowerCase();
                        final isRentLease =
                            _propertyKind == _CreatePropertyKind.rent ||
                            _propertyKind == _CreatePropertyKind.lease;
                        if (isRentLease && slug.contains('studio')) {
                          _bedrooms = 1;
                          _bathrooms = 1;
                        }
                      });
                      debugPrint(
                        'Subcategory selected: parentKind=$_parentKind parentSlug=${_selectedParentCategorySlug ?? ''} childSlug=${_selectedCategorySlug ?? ''} commercialType=$_commercialType landType=$_landType',
                      );
                      _scheduleSaveDraft();
                    },
                  ),
                ],
              ],
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
        );
  }
}
