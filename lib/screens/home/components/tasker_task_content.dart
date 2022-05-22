import 'package:flutter/material.dart';
import '../../../routes/route_names.dart';
import '../../../widgets/display_date_time.dart';
import 'home_task.dart';
import '../../../core/task/task.dart';
import '../../../main.dart';

class TaskerTaskContent extends StatefulWidget {
  const TaskerTaskContent({Key? key}) : super(key: key);

  @override
  State<TaskerTaskContent> createState() => _TaskerTaskContentState();
}

class _TaskerTaskContentState extends State<TaskerTaskContent> {
  final _now = DateTime.now();
  final List<TaskModel> _tasks = [
    TaskModel.fromJson({
      '_id': '0',
      'type': 'Dọn dẹp theo giờ',
      'date': 1653038175000,
      'start_time': 1653038175000,
      'end_time': 1653045375000,
      'address': '358/12/33 Lư Cấm, Ngọc Hiệp',
      'distance': '4km',
      'status': '',
      'bill': 300000,
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
      'status': '',
      'bill': 300000,
      'created_time': 1652859350000,
      'updated_time': 1652859350000,
    }),
    TaskModel.fromJson({
      '_id': '2',
      'type': 'Dọn dẹp theo giờ',
      'date': 1653056175000,
      'start_time': 1653056175000,
      'end_time': 1653066975000,
      'address': '358/12/33 Lư Cấm, Ngọc Hiệp',
      'distance': '4km',
      'status': '',
      'bill': 300000,
      'created_time': 1652859350000,
      'updated_time': 1652859350000,
    }),
  ];
  final _nearestTasks = <TaskModel>[];
  final _upComingTasks = <TaskModel>[];
  @override
  Widget build(BuildContext context) {
    _nearestTasks.addAll(_tasks
        .where((e) => e.startTime <= _now.millisecondsSinceEpoch)
        .toList());
    if (_tasks.where((e) {
      final startTime = DateTime.fromMillisecondsSinceEpoch(e.startTime);
      final date = DateTime.fromMillisecondsSinceEpoch(e.date);
      return date.difference(_now).inDays == 0 && startTime.isAfter(_now);
    }).isNotEmpty) {
      _nearestTasks.add(_tasks.firstWhere((e) {
        final startTime = DateTime.fromMillisecondsSinceEpoch(e.startTime);
        final date = DateTime.fromMillisecondsSinceEpoch(e.date);
        return date.difference(_now).inDays == 0 && startTime.isAfter(_now);
      }));
    }
    _upComingTasks.addAll(_tasks);
    _upComingTasks.removeWhere(
        (e) => _nearestTasks.where((n) => n.id == e.id).isNotEmpty);
    return LayoutBuilder(builder: (context, size) {
      return ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          if (_nearestTasks.isNotEmpty && _upComingTasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Text(
                'Công việc gần nhất',
                style: AppTextTheme.mediumHeaderTitle(AppColor.text7),
              ),
            ),
          if (_nearestTasks.isNotEmpty) _buildNearestTasks(),
          if (_nearestTasks.isNotEmpty && _upComingTasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Divider(
                thickness: 1.5,
                color: AppColor.shade1,
              ),
            ),
          if (_nearestTasks.isNotEmpty && _upComingTasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Text(
                'Công việc sắp tới',
                style: AppTextTheme.mediumHeaderTitle(AppColor.text7),
              ),
            ),
          if (_upComingTasks.isNotEmpty) _buildUpComingTasks(),
        ],
      );
    });
  }

  Widget _buildNearestTasks() {
    return LayoutBuilder(builder: (context, size) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: _nearestTasks.length,
        itemBuilder: (BuildContext context, index) {
          final task = _nearestTasks[index];
          final startTime = DateTime.fromMillisecondsSinceEpoch(task.startTime);
          final date = DateTime.fromMillisecondsSinceEpoch(task.date);
          final bool isInProgress =
              date.difference(_now).inDays <= 0 && startTime.isBefore(_now);
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              constraints: BoxConstraints(
                minHeight: 294,
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
                taskHeader: _taskHeader(
                  task: task,
                  tagTitle: Text(
                    isInProgress ? 'Đang diễn ra' : 'Hôm nay',
                    style: AppTextTheme.mediumHeaderTitle(
                      isInProgress ? AppColor.shade9 : AppColor.primary2,
                    ),
                  ),
                ),
                taskContent: _taskContent(task),
                taskActions: _taskActions(
                  task: task,
                  isInProgress: isInProgress,
                  onPressed: () {
                    navigateTo(workingTaskRoute);
                  },
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildUpComingTasks() {
    return LayoutBuilder(builder: (context, size) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: _upComingTasks.length,
        itemBuilder: (BuildContext context, index) {
          final task = _upComingTasks[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              constraints: BoxConstraints(
                minHeight: 294,
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
                taskHeader: _taskHeader(
                  task: task,
                  tagTitle: Text(
                    'Sắp diễn ra',
                    style: AppTextTheme.mediumHeaderTitle(
                      AppColor.primary2,
                    ),
                  ),
                ),
                taskContent: _taskContent(task),
                taskActions: _taskActions(
                  task: task,
                  onPressed: () {
                    navigateTo(toDoTaskRoute);
                  },
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _taskHeader({
    required TaskModel task,
    required Widget tagTitle,
  }) {
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
                  task.type,
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
              color: AppColor.shade1,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 10,
              ),
              child: tagTitle,
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
      displayedFormat: 'E, dd/MM/yyyy',
    );
    return Column(
      children: [
        _taskDetail(
          svgIcon: SvgIcons.time,
          title: '$startTime - $endTime',
        ),
        _taskDetail(
          svgIcon: SvgIcons.calendar,
          title: date,
        ),
        _taskDetail(
          svgIcon: SvgIcons.location,
          title: task.address,
        ),
        _taskDetail(
          svgIcon: SvgIcons.dollar1,
          title: '${task.bill} VND',
        ),
      ],
    );
  }

  Widget _taskDetail({
    IconData? icon,
    SvgIconData? svgIcon,
    String? title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
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
          Center(
            child: Text(
              title ?? '',
              style: AppTextTheme.mediumBodyText(AppColor.text1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskActions({
    required TaskModel task,
    bool isInProgress = false,
    Function()? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: AppButtonTheme.outlineRounded(
        constraints: const BoxConstraints(minHeight: 56),
        outlineColor: isInProgress ? AppColor.shade9 : AppColor.primary2,
        color: isInProgress ? AppColor.shade9 : null,
        borderRadius: BorderRadius.circular(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Xem chi tiết',
              style: AppTextTheme.headerTitle(
                isInProgress ? AppColor.white : AppColor.primary2,
              ),
            ),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
