import 'package:flutter/material.dart';
import 'package:myapp/models/all_filters_api_response.dart';
import 'package:myapp/models/lost_object_model.dart';
import 'package:myapp/models/lost_objects_api_response_model.dart';
import 'package:myapp/services/fetch_api_service.dart';
import 'package:myapp/utils/util_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LostObjectsProvider with ChangeNotifier {
  int _newCount = 0;
  int _formerCount = 0;
  int _filteredCount = 0;
  List<LostObject> _newLostObjects = [];
  List<LostObject> _formerLostObjects = [];
  List<LostObject> _filteredLostObjects = [];
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

  List<LostObject> get newLostObjects => _newLostObjects;
  List<LostObject> get formerLostObjects => _formerLostObjects;
  List<LostObject> get filteredLostObjects => _filteredLostObjects;
  bool get isLoading => _isLoading;
  int get newCount => _newCount;
  int get formerCount => _formerCount;
  int get filteredCount => _filteredCount;
  DateTime? get dateFilter => _dateFilter;
  List<String> get stationFilter => _stationFilter;
  List<String> get allStations => _allStations;
  List<String> get natureFilter => _natureFilter;
  List<String> get allNatures => _allNatures;
  List<String> get typeFilter => _typeFilter;
  List<String> get allTypes => _allTypes;

  LostObjectsProvider() {
    initLostObjetcts();
  }

  void setSelectedDate(DateTime newDate) {
    _dateFilter = newDate;
    getLostObjects();
  }

  void resetDate() {
    _dateFilter = null;
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

  Future<void> initLostObjetcts() async {
    getFiltersOptions();
    await loadLastDate();
    await getLostObjects();
    if (_newLostObjects.isNotEmpty) {
      saveLastDate(_newLostObjects[0].date);
    }
  }

  bool hasFilter() {
    return (_dateFilter != null ||
        _typeFilter.isNotEmpty ||
        _typeFilter.isNotEmpty ||
        _stationFilter.isNotEmpty);
  }

  Future<void> getLostObjects() async {
    _isLoading = true;
    notifyListeners();

    LostObjectsApiResponse apiResponse;
    String minDate = '';
    String maxDate = '';

    if (hasFilter()) {
      if (dateFilter != null) {
        DateTime originalDate = DateTime.parse(
            formatDate(_dateFilter.toString(), "yyyy-MM-dd'T'HH:mm:ssZ"));
        DateTime startOfDay =
            DateTime(originalDate.year, originalDate.month, originalDate.day);
        minDate = startOfDay.toIso8601String();
        DateTime endOfDay = startOfDay.add(const Duration(days: 1));
        maxDate = endOfDay.toIso8601String();
      }
      _formerCount = 0;
      _formerLostObjects = [];
      _newCount = 0;
      _newLostObjects = [];
      apiResponse = await fetchLostObjects(_orderBy, _orderByDirection, 20,
          stationFilter, natureFilter, typeFilter, minDate, maxDate);
      _filteredCount = apiResponse.totalCount;
      _filteredLostObjects = apiResponse.lostObjects;
    } else {
      _filteredCount = 0;
      _filteredLostObjects = [];
      if (_lastLostObjectDateLoaded.isNotEmpty) {
        minDate = _lastLostObjectDateLoaded;
      }
      apiResponse = await fetchLostObjects(_orderBy, _orderByDirection, 20,
          stationFilter, natureFilter, typeFilter, minDate, maxDate);
      if (apiResponse.lostObjects.isEmpty) {
        apiResponse = await fetchLostObjects(_orderBy, _orderByDirection, 20,
            stationFilter, natureFilter, typeFilter, '', minDate);
        _formerLostObjects = apiResponse.lostObjects;
        _formerCount = apiResponse.totalCount;
      } else {
        _formerCount = 0;
        _formerLostObjects = [];
        _newCount = apiResponse.totalCount;
        _newLostObjects = apiResponse.lostObjects;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreObjects() async {
    _isLoading = true;
    notifyListeners();

    LostObjectsApiResponse apiResponse;
    String lastObjectDisplayed;
    if (_filteredLostObjects.isNotEmpty) {
      lastObjectDisplayed =
          _filteredLostObjects[_filteredLostObjects.length - 1].date;
    } else if (_formerLostObjects.isEmpty) {
      lastObjectDisplayed = _newLostObjects[_newLostObjects.length - 1].date;
    } else {
      lastObjectDisplayed =
          _formerLostObjects[_formerLostObjects.length - 1].date;
    }
    String minDate = '';
    String maxDate = '';

    if (hasFilter()) {
      if (dateFilter != null) {
        DateTime originalDate = DateTime.parse(
            formatDate(_dateFilter.toString(), "yyyy-MM-dd'T'HH:mm:ssZ"));
        DateTime startOfDay =
            DateTime(originalDate.year, originalDate.month, originalDate.day);
        minDate = startOfDay.toIso8601String();
        DateTime endOfDay = startOfDay.add(const Duration(days: 1));
        maxDate = endOfDay.toIso8601String();
      }

      if (maxDate.isEmpty ||
          DateTime.parse(lastObjectDisplayed)
              .isBefore(DateTime.parse(maxDate))) {
        maxDate = lastObjectDisplayed;
      }
      _formerCount = 0;
      _formerLostObjects = [];
      _newCount = 0;
      _newLostObjects = [];
      if (_orderByDirection == 'asc') {
        String mem = minDate;
        minDate = maxDate;
        maxDate = mem;
      }
      apiResponse = await fetchLostObjects(_orderBy, _orderByDirection, 20,
          stationFilter, natureFilter, typeFilter, minDate, maxDate);
      if (_filteredCount == 0) {
        _filteredCount = apiResponse.totalCount;
      }
      _filteredLostObjects.addAll(apiResponse.lostObjects);
    } else {
      _filteredCount = 0;
      _filteredLostObjects = [];

      if (_lastLostObjectDateLoaded.isNotEmpty) {
        if (_formerLostObjects.isNotEmpty) {
          maxDate = _lastLostObjectDateLoaded;
        } else {
          minDate = _lastLostObjectDateLoaded;
        }
      }

      if (maxDate.isEmpty ||
          DateTime.parse(lastObjectDisplayed)
              .isBefore(DateTime.parse(maxDate))) {
        maxDate = lastObjectDisplayed;
      }
      if (_orderByDirection == 'asc') {
        String mem = minDate;
        minDate = maxDate;
        maxDate = mem;
      }

      apiResponse = await fetchLostObjects(_orderBy, _orderByDirection, 20,
          stationFilter, natureFilter, typeFilter, minDate, maxDate);
      if (formerLostObjects.isNotEmpty) {
        _formerLostObjects.addAll(apiResponse.lostObjects);
      } else {
        if (apiResponse.lostObjects.isEmpty) {
          apiResponse = await fetchLostObjects(_orderBy, _orderByDirection, 20,
              stationFilter, natureFilter, typeFilter, '', minDate);
          _formerLostObjects.addAll(apiResponse.lostObjects);
          if (_formerCount == 0) {
            _formerCount = apiResponse.totalCount;
          }
        } else {
          _formerCount = 0;
          _formerLostObjects = [];
          if (_newCount == 0) {
            _newCount = apiResponse.totalCount;
          }
          _newLostObjects.addAll(apiResponse.lostObjects);
        }
      }
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
