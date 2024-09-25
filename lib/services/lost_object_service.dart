import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/lost_objects_api_response_model.dart';

Future<LostObjectsApiResponse> fetchLostObjects() async {
  final response = await http.get(
    Uri.parse(
        'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records'),
  );

  if (response.statusCode == 200) {
    dynamic jsonResponse = json.decode(response.body);
    return LostObjectsApiResponse.fromJson(jsonResponse);
  } else {
    throw Exception('Error while retrieving lost objects');
  }
}
