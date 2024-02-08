import 'package:data/models/units/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:data/utils/filter_type.dart';
import 'package:main/blocs/notification_cubit/notification_cubit.dart';

class FilterNotifier with ChangeNotifier {
  FilterType _filterType = FilterType.unverified;
  FilterType get filterType => _filterType;
  set setFilterType(FilterType filterType) {
    _filterType = filterType;
    notifyListeners();
  }

  ActivityType? _activityType;
  ActivityType? get activityType => _activityType;
  set setActivityType(ActivityType? activityType) {
    _activityType = activityType;
    notifyListeners();
  }

  bool _isUnreadOnly = false;
  bool get isUnreadOnly => _isUnreadOnly;
  set setUnreadOnlyStatus(bool isUnreadOnly) {
    _isUnreadOnly = isUnreadOnly;
    notifyListeners();
  }

  DepartmentModel? _unit;
  DepartmentModel? get unit => _unit;
  set setDepartmentModel(DepartmentModel? unit) {
    _unit = unit;
    notifyListeners();
  }

  bool get isActive =>
      _activityType != null || _isUnreadOnly == true || _unit != null;

  bool get isFilter => _filterType != FilterType.all || _unit != null;
}
