import '../models/activity.dart';
import '../models/property.dart';
import '../models/dashboard_counts.dart';
import '../services/mock_property_service.dart';
import '../services/property_service.dart';

class PropertyRepository {
  PropertyRepository({required this.propertyService});

  final PropertyService propertyService;

  Future<List<Property>> getAssignedProperties() =>
      propertyService.getAssignedProperties();
  Future<Property> getPropertyById(String id) =>
      propertyService.getPropertyById(id);
  Future<Property> createProperty(Property property) =>
      propertyService.createProperty(property);
  Future<Property> updateProperty(Property property) =>
      propertyService.updateProperty(property);
  Future<List<String>> uploadImages({
    required String propertyId,
    required List<String> localPaths,
  }) => propertyService.uploadImages(
    propertyId: propertyId,
    localPaths: localPaths,
  );
  Future<Property> publishProperty(String id) =>
      propertyService.publishProperty(id);
  Future<Property> rejectProperty({
    required String id,
    required String reason,
  }) => propertyService.rejectProperty(id: id, reason: reason);
  Future<DashboardCounts> getStatusCounts() =>
      propertyService.getStatusCounts();
  Future<List<ActivityItem>> getDashboardActivity() =>
      propertyService.getDashboardActivity();

  List<ActivityItem> recentActivity() {
    if (propertyService is MockPropertyService) {
      return (propertyService as MockPropertyService).recentActivity();
    }
    return const [];
  }
}
