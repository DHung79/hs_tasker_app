import 'package:flutter/material.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../widgets/cancel_task_dialog.dart';
import '../../widgets/contact_dialog.dart';
import '../../widgets/jt_task_detail.dart';
import '../../core/task/task.dart';
import '../../main.dart';
import '../../widgets/display_date_time.dart';
import '../../widgets/jt_indicator.dart';
import '../../widgets/jt_toast.dart';
import '../layout_template/content_screen.dart';
import 'components/remider_dialog.dart';

class ToDoTaskScreen extends StatefulWidget {
  final String id;
  const ToDoTaskScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ToDoTaskScreen> createState() => _ToDoTaskScreenState();
}

class _ToDoTaskScreenState extends State<ToDoTaskScreen> {
  final _pageState = PageState();
  final _scrollController = ScrollController();
  bool _showList = true;
  final _taskBloc = TaskBloc();

  @override
  void initState() {
    JTToast.init(context);
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    _taskBloc.fetchDataById(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    _taskBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return PageTemplate(
      pageState: _pageState,
      onUserFetched: (user) => setState(() {}),
      appBarHeight: 0,
      child: FutureBuilder(
          future: _pageState.currentUser,
          builder: (context, AsyncSnapshot<TaskerModel> snapshot) {
            return PageContent(
              pageState: _pageState,
              onFetch: () {
                _fetchDataOnPage();
              },
              child:
                  snapshot.hasData ? _toDoPage(snapshot) : const JTIndicator(),
            );
          }),
    );
  }

  Widget _toDoPage(AsyncSnapshot<TaskerModel> snapshot) {
    return StreamBuilder(
        stream: _taskBloc.taskData,
        builder: (context, AsyncSnapshot<ApiResponse<TaskModel?>> snapshot) {
          if (snapshot.hasData) {
            final task = snapshot.data!.model!;
            return Scaffold(
              backgroundColor: AppColor.shade1,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: _appBar(task),
              ),
              body: _buildContent(task),
            );
          }
          return const JTIndicator();
        });
  }

