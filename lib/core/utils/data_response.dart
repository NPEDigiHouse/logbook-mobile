import 'package:equatable/equatable.dart';

class DataResponse<T> extends Equatable {
  const DataResponse({required this.data, this.status});

  final T data;
  final String? status;

  factory DataResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      DataResponse(
        data: json['data'],
        status: json['status'],
      );
  @override
  List<Object?> get props => [data, status];
}
