import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String username;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final int totalPoint;
  final String role;
  @JsonKey(name: 'equipped_avatar_url')
  final String? equippedAvatarUrl;
  @JsonKey(name: 'equipped_frame_url')
  final String? equippedFrameUrl;
  @JsonKey(name: 'equipped_theme_url')
  final String? equippedThemeUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.avatarUrl,
    required this.totalPoint,
    required this.role,
    this.equippedAvatarUrl,
    this.equippedFrameUrl,
    this.equippedThemeUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() => UserEntity(
        id: id,
        username: username,
        email: email,
        displayName: displayName,
        avatarUrl: avatarUrl,
        totalPoint: totalPoint,
        role: role,
        equippedAvatarUrl: equippedAvatarUrl,
        equippedFrameUrl: equippedFrameUrl,
        equippedThemeUrl: equippedThemeUrl,
      );
}
