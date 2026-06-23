import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/leaderboard_cubit.dart';
import '../bloc/leaderboard_state.dart';
import '../widgets/leaderboard_podium.dart';
import '../widgets/leaderboard_item_tile.dart';
import '../widgets/my_rank_card.dart';
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:app/features/auth/presentation/bloc/auth_state.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    _loadData();
  }

  void _loadData() {
    final cubit = context.read<LeaderboardCubit>();
    switch (_tabController.index) {
      case 0:
        cubit.fetchLiveLeaderboard();
        break;
      case 1:
        cubit.fetchSnapshot(period: 'weekly', periodLabel: 'Minggu Ini');
        break;
      case 2:
        cubit.fetchSnapshot(period: 'monthly', periodLabel: 'Bulan Ini');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110), // Increased height for TabBar
        child: AppBar(
          backgroundColor: const Color(0xE6F8FAFD),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          title: const Text(
            'PERINGKAT',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: Color(0xFF4285F4),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 12, bottom: 12, right: 4),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFD3E3FD),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back, color: Color(0xFF041E49), size: 20),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF4285F4),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF4285F4),
            tabs: const [
              Tab(text: 'Live'),
              Tab(text: 'Mingguan'),
              Tab(text: 'Bulanan'),
            ],
          ),
        ),
      ),
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
                    onPressed: _loadData,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state is LeaderboardLoaded) {
            final rankings = _tabController.index == 0
                ? (state.liveRankings ?? [])
                : (state.snapshot?.rankings.map((e) => e).toList() ?? []); // For now assuming snapshot.rankings maps correctly
                
            // Convert models to entities if necessary. Wait, snapshot rankings are already entities from Cubit!
            final List<dynamic> currentRankings = _tabController.index == 0
                ? (state.liveRankings ?? [])
                : (state.snapshot?.rankings ?? []);

            final topThree = currentRankings.take(3).toList();
            final remaining = currentRankings.skip(3).toList();
            final myRank = state.myRank;
            
            // Getting current user ID from AuthBloc to highlight user in list
            final authState = context.read<AuthBloc>().state;
            String? currentUserId;
            if (authState is Authenticated) {
               currentUserId = authState.user.id;
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isLandscape = constraints.maxWidth > 600;

                Widget content = isLandscape
                    ? Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: LeaderboardPodium(
                                        topThree: topThree.cast(),
                                      ),
                                    ),
                                  ),
                                ),
                                if (myRank != null) MyRankCard(myRank: myRank),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: _buildListSection(remaining.cast(), currentUserId),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  LeaderboardPodium(topThree: topThree.cast()),
                                  const SizedBox(height: 24),
                                  _buildListSection(remaining.cast(), currentUserId, isPortrait: true),
                                ],
                              ),
                            ),
                          ),
                          if (myRank != null) MyRankCard(myRank: myRank),
                        ],
                      );

                return RefreshIndicator(
                  onRefresh: () async => _loadData(),
                  child: content,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildListSection(List<dynamic> remaining, String? currentUserId, {bool isPortrait = false}) {
    return Container(
      margin: isPortrait ? const EdgeInsets.symmetric(horizontal: 16) : const EdgeInsets.only(top: 24, right: 24, bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3FA),
        borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 16),
          Expanded(
            child: remaining.isEmpty
                ? const Center(child: Text('Belum ada peringkat lainnya.'))
                : ListView.builder(
                    itemCount: remaining.length,
                    itemBuilder: (context, index) {
                      final entry = remaining[index];
                      return LeaderboardItemTile(
                        entry: entry,
                        rank: index + 4,
                        isCurrentUser: entry.userId == currentUserId,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
