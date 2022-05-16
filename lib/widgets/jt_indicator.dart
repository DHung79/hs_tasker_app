import 'package:flutter/material.dart';

class JTIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  const JTIndicator({
    Key? key,
    this.size = 24,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: color,
        ),
      ),
    );
  }
}
