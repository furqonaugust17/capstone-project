import 'package:flutter/material.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import 'package:intl/intl.dart';

class LeaderboardPodium extends StatelessWidget {
  final List<LeaderboardEntryEntity> topThree;

  const LeaderboardPodium({super.key, required this.topThree});

  @override
  Widget build(BuildContext context) {
    if (topThree.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (topThree.length > 1) _buildPodiumItem(topThree[1], 2, 160, const Color(0xFF8F8F8F)),
          if (topThree.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildPodiumItem(topThree[0], 1, 220, const Color(0xFFFFD900)),
            ),
          if (topThree.length > 2) _buildPodiumItem(topThree[2], 3, 140, const Color(0xFFF29D38)),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(LeaderboardEntryEntity entry, int rank, double height, Color borderColor) {
    final numberFormat = NumberFormat('#,###');

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFFD9D9D9),
          backgroundImage: entry.avatarUrl != null ? NetworkImage(entry.avatarUrl!) : null,
          child: entry.avatarUrl == null
              ? Text(
                  entry.displayName.isNotEmpty
                      ? entry.displayName[0].toUpperCase()
                      : entry.username[0].toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 24),
                )
              : null,
        ),
        const SizedBox(height: 8),
        Container(
          width: 90,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3FA),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            border: Border(
              top: BorderSide(color: borderColor, width: 5),
              left: BorderSide(color: borderColor, width: 5),
              right: BorderSide(color: borderColor, width: 5),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                rank.toString(),
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                  color: borderColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                entry.displayName,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                numberFormat.format(entry.totalScore),
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
      ],
    );
  }
}
