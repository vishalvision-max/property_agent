import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/property_form/property_form_provider.dart';
import 'commercial/commercial_section_helpers.dart';

class PricingSection extends ConsumerWidget {
  final bool isPgCoLiving;
  final bool isRentLease;
  final bool isSale;
  final bool isCommercial;
  final bool isResidential;
  final bool isSellResidentialVillaHouse;
  final String commercialType;
  final String propertyType; // e.g. rent vs sale

  const PricingSection({
    super.key,
    required this.isPgCoLiving,
    required this.isRentLease,
    required this.isSale,
    required this.isCommercial,
    required this.isResidential,
    required this.isSellResidentialVillaHouse,
    required this.commercialType,
    required this.propertyType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyFormProvider);
    final notifier = ref.read(propertyFormProvider.notifier);

    final priceLabel = isPgCoLiving
        ? 'Monthly Rent'
        : (propertyType == 'rent' ? 'Monthly Rent' : 'Price');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionField(
          label: priceLabel,
          hint: 'Amount',
          icon: Icons.currency_rupee,
          keyboard: TextInputType.number,
          value: state.price,
          onChanged: (v) {
            notifier.setPrice(v);
            notifier.clearError('price');
          },
          errorText: state.validationErrors['price'],
        ),
        if (isSale &&
            !isSellResidentialVillaHouse &&
            !(isCommercial && commercialType == 'office')) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SectionField(
                  label: 'Maintenance Charges (Optional)',
                  hint: '₹ 3500/month',
                  icon: Icons.payments_outlined,
                  keyboard: TextInputType.number,
                  value: state.maintenanceCharges,
                  onChanged: notifier.setMaintenanceCharges,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SectionField(
                  label: 'Booking Amount (Optional)',
                  hint: '₹ 2,00,000',
                  icon: Icons.account_balance_wallet_outlined,
                  keyboard: TextInputType.number,
                  value: state.bookingAmount,
                  onChanged: notifier.setBookingAmount,
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
                child: SectionField(
                  label: 'Maintenance Charges (Optional)',
                  hint: '₹ 3500/month',
                  icon: Icons.payments_outlined,
                  keyboard: TextInputType.number,
                  value: state.villaMaintenanceCharges,
                  onChanged: notifier.setVillaMaintenanceCharges,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SectionField(
                  label: 'Booking Amount (Optional)',
                  hint: '₹ 2,00,000',
                  icon: Icons.account_balance_wallet_outlined,
                  keyboard: TextInputType.number,
                  value: state.villaBookingAmount,
                  onChanged: notifier.setVillaBookingAmount,
                ),
              ),
            ],
          ),
        ],
        if (isSale) ...[
          const SizedBox(height: 12),
          const SectionLabel('Price Negotiable'),
          SectionChips(
            options: const ['yes', 'no'],
            selected: state.priceNegotiable == null
                ? ''
                : (state.priceNegotiable! ? 'yes' : 'no'),
            onChanged: (v) => notifier.setPriceNegotiable(v == 'yes'),
          ),
        ],
        if ((isRentLease) && isResidential) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SectionField(
                  label: 'Security Deposit',
                  hint: 'e.g., 50000',
                  icon: Icons.account_balance_wallet_outlined,
                  keyboard: TextInputType.number,
                  value: state.securityDeposit,
                  onChanged: notifier.setSecurityDeposit,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SectionField(
                  label: 'Maintenance Charges',
                  hint: 'e.g., 3500',
                  icon: Icons.receipt_long_outlined,
                  keyboard: TextInputType.number,
                  value: state.rentMaintenanceCharges,
                  onChanged: notifier.setRentMaintenanceCharges,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SectionField(
            label: 'Brokerage (Optional)',
            hint: 'e.g., 1 month rent',
            icon: Icons.handshake_outlined,
            keyboard: TextInputType.number,
            value: state.brokerage,
            onChanged: notifier.setBrokerage,
          ),
          const SizedBox(height: 12),
          const SectionLabel('Rent Negotiable'),
          SectionChips(
            options: const ['yes', 'no'],
            selected: state.rentNegotiable == null
                ? ''
                : (state.rentNegotiable! ? 'yes' : 'no'),
            onChanged: (v) => notifier.setRentNegotiable(v == 'yes'),
          ),
        ],
      ],
    );
  }
}
