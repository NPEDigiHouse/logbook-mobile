import 'package:json_annotation/json_annotation.dart';

part 'user_token.g.dart';

@JsonSerializable()
class UserToken {
  final String? accessToken;
  final String? refreshToken;

  UserToken({this.accessToken, this.refreshToken});

  factory UserToken.fromJson(Map<String, dynamic> data) =>
      _$UserTokenFromJson(data);
}
