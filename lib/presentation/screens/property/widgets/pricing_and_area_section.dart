import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_agent/core/theme/app_colors.dart';
import 'package:property_agent/core/utils/async_value_x.dart'; // assuming toTitleCase exists somewhere
import 'package:property_agent/data/models/property_enums.dart';
import 'package:property_agent/data/models/property_kind.dart';
import 'package:property_agent/providers/property_form/property_form_provider.dart';

class PricingAndAreaSection extends ConsumerWidget {
  const PricingAndAreaSection({
    super.key,
    required this.isLandPlot,
    required this.isCommercial,
    required this.isPgCoLiving,
    required this.type,
    required this.propertyKind,
    required this.isSellResidentialVillaHouse,
    required this.isResidential,
    required this.commercialType,
    required this.landType,
    required this.areaUnits,
    required this.priceController,
    required this.plotAreaController,
    required this.plotAreaUnit,
    required this.maintenanceChargesController,
    required this.bookingAmountController,
    required this.villaMaintenanceChargesController,
    required this.villaBookingAmountController,
    required this.priceNegotiable,
    required this.securityDepositController,
    required this.rentMaintenanceChargesController,
    required this.brokerageController,
    required this.rentNegotiable,
    required this.areaController,
    required this.areaUnit,
    required this.onPlotAreaUnitChanged,
    required this.onPriceNegotiableChanged,
    required this.onRentNegotiableChanged,
    required this.onAreaUnitChanged,
    required this.onValidateField,
    required this.onScheduleSaveDraft,
    required this.buildTextField,
    required this.buildChoiceChipRow,
    required this.toTitleCase,
  });

  final bool isLandPlot;
  final bool isCommercial;
  final bool isPgCoLiving;
  final PropertyType type;
  final dynamic propertyKind; // using dynamic to avoid private type issues if it's imported poorly
  final bool isSellResidentialVillaHouse;
  final bool isResidential;
  final String commercialType;
  final String landType;
  final List<String> areaUnits;

  final TextEditingController priceController;
  final TextEditingController plotAreaController;
  final String plotAreaUnit;
  final TextEditingController maintenanceChargesController;
  final TextEditingController bookingAmountController;
  final TextEditingController villaMaintenanceChargesController;
  final TextEditingController villaBookingAmountController;
  final bool? priceNegotiable;
  final TextEditingController securityDepositController;
  final TextEditingController rentMaintenanceChargesController;
  final TextEditingController brokerageController;
  final bool? rentNegotiable;
  final TextEditingController areaController;
  final String areaUnit;

  final ValueChanged<String> onPlotAreaUnitChanged;
  final ValueChanged<bool> onPriceNegotiableChanged;
  final ValueChanged<bool> onRentNegotiableChanged;
  final ValueChanged<String> onAreaUnitChanged;

  final ValueChanged<String> onValidateField;
  final VoidCallback onScheduleSaveDraft;

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
  }) buildTextField;

  final Widget Function(
    String label,
    List<String> options,
    String selectedValue,
    ValueChanged<String> onChanged,
  ) buildChoiceChipRow;

  final String Function(String) toTitleCase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyStr = propertyKind?.toString().split('.').last;
    final isSale = propertyStr == 'sale';
    final isRent = propertyStr == 'rent';
    final isLease = propertyStr == 'lease';

    final priceLabel = isPgCoLiving
        ? 'Monthly Rent'
        : (type == PropertyType.rent ? 'Monthly Rent' : 'Price');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTextField(
          priceController,
          priceLabel,
          'Amount',
          Icons.currency_rupee,
          keyboardType: TextInputType.number,
          onChanged: (_) => onValidateField('price'),
          errorText: ref.watch(propertyFormProvider).errorFor('price'),
        ),
        if (isLandPlot) ...[
          const SizedBox(height: 12),
          TextField(
            controller: plotAreaController,
            keyboardType: TextInputType.number,
            onChanged: (_) => onScheduleSaveDraft(),
            decoration: InputDecoration(
              labelText: 'Plot Area',
              hintText: 'Area',
              prefixIcon: const Icon(Icons.terrain, size: 18),
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: plotAreaUnit,
                    isDense: true,
                    dropdownColor: Colors.white,
                    iconEnabledColor: Colors.black,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    items: (landType == 'agricultural'
                            ? areaUnits
                            : areaUnits.where((u) => u != 'acre'))
                        .map(
                          (u) => DropdownMenuItem<String>(
                            value: u,
                            child: Text(
                              toTitleCase(u),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) onPlotAreaUnitChanged(v);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
        if (isSale &&
            !isSellResidentialVillaHouse &&
            !(isCommercial && commercialType == 'office')) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: buildTextField(
                  maintenanceChargesController,
                  'Maintenance Charges (Optional)',
                  '₹ 3500/month',
                  Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildTextField(
                  bookingAmountController,
                  'Booking Amount (Optional)',
                  '₹ 2,00,000',
                  Icons.account_balance_wallet_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
        if (isSellResidentialVillaHouse) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: buildTextField(
                  villaMaintenanceChargesController,
                  'Maintenance Charges (Optional)',
                  '₹ 3500/month',
                  Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildTextField(
                  villaBookingAmountController,
                  'Booking Amount (Optional)',
                  '₹ 2,00,000',
                  Icons.account_balance_wallet_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
        if (isSale) ...[
          const SizedBox(height: 12),
          buildChoiceChipRow(
            'Price Negotiable',
            const ['yes', 'no'],
            priceNegotiable == null ? '' : (priceNegotiable! ? 'yes' : 'no'),
            (v) => onPriceNegotiableChanged(v == 'yes'),
          ),
        ],
        if ((isRent || isLease) && isResidential) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: buildTextField(
                  securityDepositController,
                  'Security Deposit',
                  'e.g., 50000',
                  Icons.account_balance_wallet_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => onScheduleSaveDraft(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildTextField(
                  rentMaintenanceChargesController,
                  'Maintenance Charges',
                  'e.g., 3500',
                  Icons.receipt_long_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => onScheduleSaveDraft(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          buildTextField(
            brokerageController,
            'Brokerage (Optional)',
            'e.g., 1 month rent',
            Icons.handshake_outlined,
            keyboardType: TextInputType.number,
            onChanged: (_) => onScheduleSaveDraft(),
          ),
          const SizedBox(height: 12),
          buildChoiceChipRow(
            'Rent Negotiable',
            const ['yes', 'no'],
            rentNegotiable == null ? '' : (rentNegotiable! ? 'yes' : 'no'),
            (v) => onRentNegotiableChanged(v == 'yes'),
          ),
        ],
        const SizedBox(height: 12),
        if (!isLandPlot) ...[
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
                      controller: areaController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => onValidateField('area'),
                      decoration: InputDecoration(
                        hintText: isCommercial ? 'Built-up area' : 'Size',
                        errorText:
                            ref.watch(propertyFormProvider).errorFor('area'),
                        suffixIcon: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: areaUnit,
                              isDense: true,
                              dropdownColor: Colors.white,
                              iconEnabledColor: Colors.black,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              items: areaUnits
                                  .map(
                                    (u) => DropdownMenuItem<String>(
                                      value: u,
                                      child: Text(
                                        toTitleCase(u),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) onAreaUnitChanged(v);
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
}
