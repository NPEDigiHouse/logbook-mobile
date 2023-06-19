import 'package:elogbook/core/utils/failure.dart';

extension JsonMap on Map<String, dynamic> {
  E value<E>(String key) {
    if (this.containsKey(key)) {
      print(key);
      return this[key] as E;
    } else {
      throw FieldParseFailure('Failed');
    }
  }
}
