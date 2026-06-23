import 'package:app/features/game_session/domain/entities/game_session_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_text_styles.dart';
import '../bloc/history/history_cubit.dart';

import 'package:app/shared/widgets/custom_app_bar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<HistoryCubit>().fetchHistory(refresh: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HistoryCubit>().fetchHistory();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'RIWAYAT MENGGAMBAR KAMU'),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state.status == HistoryStatus.loading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == HistoryStatus.error && state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gagal memuat riwayat: ${state.errorMessage}',
                    style: AppTextStyles.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<HistoryCubit>().fetchHistory(
                      refresh: true,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state.status == HistoryStatus.success && state.items.isEmpty) {
            return const Center(child: Text('Belum ada riwayat bermain.'));
          }

          return RefreshIndicator(
            onRefresh: () => context.read<HistoryCubit>().fetchHistory(refresh: true),
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 234 / 278,
              ),
              itemCount: state.hasReachedMax ? state.items.length : state.items.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final item = state.items[index];
                return _buildHistoryCard(context, item);
              },
            ),
          );
        },
      ),
    );
  }

  double _calculateRating(double similarity, int timeInSeconds) {
    // Similarity weight: Max 2.8 stars
    double baseScore = (similarity / 100.0) * 2.8;

    // Time bonus weight: Max 0.2 stars
    double timeBonus = 0.0;
    if (timeInSeconds <= 15) {
      timeBonus = 0.2;
    } else if (timeInSeconds <= 60) {
      // Scales down linearly from 0.2 to 0.0 between 15 and 60 seconds
      timeBonus = 0.2 - ((timeInSeconds - 15) / 45.0) * 0.2;
    }

    // Clamp total score to [0.0, 3.0]
    return (baseScore + timeBonus).clamp(0.0, 3.0);
  }

  Widget _buildHistoryCard(BuildContext context, GameSessionEntity item) {
    double stars = _calculateRating(item.confidenceScore * 100, item.drawingDuration);

    // Default formatting if intl locale hasn't been set up for 'id'
    String formattedDate = DateFormat('dd MMMM yyyy').format(item.startedAt.toLocal());

    return GestureDetector(
      onTap: () {
        context.push('/history/${item.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3FA),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: item.imageUrl != null
                          ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: RatingBarIndicator(
                      rating: stars.toDouble(),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFC107),
                      ),
                      itemCount: 3,
                      itemSize: 24.0,
                      unratedColor: Colors.grey.shade400,
                      direction: Axis.horizontal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.animalName ?? 'Hewan',
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
