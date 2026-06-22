// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_statistic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatisticModel _$UserStatisticModelFromJson(Map<String, dynamic> json) =>
    UserStatisticModel(
      userId: json['userId'] as String,
      totalGames: (json['totalGames'] as num).toInt(),
      totalScore: (json['totalScore'] as num).toInt(),
      highestScore: (json['highestScore'] as num).toInt(),
      averageFocus: (json['averageFocus'] as num).toDouble(),
      totalDrawingTime: (json['totalDrawingTime'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserStatisticModelToJson(UserStatisticModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'totalGames': instance.totalGames,
      'totalScore': instance.totalScore,
      'highestScore': instance.highestScore,
      'averageFocus': instance.averageFocus,
      'totalDrawingTime': instance.totalDrawingTime,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