  Widget _appBar(TaskModel task) {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0.16,
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppButtonTheme.fillRounded(
                constraints: const BoxConstraints(maxWidth: 40),
                color: AppColor.transparent,
                highlightColor: AppColor.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 28, 0, 24),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: AppColor.black,
                    ),
                  ),
                ),
                onPressed: () {
                  navigateTo(homeRoute);
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 24.5, 10, 16.5),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 39),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'Công việc sắp tới',
                          style: AppTextTheme.subText(AppColor.primary1),
                        ),
                      ),
                      Text(
                        task.service.name,
                        style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 16, 16),
            child: AppButtonTheme.fillRounded(
                constraints: const BoxConstraints(minHeight: 40),
                color: AppColor.shade1,
                borderRadius: BorderRadius.circular(50),
                highlightColor: AppColor.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Hủy công việc',
                    style: AppTextTheme.mediumHeaderTitle(AppColor.others1),
                  ),
                ),
                onPressed: () {
                  _cancelTaskDialog(task);
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(TaskModel task) {
    return LayoutBuilder(
      builder: (context, size) {
        return SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _customerContact(task),
            ),
            _taskDetails(task),
          ]),
        );
      },
    );
  }

  Widget _customerContact(TaskModel task) {
    return Container(
      color: AppColor.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
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
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Khách hàng',
                      style: AppTextTheme.subText(AppColor.primary1),
                    ),
                  ),
                  Text(
                    task.user.name,
                    style: AppTextTheme.mediumBodyText(AppColor.black),
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
            child: AppButtonTheme.fillRounded(
                constraints: const BoxConstraints(minHeight: 44),
                color: AppColor.primary2,
                borderRadius: BorderRadius.circular(50),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SvgIcon(
                    SvgIcons.message,
                    size: 24,
                    color: AppColor.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Liên lạc',
                      style: AppTextTheme.mediumHeaderTitle(
                        AppColor.white,
                      ),
                    ),
                  ),
                ]),
                onPressed: () {
                  _showContact(task);
                }),
          ),
        ],
      ),
    );
  }

  Widget _taskDetails(TaskModel task) {
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
    return Container(
      color: AppColor.white,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: JTTaskDetail.taskDetailBox(
            svgIcon: SvgIcons.locationOutline,
            headerTitle: 'Địa chỉ',
            contentTitle: task.address,
            boxColor: AppColor.shade2,
            button: AppButtonTheme.fillRounded(
              constraints: const BoxConstraints(minHeight: 44),
              color: AppColor.shade5,
              borderRadius: BorderRadius.circular(50),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SvgIcon(
                  SvgIcons.navigation,
                  size: 24,
                  color: AppColor.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Chỉ đường',
                    style: AppTextTheme.mediumHeaderTitle(
                      AppColor.white,
                    ),
                  ),
                ),
              ]),
              onPressed: () {
                navigateTo(mapRoute);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: JTTaskDetail.taskDetailBox(
            svgIcon: SvgIcons.time,
            headerTitle: 'Thời gian làm',
            contentTitle: '$date, từ $startTime đến $endTime',
            boxColor: AppColor.shade2,
            button: AppButtonTheme.outlineRounded(
                constraints: const BoxConstraints(minHeight: 44),
                color: AppColor.white,
                outlineColor: AppColor.shade5,
                borderRadius: BorderRadius.circular(50),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SvgIcon(
                    SvgIcons.notifications,
                    size: 24,
                    color: AppColor.shade5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Đặt lời nhắc',
                      style: AppTextTheme.mediumHeaderTitle(
                        AppColor.shade5,
                      ),
                    ),
                  ),
                ]),
                onPressed: () {
                  _remiderDialog();
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: JTTaskDetail.taskDetail(
            svgIcon: SvgIcons.dollar,
            headerTitle: 'Tổng tiền',
            contentTitle: '${task.totalPrice} VND',
            backgroundColor: AppColor.shade2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: JTTaskDetail.taskDetail(
            svgIcon: SvgIcons.home2,
            headerTitle: 'Loại nhà',
            contentTitle: getHomeType(task.typeHome),
            backgroundColor: AppColor.shade2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: JTTaskDetail.taskDetail(
            svgIcon: SvgIcons.notebook,
            headerTitle: 'Ghi chú',
            contentTitle: task.note,
            backgroundColor: AppColor.shade2,
          ),
        ),
        if (task.checkList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            child: JTTaskDetail.taskDetailList(
              svgIcon: SvgIcons.listCheck,
              headerTitle: 'Danh sách kiểm tra',
              contentList: Text(
                task.checkList.map((e) {
                  return ' \u2022 $e \n';
                }).toString(),
                style: AppTextTheme.mediumHeaderTitle(AppColor.black),
              ),
              backgroundColor: AppColor.shade2,
              showList: _showList,
              onTap: () {
                setState(() {
                  _showList = !_showList;
                });
              },
            ),
          ),
      ]),
    );
  }

  _remiderDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black12,
        builder: (BuildContext context) {
          return const RemiderDialog();
        });
  }

  _showContact(TaskModel task) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        builder: (context) {
          return ContactDialog(user: task.user);
        });
  }

  _cancelTaskDialog(TaskModel task) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black12,
        builder: (BuildContext context) {
          return CancelTaskDialog(
              task: task,
              contentHeader: Text(
                'Bạn có chắc chắn hủy công việc?',
                style: AppTextTheme.normalText(AppColor.black),
              ),
              accountBalances: '${task.totalPrice} VND',
              onConfirmed: () {
                _cancelTask(task);
              });
        });
  }

  _cancelTask(TaskModel task) {
    _taskBloc
        .cancelTask(task.id)
        .then((value) => navigateTo(homeRoute))
        .onError((ApiError error, stackTrace) {
      setState(() {
        logDebug(error.errorMessage);
        JTToast.errorToast(message: showError(error.errorCode, context));
      });
    }).catchError(
      (error, stackTrace) {
        setState(() {
          logDebug(error.toString());
          JTToast.errorToast(message: error.toString());
        });
      },
    );
  }

  _fetchDataOnPage() {}
}
