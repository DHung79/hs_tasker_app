import 'package:flutter/material.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import 'package:intl/intl.dart';
import '../../core/task/task.dart';
import '../../main.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/display_date_time.dart';
import '../../widgets/jt_indicator.dart';
import '../../widgets/jt_task_detail.dart';
import '../layout_template/content_screen.dart';

class JobDetailScreen extends StatefulWidget {
  final String id;
  const JobDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final _pageState = PageState();
  final _scrollController = ScrollController();
  final _taskBloc = TaskBloc();
  final completeStatus = 2;

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    _taskBloc.fetchDataById(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    _taskBloc.dispose();
    super.dispose();
  }

  final isHistory = getCurrentRouteName().startsWith(taskHistoryRoute);

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
              child: snapshot.hasData
                  ? _jobDetailPage(snapshot)
                  : const JTIndicator(),
            );
          }),
    );
  }

  Widget _jobDetailPage(AsyncSnapshot<TaskerModel> snapshot) {
    return StreamBuilder(
        stream: _taskBloc.taskData,
        builder: (context, AsyncSnapshot<ApiResponse<TaskModel?>> snapshot) {
          if (snapshot.hasData) {
            final task = snapshot.data!.model!;
            return Scaffold(
              backgroundColor: AppColor.shade1,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: _appBar(),
              ),
              body: _buildContent(task),
            );
          }
          return const JTIndicator();
        });
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0.16,
      flexibleSpace: Row(
        children: [
          AppButtonTheme.fillRounded(
            constraints: const BoxConstraints(minHeight: 56),
            color: AppColor.transparent,
            highlightColor: AppColor.white,
            child: SvgIcon(
              SvgIcons.arrowBackIos,
              size: 24,
              color: AppColor.black,
            ),
            onPressed: () {
              navigateTo(preRoute);
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'Chi tiết công việc',
                  style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                ),
              ),
            ),
          ),
          AppButtonTheme.fillRounded(
            constraints: const BoxConstraints(minHeight: 56),
            color: AppColor.transparent,
            highlightColor: AppColor.white,
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(TaskModel task) {
    return LayoutBuilder(
      builder: (context, size) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        color: AppColor.white,
                        child: _jobHeader(task),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _basicInfo(task),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _customerRequests(task),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        color: AppColor.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 12, 12, 12),
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
                                  Text(
                                    task.user.name,
                                    style: AppTextTheme.mediumBodyText(
                                        AppColor.black),
                                  ),
                                  Text(
                                    'Đã làm cho khách hàng này 4 lần',
                                    style:
                                        AppTextTheme.subText(AppColor.primary1),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (isHistory) _buildResults(task),
                  ],
                ),
              ),
            ),
            if (!isHistory) _actions(task),
          ],
        );
      },
    );
  }

  Widget _jobHeader(TaskModel task) {
    return LayoutBuilder(builder: (context, size) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 110),
            child: Image.asset(
              'assets/images/logo.png',
              width: size.maxWidth,
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              task.service.name,
              style: AppTextTheme.mediumHeaderTitle(AppColor.black),
            ),
          ),
        ],
      );
    });
  }

  Widget _basicInfo(TaskModel task) {
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
    // final endTime = formatFromInt(
    //   value: task.endTime,
    //   context: context,
    //   displayedFormat: 'HH:mm',
    // );
    final price =
        NumberFormat('#,##0 VND', 'vi').format(task.selectedOption.price);
    return Container(
      constraints: const BoxConstraints(minHeight: 352),
      decoration: BoxDecoration(color: AppColor.white),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Thông tin cơ bản',
                style: AppTextTheme.mediumHeaderTitle(AppColor.black),
              ),
            ),
            if (isHistory)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildInfo(
                  headerTitle: 'Trạng thái',
                  content: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 26),
                      decoration: BoxDecoration(
                        color: task.status == completeStatus
                            ? AppColor.shade9
                            : AppColor.others1,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 10,
                        ),
                        child: Text(
                          task.status == completeStatus
                              ? 'Hoàn thành'
                              : 'Bị hủy bỏ',
                          style: AppTextTheme.mediumHeaderTitle(AppColor.white),
                        ),
                      ),
                    ),
                  ),
                  svgIcon: SvgIcons.dollar,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: JTTaskDetail.taskDetail(
                headerTitle: 'Tổng tiền',
                contentTitle: price,
                svgIcon: SvgIcons.dollar,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: JTTaskDetail.taskDetail(
                headerTitle: 'Thời gian làm',
                contentTitle: '$date, từ $startTime',
                svgIcon: SvgIcons.time,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: JTTaskDetail.taskDetail(
                headerTitle: 'Địa chỉ',
                contentTitle: task.address.name,
                svgIcon: SvgIcons.locationOutline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: JTTaskDetail.taskDetail(
                headerTitle: 'Loại nhà',
                contentTitle: getHomeType(task.typeHome),
                svgIcon: SvgIcons.home2,
              ),
            ),
            // JTTaskDetail.taskDetail(
            //   headerTitle: 'Khoảng cách',
            //   contentTitle: '4km',
            //   svgIcon: SvgIcons.carSide,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _customerRequests(TaskModel task) {
    return Container(
      constraints: const BoxConstraints(minHeight: 296),
      decoration: BoxDecoration(color: AppColor.white),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Yêu cầu từ khách hàng',
                style: AppTextTheme.mediumHeaderTitle(AppColor.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: JTTaskDetail.taskDetail(
                headerTitle: 'Ghi chú',
                contentTitle: task.note,
                svgIcon: SvgIcons.notebook,
              ),
            ),
            if (task.checkList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildInfo(
                  headerTitle: 'Danh sách kiểm tra',
                  checkList: task.checkList,
                  svgIcon: SvgIcons.listCheck,
                ),
              ),
            // JTTaskDetail.taskDetail(
            //   headerTitle: 'Dụng cụ tự mang',
            //   contentTitle: ' \u2022 Chổi\n \u2022 Cây lau nhà',
            //   svgIcon: SvgIcons.broom,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo({
    required String headerTitle,
    Widget? content,
    IconData? icon,
    SvgIconData? svgIcon,
    List<ToDoModel>? checkList,
  }) {
    return LayoutBuilder(builder: (context, size) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColor.shade10,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: icon != null
                    ? Icon(
                        icon,
                        color: AppColor.shade5,
                        size: 24,
                      )
                    : SvgIcon(
                        svgIcon,
                        color: AppColor.shade5,
                        size: 24,
                      ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headerTitle,
                  style: AppTextTheme.subText(AppColor.shade5),
                ),
                content ??
                    Column(
                      children: [
                        for (var item in checkList!)
                          _infoItem(
                            title: item.name,
                            isCheck: item.status,
                          ),
                      ],
                    ),
              ],
            ),
          )
        ],
      );
    });
  }

  Widget _infoItem({
    required String title,
    required bool isCheck,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        constraints: const BoxConstraints(minHeight: 24),
        child: Row(
          children: [
            isHistory
                ? SvgIcon(
                    isCheck ? SvgIcons.check : SvgIcons.close,
                    color: isCheck ? AppColor.shade9 : AppColor.others1,
                    size: 24,
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      '\u2022',
                      style: AppTextTheme.mediumBodyText(
                        AppColor.black,
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                title,
                style: AppTextTheme.mediumBodyText(
                  AppColor.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actions(TaskModel task) {
    return LayoutBuilder(builder: (context, size) {
      return Container(
        height: 84,
        width: size.maxWidth,
        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AppButtonTheme.fillRounded(
            constraints: const BoxConstraints(minHeight: 52),
            color: AppColor.primary2,
            highlightColor: AppColor.primary2,
            borderRadius: BorderRadius.circular(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgIcon(
                  SvgIcons.checkCircleOutline,
                  color: AppColor.white,
                  size: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Nhận việc',
                    style: AppTextTheme.headerTitle(AppColor.white),
                  ),
                ),
              ],
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.black12,
                builder: (BuildContext context) {
                  return _buildTakeJob(task);
                },
              );
            },
          ),
        ),
      );
    });
  }

  _buildTakeJob(TaskModel task) {
    return JTConfirmDialog(
      headerTitle: 'Nhận việc mới',
      contentText: 'Bạn có chắc chắn muốn nhận công việc này?',
      actionField: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
        child: Column(
          children: [
            AppButtonTheme.fillRounded(
              constraints: const BoxConstraints(
                minHeight: 52,
              ),
              borderRadius: BorderRadius.circular(4),
              color: AppColor.primary2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIcon(
                    SvgIcons.checkCircleOutline,
                    color: AppColor.white,
                    size: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Đồng ý',
                      style: AppTextTheme.headerTitle(AppColor.white),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                _takeTask(task);
              },
            ),
            const SizedBox(height: 16),
            AppButtonTheme.fillRounded(
              constraints: const BoxConstraints(
                minHeight: 52,
              ),
              borderRadius: BorderRadius.circular(4),
              color: AppColor.shade1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIcon(
                    SvgIcons.arrowBackIos,
                    color: AppColor.black,
                    size: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Trở về',
                      style: AppTextTheme.headerTitle(AppColor.black),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  _takeTask(TaskModel task) {
    _taskBloc.takeTask(task.id).then(
      (value) async {
        Navigator.of(context).pop();
        navigateTo(homeRoute);
      },
    ).onError((ApiError error, stackTrace) {
      Navigator.of(context).pop();
      _takeJobErrorDialog();
    }).catchError(
      (error, stackTrace) {
        Navigator.of(context).pop();
        _takeJobErrorDialog();
      },
    );
  }

  _takeJobErrorDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black12,
        builder: (BuildContext context) {
          return JTConfirmDialog(
            headerTitle: 'Thông báo',
            contentText: 'Bạn đã có công việc trong khung giờ này.',
            actionField: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
              child: Column(
                children: [
                  AppButtonTheme.fillRounded(
                    constraints: const BoxConstraints(
                      minHeight: 52,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    color: AppColor.primary2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgIcon(
                          SvgIcons.arrowBackIos,
                          color: AppColor.white,
                          size: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Trở về',
                            style: AppTextTheme.headerTitle(AppColor.white),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildResults(TaskModel task) {
    return LayoutBuilder(builder: (context, size) {
      return Container(
        width: size.maxWidth,
        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kết quả thực tế',
                style: AppTextTheme.mediumHeaderTitle(AppColor.black),
              ),
              _buildImages(
                title: 'Trước',
                images: task.listPicturesBefore,
              ),
              _buildImages(
                title: 'Sau',
                images: task.listPicturesAfter,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildImages({
    required String title,
    required List<String> images,
  }) {
    return LayoutBuilder(builder: (context, size) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              title,
              style: AppTextTheme.mediumHeaderTitle(AppColor.primary1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 100,
              width: size.maxWidth,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (BuildContext context, index) {
                  final url = images[index];
                  final isLast = index != images.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(right: isLast ? 16 : 0),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  _fetchDataOnPage() {}
}
