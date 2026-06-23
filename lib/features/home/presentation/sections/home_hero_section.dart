import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/features/home/presentation/widgets/home_start_button.dart';


class HomeHeroSection extends StatelessWidget {
  final VoidCallback onStartPressed;
  const HomeHeroSection({super.key, required this.onStartPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 224,
      top: 54,
      width: 468,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ANIDRAW',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              height: 1.15,
              letterSpacing: 0.32,
              fontFamily: 'PoetsenOne'
            ),
          ),
          Text(
            'Ayo belajar menggambar hewan lucu dengan\ncara yang menyenangkan!',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          HomeStartButton(onPressed: () => onStartPressed()),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => context.push('/history'),
                child: Container(
                  height: 79,
                  width: 106,
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F3FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.collections, color: Colors.blue, size: 30),
                      Text('Galeri', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  )
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/leaderboard'),
                child: Container(
                  height: 79,
                  width: 106,
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F3FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.leaderboard, color: Color(0xFFFFD900), size: 30),
                      Text('Peringkat', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  )
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/shop'),
                child: Container(
                  height: 79,
                  width: 106,
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F3FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store, color: Color(0xFFF29D38), size: 30),
                      Text('Toko', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  )
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
