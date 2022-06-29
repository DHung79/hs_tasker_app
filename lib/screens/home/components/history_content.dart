import 'dart:math';
import 'package:flutter/material.dart';
import '../../../routes/route_names.dart';
import '../../../core/task/task.dart';
import '../../../main.dart';
import '../../../widgets/display_date_time.dart';
import '../../../widgets/jt_indicator.dart';
import '../../../widgets/jt_task_detail.dart';
import 'home_task.dart';

class HistoryContent extends StatefulWidget {
  final TaskerModel tasker;
  const HistoryContent({
    Key? key,
    required this.tasker,
  }) : super(key: key);

  @override
  State<HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> {
  final _taskBloc = TaskBloc();

  @override
  void initState() {
    _taskBloc.fetchAllData({'tasker': widget.tasker.id});
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
              final historyTasks = tasks.where((e) {
                return e.status >= 2;
              }).toList();
              if (historyTasks.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: historyTasks.length,
                  itemBuilder: (BuildContext context, index) {
                    final task = historyTasks[index];
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
              } else {
                return Center(
                  child: Text(
                    ScreenUtil.t(I18nKey.noData)!,
                    style: AppTextTheme.mediumBodyText(AppColor.black),
                  ),
                );
              }
            }
            return const JTIndicator();
          });
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
                task.status == 3 ? 'Hoàn thành' : 'Bị hủy bỏ',
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
          svgIcon: SvgIcons.dollar,
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
          svgIcon: SvgIcons.locationOutline,
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
                child: task.user.avatar.isNotEmpty
                    ? Image.network(
                        task.user.avatar,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/logo.png",
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
                      SvgIcons.arrowBackIos,
                      color: AppColor.primary2,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () {
            navigateTo(taskHistoryRoute + '/${task.id}');
          },
        ),
      ],
    );
  }
}
