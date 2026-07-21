// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_rank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyRankModel _$MyRankModelFromJson(Map<String, dynamic> json) => MyRankModel(
  rank: (json['rank'] as num).toInt(),
  totalScore: (json['totalScore'] as num).toInt(),
  totalGames: (json['totalGames'] as num).toInt(),
);

Map<String, dynamic> _$MyRankModelToJson(MyRankModel instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'totalScore': instance.totalScore,
      'totalGames': instance.totalGames,
    };
