import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextTheme {
  static TextStyle h0 = TextStyle(
    fontSize: 30,
    color: AppColor.text1,
    fontWeight: FontWeight.bold,
  );
  static TextStyle h1 = TextStyle(
    fontSize: 22,
    color: AppColor.text1,
    fontWeight: FontWeight.bold,
  );
  static TextStyle h2 = TextStyle(
    fontSize: 24,
    color: AppColor.text1,
    fontWeight: FontWeight.bold,
  );
  static TextStyle h3 = TextStyle(
    fontSize: 18,
    color: AppColor.text1,
    fontWeight: FontWeight.bold,
  );
  static TextStyle h4 = TextStyle(
    fontSize: 16,
    color: AppColor.text1,
    fontWeight: FontWeight.bold,
  );
  static TextStyle h5 = TextStyle(
    fontSize: 14,
    color: AppColor.text1,
    fontWeight: FontWeight.bold,
  );
  static TextStyle h0White = TextStyle(
    fontSize: 30,
    color: AppColor.text2,
  );
  static TextStyle h1White = TextStyle(
    fontSize: 22,
    color: AppColor.text2,
    fontWeight: FontWeight.bold,
  );
  static TextStyle h2White = TextStyle(
    fontSize: 20,
    color: AppColor.text2,
    fontWeight: FontWeight.bold,
  );
  static TextStyle h3White = TextStyle(
    fontSize: 18,
    color: AppColor.text2,
    fontWeight: FontWeight.bold,
  );
  static TextStyle h4White = TextStyle(
    fontSize: 16,
    color: AppColor.text2,
    fontWeight: FontWeight.bold,
  );
  static TextStyle title1 = TextStyle(
    fontSize: 18,
    color: AppColor.text1,
  );
  static TextStyle title1White = TextStyle(
    fontSize: 18,
    color: AppColor.text2,
  );
  static TextStyle title2 = TextStyle(
    fontSize: 16,
    color: AppColor.text1,
  );
  static TextStyle title2White = TextStyle(
    fontSize: 16,
    color: AppColor.text2,
  );
  static TextStyle title3 = TextStyle(
    fontSize: 14,
    color: AppColor.text1,
  );
  static TextStyle title3White = TextStyle(
    fontSize: 14,
    color: AppColor.text2,
  );
  static TextStyle title4 = TextStyle(
    fontSize: 12,
    color: AppColor.text1,
  );
  static TextStyle title4White = TextStyle(
    fontSize: 12,
    color: AppColor.text2,
  );
  static TextStyle subtitle1White = TextStyle(
    fontSize: 14,
    color: AppColor.text2.withOpacity(0.6),
  );
  static TextStyle subtitle3 = TextStyle(
    fontSize: 14,
    color: AppColor.text2,
  );
  static TextStyle linkTitleWhite = TextStyle(
    fontSize: 14,
    color: AppColor.text2,
  );
  static TextStyle content = TextStyle(
    fontSize: 16,
    color: AppColor.text1,
  );
  static TextStyle contentWhite = TextStyle(
    fontSize: 16,
    color: AppColor.text2,
  );

  static TextStyle jTTextFormField = GoogleFonts.lexend(
    fontWeight: FontWeight.w500,
    color: AppColor.text2,
  );

  static TextStyle forgotPassword = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontSize: 14,
    decoration: TextDecoration.underline,
  );

  static TextStyle login = GoogleFonts.lexend(
    fontWeight: FontWeight.w700,
    color: AppColor.primary1,
    fontSize: 16,
  );
}
