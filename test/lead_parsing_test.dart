import 'package:flutter_test/flutter_test.dart';
import 'package:property_agent/data/models/lead.dart';

void main() {
  test('Lead.fromJson parses the API response perfectly', () {
    final Map<String, dynamic> apiLeadJson = {
      "id": 9,
      "lead_types": null,
      "user_id": 9,
      "name": "Test",
      "phone": "985632145",
      "email": null,
      "type": "sale",
      "property_type": "Test",
      "city": "mohali",
      "state": null,
      "pincode": "140104",
      "address": null,
      "budget_min": null,
      "budget_max": null,
      "message": null,
      "assigned_to": null,
      "status": "assigned",
      "source": "website",
      "utm_source": null,
      "utm_medium": null,
      "utm_campaign": null,
      "last_contacted_at": null,
      "priority": "medium",
      "lead_score": 0,
      "converted_property_id": null,
      "created_at": "2026-05-06T09:19:49.000000Z",
      "updated_at": "2026-05-25T12:38:58.000000Z",
      "property_id": null,
      "property": null
    };

    final lead = Lead.fromJson(apiLeadJson);

    expect(lead.id, 9);
    expect(lead.name, "Test");
    expect(lead.phone, "985632145");
    expect(lead.email, isNull);
    expect(lead.type, "sale");
    expect(lead.propertyType, "Test");
    expect(lead.city, "mohali");
    expect(lead.state, "");
    expect(lead.pincode, "140104");
    expect(lead.address, isNull);
    expect(lead.budgetMin, isNull);
    expect(lead.budgetMax, isNull);
    expect(lead.message, isNull);
    expect(lead.assignedTo, isNull);
    expect(lead.status, "assigned");
    expect(lead.source, "website");
    expect(lead.utmSource, isNull);
    expect(lead.utmMedium, isNull);
    expect(lead.utmCampaign, isNull);
    expect(lead.lastContactedAt, isNull);
    expect(lead.priority, "medium");
    expect(lead.leadScore, 0);
    expect(lead.convertedPropertyId, isNull);
    expect(lead.createdAt, DateTime.parse("2026-05-06T09:19:49.000000Z"));
    expect(lead.updatedAt, DateTime.parse("2026-05-25T12:38:58.000000Z"));
  });
}
