import 'package:dio/dio.dart';
import 'package:elogbook/core/utils/failure.dart';

Failure failure(Object e) {
  if (e is DioException) {
    if (e.response != null) {
      print(e.response?.data['data']);
      return ClientFailure((e.response?.data['data']));
    } else {
      return ClientFailure(e.message ?? '');
    }
  }
  return ClientFailure('error not recognized');
}
