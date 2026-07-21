import 'package:json_annotation/json_annotation.dart';
import '../../../../features/animal/data/models/animal_model.dart';

part 'animal_model_relation.g.dart';

@JsonSerializable()
class AnimalModelRelation {
  final String id;
  final String animalId;
  final String modelId;
  final AnimalModel animal;

  const AnimalModelRelation({
    required this.id,
    required this.animalId,
    required this.modelId,
    required this.animal,
  });

  factory AnimalModelRelation.fromJson(Map<String, dynamic> json) =>
      _$AnimalModelRelationFromJson(json);

  Map<String, dynamic> toJson() => _$AnimalModelRelationToJson(this);
}
