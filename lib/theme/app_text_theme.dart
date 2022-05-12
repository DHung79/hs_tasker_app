import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static TextStyle mediumBigText(Color color) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w500,
      color: color,
      fontSize: 24,
    );
  }

  static TextStyle bigText(Color color) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 24,
    );
  }

  static TextStyle headerTitle(Color color) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w700,
      color: color,
      fontSize: 16,
    );
  }

  static TextStyle mediumHeaderTitle(Color color) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w500,
      color: color,
      fontSize: 16,
    );
  }

  static TextStyle normalHeaderTitle(Color color) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 16,
    );
  }

  static TextStyle boldBodyText(Color color) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w700,
      color: color,
      fontSize: 14,
    );
  }

  static TextStyle mediumBodyText(Color color) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w500,
      color: color,
      fontSize: 14,
    );
  }

  static TextStyle normalText(Color color) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 14,
    );
  }

  static TextStyle link(Color color) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 14,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle superscript(Color color) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 14,
      fontFeatures: [
        const FontFeature.enable('sups'),
      ],
    );
  }

  static TextStyle subText(Color color) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 12,
    );
  }

  static TextStyle superSmallText(Color color) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 10,
    );
  }
}
