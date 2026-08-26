/// Converts a backend slug/enum value like "ground_floor" or "high-street"
/// into a human-readable label ("Ground Floor", "High Street") for display.
String humanizeLabel(String? value) {
  if (value == null) return '';
  final trimmed = value.trim();
  if (trimmed.isEmpty) return trimmed;
  return trimmed
      .replaceAll('_', ' ')
      .replaceAll('-', ' ')
      .split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) {
        final lower = w.toLowerCase();
        switch (lower) {
          case 'pg':
            return 'PG';
          case 'noc':
            return 'NOC';
          case 'cctv':
            return 'CCTV';
          case 'ac':
            return 'AC';
          case 'bhk':
            return 'BHK';
          default:
            return w[0].toUpperCase() + w.substring(1).toLowerCase();
        }
      })
      .join(' ');
}