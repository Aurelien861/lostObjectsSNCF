class AllFiltersApiResponse {
  final List<String> allStations;
  final List<String> allTypes;
  final List<String> allNatures;

  AllFiltersApiResponse(
      {required this.allStations,
      required this.allTypes,
      required this.allNatures});

  factory AllFiltersApiResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> facetGroups = (json['facet_groups'] as List);
    List<String> allStations = [];
    List<String> allTypes = [];
    List<String> allNatures = [];

    for (var facetGroup in facetGroups) {
      List<dynamic> facets = facetGroup['facets'];

      if (facetGroup['name'] == 'gc_obo_gare_origine_r_name') {
        allStations = facets.map((facet) => facet['name'] as String).toList();
      } else if (facetGroup['name'] == 'gc_obo_nature_c') {
        allNatures = facets.map((facet) => facet['name'] as String).toList();
      } else if (facetGroup['name'] == 'gc_obo_type_c') {
        allTypes = facets.map((facet) => facet['name'] as String).toList();
      }
    }

    return AllFiltersApiResponse(
        allStations: allStations, allNatures: allNatures, allTypes: allTypes);
  }
}
