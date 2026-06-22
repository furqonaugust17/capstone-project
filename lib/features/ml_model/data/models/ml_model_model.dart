import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/ml_model_entity.dart';
import 'animal_model_relation.dart';

part 'ml_model_model.g.dart';

@JsonSerializable()
class MLModelModel {
  final String id;
  final String name;
  final String version;
  final String fileUrl;
  final int? inputSize;
  final double? accuracy;
  final bool isActive;
  final List<AnimalModelRelation> animalModels;

  const MLModelModel({
    required this.id,
    required this.name,
    required this.version,
    required this.fileUrl,
    this.inputSize,
    this.accuracy,
    required this.isActive,
    required this.animalModels,
  });

  factory MLModelModel.fromJson(Map<String, dynamic> json) =>
      _$MLModelModelFromJson(json);

  Map<String, dynamic> toJson() => _$MLModelModelToJson(this);

  MLModelEntity toEntity() {
    // Extract labels from the relation mapping
    final labels = animalModels.map((rel) => rel.animal.name).toList();

    return MLModelEntity(
      id: id,
      name: name,
      version: version,
      fileUrl: fileUrl,
      inputSize: inputSize ?? 224, // default input size if null
      isActive: isActive,
      labels: labels,
    );
  }
}
