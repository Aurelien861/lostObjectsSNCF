import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/lost_objects_api_response_model.dart';

Future<LostObjectsApiResponse> fetchLostObjects(
    String orderBy, String orderByDirection, int limit, String dateFilter,
    [String? where]) async {
  String baseUrl =
      'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records';
  String url = '$baseUrl?order_by=$orderBy%20$orderByDirection&limit=$limit';

  if (where != null || (dateFilter.isNotEmpty && dateFilter != "Date invalide")) {
    url += "&where=";
    if (where != null) {
      url += Uri.encodeComponent(" date < date'$where'");
    }
    if (dateFilter.isNotEmpty && dateFilter != "Date invalide") {
      DateTime originalDate = DateTime.parse(dateFilter);
      DateTime startOfDay = DateTime(originalDate.year, originalDate.month, originalDate.day);
      String formattedStartDay = startOfDay.toIso8601String();
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));
      String formattedEndDay = endOfDay.toIso8601String();
      url += url.substring(url.length - 6) == 'where=' ? "" : " AND";
      url += Uri.encodeComponent(" date >= date'$formattedStartDay' AND date < date'$formattedEndDay'");
    }
  }

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    dynamic jsonResponse = json.decode(response.body);
    return LostObjectsApiResponse.fromJson(jsonResponse);
  } else {
    throw Exception('Error while retrieving lost objects');
  }
}
