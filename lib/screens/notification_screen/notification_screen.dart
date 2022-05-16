import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../core/authentication/auth.dart';
import '../../core/tasker/tasker.dart';
import '../../main.dart';
import '../../widgets/jt_indicator.dart';
import '../layout_template/content_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _pageState = PageState();

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
              child:
                  snapshot.hasData ? _notiPage(snapshot) : const JTIndicator(),
            );
          }),
    );
  }

  Widget _notiPage(AsyncSnapshot<TaskerModel> snapshot) {
    return Scaffold(
      backgroundColor: AppColor.white,
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
                  'Thông báo',
                  style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                ),
              ),
            ),
          ),
          AppButtonTheme.fillRounded(
            constraints: const BoxConstraints(minHeight: 56),
            color: AppColor.transparent,
            highlightColor: AppColor.white,
            child: SvgIcon(
              SvgIcons.refresh,
              size: 48,
              color: AppColor.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    const items = 3;
    return LayoutBuilder(builder: (context, size) {
      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: items,
        itemBuilder: (BuildContext context, index) {
          final isEven = index % 2 == 0;
          final tagColor = isEven ? AppColor.shade9 : AppColor.others1;
          return Container(
            constraints: const BoxConstraints(minHeight: 172),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 4,
                  color: tagColor,
                ),
                bottom: index != items - 1
                    ? BorderSide(
                        color: AppColor.shade1,
                      )
                    : BorderSide.none,
              ),
            ),
            child: Column(
              children: [
                _notiTag(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 16, 16),
                  child: AppButtonTheme.fillRounded(
                    borderRadius: BorderRadius.circular(4),
                    constraints: const BoxConstraints(minHeight: 44),
                    color: tagColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Xem công việc',
                          style: AppTextTheme.headerTitle(AppColor.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Transform.rotate(
                            angle: 180 * pi / 180,
                            child: SvgIcon(
                              SvgIcons.arrowBack,
                              color: AppColor.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _notiTag() {
    return LayoutBuilder(builder: (context, size) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 3, 0),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: size.maxWidth - 63 - 32,
              constraints: const BoxConstraints(minHeight: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhận được công việc mới!',
                    style: AppTextTheme.normalText(AppColor.primary1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Nancy Jewel McDonie đã chấp nhận yêu cầu của bạn.',
                      style: AppTextTheme.normalText(AppColor.black),
                    ),
                  ),
                  Text(
                    'Vừa mới',
                    style: AppTextTheme.normalText(AppColor.text7),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  _fetchDataOnPage() {}
}
