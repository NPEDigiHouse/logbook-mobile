import 'package:data/utils/failure.dart';
import 'package:dio/dio.dart';

Failure failure(Object e) {
  if (e is DioException) {
    if (e.response != null) {
      return ClientFailure((e.response?.data['data']).toString().trim());
    } else {
      return ClientFailure(e.message ?? '');
    }
  }
  return const ClientFailure('error not recognized');
}
