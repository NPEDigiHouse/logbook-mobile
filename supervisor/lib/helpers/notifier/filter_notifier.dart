import 'package:data/models/units/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:data/utils/filter_type.dart';



class FilterNotifier with ChangeNotifier {
  FilterType _filterType = FilterType.unverified;
  FilterType get filterType => _filterType;
  set setFilterType(FilterType filterType) {
    _filterType = filterType;
    notifyListeners();
  }

  DepartmentModel? _unit;
  DepartmentModel? get unit => _unit;
  set setDepartmentModel(DepartmentModel? unit) {
    _unit = unit;
    notifyListeners();
  }
}
