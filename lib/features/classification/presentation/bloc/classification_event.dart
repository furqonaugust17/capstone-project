part of 'classification_bloc.dart';

abstract class ClassificationEvent extends Equatable {
  const ClassificationEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

class ClassificationWarmUpRequested extends ClassificationEvent {
  const ClassificationWarmUpRequested();
}

class ClassificationRequested extends ClassificationEvent {
  final Uint8List imageBytes;
  final bool? forceGrayscale;
  final bool isRawRgba;
  final int? width;
  final int? height;

  const ClassificationRequested({
    required this.imageBytes,
    this.forceGrayscale,
    this.isRawRgba = false,
    this.width,
    this.height,
  });

  @override
  List<Object?> get props => <Object?>[
    imageBytes,
    forceGrayscale,
    isRawRgba,
    width,
    height,
  ];
}

class ClassificationResetRequested extends ClassificationEvent {
  const ClassificationResetRequested();
}
