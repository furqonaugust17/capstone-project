// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  totalPoint: (json['totalPoint'] as num).toInt(),
  role: json['role'] as String,
  equippedAvatarUrl: json['equipped_avatar_url'] as String?,
  equippedFrameUrl: json['equipped_frame_url'] as String?,
  equippedThemeUrl: json['equipped_theme_url'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'totalPoint': instance.totalPoint,
  'role': instance.role,
  'equipped_avatar_url': instance.equippedAvatarUrl,
  'equipped_frame_url': instance.equippedFrameUrl,
  'equipped_theme_url': instance.equippedThemeUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
