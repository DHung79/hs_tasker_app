import 'package:flutter/material.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../widgets/cancel_task_dialog.dart';
import '../../widgets/contact_dialog.dart';
import '../../widgets/jt_task_detail.dart';
import '../../core/task/task.dart';
import '../../main.dart';
import '../../widgets/display_date_time.dart';
import '../../widgets/jt_indicator.dart';
import '../layout_template/content_screen.dart';
import 'components/remider_dialog.dart';

class ToDoTaskScreen extends StatefulWidget {
  const ToDoTaskScreen({Key? key}) : super(key: key);

  @override
  State<ToDoTaskScreen> createState() => _ToDoTaskScreenState();
}

class _ToDoTaskScreenState extends State<ToDoTaskScreen> {
  final _pageState = PageState();
  final _scrollController = ScrollController();
  bool _showList = true;

  final _task = TaskModel.fromJson({
    '_id': '0',
    'type': 'Dọn dẹp theo giờ',
    'date': 1653038175000,
    'start_time': 1653038175000,
    'end_time': 1653045375000,
    'address': '358/12/33 Lư Cấm, Ngọc Hiệp, Nha Trang Khánh Hòa',
    'distance': '4km',
    'status': '',
    'bill': 300000,
    'created_time': 1652859350000,
    'updated_time': 1652859350000,
  });
  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
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
    return Scaffold(
      backgroundColor: AppColor.shade1,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: _appBar(),
      ),
      body: _buildContent(),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0.16,
      flexibleSpace:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'Công việc sắp tới',
                  style: AppTextTheme.subText(AppColor.primary1),
                ),
              ),
              Text(
                _task.service.name,
                style: AppTextTheme.mediumHeaderTitle(AppColor.black),
              ),
            ]),
          ),
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
                _cancelTaskDialog(_task);
              }),
        ),
      ]),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, size) {
        return SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _customerContact(),
            ),
            _taskDetails(),
          ]),
        );
      },
    );
  }

  Widget _customerContact() {
    return Container(
      color: AppColor.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
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
                    'Nancy Jewel McDonie',
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
                    SvgIcons.comment,
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
                  _showContact();
                }),
          ),
        ],
      ),
    );
  }

  Widget _taskDetails() {
    final date = formatFromInt(
      value: _task.date,
      context: context,
      displayedFormat: 'dd/MM/yyyy',
    );
    final startTime = formatFromInt(
      value: _task.startTime,
      context: context,
      displayedFormat: 'HH:mm',
    );
    final endTime = formatFromInt(
      value: _task.endTime,
      context: context,
      displayedFormat: 'HH:mm',
    );
    return Container(
      color: AppColor.white,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: JTTaskDetail.taskDetailBox(
            svgIcon: SvgIcons.location,
            headerTitle: 'Địa chỉ',
            contentTitle: _task.address,
            boxColor: AppColor.shade2,
            button: AppButtonTheme.fillRounded(
              constraints: const BoxConstraints(minHeight: 44),
              color: AppColor.shade5,
              borderRadius: BorderRadius.circular(50),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SvgIcon(
                  SvgIcons.navigation1,
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
                    SvgIcons.bell,
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
            svgIcon: SvgIcons.dollar1,
            headerTitle: 'Tổng tiền',
            contentTitle: '${_task.totalPrice} VND',
            backgroundColor: AppColor.shade2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: JTTaskDetail.taskDetail(
            svgIcon: SvgIcons.time,
            headerTitle: 'Loại nhà',
            contentTitle: 'Căn hộ',
            backgroundColor: AppColor.shade2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: JTTaskDetail.taskDetail(
            svgIcon: SvgIcons.car,
            headerTitle: 'Ghi chú',
            contentTitle: 'Mang theo chổi',
            backgroundColor: AppColor.shade2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: JTTaskDetail.taskDetail(
            svgIcon: SvgIcons.clean,
            headerTitle: 'Dụng cụ tự mang',
            contentTitle: ' \u2022 Chổi\n \u2022 Cây lau nhà',
            backgroundColor: AppColor.shade2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          child: JTTaskDetail.taskDetailList(
            svgIcon: SvgIcons.checkList,
            headerTitle: 'Danh sách kiểm tra',
            contentList: Text(
              ' \u2022 Lau ghế rồng \n \u2022 Lau bình hoa \n \u2022 Kiểm tra thức ăn cho cún',
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

  _showContact() {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        builder: (context) {
          return const ContactDialog();
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
            accountBalances: '700.000 VND',
          );
        });
  }

  _fetchDataOnPage() {}
}
