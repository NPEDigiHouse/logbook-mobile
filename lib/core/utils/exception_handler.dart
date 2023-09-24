import 'package:dio/dio.dart';
import 'package:elogbook/core/utils/failure.dart';

Failure failure(Object e) {
  if (e is DioException) {
    if (e.response != null) {
      return ClientFailure((e.response?.data['data']).toString().trim());
    } else {
      return ClientFailure(e.message ?? '');
    }
  }
  return ClientFailure('error not recognized');
}
