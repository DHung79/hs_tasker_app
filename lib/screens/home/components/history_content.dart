import 'dart:math';
import 'package:flutter/material.dart';
import '../../../routes/route_names.dart';
import '../../../core/task/task.dart';
import '../../../main.dart';
import '../../../widgets/display_date_time.dart';
import '../../../widgets/jt_task_detail.dart';
import 'home_task.dart';

class HistoryContent extends StatefulWidget {
  const HistoryContent({Key? key}) : super(key: key);

  @override
  State<HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> {
  final List<TaskModel> tasks = [
    TaskModel.fromJson({
      '_id': '0',
      'type': 'Dọn dẹp theo giờ',
      'date': 1653038175000,
      'start_time': 1653038175000,
      'end_time': 1653045375000,
      'address': '358/12/33 Lư Cấm, Ngọc Hiệp',
      'distance': '4km',
      'status': 'Hoàn thành',
      'bill': 300000,
      'user': {'name': 'Nancy Jewel McDonie'},
      'created_time': 1652859350000,
      'updated_time': 1652859350000,
    }),
    TaskModel.fromJson({
      '_id': '1',
      'type': 'Dọn dẹp theo giờ',
      'date': 1653131775000,
      'start_time': 1653131775000,
      'end_time': 1653142575000,
      'address': '358/12/33 Lư Cấm, Ngọc Hiệp',
      'distance': '4km',
      'status': 'Bị hủy bỏ',
      'bill': 300000,
      'user': {'name': 'Nancy Jewel McDonie'},
      'created_time': 1652859350000,
      'updated_time': 1652859350000,
    }),
  ];
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, index) {
          final task = tasks[index];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              constraints: BoxConstraints(
                minHeight: 408,
                minWidth: size.maxWidth - 32,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadow.withOpacity(0.16),
                    blurRadius: 24,
                    spreadRadius: 0.16,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: HomeTask(
                taskHeader: _taskHeader(task),
                taskContent: _taskContent(task),
                taskActions: _taskActions(task),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _taskHeader(
    TaskModel task,
  ) {
    return Container(
      constraints: const BoxConstraints(minHeight: 42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  task.service.name,
                  style: AppTextTheme.mediumHeaderTitle(AppColor.primary1),
                ),
              ),
              Text(
                formatFromInt(
                  value: task.date,
                  context: context,
                  displayedFormat: 'dd/MM/yyyy',
                ),
                style: AppTextTheme.normalText(AppColor.text7),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: task.status == 3 ? AppColor.shade9 : AppColor.others1,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 10,
              ),
              child: Text(
                task.status.toString(),
                style: AppTextTheme.mediumHeaderTitle(AppColor.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskContent(TaskModel task) {
    final startTime = formatFromInt(
      value: task.startTime,
      context: context,
      displayedFormat: 'HH:mm',
    );
    final endTime = formatFromInt(
      value: task.endTime,
      context: context,
      displayedFormat: 'HH:mm',
    );
    final date = formatFromInt(
      value: task.date,
      context: context,
      displayedFormat: 'dd/MM/yyyy',
    );
    return Column(
      children: [
        JTTaskDetail.taskDetail(
          svgIcon: SvgIcons.dollar1,
          headerTitle: 'Tổng tiền',
          contentTitle: '${task.totalPrice} VND',
          backgroundColor: AppColor.shade2,
        ),
        JTTaskDetail.taskDetail(
          svgIcon: SvgIcons.time,
          headerTitle: 'Thời gian',
          contentTitle: 'Từ $startTime đến $endTime, $date',
          backgroundColor: AppColor.shade2,
        ),
        JTTaskDetail.taskDetail(
          svgIcon: SvgIcons.location,
          headerTitle: 'Địa chỉ',
          contentTitle: task.address,
          backgroundColor: AppColor.shade2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Divider(
            thickness: 1.5,
            color: AppColor.shade1,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 44,
                  height: 44,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Khách hàng',
                    style: AppTextTheme.normalText(AppColor.primary1),
                  ),
                ),
                Text(
                  task.user.name,
                  style: AppTextTheme.mediumBodyText(AppColor.black),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _taskActions(TaskModel task) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Divider(
            thickness: 1.5,
            color: AppColor.shade1,
          ),
        ),
        AppButtonTheme.outlineRounded(
          constraints: const BoxConstraints(minHeight: 56),
          outlineColor: AppColor.primary2,
          borderRadius: BorderRadius.circular(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Xem chi tiết',
                style: AppTextTheme.mediumHeaderTitle(AppColor.primary2),
              ),
              if (homeTabIndex != 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Transform.rotate(
                    angle: 180 * pi / 180,
                    child: SvgIcon(
                      SvgIcons.arrowBack,
                      color: AppColor.primary2,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () {
            navigateTo(taskHistoryRoute);
          },
        ),
      ],
    );
  }
}
