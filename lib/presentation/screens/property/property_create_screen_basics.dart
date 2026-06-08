// ignore_for_file: invalid_use_of_protected_member
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
    return PricingAndAreaSection(
      isLandPlot: _isLandPlotContext,
      isCommercial: _isCommercialContext,
      isPgCoLiving: _propertyKind == _CreatePropertyKind.pg || _propertyKind == _CreatePropertyKind.coLiving,
      type: _type,
      propertyKind: _propertyKind,
      isSellResidentialVillaHouse: _isSellResidentialVillaHouse,
      isResidential: !_isLandPlotContext && !_isCommercialContext,
      commercialType: _commercialType ?? '',
      landType: _landType ?? '',
      areaUnits: _PropertyCreateScreenState._areaUnits,
      priceController: _price,
      plotAreaController: _plotArea,
      plotAreaUnit: _plotAreaUnit,
      maintenanceChargesController: _maintenanceCharges,
      bookingAmountController: _bookingAmount,
      villaMaintenanceChargesController: _villaMaintenanceCharges,
      villaBookingAmountController: _villaBookingAmount,
      priceNegotiable: _priceNegotiable,
      securityDepositController: _securityDeposit,
      rentMaintenanceChargesController: _rentMaintenanceCharges,
      brokerageController: _brokerage,
      rentNegotiable: _rentNegotiable,
      areaController: _area,
      areaUnit: _areaUnit,
      onPlotAreaUnitChanged: (v) {
        setState(() => _plotAreaUnit = v);
        _scheduleSaveDraft();
      },
      onPriceNegotiableChanged: (v) {
        setState(() => _priceNegotiable = v);
        _scheduleSaveDraft();
      },
      onRentNegotiableChanged: (v) {
        setState(() => _rentNegotiable = v);
        _scheduleSaveDraft();
      },
      onAreaUnitChanged: (v) {
        setState(() => _areaUnit = v);
        _scheduleSaveDraft();
      },
      onValidateField: _validateField,
      onScheduleSaveDraft: _scheduleSaveDraft,
      buildTextField: _buildTextField,
      buildChoiceChipRow: _buildChoiceChipRow,
      toTitleCase: toTitleCase,
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
              final isSale = _propertyKind == _CreatePropertyKind.sale;
              final isLease = _propertyKind == _CreatePropertyKind.lease;
              final isRent = _propertyKind == _CreatePropertyKind.rent;
              final kind = _propertyKind;

              effectiveChildren = effectiveChildren.where((c) {
                final slug = (c.slug ?? '').toLowerCase();

                // Always hide PG / hostel / co-living / dormitory variants in non-PG modes
                if (slug.contains('pg') ||
                    slug.contains('hostel') ||
                    slug.contains('co-living') ||
                    slug.contains('coliving') ||
                    slug.contains('dormitory') ||
                    slug.contains('guest-house')) {
                  return false;
                }

                // ── Residential filter ──────────────────────────────────────
                if (parentSlug == 'residential') {
                  if (isSale || isLease) {
                    // Sale & Lease: Apartment, Builder Floor, Independent House,
                    // Villa, Duplex, Farm House
                    return _PropertyCreateScreenState._saleResidentialAllowedKeywords
                        .any((kw) => slug.contains(kw));
                  }
                  if (isRent) {
                    // Rent: no Farmhouse, Duplex
                    return !_PropertyCreateScreenState._rentResidentialExcludedKeywords
                        .any((kw) => slug.contains(kw));
                  }
                }

                // ── Commercial filter ───────────────────────────────────────
                if (parentSlug == 'commercial') {
                  // All modes: Office, Shop, Showroom, Warehouse, Industrial Shed
                  // The list coming from the API should already be correct;
                  // just keep the existing items
                  return true;
                }

                // ── Land / Plot filter ──────────────────────────────────────
                if (parentSlug == 'land-plot') {
                  if (isRent) {
                    // Rent has no Land/Plot — this branch is already hidden at
                    // parent level; return true defensively.
                    return true;
                  }
                  // Sale & Lease: Residential Plot, Commercial Plot,
                  // Industrial Plot, Agricultural Land
                  return _PropertyCreateScreenState._saleLeaseLandAllowedKeywords
                      .any((kw) => slug.contains(kw));
                }

                return true;
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
                    label: _propertyKind == _CreatePropertyKind.coLiving
                        ? 'Co-Living Type'
                        : 'PG / Hostel Type',
                    values: _propertyKind == _CreatePropertyKind.coLiving
                        ? _PropertyCreateScreenState._coLivingResidentialSubcategories
                        : _PropertyCreateScreenState._pgResidentialSubcategories,
                    value: _selectedCategorySlug,
                    labelFor: (s) => toTitleCase(s),
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
                ] else if (parentSlug == 'commercial' && !isPgCoLiving) ...[
                  const SizedBox(height: 12),
                  _buildChoiceGrid<String>(
                    label: 'Sub Category',
                    values: _PropertyCreateScreenState._commercialSubcategorySlugs,
                    value: _selectedCategorySlug,
                    labelFor: (s) =>
                        _PropertyCreateScreenState._commercialSubcategoryLabels[s] ??
                        toTitleCase(s),
                    onChanged: (slug) {
                      setState(() {
                        _selectedCategoryId = null;
                        _selectedCategorySlug = slug;
                        // Try to match to an API child if available
                        for (final child in children) {
                          if ((child.slug ?? '').toLowerCase().contains(slug) ||
                              slug.contains((child.slug ?? '').toLowerCase())) {
                            _selectedCategoryId = child.id;
                            break;
                          }
                        }
                        _syncDetailsFromSelectedCategorySlugs();
                      });
                      _scheduleSaveDraft();
                    },
                  ),
                ] else if (parentSlug == 'land-plot' && !isPgCoLiving) ...[
                  const SizedBox(height: 12),
                  _buildChoiceGrid<String>(
                    label: 'Sub Category',
                    values: _PropertyCreateScreenState._landPlotSubcategorySlugs,
                    value: _selectedCategorySlug,
                    labelFor: (s) =>
                        _PropertyCreateScreenState._landPlotSubcategoryLabels[s] ??
                        toTitleCase(s),
                    onChanged: (slug) {
                      setState(() {
                        _selectedCategoryId = null;
                        _selectedCategorySlug = slug;
                        // Try to match to an API child if available
                        for (final child in children) {
                          if ((child.slug ?? '').toLowerCase().contains(slug) ||
                              slug.contains((child.slug ?? '').toLowerCase())) {
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
                    value: _selectedCategoryId,
                    labelFor: (id) => effectiveChildren.firstWhere((c) => c.id == id).name,
                    onChanged: (id) {
                      setState(() {
                        final child = effectiveChildren.firstWhere((c) => c.id == id);
                        _selectedCategoryId = id;
                        _selectedCategorySlug = child.slug;
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
