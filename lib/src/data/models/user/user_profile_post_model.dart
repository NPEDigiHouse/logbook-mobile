import 'package:json_annotation/json_annotation.dart';

part 'user_profile_post_model.g.dart';

@JsonSerializable()
class UserProfilePostModel {
  final String? username;
  final String? nim;
  final String? email;
  final String? pic;

  UserProfilePostModel({this.email, this.nim, this.pic, this.username});

  factory UserProfilePostModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfilePostModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfilePostModelToJson(this);
}
