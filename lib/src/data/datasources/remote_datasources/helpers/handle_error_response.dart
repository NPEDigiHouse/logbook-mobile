import 'package:dio/dio.dart';
import 'package:elogbook/core/utils/failure.dart';

Future<void> handleErrorResponse(
    {required Response response,
    Future<void>? refreshToken,
    Future? retryOriginalRequest}) async {
  switch (response.statusCode) {
    case 400:
      throw BadRequestFailure(response.data);
    case 401:
      throw UnauthorizedFailure(response.data);
    case 500:
      throw ServerErrorFailure(response.data);
    case 444:
      await refreshToken;
      await retryOriginalRequest;
      break;
    default:
      return null;
  }
}
