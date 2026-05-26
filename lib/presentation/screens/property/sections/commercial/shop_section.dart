import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_agent/providers/property_form/property_form_provider.dart';
import 'commercial_section_helpers.dart';

class ShopSection extends ConsumerWidget {
  const ShopSection({super.key});

  static const _shopTypes = ['retail', 'showroom', 'food_beverage', 'grocery', 'pharmacy', 'other'];
  static const _floorTypes = ['marble', 'tiles', 'granite', 'wood', 'concrete', 'other'];
  static const _areaUnits = ['sqft', 'sqm', 'acres', 'cents'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(propertyFormProvider);
    final n = ref.read(propertyFormProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Shop Type'),
        SectionChips(options: _shopTypes, selected: s.shopType, onChanged: n.setShopType),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(flex: 3, child: SectionField(
            label: 'Shop Area', hint: '600',
            value: s.shopArea, keyboard: TextInputType.number, onChanged: n.setShopArea,
          )),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: SectionUnitDropdown(
            value: s.shopAreaUnit, options: _areaUnits, onChanged: n.setShopAreaUnit,
          )),
        ]),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: SectionField(
            label: 'Frontage Width (ft)', hint: 'e.g. 20',
            value: s.frontageWidth, keyboard: TextInputType.number, onChanged: n.setFrontageWidth,
          )),
          const SizedBox(width: 12),
          Expanded(child: SectionField(
            label: 'Ceiling Height (ft)', hint: 'e.g. 12',
            value: s.ceilingHeight, keyboard: TextInputType.number, onChanged: n.setCeilingHeight,
          )),
        ]),
        const SizedBox(height: 16),

        const SectionLabel('Main Road Facing'),
        SectionChips(
          options: const ['yes', 'no'],
          selected: s.mainRoadFacing == null ? '' : (s.mainRoadFacing! ? 'yes' : 'no'),
          onChanged: (v) => n.setMainRoadFacing(v == 'yes'),
        ),
        const SizedBox(height: 12),

        const SectionLabel('Corner Shop'),
        SectionChips(
          options: const ['yes', 'no'],
          selected: s.cornerShop == null ? '' : (s.cornerShop! ? 'yes' : 'no'),
          onChanged: (v) => n.setCornerShop(v == 'yes'),
        ),
        const SizedBox(height: 12),

        const SectionLabel('Washroom Available'),
        SectionChips(
          options: const ['yes', 'no'],
          selected: s.washroomAvailable == null ? '' : (s.washroomAvailable! ? 'yes' : 'no'),
          onChanged: (v) => n.setWashroomAvailable(v == 'yes'),
        ),
        const SizedBox(height: 12),

        const SectionLabel('Floor Type'),
        SectionChips(options: _floorTypes, selected: s.floorType, onChanged: n.setFloorType),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: SectionField(
            label: 'Market Name (Optional)', hint: 'e.g. Main Bazaar',
            value: s.marketName, onChanged: n.setMarketName,
          )),
          const SizedBox(width: 12),
          Expanded(child: SectionField(
            label: 'Locality (Optional)', hint: 'Area/locality',
            value: s.locality, onChanged: n.setLocality,
          )),
        ]),
        const SizedBox(height: 16),
      ],
    );
  }
}
