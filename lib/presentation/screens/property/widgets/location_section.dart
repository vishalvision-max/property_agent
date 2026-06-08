import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_agent/core/theme/app_colors.dart';
import 'package:property_agent/core/theme/app_theme.dart';
import 'package:property_agent/providers/property_form/address_suggestions_provider.dart';
import 'package:property_agent/providers/property_form/form_submit_state_provider.dart';
import 'package:property_agent/providers/property_form/property_form_provider.dart';
import 'package:property_agent/data/services/google_places_service.dart';

import 'package:flutter/services.dart';

class LocationSection extends ConsumerWidget {
  const LocationSection({
    super.key,
    required this.addressController,
    required this.villageController,
    required this.landmarkController,
    required this.cityController,
    required this.stateController,
    required this.pincodeController,
    required this.ownerNameController,
    required this.ownerPhoneController,
    required this.addressFocusNode,
    required this.isSellResidentialFarmhouse,
    required this.isSellResidentialApartment,
    required this.whatsappUpdates,
    required this.onWhatsappUpdatesChanged,
    required this.onAddressChanged,
    required this.onSelectAddressPrediction,
    required this.onScheduleSaveDraft,
    required this.onValidateField,
    required this.onForceAutoFillLocation,
    required this.buildTextField,
    required this.buildChoiceChipRow,
  });

  final TextEditingController addressController;
  final TextEditingController villageController;
  final TextEditingController landmarkController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;
  final TextEditingController ownerNameController;
  final TextEditingController ownerPhoneController;
  final FocusNode addressFocusNode;

  final bool isSellResidentialFarmhouse;
  final bool isSellResidentialApartment;
  final bool whatsappUpdates;

  final ValueChanged<bool> onWhatsappUpdatesChanged;
  final ValueChanged<String> onAddressChanged;
  final ValueChanged<PlacePrediction> onSelectAddressPrediction;
  final VoidCallback onScheduleSaveDraft;
  final ValueChanged<String> onValidateField;
  final VoidCallback onForceAutoFillLocation;

  final Widget Function(
    TextEditingController controller,
    String labelText,
    String hintText,
    IconData icon, {
    int maxLines,
    TextInputType keyboardType,
    ValueChanged<String>? onChanged,
    String? errorText,
    String? helperText,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) buildTextField;

  final Widget Function(
    String label,
    List<String> options,
    String selectedValue,
    ValueChanged<String> onChanged,
  ) buildChoiceChipRow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Stack(
          children: [
            buildTextField(
              addressController,
              'Address',
              'Street address',
              Icons.location_on,
              onChanged: onAddressChanged,
              errorText: ref.watch(propertyFormProvider).errorFor('address'),
            ),
            if (ref.watch(addressSuggestionsProvider).isLoading ||
                ref.watch(formSubmitStateProvider))
              const Positioned(
                right: 12,
                top: 12,
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            if (addressFocusNode.hasFocus &&
                (ref.watch(addressSuggestionsProvider).valueOrNull ?? [])
                    .isNotEmpty)
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
                      itemCount:
                          (ref.watch(addressSuggestionsProvider).valueOrNull ??
                                  [])
                              .length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final pred = (ref
                                .watch(addressSuggestionsProvider)
                                .valueOrNull ??
                            [])[i];
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
                          onTap: () => onSelectAddressPrediction(pred),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (isSellResidentialFarmhouse) ...[
          buildTextField(
            villageController,
            'Village',
            'Village name',
            Icons.location_city_outlined,
            onChanged: (_) => onScheduleSaveDraft(),
          ),
          const SizedBox(height: 12),
          buildTextField(
            landmarkController,
            'Landmark (Optional)',
            'Near ...',
            Icons.place_outlined,
            onChanged: (_) => onScheduleSaveDraft(),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: buildTextField(
                cityController,
                'City',
                'City name',
                Icons.location_city,
                onChanged: (_) => onValidateField('city'),
                errorText: ref.watch(propertyFormProvider).errorFor('city'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildTextField(
                stateController,
                'State',
                'State name',
                Icons.map,
                onChanged: (_) => onValidateField('state'),
                errorText: ref.watch(propertyFormProvider).errorFor('state'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        buildTextField(
          pincodeController,
          'Pincode',
          '6-digit code',
          Icons.mail,
          keyboardType: TextInputType.number,
          onChanged: (_) => onValidateField('pincode'),
          errorText: ref.watch(propertyFormProvider).errorFor('pincode'),
        ),
        const SizedBox(height: 12),
        buildTextField(
          ownerNameController,
          'Owner Name (Optional)',
          'Owner full name',
          Icons.person_outline,
          onChanged: (_) => onScheduleSaveDraft(),
        ),
        const SizedBox(height: 12),
        buildTextField(
          ownerPhoneController,
          'Phone Number (Optional)',
          '10-digit phone',
          Icons.call_outlined,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) {
            onValidateField('ownerPhone');
            onScheduleSaveDraft();
          },
          errorText: ref.watch(propertyFormProvider).errorFor('ownerPhone'),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onForceAutoFillLocation,
            icon: const Icon(Icons.my_location, size: 16),
            label: const Text('Use current location'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.gold,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}
