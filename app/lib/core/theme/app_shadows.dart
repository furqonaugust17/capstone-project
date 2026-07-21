import 'package:flutter/material.dart';

class AppShadows {
  static const soft = BoxShadow(
    color: Color(0x1A000000), // 10% black
    offset: Offset(0, 4),
    blurRadius: 12,
    spreadRadius: 0,
  );

  static const subtle = BoxShadow(
    color: Color(0x0F000000),
    offset: Offset(0, 2),
    blurRadius: 6,
  );

  static List<BoxShadow> card = [
    const BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 1),
      blurRadius: 4,
    ),
  ];
}
