import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_agent/providers/property_form/property_form_provider.dart';
import 'commercial_section_helpers.dart';

class WarehouseSection extends ConsumerWidget {
  const WarehouseSection({super.key});

  static const _warehouseTypes = ['warehouse', 'factory', 'industrial_building'];
  static const _truckAccessTypes = ['heavy', 'medium', 'small'];
  static const _areaUnits = ['sqft', 'sqm', 'acres', 'cents', 'guntas'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(propertyFormProvider);
    final n = ref.read(propertyFormProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Warehouse Type'),
        SectionChips(options: _warehouseTypes, selected: s.warehouseType, onChanged: n.setWarehouseType),
        const SizedBox(height: 16),

        Row(children: [
          Expanded(flex: 3, child: SectionField(
            label: 'Plot Area', hint: '4000',
            value: s.warehousePlotArea,
            keyboard: TextInputType.number,
            onChanged: n.setWarehousePlotArea,
          )),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: SectionUnitDropdown(
            value: s.warehousePlotAreaUnit,
            options: _areaUnits,
            onChanged: n.setWarehousePlotAreaUnit,
          )),
        ]),
        const SizedBox(height: 12),

        SectionField(
          label: 'Ceiling Height (ft)', hint: '18',
          value: s.warehouseCeilingHeight,
          keyboard: TextInputType.number,
          onChanged: n.setWarehouseCeilingHeight,
        ),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: SectionField(
            label: 'Loading Bays', hint: '4',
            value: s.warehouseLoadingBays,
            keyboard: TextInputType.number,
            onChanged: n.setWarehouseLoadingBays,
          )),
          const SizedBox(width: 12),
          Expanded(child: SectionField(
            label: 'Dock Levelers', hint: '2',
            value: s.warehouseDockLevelers,
            keyboard: TextInputType.number,
            onChanged: n.setWarehouseDockLevelers,
          )),
        ]),
        const SizedBox(height: 12),

        SectionField(
          label: 'Power Supply', hint: 'e.g. 3-phase 440V',
          value: s.warehousePowerSupply,
          onChanged: n.setWarehousePowerSupply,
        ),
        const SizedBox(height: 16),

        const SectionLabel('Facilities'),
        SectionSwitch(label: 'Lift Available', value: s.warehouseLiftAvailable, onChanged: n.setWarehouseLiftAvailable),
        SectionSwitch(label: 'Goods Lift', value: s.warehouseGoodsLift, onChanged: n.setWarehouseGoodsLift),
        SectionSwitch(label: 'Pre-Leased', value: s.warehousePreLeased, onChanged: n.setWarehousePreLeased),
        const SizedBox(height: 12),

        const SectionLabel('Industrial License'),
        SectionChips(
          options: const ['yes', 'no'],
          selected: s.warehouseIndustrialLicense == null ? '' : (s.warehouseIndustrialLicense! ? 'yes' : 'no'),
          onChanged: (v) => n.setWarehouseIndustrialLicense(v == 'yes'),
        ),
        const SizedBox(height: 16),

        const SectionLabel('Truck Access'),
        SectionChips(options: _truckAccessTypes, selected: s.warehouseTruckAccess, onChanged: n.setWarehouseTruckAccess),
        const SizedBox(height: 16),

        const SectionLabel('Industrial Area (Optional)'),
        SectionField(
          label: 'Area / Zone Name', hint: 'e.g. Phase-2 Industrial Area',
          value: s.warehouseAreaName,
          onChanged: n.setWarehouseAreaName,
        ),
        const SizedBox(height: 12),
        SectionField(
          label: 'Industrial Area City', hint: 'e.g. Panchkula',
          value: s.warehouseCity,
          onChanged: n.setWarehouseCity,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
