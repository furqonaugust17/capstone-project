import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/animal_entity.dart';

part 'animal_model.g.dart';

@JsonSerializable()
class AnimalModel {
  final String id;
  final String name;
  final String? description;
  final String? thumbnailUrl;
  final String? hintImageUrl;
  final bool isActive;
  @JsonKey(defaultValue: 100)
  final int baseScore;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AnimalModel({
    required this.id,
    required this.name,
    this.description,
    this.thumbnailUrl,
    this.hintImageUrl,
    required this.isActive,
    required this.baseScore,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) =>
      _$AnimalModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnimalModelToJson(this);

  AnimalEntity toEntity() => AnimalEntity(
        id: id,
        name: name,
        description: description,
        thumbnailUrl: thumbnailUrl,
        hintImageUrl: hintImageUrl,
        isActive: isActive,
        baseScore: baseScore,
      );
}
