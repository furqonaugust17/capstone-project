// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ml_model_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MLModelModel _$MLModelModelFromJson(Map<String, dynamic> json) => MLModelModel(
  id: json['id'] as String,
  name: json['name'] as String,
  version: json['version'] as String,
  fileUrl: json['fileUrl'] as String,
  inputSize: (json['inputSize'] as num?)?.toInt(),
  accuracy: (json['accuracy'] as num?)?.toDouble(),
  isActive: json['isActive'] as bool,
  animalModels: (json['animalModels'] as List<dynamic>)
      .map((e) => AnimalModelRelation.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MLModelModelToJson(MLModelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'version': instance.version,
      'fileUrl': instance.fileUrl,
      'inputSize': instance.inputSize,
      'accuracy': instance.accuracy,
      'isActive': instance.isActive,
      'animalModels': instance.animalModels,
    };
