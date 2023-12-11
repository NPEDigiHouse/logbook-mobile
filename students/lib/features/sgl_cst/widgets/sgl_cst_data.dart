class SglModel {
  final String date;
  List<SglItemModel> items;

  SglModel({required this.date, required this.items});
}

class SglItemModel {
  final String activity;
  final String time;

  SglItemModel({required this.activity, required this.time});
}
