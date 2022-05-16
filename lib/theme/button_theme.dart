import 'package:flutter/material.dart';

class AppButtonTheme {
  static Widget underLine({
    required Widget child,
    void Function()? onPressed,
    Color? color,
    Color lineColor = Colors.white,
    double lineWidth = 1,
    BoxConstraints? constraints,
  }) {
    return Container(
      constraints: constraints,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: lineWidth,
            color: lineColor,
          ),
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  static Widget fillRounded({
    required Widget child,
    void Function()? onPressed,
    Color? color,
    Color? highlightColor,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    BoxConstraints? constraints,
  }) {
    return Container(
      constraints: constraints,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          primary: highlightColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  static Widget outlineRounded({
    required Widget child,
    void Function()? onPressed,
    Color? color,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    Color outlineColor = Colors.white,
    double borderWidth = 1,
    BoxConstraints? constraints,
  }) {
    return Container(
      constraints: constraints,
      child: TextButton(
        style: TextButton.styleFrom(
          primary: outlineColor,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide(
              width: borderWidth,
              color: outlineColor,
            ),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
