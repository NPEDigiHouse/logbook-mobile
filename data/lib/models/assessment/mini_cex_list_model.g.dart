// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_cex_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiniCexListModel _$MiniCexListModelFromJson(Map<String, dynamic> json) =>
    MiniCexListModel(
      miniCexListModelCase: json['case'] as String?,
      id: json['id'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$MiniCexListModelToJson(MiniCexListModel instance) =>
    <String, dynamic>{
      'case': instance.miniCexListModelCase,
      'id': instance.id,
      'location': instance.location,
    };
