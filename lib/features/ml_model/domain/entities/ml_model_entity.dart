import 'package:equatable/equatable.dart';

class MLModelEntity extends Equatable {
  final String id;
  final String name;
  final String version;
  final String fileUrl;
  final int inputSize;
  final bool isActive;
  final List<String> labels;

  const MLModelEntity({
    required this.id,
    required this.name,
    required this.version,
    required this.fileUrl,
    required this.inputSize,
    required this.isActive,
    required this.labels,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        version,
        fileUrl,
        inputSize,
        isActive,
        labels,
      ];
}
