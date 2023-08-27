import 'package:intl/intl.dart';

/// A collection of functions that are reusable
class ReusableFunctionHelper {
  /// Convert DateTime to String
  static String datetimeToString(DateTime date,
      {bool isShowTime = false, String? format}) {
    return isShowTime
        ? DateFormat(format ?? 'dd MMMM yyyy, HH:MM', "id_ID").format(date)
        : DateFormat(format ?? 'EEEE, dd MMMM yyyy', "id_ID").format(date);
  }

  static String datetimeToStringTime(DateTime date, {String? format}) {
    return DateFormat(format ?? 'HH:MM', "id_ID").format(date);
  }

  /// Convert String to DateTime
  static DateTime stringToDateTime(String date, {bool isShowTime = false}) {
    return isShowTime
        ? DateFormat('HH:MM, dd MMMM yyyy', "id_ID").parse(date)
        : DateFormat("EEEE, dd MMMM yyyy", "id_ID").parse(date);
  }
}
