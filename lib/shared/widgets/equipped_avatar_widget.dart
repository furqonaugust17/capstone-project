import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';

class EquippedAvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final String? frameUrl;
  final double size;

  const EquippedAvatarWidget({
    super.key,
    this.avatarUrl,
    this.frameUrl,
    this.size = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The base avatar image
          Container(
            width: size * 0.85, // Scale down slightly to fit inside the frame
            height: size * 0.85,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface, // Background if no image
            ),
            clipBehavior: Clip.hardEdge,
            child: avatarUrl != null
                ? Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.grey,
                      );
                    },
                  )
                : const Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.grey,
                  ),
          ),
          
          // The frame overlaid on top
          if (frameUrl != null)
            Positioned.fill(
              child: Image.network(
                frameUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }
}
