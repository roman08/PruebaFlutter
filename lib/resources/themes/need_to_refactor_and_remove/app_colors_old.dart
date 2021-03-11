import 'package:flutter/material.dart';

class AppColorsOld {
  final Color primaryBlue;
  final Color darkShade;
  final Color boldShade;
  final Color midShade;
  final Color lightShade;
  final Color extraLightShade;
  final Color thinShade;
  final Color white;
  final Color green;
  final Color red;

  AppColorsOld({
    this.primaryBlue,
    this.darkShade,
    this.boldShade,
    this.midShade,
    this.lightShade,
    this.extraLightShade,
    this.thinShade,
    this.white,
    this.green,
    this.red,
  });

  factory AppColorsOld.defaultColors() => _defaultColors();
}

AppColorsOld _defaultColors() {
  return AppColorsOld(
    primaryBlue: const Color(0xFFFF0000),
    green: const Color(0xFF17D970),
    darkShade: const Color(0xFF333333),
    boldShade: const Color(0xFFFF8D8D),
    midShade: const Color(0xFFDCE4FF),
    lightShade: const Color(0xFFD6E6EC),
    extraLightShade: const Color(0xFFEEF2FE),
    thinShade: const Color(0xFFF9FBFD),
    white: Colors.white,
    red: Colors.red,
  );
}
