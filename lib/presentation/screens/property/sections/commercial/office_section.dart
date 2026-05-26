import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_agent/providers/property_form/property_form_provider.dart';
import 'commercial_section_helpers.dart';

class OfficeSection extends ConsumerWidget {
  const OfficeSection({super.key});

  static const _officeTypes = [
    'private_office', 'shared_office', 'co_working',
    'managed_office', 'virtual_office', 'it_park',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(propertyFormProvider);
    final n = ref.read(propertyFormProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Office Type'),
        SectionChips(options: _officeTypes, selected: s.officeType, onChanged: n.setOfficeType),
        const SizedBox(height: 12),

        SectionField(
          label: 'Office Area (sqft)', hint: 'Area in sqft',
          value: s.officeArea,
          keyboard: TextInputType.number,
          onChanged: n.setOfficeArea,
        ),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: SectionField(
            label: 'Cabins', hint: '0–50',
            value: s.cabins, keyboard: TextInputType.number, onChanged: n.setCabins,
          )),
          const SizedBox(width: 12),
          Expanded(child: SectionField(
            label: 'Meeting Rooms', hint: '0–30',
            value: s.meetingRooms, keyboard: TextInputType.number, onChanged: n.setMeetingRooms,
          )),
        ]),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: SectionField(
            label: 'Seats', hint: '0–500',
            value: s.seats, keyboard: TextInputType.number, onChanged: n.setSeats,
          )),
          const SizedBox(width: 12),
          Expanded(child: SectionField(
            label: 'Max Seats', hint: '0–500',
            value: s.maxSeats, keyboard: TextInputType.number, onChanged: n.setMaxSeats,
          )),
        ]),
        const SizedBox(height: 12),

        SectionField(
          label: 'Conference Rooms', hint: '0–20',
          value: s.conferenceRooms, keyboard: TextInputType.number, onChanged: n.setConferenceRooms,
        ),
        const SizedBox(height: 12),

        SectionField(
          label: 'Number of Lifts', hint: 'e.g. 2',
          value: s.numberOfLifts, keyboard: TextInputType.number, onChanged: n.setNumberOfLifts,
        ),
        const SizedBox(height: 16),

        const SectionLabel('Facilities'),
        SectionSwitch(label: 'Reception Area', value: s.receptionArea, onChanged: n.setReceptionArea),
        SectionSwitch(label: 'Pantry', value: s.pantry, onChanged: n.setPantry),
        SectionSwitch(label: 'Cafeteria', value: s.cafeteria, onChanged: n.setCafeteria),
        SectionSwitch(label: 'Server Room', value: s.serverRoom, onChanged: n.setServerRoom),
        SectionSwitch(label: 'Fire Safety Installed', value: s.fireSafetyInstalled, onChanged: n.setFireSafetyInstalled),
        SectionSwitch(label: 'Central AC', value: s.centralAC, onChanged: n.setCentralAC),
        SectionSwitch(label: 'Visitor Parking', value: s.visitorParking, onChanged: n.setVisitorParking),
        const SizedBox(height: 16),

        const SectionLabel('Price Negotiable'),
        SectionChips(
          options: const ['yes', 'no'],
          selected: s.officeNegotiable == null ? '' : (s.officeNegotiable! ? 'yes' : 'no'),
          onChanged: (v) => n.setOfficeNegotiable(v == 'yes'),
        ),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: SectionField(
            label: 'Maintenance Charges', hint: '₹ 5,000',
            value: s.officeMaintenanceCharges, keyboard: TextInputType.number,
            onChanged: n.setOfficeMaintenanceCharges,
          )),
          const SizedBox(width: 12),
          Expanded(child: SectionField(
            label: 'Booking Amount', hint: '₹ 1,00,000',
            value: s.officeBookingAmount, keyboard: TextInputType.number,
            onChanged: n.setOfficeBookingAmount,
          )),
        ]),
        const SizedBox(height: 16),
      ],
    );
  }
}
