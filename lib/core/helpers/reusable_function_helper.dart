import 'package:intl/intl.dart';

/// A collection of functions that are reusable
class ReusableFunctionHelper {
  /// Convert DateTime to String
  static String datetimeToString(DateTime date,
      {bool isShowTime = false, String? format}) {
    return isShowTime
        ? DateFormat(format ?? 'dd MMMM yyyy, HH:mm', "en_EN").format(date)
        : DateFormat(format ?? 'EEEE, dd MMMM yyyy', "en_EN").format(date);
  }

  static String datetimeToStringTime(DateTime date, {String? format}) {
    return DateFormat(format ?? 'HH:mm', "en_EN").format(date);
  }

  /// Convert String to DateTime
  static DateTime stringToDateTime(String date, {bool isShowTime = false}) {
    return isShowTime
        ? DateFormat('HH:mm, dd MMMM yyyy', "en_EN").parse(date)
        : DateFormat("EEEE, dd MMMM yyyy", "en_EN").parse(date);
  }

  static String epochToStringTime({required int startTime, int? endTime}) {
    String time = '';
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(startTime * 1000);
    time += datetimeToStringTime(startDate);
    if (endTime != null) {
      DateTime endDate = DateTime.fromMillisecondsSinceEpoch(endTime * 1000);
      time += ' - ';
      time += datetimeToStringTime(endDate);
    }
    return time;
  }

  static String rateToText(int i) {
    final ratingMap = {
      1: '\"Bad\"',
      2: '\"Average\"',
      3: '\"Good\"',
      4: '\"Very Good\"',
      5: '\"Perfect\"',
    };
    return ratingMap[i] ?? 'Unknown';
  }
}
