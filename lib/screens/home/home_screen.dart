import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../core/authentication/auth.dart';
import '../../core/tasker/tasker.dart';
import '../../main.dart';
import '../../widgets/jt_indicator.dart';
import '../layout_template/content_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  snapshot.hasData ? _homePage(snapshot) : const JTIndicator(),
            );
          }),
    );
  }

  Widget _homePage(AsyncSnapshot<TaskerModel> snapshot) {
    final tasker = snapshot.data;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(146),
        child: _appBar(tasker!),
      ),
      body: _buildContent(tasker),
    );
  }

  Widget _appBar(TaskerModel tasker) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.16,
      flexibleSpace: Column(
        children: [
          SizedBox(
            height: 96,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 8, 24),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 28, 32, 24),
                      child: _taskerInfo(tasker),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 27, 8, 27),
                    child: _buildNoti(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: _appBarNavigation(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoti() {
    bool hasNoti = notiBadges != 0;
    return Container(
      width: hasNoti ? 76 : 42,
      height: 42,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColor.shadow.withOpacity(0.16),
            blurRadius: 4,
            blurStyle: BlurStyle.outer,
          ),
        ],
        borderRadius: hasNoti ? BorderRadius.circular(50) : null,
        shape: hasNoti ? BoxShape.rectangle : BoxShape.circle,
      ),
      child: hasNoti
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.notifications_outlined),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppColor.others1,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      notiBadges > 9 ? '9+' : '$notiBadges',
                      style: AppTextTheme.mediumBodyText(
                        Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Icon(Icons.notifications_outlined),
    );
  }

  Widget _taskerInfo(TaskerModel tasker) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              tasker.name,
              style: AppTextTheme.normalText(AppColor.text1),
            ),
          ),
          Row(
            children: [
              Text(
                'Xem thêm',
                style: AppTextTheme.subText(AppColor.primary2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Transform.rotate(
                  angle: 180 * pi / 180,
                  child: SvgIcon(
                    SvgIcons.arrowBack,
                    color: AppColor.primary2,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        navigateTo(taskerProfileRoute);
      },
    );
  }

  Widget _appBarNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _headerButton(
          index: 0,
          title: 'Trang tin mới',
          onPressed: () {},
        ),
        _headerButton(
          index: 1,
          title: 'Hiện tại',
          onPressed: () {},
        ),
        _headerButton(
          index: 2,
          title: 'Lịch sử',
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _headerButton({
    required String title,
    required void Function()? onPressed,
    required int index,
  }) {
    final bool isSelected = index == 0;
    return Expanded(
      child: AppButtonTheme.underLine(
        onPressed: onPressed,
        lineColor: isSelected ? AppColor.primary1 : Colors.white,
        lineWidth: 4,
        child: Text(
          title,
          style: AppTextTheme.normalText(
            isSelected ? AppColor.primary1 : AppColor.text3,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(TaskerModel? tasker) {
    return LayoutBuilder(builder: (context, size) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: 2,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              constraints: BoxConstraints(
                minHeight: 408,
                minWidth: size.maxWidth - 32,
              ),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColor.shadow.withOpacity(0.16),
                    blurRadius: 24,
                    spreadRadius: 0.16,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: _buildTask(),
            ),
          );
        },
      );
    });
  }

  Widget _buildTask() {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 42),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dọn dẹp theo giờ',
                    style: AppTextTheme.mediumHeaderTitle(AppColor.primary1),
                  ),
                  Text(
                    'Vừa mới',
                    style: AppTextTheme.normalText(AppColor.text7),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Divider(
                thickness: 1.5,
                color: AppColor.shade1,
              ),
            ),
            _taskContent(),
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
                    style: AppTextTheme.subText(AppColor.primary2),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Transform.rotate(
                      angle: 180 * pi / 180,
                      child: SvgIcon(
                        SvgIcons.arrowBack,
                        color: AppColor.primary2,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {},
            )
          ],
        ),
      );
    });
  }

  Widget _taskContent() {
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
                    child: _taskHeader(
                      headerTitle: 'Thời lượng',
                      contentTitle: '2 tiếng (14:00)',
                    ),
                  ),
                  VerticalDivider(
                    thickness: 2,
                    color: AppColor.shade1,
                  ),
                  Expanded(
                    flex: 1,
                    child: _taskHeader(
                      headerTitle: 'Tổng tiền (VND)',
                      contentTitle: '300.000',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _taskDetail(
          svgIcon: SvgIcons.time,
          headerTitle: 'Thời gian làm',
          contentTitle: 'Ngày mai, từ 14:00 đến 16:00',
        ),
        _taskDetail(
          svgIcon: SvgIcons.location,
          headerTitle: 'Địa chỉ',
          contentTitle: '358/12/33 Lư Cấm, Ngọc Hiệp',
        ),
        _taskDetail(
          svgIcon: SvgIcons.car,
          headerTitle: 'Khoảng cách',
          contentTitle: '4km',
        ),
      ],
    );
  }

  Widget _taskHeader({
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

  Widget _taskDetail({
    IconData? icon,
    SvgIconData? svgIcon,
    String? contentTitle,
    String? headerTitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
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
                        size: 20,
                        color: AppColor.shade5,
                      )
                    : SvgIcon(
                        svgIcon,
                        size: 20,
                        color: AppColor.shade5,
                      ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headerTitle ?? '',
                style: AppTextTheme.normalText(AppColor.shade5),
              ),
              Text(
                contentTitle ?? '',
                style: AppTextTheme.mediumBodyText(AppColor.text1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _fetchDataOnPage() {}
}
