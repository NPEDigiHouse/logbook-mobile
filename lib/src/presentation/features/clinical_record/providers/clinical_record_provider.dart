import 'package:flutter/material.dart';

class ClinicalRecordForm {
  final Widget parent;
  final List<Widget> items;

  ClinicalRecordForm({required this.parent, required this.items});
}

class ClinicalRecordProvider with ChangeNotifier {
  final List<ClinicalRecordForm> _listParent = [];

  List<ClinicalRecordForm> get listParent => _listParent;

  void addNewForm(Widget parent, Widget initialItem) {
    _listParent.add(ClinicalRecordForm(parent: parent, items: [initialItem]));
    notifyListeners();
  }
}
