import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../bloc/leaderboard_cubit.dart';
import '../bloc/leaderboard_state.dart';
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:app/features/auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import '../../domain/entities/my_rank_entity.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<LeaderboardCubit>().fetchLiveLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<LeaderboardCubit, LeaderboardState>(
        builder: (context, state) {
          if (state is LeaderboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LeaderboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Gagal memuat: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<LeaderboardCubit>().fetchLiveLeaderboard(),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state is LeaderboardLoaded) {
            final rankings = state.liveRankings ?? [];
            final topThree = rankings.take(3).toList();
            final remaining = rankings.skip(3).toList();
            final myRank = state.myRank;

            final authState = context.read<AuthBloc>().state;
            String? currentUserId;
            if (authState is Authenticated) {
              currentUserId = authState.user.id;
            }

            return Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  width: 917,
                  height: 412,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      // Header
                      Positioned(
                        left: 0,
                        top: 0,
                        width: 917,
                        height: 64,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          color: const Color.fromRGBO(248, 250, 253, 0.9),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => context.pop(),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD3E3FD),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_back,
                                        color: Color(0xFF041E49),
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                              const Text(
                                'PERINGKAT',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: Color(0xFF4285F4),
                                ),
                              ),
                              const SizedBox(width: 32), // Balance the row
                            ],
                          ),
                        ),
                      ),

                      // Podium Peringkat 2
                      if (topThree.length > 1)
                        Positioned(
                          left: 104,
                          top: 139,
                          width: 101,
                          height: 229,
                          child: _buildPodium(
                            topThree[1],
                            2,
                            const Color(0xFF8F8F8F),
                          ),
                        ),

                      // Podium Peringkat 1
                      if (topThree.isNotEmpty)
                        Positioned(
                          left: 220,
                          top: 80,
                          width: 101,
                          height: 288,
                          child: _buildPodium(
                            topThree[0],
                            1,
                            const Color(0xFFFFD900),
                          ),
                        ),

                      // Podium Peringkat 3
                      if (topThree.length > 2)
                        Positioned(
                          left: 336,
                          top: 166,
                          width: 101,
                          height: 202,
                          child: _buildPodium(
                            topThree[2],
                            3,
                            const Color(0xFFF29D38),
                          ),
                        ),

                      // My Rank Widget
                      if (myRank != null)
                        Positioned(
                          left: 56,
                          top: 317,
                          width: 429,
                          height: 95,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFD3E3FD),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 15),
                                Container(
                                  width: 67,
                                  height: 67,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFD9D9D9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kamu Peringkat Ke-${myRank.rank}',
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '${NumberFormat('#,###').format(myRank.totalScore)} Poin',
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                      // List Peringkat
                      Positioned(
                        left: 546,
                        top: 64,
                        width: 371,
                        height: 348,
                        child: Container(
                          color: const Color(0xFFF3F3FA),
                          padding: const EdgeInsets.only(
                            top: 22,
                            left: 33,
                            right: 32,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Daftar Peringkat',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 22),
                                  itemCount: remaining.length,
                                  itemBuilder: (context, index) {
                                    final entry = remaining[index];
                                    return _buildListItem(
                                      entry,
                                      index + 4,
                                      entry.userId == currentUserId,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildPodium(
    LeaderboardEntryEntity entry,
    int rank,
    Color borderColor,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 67,
          height: 67,
          decoration: const BoxDecoration(
            color: Color(0xFFD9D9D9),
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: entry.avatarUrl != null
              ? Image.network(entry.avatarUrl!, fit: BoxFit.cover)
              : Center(
                  child: Text(
                    entry.displayName.isNotEmpty
                        ? entry.displayName[0].toUpperCase()
                        : entry.username[0].toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black54,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 3),
        Text(
          entry.displayName,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${NumberFormat('#,###').format(entry.totalScore)}',
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: Container(
            width: 101,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3FA),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              border: Border(
                top: BorderSide(color: borderColor, width: 5),
                left: BorderSide(color: borderColor, width: 5),
                right: BorderSide(color: borderColor, width: 5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(
    LeaderboardEntryEntity entry,
    int rank,
    bool isCurrentUser,
  ) {
    return Container(
      width: 306,
      height: 78,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(10),
        border: isCurrentUser
            ? Border.all(color: Colors.blueAccent, width: 2)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '#$rank',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 13),
          Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: entry.avatarUrl != null
                ? Image.network(entry.avatarUrl!, fit: BoxFit.cover)
                : Center(
                    child: Text(
                      entry.displayName.isNotEmpty
                          ? entry.displayName[0].toUpperCase()
                          : entry.username[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
          ),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isCurrentUser
                    ? '${entry.displayName} (Kamu)'
                    : entry.displayName,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                '${NumberFormat('#,###').format(entry.totalScore)} Poin',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
