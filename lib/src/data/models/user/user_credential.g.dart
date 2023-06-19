// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCredential _$UserCredentialFromJson(Map<String, dynamic> json) =>
    UserCredential(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$UserCredentialToJson(UserCredential instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
