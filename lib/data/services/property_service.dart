import '../models/property.dart';
import '../models/activity.dart';
import '../models/dashboard_counts.dart';

abstract class PropertyService {
  Future<List<Property>> getAssignedProperties();
  Future<Property> getPropertyById(String id);
  Future<Property> createProperty(Property property);
  Future<Property> updateProperty(Property property);
  Future<List<String>> uploadImages({
    required String propertyId,
    required List<String> localPaths,
  });
  Future<Property> publishProperty(String id);
  Future<Property> rejectProperty({required String id, required String reason});
  Future<DashboardCounts> getStatusCounts();
  Future<List<ActivityItem>> getDashboardActivity();
}
