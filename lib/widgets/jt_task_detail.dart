import 'dart:math';
import 'package:flutter/material.dart';
import '../main.dart';

class JTTaskDetail {
  static Widget taskDetail({
    IconData? icon,
    SvgIconData? svgIcon,
    String? contentTitle,
    String? headerTitle,
    Color? backgroundColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  headerTitle ?? '',
                  style: AppTextTheme.normalText(AppColor.shade5),
                ),
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

  static Widget taskDetailBox({
    IconData? icon,
    SvgIconData? svgIcon,
    String? contentTitle,
    String? headerTitle,
    Color? boxColor,
    double radius = 10,
    BoxConstraints constraints = const BoxConstraints(minHeight: 136),
    required Widget button,
  }) {
    return LayoutBuilder(builder: (context, size) {
      return Container(
        constraints: constraints,
        decoration: BoxDecoration(
          color: boxColor ?? AppColor.shade2,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  constraints: BoxConstraints(maxWidth: size.maxWidth - 32),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColor.white,
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                headerTitle ?? '',
                                style: AppTextTheme.subText(AppColor.shade5),
                              ),
                            ),
                            Text(
                              contentTitle ?? '',
                              style: AppTextTheme.mediumHeaderTitle(
                                  AppColor.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              button,
            ],
          ),
        ),
      );
    });
  }

  static Widget taskDetailList({
    IconData? icon,
    SvgIconData? svgIcon,
    String? contentTitle,
    String? headerTitle,
    Color? backgroundColor,
    double radius = 10,
    BoxConstraints constraints = const BoxConstraints(minHeight: 76),
    Function()? onTap,
    bool showList = true,
  }) {
    final double angle = showList ? 180 : 0;
    return LayoutBuilder(builder: (context, size) {
      return Container(
        constraints: constraints,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColor.shade2,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: size.maxWidth - 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColor.white,
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  headerTitle ?? '',
                                  style:
                                      AppTextTheme.subText(AppColor.shade5),
                                ),
                              ),
                              InkWell(
                                child: Transform.rotate(
                                  angle: angle * pi / 180,
                                  child: SvgIcon(
                                    SvgIcons.keyboardDown,
                                    color: AppColor.black,
                                    size: 24,
                                  ),
                                ),
                                onTap: onTap,
                              ),
                            ],
                          ),
                          if(showList)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              contentTitle ?? '',
                              style: AppTextTheme.mediumHeaderTitle(
                                  AppColor.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
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
