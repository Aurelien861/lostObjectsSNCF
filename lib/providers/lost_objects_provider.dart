import 'package:flutter/material.dart';
import 'package:myapp/models/all_filters_api_response.dart';
import 'package:myapp/models/lost_object_model.dart';
import 'package:myapp/models/lost_objects_api_response_model.dart';
import 'package:myapp/services/fetch_api_service.dart';
import 'package:myapp/utils/util_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LostObjectsProvider with ChangeNotifier {
  int _totalCount = 0;
  List<LostObject> _lostObjects = [];
  String _lastLostObjectDateLoaded = '';
  bool _isLoading = false;
  DateTime? _dateFilter;
  List<String> _stationFilter = [];
  List<String> _allStations = [];
  List<String> _typeFilter = [];
  List<String> _allTypes = [];
  List<String> _natureFilter = [];
  List<String> _allNatures = [];
  String _orderBy = 'date';
  String _orderByDirection = 'desc';

  List<LostObject> get lostObjects => _lostObjects;
  bool get isLoading => _isLoading;
  int get totalCount => _totalCount;
  DateTime? get dateFilter => _dateFilter;
  List<String> get stationFilter => _stationFilter;
  List<String> get allStations => _allStations;
  List<String> get natureFilter => _natureFilter;
  List<String> get allNatures => _allNatures;
  List<String> get typeFilter => _typeFilter;
  List<String> get allTypes => _allTypes;

  LostObjectsProvider() {
    getFiltersOptions();
    getLostObjects();
  }

  void setSelectedDate(DateTime newDate) {
    _dateFilter = newDate;
    getLostObjects();
  }

  Future<void> setSelectedStations(List<String> stations) async {
    _stationFilter = stations;
    getLostObjects();
  }

  Future<void> setSelectedNatures(List<String> natures) async {
    _natureFilter = natures;
    getLostObjects();
  }

  Future<void> setSelectedTypes(List<String> types) async {
    _typeFilter = types;
    getLostObjects();
  }

  void setSelectedSort(String orderBy, String direction) {
    _orderBy = orderBy;
    _orderByDirection = direction;
    getLostObjects();
  }

  Future<void> getFiltersOptions() async {
    _isLoading = true;
    notifyListeners();

    AllFiltersApiResponse apiResponse = await fetchAllFilters();
    _allStations = apiResponse.allStations;
    _allNatures = apiResponse.allNatures;
    _allTypes = apiResponse.allTypes;
    _isLoading = false;
    notifyListeners();
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
    apiResponse = await fetchLostObjects(
        _orderBy,
        _orderByDirection,
        20,
        formatDate(_dateFilter.toString(), "yyyy-MM-dd'T'HH:mm:ssZ"),
        stationFilter,
        natureFilter,
        typeFilter);
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
    apiResponse = await fetchLostObjects(
        _orderBy,
        _orderByDirection,
        20,
        formatDate(_dateFilter.toString(), "yyyy-MM-dd'T'HH:mm:ssZ"),
        stationFilter,
        natureFilter,
        typeFilter,
        date);

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
