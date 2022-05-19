import 'package:flutter/material.dart';
import '../../main.dart';
import '../../widgets/jt_indicator.dart';
import '../layout_template/content_screen.dart';

class WorkingTaskScreen extends StatefulWidget {
  const WorkingTaskScreen({Key? key}) : super(key: key);

  @override
  State<WorkingTaskScreen> createState() => _WorkingTaskScreenState();
}

class _WorkingTaskScreenState extends State<WorkingTaskScreen> {
  final _pageState = PageState();
  final _scrollController = ScrollController();
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
                  ? _inProgressPage(snapshot)
                  : const JTIndicator(),
            );
          }),
    );
  }

  Widget _inProgressPage(AsyncSnapshot<TaskerModel> snapshot) {
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
      flexibleSpace: Row(
        children: [
          AppButtonTheme.fillRounded(
            constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
            color: AppColor.transparent,
            highlightColor: AppColor.white,
            child: Center(
              child: SvgIcon(
                SvgIcons.arrowBack,
                size: 24,
                color: AppColor.black,
              ),
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 24.5, 10, 16.5),
            child: Expanded(
              child: Center(
                child: Text(
                  'Chi tiết công việc',
                  style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                ),
              ),
            ),
          ),
          AppButtonTheme.fillRounded(
            constraints: const BoxConstraints(minHeight: 40),
            color: AppColor.transparent,
            highlightColor: AppColor.white,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Hủy công việc',
                style: AppTextTheme.mediumHeaderTitle(AppColor.others1),
              ),
            ),
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

  _fetchDataOnPage() {}
}
