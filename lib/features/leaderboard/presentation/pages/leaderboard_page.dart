import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/leaderboard_cubit.dart';
import '../bloc/leaderboard_state.dart';
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:app/features/auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

import 'package:app/shared/widgets/custom_app_bar.dart';

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
      appBar: const CustomAppBar(title: 'PERINGKAT'),
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
              child: Container(
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kiri: Podium & My Rank (Membutuhkan Stack karena overlap)
                    SizedBox(
                      width: 546,
                      child: Stack(
                        children: [
                          // Podium Row
                          Positioned(
                            left: 104,
                            top: 16,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Podium 2
                                if (topThree.length > 1)
                                  SizedBox(
                                    width: 101,
                                    height: 260,
                                    child: _buildPodium(
                                      topThree[1],
                                      2,
                                      const Color(0xFF8F8F8F),
                                    ),
                                  )
                                else
                                  const SizedBox(width: 101, height: 260),

                                const SizedBox(width: 15),

                                // Podium 1
                                if (topThree.isNotEmpty)
                                  SizedBox(
                                    width: 101,
                                    height: 290,
                                    child: _buildPodium(
                                      topThree[0],
                                      1,
                                      const Color(0xFFFFD900),
                                    ),
                                  )
                                else
                                  const SizedBox(width: 101, height: 290),

                                const SizedBox(width: 15),

                                // Podium 3
                                if (topThree.length > 2)
                                  SizedBox(
                                    width: 101,
                                    height: 235,
                                    child: _buildPodium(
                                      topThree[2],
                                      3,
                                      const Color(0xFFF29D38),
                                    ),
                                  )
                                else
                                  const SizedBox(width: 101, height: 235),
                              ],
                            ),
                          ),

                          // My Rank Widget
                          if (myRank != null)
                            Positioned(
                              left: 56,
                              bottom: 0,
                              child: Container(
                                width: 429,
                                padding: EdgeInsets.symmetric(vertical: 10),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                        ],
                      ),
                    ),

                    // Kanan: List Peringkat
                    Expanded(
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
            child: Column(
              children: [
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
                  NumberFormat('#,###').format(entry.totalScore),
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
