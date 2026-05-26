import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_agent/providers/property_form/property_form_provider.dart';
import 'commercial_section_helpers.dart';

class ShowroomSection extends ConsumerWidget {
  const ShowroomSection({super.key});

  static const _furnishings = ['furnished', 'semi_furnished', 'unfurnished'];
  static const _floorTypes = ['marble', 'tiles', 'granite', 'wood', 'epoxy', 'concrete'];
  static const _areaUnits = ['sqft', 'sqm', 'acres', 'cents'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(propertyFormProvider);
    final n = ref.read(propertyFormProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(flex: 3, child: SectionField(
            label: 'Showroom Area', hint: '2000',
            value: s.showroomArea, keyboard: TextInputType.number, onChanged: n.setShowroomArea,
          )),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: SectionUnitDropdown(
            value: s.showroomAreaUnit, options: _areaUnits, onChanged: n.setShowroomAreaUnit,
          )),
        ]),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: SectionField(
            label: 'Frontage Width (ft)', hint: 'e.g. 30',
            value: s.showroomFrontageWidth, keyboard: TextInputType.number,
            onChanged: n.setShowroomFrontageWidth,
          )),
          const SizedBox(width: 12),
          Expanded(child: SectionField(
            label: 'Ceiling Height (ft)', hint: 'e.g. 15',
            value: s.showroomCeilingHeight, keyboard: TextInputType.number,
            onChanged: n.setShowroomCeilingHeight,
          )),
        ]),
        const SizedBox(height: 16),

        const SectionLabel('Main Road Facing'),
        SectionChips(
          options: const ['yes', 'no'],
          selected: s.showroomMainRoadFacing == null ? '' : (s.showroomMainRoadFacing! ? 'yes' : 'no'),
          onChanged: (v) => n.setShowroomMainRoadFacing(v == 'yes'),
        ),
        const SizedBox(height: 12),

        const SectionLabel('Corner Showroom'),
        SectionChips(
          options: const ['yes', 'no'],
          selected: s.showroomCorner == null ? '' : (s.showroomCorner! ? 'yes' : 'no'),
          onChanged: (v) => n.setShowroomCorner(v == 'yes'),
        ),
        const SizedBox(height: 12),

        const SectionLabel('Washroom Available'),
        SectionChips(
          options: const ['yes', 'no'],
          selected: s.showroomWashroom == null ? '' : (s.showroomWashroom! ? 'yes' : 'no'),
          onChanged: (v) => n.setShowroomWashroom(v == 'yes'),
        ),
        const SizedBox(height: 12),

        SectionField(
          label: 'Parking Slots (Optional)', hint: 'e.g. 5',
          value: s.showroomParkingSlots, keyboard: TextInputType.number,
          onChanged: n.setShowroomParkingSlots,
        ),
        const SizedBox(height: 12),

        const SectionLabel('Furnishing Status'),
        SectionChips(options: _furnishings, selected: s.showroomFurnishing, onChanged: n.setShowroomFurnishing),
        const SizedBox(height: 12),

        const SectionLabel('Floor Type'),
        SectionChips(options: _floorTypes, selected: s.showroomFloorType, onChanged: n.setShowroomFloorType),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: SectionField(
            label: 'Market Name (Optional)', hint: 'Market name',
            value: s.showroomMarketName, onChanged: n.setShowroomMarketName,
          )),
          const SizedBox(width: 12),
          Expanded(child: SectionField(
            label: 'Locality (Optional)', hint: 'Area/locality',
            value: s.showroomLocality, onChanged: n.setShowroomLocality,
          )),
        ]),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: SectionField(
            label: 'Owner Name (Optional)', hint: 'Name',
            value: s.showroomOwnerName, onChanged: n.setShowroomOwnerName,
          )),
          const SizedBox(width: 12),
          Expanded(child: SectionField(
            label: 'Owner Mobile (Optional)', hint: 'Mobile number',
            value: s.showroomOwnerMobile, keyboard: TextInputType.phone,
            onChanged: n.setShowroomOwnerMobile,
          )),
        ]),
        const SizedBox(height: 16),
      ],
    );
  }
}
