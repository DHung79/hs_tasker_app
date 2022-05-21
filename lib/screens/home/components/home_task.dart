import 'package:flutter/material.dart';
import '../../../main.dart';

class HomeTask extends StatelessWidget {
  final Widget taskHeader;
  final Widget taskContent;
  final Widget taskActions;

  const HomeTask({
    Key? key,
    required this.taskHeader,
    required this.taskContent,
    required this.taskActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            taskHeader,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Divider(
                thickness: 1.5,
                color: AppColor.shade1,
              ),
            ),
            taskContent,
            taskActions,
          ],
        ),
      );
    });
  }
}


