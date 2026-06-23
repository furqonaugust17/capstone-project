import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/shared/widgets/custom_app_bar.dart';
import 'package:app/features/statistics/presentation/bloc/statistics_cubit.dart';
import 'package:app/features/statistics/presentation/bloc/statistics_state.dart';
import 'package:app/injection/injection.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<StatisticsCubit>()..fetchMyStatistics(),
      child: const StatisticsView(),
    );
  }
}

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  String _formatDrawingTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (minutes > 0) return '$minutes menit $seconds detik';
    return '$seconds detik';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'STATISTIK SAYA'),
      body: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StatisticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<StatisticsCubit>().fetchMyStatistics();
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (state is StatisticsLoaded) {
            final data = state.statistics;
            return RefreshIndicator(
              onRefresh: () => context.read<StatisticsCubit>().fetchMyStatistics(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: '🎮',
                          value: '${data.totalGames}',
                          label: 'Games',
                          color: const Color(0xFFE8F0FE), // Light blue
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          icon: '⭐',
                          value: '${data.totalScore}',
                          label: 'Score',
                          color: const Color(0xFFFFF8E1), // Light yellow
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: '🏆',
                          value: '${data.highestScore}',
                          label: 'Highest',
                          color: const Color(0xFFFCE8E6), // Light red
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          icon: '🎯',
                          value: '${(data.averageFocus * 100).toStringAsFixed(0)}%',
                          label: 'Focus',
                          color: const Color(0xFFE6F4EA), // Light green
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _StatCard(
                    icon: '⏱️',
                    value: _formatDrawingTime(data.totalDrawingTime),
                    label: 'Total Drawing Time',
                    color: const Color(0xFFF3E5F5), // Light purple
                    isWide: true,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;
  final bool isWide;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textNavy,
                  fontSize: isWide ? 24 : 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
