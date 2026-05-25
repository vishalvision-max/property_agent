enum PropertyStatus { pending, approved, listed, rejected }

enum PropertyType { rent, sale, lease }

extension PropertyStatusX on PropertyStatus {
  String get label => switch (this) {
        PropertyStatus.pending => 'Pending',
        PropertyStatus.approved => 'Approved',
        PropertyStatus.listed => 'Listed',
        PropertyStatus.rejected => 'Rejected',
      };
}

extension PropertyTypeX on PropertyType {
  String get label => switch (this) {
        PropertyType.rent => 'Rent',
        PropertyType.sale => 'Sale',
        PropertyType.lease => 'Lease',
      };
}

