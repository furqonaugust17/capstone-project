// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_model_relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimalModelRelation _$AnimalModelRelationFromJson(Map<String, dynamic> json) =>
    AnimalModelRelation(
      id: json['id'] as String,
      animalId: json['animalId'] as String,
      modelId: json['modelId'] as String,
      animal: AnimalModel.fromJson(json['animal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnimalModelRelationToJson(
  AnimalModelRelation instance,
) => <String, dynamic>{
  'id': instance.id,
  'animalId': instance.animalId,
  'modelId': instance.modelId,
  'animal': instance.animal,
};
