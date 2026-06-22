import 'package:equatable/equatable.dart';

class AnimalEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? thumbnailUrl;
  final String? hintImageUrl;
  final bool isActive;
  final int baseScore;

  const AnimalEntity({
    required this.id,
    required this.name,
    this.description,
    this.thumbnailUrl,
    this.hintImageUrl,
    required this.isActive,
    required this.baseScore,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        thumbnailUrl,
        hintImageUrl,
        isActive,
        baseScore,
      ];
}
