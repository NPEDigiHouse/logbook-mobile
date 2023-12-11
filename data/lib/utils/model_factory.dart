import 'package:data/utils/failure.dart';

extension JsonMap on Map<String, dynamic> {
  E value<E>(String key) {
    if (containsKey(key)) {
      return this[key] as E;
    } else {
      throw const FieldParseFailure('Failed');
    }
  }
}
