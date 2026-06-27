import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final int totalPoint;
  final String role;
  final String? equippedAvatarUrl;
  final String? equippedFrameUrl;
  final String? equippedThemeUrl;

  const UserEntity({
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
  });

  UserEntity copyWith({
    String? id,
    String? username,
    String? email,
    String? displayName,
    String? avatarUrl,
    int? totalPoint,
    String? role,
    String? equippedAvatarUrl,
    String? equippedFrameUrl,
    String? equippedThemeUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalPoint: totalPoint ?? this.totalPoint,
      role: role ?? this.role,
      equippedAvatarUrl: equippedAvatarUrl ?? this.equippedAvatarUrl,
      equippedFrameUrl: equippedFrameUrl ?? this.equippedFrameUrl,
      equippedThemeUrl: equippedThemeUrl ?? this.equippedThemeUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        displayName,
        avatarUrl,
        totalPoint,
        role,
        equippedAvatarUrl,
        equippedFrameUrl,
        equippedThemeUrl,
      ];
}
