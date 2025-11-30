import 'package:flutter/material.dart';

/// Centralized design tokens for spacing, radius, elevations, durations.
class DT {
  // Spacing scale (8px baseline)
  static const s0 = 0.0;
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 20.0;
  static const s6 = 24.0;
  static const s7 = 32.0;
  static const s8 = 40.0;
  static const s9 = 56.0;

  // Border radius
  static const rXs = 4.0;
  static const rSm = 8.0;
  static const rMd = 12.0;
  static const rLg = 20.0;
  static const rXl = 28.0;
  static const rFull = 999.0;

  // Elevations as shadows
  static const shadowSm = [
    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
  ];
  static const shadowMd = [
    BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 6)),
  ];
  static const shadowLg = [
    BoxShadow(color: Colors.black38, blurRadius: 28, offset: Offset(0, 10)),
  ];

  // Durations
  static const dFast = Duration(milliseconds: 150);
  static const dBase = Duration(milliseconds: 280);
  static const dSlow = Duration(milliseconds: 500);
}
