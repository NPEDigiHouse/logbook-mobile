// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_clinical_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyClinicalRecordModel _$VerifyClinicalRecordModelFromJson(
        Map<String, dynamic> json) =>
    VerifyClinicalRecordModel(
      verified: json['verified'] as bool,
      rating: json['rating'] as int?,
      supervisorFeedback: json['supervisorFeedback'] as String?,
    );

Map<String, dynamic> _$VerifyClinicalRecordModelToJson(
        VerifyClinicalRecordModel instance) =>
    <String, dynamic>{
      'verified': instance.verified,
      'rating': instance.rating,
      'supervisorFeedback': instance.supervisorFeedback,
    };
