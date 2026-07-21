import 'package:equatable/equatable.dart';

class PredictionEntity extends Equatable {
  final String label;
  final double confidence;
  final List<double> rawScores;
  final Duration inferenceDuration;

  const PredictionEntity({
    required this.label,
    required this.confidence,
    required this.rawScores,
    required this.inferenceDuration,
  });

  @override
  List<Object?> get props => <Object?>[
    label,
    confidence,
    rawScores,
    inferenceDuration,
  ];
}
