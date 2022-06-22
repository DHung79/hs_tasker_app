import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hs_tasker_app/widgets/jt_indicator.dart';
import '../../../core/task/task.dart';
import '../../../routes/route_names.dart';
import '../../../widgets/display_date_time.dart';
import '../../../widgets/jt_task_detail.dart';
import 'home_task.dart';
import '../../../main.dart';

class NewPostContent extends StatefulWidget {
  const NewPostContent({
    Key? key,
  }) : super(key: key);

  @override
  State<NewPostContent> createState() => _NewPostContentState();
}

class _NewPostContentState extends State<NewPostContent> {
  final _taskBloc = TaskBloc();

  @override
  void initState() {
    _taskBloc.fetchAllData({});
    super.initState();
  }

  @override
  void dispose() {
    _taskBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return StreamBuilder(
          stream: _taskBloc.allData,
          builder:
              (context, AsyncSnapshot<ApiResponse<ListTaskModel?>> snapshot) {
            if (snapshot.hasData) {
              final tasks = snapshot.data!.model!.records;
              return ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, index) {
                  final task = tasks[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
            }
            return const JTIndicator();
          });
    });
  }

  Widget _taskHeader(TaskModel task) {
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
                timeAgoFromNow(task.updatedTime, context),
                style: AppTextTheme.normalText(AppColor.text7),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _taskContent(TaskModel task) {
    final start = DateTime.fromMillisecondsSinceEpoch(task.startTime);
    final end = DateTime.fromMillisecondsSinceEpoch(task.endTime);
    final estimateTime = end.difference(start).inHours;
    final date = formatFromInt(
      value: task.date,
      context: context,
      displayedFormat: 'dd/MM/yyyy',
    );
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
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 59),
          decoration: BoxDecoration(
            color: AppColor.shade2,
            borderRadius: BorderRadius.circular(4),
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _contentHeader(
                      headerTitle: 'Thời lượng',
                      contentTitle: '$estimateTime tiếng ($startTime)',
                    ),
                  ),
                  VerticalDivider(
                    thickness: 2,
                    color: AppColor.shade1,
                  ),
                  Expanded(
                    flex: 1,
                    child: _contentHeader(
                      headerTitle: 'Tổng tiền (VND)',
                      contentTitle: '${task.totalPrice}',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        JTTaskDetail.taskDetail(
          svgIcon: SvgIcons.time,
          headerTitle: 'Thời gian làm',
          contentTitle: '$date, từ $startTime đến $endTime',
        ),
        JTTaskDetail.taskDetail(
          svgIcon: SvgIcons.locationOutline,
          headerTitle: 'Địa chỉ',
          contentTitle: task.address,
        ),
      ],
    );
  }

  Widget _contentHeader({
    String? contentTitle,
    String? headerTitle,
  }) {
    return Column(
      children: [
        Text(
          headerTitle ?? '',
          style: AppTextTheme.subText(AppColor.text3),
        ),
        Text(
          contentTitle ?? '',
          style: AppTextTheme.mediumHeaderTitle(AppColor.primary1),
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
                      SvgIcons.arrowIosBack,
                      color: AppColor.primary2,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () {
            navigateTo(jobDetailRoute);
          },
        ),
      ],
    );
  }
}
