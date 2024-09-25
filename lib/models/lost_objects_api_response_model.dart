import 'package:myapp/models/lost_object_model.dart';

class LostObjectsApiResponse {
  final int totalCount;
  final List<LostObject> lostObjects;

  LostObjectsApiResponse({
    required this.totalCount,
    required this.lostObjects,
  });

  factory LostObjectsApiResponse.fromJson(Map<String, dynamic> json) {
    return LostObjectsApiResponse(
      totalCount: json['total_count'],
      lostObjects: (json['results'] as List)
          .map((item) => LostObject.fromJson(item))
          .toList(),
    );
  }


}
