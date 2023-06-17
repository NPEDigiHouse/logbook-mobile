import 'package:json_annotation/json_annotation.dart';

part 'user_credential.g.dart';

@JsonSerializable()
class UserCredential {
  final String? accessToken;
  final String? refreshToken;

  UserCredential({this.accessToken, this.refreshToken});

  factory UserCredential.fromJson(Map<String, dynamic> data) =>
      _$UserCredentialFromJson(data);
}
