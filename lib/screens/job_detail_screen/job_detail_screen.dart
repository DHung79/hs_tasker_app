import 'package:flutter/material.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../core/authentication/auth.dart';
import '../../core/tasker/tasker.dart';
import '../../main.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/jt_indicator.dart';
import '../layout_template/content_screen.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({Key? key}) : super(key: key);

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final _pageState = PageState();
  final _scrollController = ScrollController();
  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  final List<bool> _checkList = [
    true,
    true,
    true,
  ];

  final List<String> _toDoList = [
    'Lau ghế rồng',
    'Lau bình hoa',
    'Kiểm tra thức ăn cho cún',
  ];

  final isHistory = getCurrentRouteName() == taskHistoryRoute;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return PageTemplate(
      pageState: _pageState,
      onUserFetched: (user) => setState(() {}),
      onFetch: () {
        _fetchDataOnPage();
      },
      appBarHeight: 0,
      child: FutureBuilder(
          future: _pageState.currentUser,
          builder: (context, AsyncSnapshot<TaskerModel> snapshot) {
            return PageContent(
              userSnapshot: snapshot,
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
    return Scaffold(
      backgroundColor: AppColor.shade1,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: _appBar(),
      ),
      body: _buildContent(),
    );
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
              SvgIcons.arrowBack,
              size: 24,
              color: AppColor.black,
            ),
            onPressed: () => navigateTo(homeRoute),
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

  Widget _buildContent() {
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
                        child: _jobHeader(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _basicInfo(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _customerRequests(),
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
                                  Text(
                                    'Nancy Jewel McDonie',
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
                  ],
                ),
              ),
            ),
            if (!isHistory) _actions(),
          ],
        );
      },
    );
  }

  Widget _jobHeader() {
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
              'Dọn dẹp nhà theo giờ',
              style: AppTextTheme.mediumHeaderTitle(AppColor.black),
            ),
          ),
        ],
      );
    });
  }

  Widget _basicInfo() {
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
                  title: 'Trạng thái',
                  content: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 26),
                      decoration: BoxDecoration(
                        color: _checkList.contains(false)
                            ? AppColor.others1
                            : AppColor.shade9,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 10,
                        ),
                        child: Text(
                          'Hoàn thành',
                          style: AppTextTheme.mediumBodyText(AppColor.white),
                        ),
                      ),
                    ),
                  ),
                  svgIcon: SvgIcons.dollar1,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildInfo(
                title: 'Tổng tiền',
                text: '300.00 VND',
                svgIcon: SvgIcons.dollar1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildInfo(
                title: 'Thời gian làm',
                text: 'Ngày mai, từ 14:00 đến 16:00',
                svgIcon: SvgIcons.time,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildInfo(
                title: 'Địa chỉ',
                text: '358/12/33 Lư Cấm, Ngọc Hiệp',
                svgIcon: SvgIcons.location,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildInfo(
                title: 'Loại nhà',
                text: 'Căn hộ',
                svgIcon: SvgIcons.home,
              ),
            ),
            _buildInfo(
              title: 'Khoảng cách',
              text: '4km',
              svgIcon: SvgIcons.car,
            ),
          ],
        ),
      ),
    );
  }

  Widget _customerRequests() {
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
              child: _buildInfo(
                title: 'Ghi chú',
                text: 'Mang theo chổi',
                svgIcon: SvgIcons.list,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildInfo(
                title: 'Danh sách kiểm tra',
                toDoList: _toDoList,
                checkList: _checkList,
                svgIcon: SvgIcons.checkList,
              ),
            ),
            _buildInfo(
              title: 'Dụng cụ tự mang',
              text: ' \u2022 Chổi\n \u2022 Cây lau nhà',
              svgIcon: SvgIcons.clean,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo({
    required String title,
    String? text,
    Widget? content,
    IconData? icon,
    SvgIconData? svgIcon,
    List<String>? toDoList,
    List<bool>? checkList,
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
                  title,
                  style: AppTextTheme.subText(AppColor.shade5),
                ),
                text != null
                    ? Text(
                        text,
                        style: AppTextTheme.mediumBodyText(AppColor.black),
                      )
                    : content ??
                        Column(
                          children: [
                            for (var i = 0; i < toDoList!.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 24),
                                  child: Row(
                                    children: [
                                      isHistory
                                          ? SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: Checkbox(
                                                checkColor: AppColor.white,
                                                activeColor: AppColor.shade9,
                                                value: checkList![i],
                                                onChanged: (value) {},
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4),
                                              child: Text(
                                                '\u2022',
                                                style:
                                                    AppTextTheme.mediumBodyText(
                                                  AppColor.black,
                                                ),
                                              ),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Text(
                                          toDoList[i],
                                          style: AppTextTheme.mediumBodyText(
                                            AppColor.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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

  Widget _actions() {
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
                  SvgIcons.circleCheck,
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
                  return _buildTakeJob();
                },
              );
            },
          ),
        ),
      );
    });
  }

  _buildTakeJob() {
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
                    SvgIcons.circleCheck,
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
                Navigator.of(context).pop();
                _takeJobErrorDialog();
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
                    SvgIcons.arrowBack,
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
                          SvgIcons.arrowBack,
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

  _fetchDataOnPage() {}
}
