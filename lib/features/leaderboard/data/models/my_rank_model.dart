import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/my_rank_entity.dart';

part 'my_rank_model.g.dart';

@JsonSerializable()
class MyRankModel {
  final int rank;
  final int totalScore;
  final int totalGames;

  const MyRankModel({
    required this.rank,
    required this.totalScore,
    required this.totalGames,
  });

  factory MyRankModel.fromJson(Map<String, dynamic> json) =>
      _$MyRankModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyRankModelToJson(this);

  MyRankEntity toEntity() => MyRankEntity(
        rank: rank,
        totalScore: totalScore,
        totalGames: totalGames,
      );
}
