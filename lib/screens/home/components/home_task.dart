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

Widget taskDetail({
  IconData? icon,
  SvgIconData? svgIcon,
  String? contentTitle,
  String? headerTitle,
  Color? backgroundColor,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColor.shade10,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: icon != null
                  ? Icon(
                      icon,
                      size: 20,
                      color: AppColor.shade5,
                    )
                  : SvgIcon(
                      svgIcon,
                      size: 20,
                      color: AppColor.shade5,
                    ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headerTitle ?? '',
              style: AppTextTheme.normalText(AppColor.shade5),
            ),
            Text(
              contentTitle ?? '',
              style: AppTextTheme.mediumBodyText(AppColor.text1),
            ),
          ],
        ),
      ],
    ),
  );
}

class TaskItem {
  final IconData? icon;
  final SvgIconData? svgIcon;
  final String? contentTitle;
  final String? headerTitle;
  TaskItem({
    this.icon,
    this.svgIcon,
    this.contentTitle,
    this.headerTitle,
  });
}
