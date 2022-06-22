import 'package:flutter/material.dart';
import '../../../routes/route_names.dart';
import '../../../widgets/display_date_time.dart';
import '../../../widgets/jt_indicator.dart';
import 'home_task.dart';
import '../../../core/task/task.dart';
import '../../../main.dart';

class TaskerTaskContent extends StatefulWidget {
  final TaskerModel tasker;
  const TaskerTaskContent({
    Key? key,
    required this.tasker,
  }) : super(key: key);

  @override
  State<TaskerTaskContent> createState() => _TaskerTaskContentState();
}

class _TaskerTaskContentState extends State<TaskerTaskContent> {
  final _now = DateTime.now();
  final _nearestTasks = <TaskModel>[];
  final _upComingTasks = <TaskModel>[];
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
              _nearestTasks.addAll(tasks.where((e) {
                final date = DateTime.fromMillisecondsSinceEpoch(e.date);
                return date.difference(_now).inDays <= 0 &&
                    e.startTime <= _now.millisecondsSinceEpoch;
              }).toList());
              if (tasks.where((e) {
                final startTime =
                    DateTime.fromMillisecondsSinceEpoch(e.startTime);
                final date = DateTime.fromMillisecondsSinceEpoch(e.date);
                return date.difference(_now).inDays == 0 &&
                    startTime.isAfter(_now);
              }).isNotEmpty) {
                _nearestTasks.add(tasks.firstWhere((e) {
                  final startTime =
                      DateTime.fromMillisecondsSinceEpoch(e.startTime);
                  final date = DateTime.fromMillisecondsSinceEpoch(e.date);
                  return date.difference(_now).inDays == 0 &&
                      startTime.isAfter(_now);
                }));
              }
              _upComingTasks.addAll(tasks);
              _upComingTasks.removeWhere(
                  (e) => _nearestTasks.where((n) => n.id == e.id).isNotEmpty);
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
            }
            return const JTIndicator();
          });
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
          svgIcon: SvgIcons.locationOutline,
          title: task.address,
        ),
        _taskDetail(
          svgIcon: SvgIcons.dollar,
          title: '${task.totalPrice} VND',
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
          Expanded(
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
