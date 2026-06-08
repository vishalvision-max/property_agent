import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://propertysearch.visionvivante.in/api/v1',
    headers: {
      'Authorization': 'Bearer 724|EogRMytkCdSea4tOBmJDWi5TjW8tnI6uszfBsH2ue219a36b',
      'Accept': 'application/json',
    },
  ));

  final formData = FormData.fromMap({
    'type': 'sale',
    'category_id': '26',
    'property_kind': 'plot',
    'listing_type': 'owner',
    'title': 'Test Farmhouse Plot',
    'description': 'Testing plot kind',
    'price': '300',
    'area': '200',
    'area_unit': 'sqft',
    'address': 'Sco 21, Sector 5, MDC',
    'city': 'Panchkula',
    'state': 'Haryana',
    'pincode': '134114',
    'latitude': '30.717',
    'longitude': '76.850',
    'farm_land_area': '500',
    'farm_rooms': '5',
    'balconies': '3',
  });

  try {
    final res = await dio.post('/staff/properties', data: formData);
    print(res.data);
  } catch (e) {
    if (e is DioException) {
      print(e.response?.data);
    } else {
      print(e);
    }
  }
}
