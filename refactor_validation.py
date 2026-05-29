import re

file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen.dart'
with open(file_path, 'r') as f:
    content = f.read()

# 1. Remove the String? declarations
content = re.sub(
    r'^\s*String\?\s*_priceErr,\s*_areaErr,\s*_descErr,\s*_addressErr,\s*_cityErr,\s*_stateErr,\s*_pincodeErr;\s*$',
    '',
    content,
    flags=re.MULTILINE
)

# 2. Replace _validateField logic
old_validate_field = """  void _validateField(String field) {
    setState(() {
      switch (field) {
        case 'price':
          _priceErr = Validators.positiveNum(_price.text, label: 'Price');
          break;
        case 'area':
          _areaErr = Validators.positiveNum(_area.text, label: 'Area');
          break;
        case 'desc':
          _descErr = Validators.minLen(
            _description.text,
            15,
            label: 'Description',
          );
          break;
        case 'address':
          _addressErr = Validators.requiredText(
            _address.text,
            label: 'Address',
          );
          break;
        case 'city':
          _cityErr = Validators.requiredText(_city.text, label: 'City');
          break;
        case 'state':
          _stateErr = Validators.requiredText(_state.text, label: 'State');
          break;
        case 'pincode':
          _pincodeErr = Validators.requiredText(
            _pincode.text,
            label: 'Pincode',
          );
          break;
      }
    });
    _maybeAutoAdvanceSections();
  }"""

new_validate_field = """  void _validateField(String field) {
    String? err;
    switch (field) {
      case 'price':
        err = Validators.positiveNum(_price.text, label: 'Price');
        break;
      case 'area':
        err = Validators.positiveNum(_area.text, label: 'Area');
        break;
      case 'desc':
        err = Validators.minLen(
          _description.text,
          15,
          label: 'Description',
        );
        break;
      case 'address':
        err = Validators.requiredText(
          _address.text,
          label: 'Address',
        );
        break;
      case 'city':
        err = Validators.requiredText(_city.text, label: 'City');
        break;
      case 'state':
        err = Validators.requiredText(_state.text, label: 'State');
        break;
      case 'pincode':
        err = Validators.requiredText(
          _pincode.text,
          label: 'Pincode',
        );
        break;
    }
    
    // Instead of setState, send the error to Riverpod
    ref.read(propertyFormProvider.notifier).setError(field, err);
    _maybeAutoAdvanceSections();
  }"""

content = content.replace(old_validate_field, new_validate_field)

# 3. Replace _isFormValid logic
old_form_valid = """    final areaOk = isLandPlot || (isShopOrShowroom && hasShopOrShowroomArea)
        ? true
        : (_areaErr == null);

    _validateField('price');
    if (!(isLandPlot || (isShopOrShowroom && hasShopOrShowroomArea))) {
      _validateField('area');
    } else {
      _areaErr = null;
    }
    _validateField('desc');
    _validateField('address');
    _validateField('city');
    _validateField('state');
    _validateField('pincode');
    return _priceErr == null &&
        areaOk &&
        _descErr == null &&
        _addressErr == null &&
        _cityErr == null &&
        _stateErr == null &&
        _pincodeErr == null &&
        _images.isNotEmpty;"""

new_form_valid = """    final s = ref.read(propertyFormProvider);
    final areaOk = isLandPlot || (isShopOrShowroom && hasShopOrShowroomArea)
        ? true
        : (s.errorFor('area') == null);

    _validateField('price');
    if (!(isLandPlot || (isShopOrShowroom && hasShopOrShowroomArea))) {
      _validateField('area');
    } else {
      ref.read(propertyFormProvider.notifier).clearError('area');
    }
    _validateField('desc');
    _validateField('address');
    _validateField('city');
    _validateField('state');
    _validateField('pincode');
    
    final updatedState = ref.read(propertyFormProvider);
    return updatedState.errorFor('price') == null &&
        areaOk &&
        updatedState.errorFor('desc') == null &&
        updatedState.errorFor('address') == null &&
        updatedState.errorFor('city') == null &&
        updatedState.errorFor('state') == null &&
        updatedState.errorFor('pincode') == null &&
        _images.isNotEmpty;"""

content = content.replace(old_form_valid, new_form_valid)

# 4. Update the _create method error messages logic
old_create_checks = """      if (_priceErr != null) issues.add('enter valid price');
      if (_areaErr != null) issues.add('enter valid area');
      if (_descErr != null) issues.add('enter description (min 15 chars)');
      if (_addressErr != null ||
          _cityErr != null ||
          _stateErr != null ||
          _pincodeErr != null) {"""

new_create_checks = """      final st = ref.read(propertyFormProvider);
      if (st.errorFor('price') != null) issues.add('enter valid price');
      if (st.errorFor('area') != null) issues.add('enter valid area');
      if (st.errorFor('desc') != null) issues.add('enter description (min 15 chars)');
      if (st.errorFor('address') != null ||
          st.errorFor('city') != null ||
          st.errorFor('state') != null ||
          st.errorFor('pincode') != null) {"""

content = content.replace(old_create_checks, new_create_checks)

# 5. UI replacements
# errorText: _priceErr -> errorText: ref.watch(propertyFormProvider).errorFor('price')
content = re.sub(r'errorText:\s*_([a-zA-Z]+)Err', r"errorText: ref.watch(propertyFormProvider).errorFor('\1')", content)

with open(file_path, 'w') as f:
    f.write(content)

print("Done refactoring validation states.")
