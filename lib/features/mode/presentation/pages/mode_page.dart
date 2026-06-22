import 'package:flutter/material.dart';
import 'package:app/features/mode/presentation/sections/mode_scene_section.dart';

class ModePage extends StatelessWidget {
  final dynamic selectedAnimal;

  const ModePage({super.key, this.selectedAnimal});

  @override
  Widget build(BuildContext context) {
    // Use a fixed artboard size and FittedBox for responsiveness (matches other pages)
    const artboardWidth = 917.0;
    const artboardHeight = 412.0;

    return Scaffold(
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: artboardWidth,
            height: artboardHeight,
            child: ModeSceneSection(selectedAnimal: selectedAnimal),
          ),
        ),
      ),
    );
  }
}
