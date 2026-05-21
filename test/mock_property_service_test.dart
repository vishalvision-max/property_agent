import 'package:flutter_test/flutter_test.dart';
import 'package:property_agent/data/models/property.dart';
import 'package:property_agent/data/models/property_enums.dart';
import 'package:property_agent/data/services/mock_property_service.dart';

void main() {
  test('MockPropertyService can create property', () async {
    final service = MockPropertyService();
    final created = await service.createProperty(
      Property(
        id: 'prop_test',
        name: 'Test Property',
        ownerName: 'Owner X',
        location: 'Test Location',
        price: 100,
        type: PropertyType.rent,
        amenities: const ['Gym'],
        images: const ['local/path.jpg'],
        videos: const [],
        description: 'This is a long enough description for testing.',
        status: PropertyStatus.pending,
      ),
    );
    expect(created.id, 'prop_test');
  });
}
