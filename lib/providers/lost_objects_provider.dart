import 'package:flutter/material.dart';
import 'package:myapp/models/lost_object_model.dart';
import 'package:myapp/models/lost_objects_api_response_model.dart';
import 'package:myapp/services/lost_object_service.dart';

class LostObjectsProvider with ChangeNotifier {
  int _totalCount = 0;
  List<LostObject> _lostObjects = [];
  bool _isLoading = false;

  List<LostObject> get lostObject => _lostObjects;
  bool get isLoading => _isLoading;

  LostObjectsProvider() {
    getLostObjects();
  }

  Future<void> getLostObjects() async {
    _isLoading = true;
    notifyListeners();
    LostObjectsApiResponse apiResponse = await fetchLostObjects();
    _totalCount = apiResponse.totalCount;
    _lostObjects = apiResponse.lostObjects;
    _isLoading = false;
    notifyListeners();
  }
}
