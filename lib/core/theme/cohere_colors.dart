import 'package:flutter/material.dart';

abstract final class CohereColors {
  // === Accent ===
  static const Color accent = Color(0xFF003C33);
  static const Color accentDark = Color(0xFF00897B);
  static const Color accentSoft = Color(0xFFEDFCE9);
  static const Color accentSoftDark = Color(0x2200897B);

  // === Light surfaces ===
  static const Color canvas = Color(0xFFFFFFFF);
  static const Color softStone = Color(0xFFEEECE7);
  static const Color surfElev = Color(0xFFFAFAFA);

  // === Dark surfaces ===
  static const Color darkPage = Color(0xFF0A0A0C);
  static const Color darkCard = Color(0xFF131316);
  static const Color darkStone = Color(0xFF18171A);
  static const Color darkElev = Color(0xFF1C1C20);

  // === Light text ===
  static const Color ink = Color(0xFF212121);
  static const Color slate = Color(0xFF75758A);
  static const Color mutedSlate = Color(0xFF93939F);

  // === Dark text ===
  static const Color inkDark = Color(0xFFF3F3F1);
  static const Color inkDimDark = Color(0xFF9999A1);
  static const Color inkMuteDark = Color(0xFF6B6B75);

  // === Rules ===
  static const Color hairline = Color(0xFFD9D9DD);
  static const Color hairlineSoft = Color(0xFFECECEC);
  static const Color darkRule = Color(0x14FFFFFF);
  static const Color darkRuleSoft = Color(0x0DFFFFFF);

  // === Tab bar ===
  static const Color tabBgLight = Color(0xDBFFFFFF);
  static const Color tabBorderLight = Color(0x0F000000);
  static const Color tabBgDark = Color(0xE1141416);
  static const Color tabBorderDark = Color(0x0FFFFFFF);

  // === Semantic helpers ===
  static Color surfRule(Brightness b) =>
      b == Brightness.dark ? darkRule : hairline;

  static Color surfRuleSoft(Brightness b) =>
      b == Brightness.dark ? darkRuleSoft : hairlineSoft;

  static Color inkColor(Brightness b) =>
      b == Brightness.dark ? inkDark : ink;

  static Color inkDim(Brightness b) =>
      b == Brightness.dark ? inkDimDark : slate;

  static Color inkMute(Brightness b) =>
      b == Brightness.dark ? inkMuteDark : mutedSlate;

  static Color surfPage(Brightness b) =>
      b == Brightness.dark ? darkPage : canvas;

  static Color surfCard(Brightness b) =>
      b == Brightness.dark ? darkCard : canvas;

  static Color surfStone(Brightness b) =>
      b == Brightness.dark ? darkStone : softStone;

  static Color surfElevColor(Brightness b) =>
      b == Brightness.dark ? darkElev : surfElev;

  static Color accentColor(Brightness b) =>
      b == Brightness.dark ? accentDark : accent;

  static Color accentSoftColor(Brightness b) =>
      b == Brightness.dark ? accentSoftDark : accentSoft;
}
