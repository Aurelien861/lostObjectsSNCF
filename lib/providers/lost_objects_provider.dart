import 'package:flutter/material.dart';
import 'package:myapp/models/lost_object_model.dart';
import 'package:myapp/models/lost_objects_api_response_model.dart';
import 'package:myapp/services/lost_object_service.dart';
import 'package:myapp/utils/util_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LostObjectsProvider with ChangeNotifier {
  int _totalCount = 0;
  List<LostObject> _lostObjects = [];
  String _lastLostObjectDateLoaded = '';
  bool _isLoading = false;
  DateTime? _dateFilter;
  String _orderBy = 'date';
  String _orderByDirection = 'desc';

  List<LostObject> get lostObjects => _lostObjects;
  bool get isLoading => _isLoading;
  int get totalCount => _totalCount;
  DateTime? get dateFilter => _dateFilter;

  void setSelectedDate(DateTime newDate) {
    _dateFilter = newDate;
    getLostObjects();
  }

  void setSelectedSort(String orderBy, String direction) {
    _orderBy = orderBy;
    _orderByDirection = direction;
    getLostObjects();
  }

  LostObjectsProvider() {
    getLostObjects();
  }

  Future<void> getLostObjects() async {
    _isLoading = true;
    notifyListeners();

    await loadLastDate();
    LostObjectsApiResponse apiResponse;
    // if (_lastLostObjectDateLoaded.isNotEmpty) {
    //   apiResponse =
    //       await fetchLostObjects('date', 'desc', 20, "date>'$_lastLostObjectDateLoaded'");
    //   if (apiResponse.totalCount == 0) {
    //     apiResponse = await fetchLostObjects('date', 'desc', 20);
    //   }
    // } else {
    apiResponse = await fetchLostObjects(_orderBy, _orderByDirection, 20,
        formatDate(_dateFilter.toString(), "yyyy-MM-dd'T'HH:mm:ssZ"));
    //}
    _totalCount = apiResponse.totalCount;
    _lostObjects = apiResponse.lostObjects;
    if (_lostObjects.isNotEmpty) {
      saveLastDate(_lostObjects[0].date);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreObjects() async {
    _isLoading = true;
    notifyListeners();

    String date = _lostObjects[_lostObjects.length - 1].date;
    LostObjectsApiResponse apiResponse;
    apiResponse = await fetchLostObjects(_orderBy, _orderByDirection, 20,
        formatDate(_dateFilter.toString(), "yyyy-MM-dd'T'HH:mm:ssZ"), date);

    _lostObjects.addAll(apiResponse.lostObjects);
    if (_lostObjects.isNotEmpty) {
      saveLastDate(_lostObjects[0].date);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadLastDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lastLostObjectDateLoaded = prefs.getString('lastObjectDate') ?? '';
  }

  Future<void> saveLastDate(String lastDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastObjectDate', lastDate);
  }
}
