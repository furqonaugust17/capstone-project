import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_text_styles.dart';
import '../bloc/detail/session_detail_cubit.dart';
// Note: We could reuse ResultSceneSection but since ResultSceneSection needs imageBytes 
// and some other specific states, we can build a simple detail view here or refactor.

import 'package:app/shared/widgets/custom_app_bar.dart';

class SessionDetailPage extends StatefulWidget {
  final String sessionId;

  const SessionDetailPage({super.key, required this.sessionId});

  @override
  State<SessionDetailPage> createState() => _SessionDetailPageState();
}

class _SessionDetailPageState extends State<SessionDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<SessionDetailCubit>().fetchDetail(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'DETAIL SESI'),
      backgroundColor: AppColors.background,
      body: BlocBuilder<SessionDetailCubit, SessionDetailState>(
        builder: (context, state) {
          if (state is SessionDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SessionDetailError) {
            return Center(child: Text(state.message));
          } else if (state is SessionDetailSuccess) {
            final session = state.session;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Skor Akhir: ${session.gameScore}',
                        style: AppTextStyles.displayMedium.copyWith(color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(height: 32),
                      if (session.imageUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            session.imageUrl!,
                            height: 200,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      _buildDetailRow('Hewan', session.animalName ?? '-'),
                      _buildDetailRow('Model yang digunakan', session.modelVersion ?? '-'),
                      _buildDetailRow('Tebakan Model', session.predictionLabel),
                      _buildDetailRow('Confidence', '${(session.confidenceScore * 100).toStringAsFixed(1)}%'),
                      _buildDetailRow('Durasi Menggambar', '${session.drawingDuration} detik'),
                      _buildDetailRow('Waktu Bermain', DateFormat('dd MMM yyyy, HH:mm:ss').format(session.startedAt.toLocal())),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
