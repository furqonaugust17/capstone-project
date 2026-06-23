import 'package:flutter/material.dart';
import 'package:app/features/mode/presentation/sections/mode_scene_section.dart';

import 'package:app/shared/widgets/custom_app_bar.dart';

class ModePage extends StatelessWidget {
  final dynamic selectedAnimal;

  const ModePage({super.key, this.selectedAnimal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'MODE'),
      body: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Center(child: ModeSceneSection(selectedAnimal: selectedAnimal)),
      ),
    );
  }
}
