import 'package:equatable/equatable.dart';

class MyRankEntity extends Equatable {
  final int rank;
  final int totalScore;
  final int totalGames;

  const MyRankEntity({
    required this.rank,
    required this.totalScore,
    required this.totalGames,
  });

  @override
  List<Object?> get props => [rank, totalScore, totalGames];
}
