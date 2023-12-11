// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfilePostModel _$UserProfilePostModelFromJson(
        Map<String, dynamic> json) =>
    UserProfilePostModel(
      email: json['email'] as String?,
      nim: json['nim'] as String?,
      pic: json['pic'] as String?,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$UserProfilePostModelToJson(
        UserProfilePostModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'nim': instance.nim,
      'email': instance.email,
      'pic': instance.pic,
    };
