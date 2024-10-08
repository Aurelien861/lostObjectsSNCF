import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/all_filters_api_response.dart';
import 'package:myapp/models/lost_objects_api_response_model.dart';

Future<AllFiltersApiResponse> fetchAllFilters() async {
  String url =
      'https://data.sncf.com/api/records/1.0/search/?rows=0&facet=date&facet=gc_obo_date_heure_restitution_c&facet=gc_obo_gare_origine_r_name&facet=gc_obo_nature_c&facet=gc_obo_type_c&facet=gc_obo_nom_recordtype_sc_c&facetsort.date=-alphanum&facetsort.gc_obo_date_heure_restitution_c=-alphanum&facetsort.gc_obo_nom_recordtype_sc_c=alphanum&dataset=objets-trouves-restitution&timezone=Europe%2FBerlin&lang=fr';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    dynamic jsonResponse = json.decode(response.body);
    return AllFiltersApiResponse.fromJson(jsonResponse);
  } else {
    throw Exception('Error while retrieving filters');
  }
}

Future<LostObjectsApiResponse> fetchLostObjects(
    String orderBy,
    String orderByDirection,
    int limit,
    String dateFilter,
    List<String> stationFilter,
    List<String> natureFilter,
    List<String> typeFilter,
    [String? where]) async {
  String baseUrl =
      'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records';
  String url = '$baseUrl?order_by=$orderBy%20$orderByDirection&limit=$limit';

  if (where != null ||
      stationFilter.isNotEmpty ||
      natureFilter.isNotEmpty ||
      typeFilter.isNotEmpty ||
      (dateFilter.isNotEmpty && dateFilter != "Date invalide")) {
    url += "&where=";
    if (where != null) {
      url += Uri.encodeComponent(" date < date'$where'");
    }
    if (dateFilter.isNotEmpty && dateFilter != "Date invalide") {
      DateTime originalDate = DateTime.parse(dateFilter);
      DateTime startOfDay =
          DateTime(originalDate.year, originalDate.month, originalDate.day);
      String formattedStartDay = startOfDay.toIso8601String();
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));
      String formattedEndDay = endOfDay.toIso8601String();
      url += url.substring(url.length - 6) == 'where=' ? "" : " AND";
      url += Uri.encodeComponent(
          " date >= date'$formattedStartDay' AND date < date'$formattedEndDay'");
    }
    if (stationFilter.isNotEmpty) {
      url += url.substring(url.length - 6) == 'where=' ? "" : " AND";
      String station = stationFilter[0];
      url += Uri.encodeComponent(" (gc_obo_gare_origine_r_name = '$station'");
      for (int i = 1; i < stationFilter.length; i++) {
        station = stationFilter[i];
        url +=
            Uri.encodeComponent(" or gc_obo_gare_origine_r_name = '$station'");
      }
      url += ")";
    }
    if (natureFilter.isNotEmpty) {
      url += url.substring(url.length - 6) == 'where=' ? "" : " AND";
      String nature = natureFilter[0];
      url += Uri.encodeComponent(" (gc_obo_nature_c = '$nature'");
      for (int i = 1; i < natureFilter.length; i++) {
        nature = natureFilter[i];
        url +=
            Uri.encodeComponent(" or gc_obo_nature_c = '$nature'");
      }
      url += ")";
    }
    if (typeFilter.isNotEmpty) {
      url += url.substring(url.length - 6) == 'where=' ? "" : " AND";
      String type = typeFilter[0];
      url += Uri.encodeComponent(" (gc_obo_type_c = '$type'");
      for (int i = 1; i < typeFilter.length; i++) {
        type = typeFilter[i];
        url +=
            Uri.encodeComponent(" or gc_obo_type_c = '$type'");
      }
      url += ")";
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
