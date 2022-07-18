import 'dart:math';
import 'package:flutter/material.dart';
import '/routes/route_names.dart';
import '/screens/home/components/history_content.dart';
import '/screens/home/components/new_post_content.dart';
import '/screens/home/components/tasker_task_content.dart';
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
                  snapshot.hasData ? _homePage(snapshot) : const JTIndicator(),
            );
          }),
    );
  }

  Widget _homePage(AsyncSnapshot<TaskerModel> snapshot) {
    final tasker = snapshot.data;
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(146),
        child: _appBar(tasker!),
      ),
      body: _buildContent(tasker),
    );
  }

  Widget _appBar(TaskerModel tasker) {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow.withOpacity(0.16),
              blurRadius: 16,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Column(
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
                        child: tasker.avatar.isNotEmpty
                            ? Image.network(
                                tasker.avatar,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/logo.png",
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
                      child: InkWell(
                        child: _buildNoti(),
                        onTap: () {
                          setState(() {
                            notiBadges = 0;
                            navigateTo(notificationRoute);
                          });
                        },
                      ),
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
      ),
    );
  }

  Widget _buildNoti() {
    bool hasNoti = notiBadges != 0;
    return Container(
      width: hasNoti ? 76 : 42,
      height: 42,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.shadow.withOpacity(0.16),
            blurRadius: 16,
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
                        AppColor.white,
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
      highlightColor: AppColor.white,
      splashColor: AppColor.white,
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
                    SvgIcons.arrowBackIos,
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
          onPressed: () {
            setState(() {
              homeTabIndex = 0;
            });
          },
        ),
        _headerButton(
          index: 1,
          title: 'Hiện tại',
          onPressed: () {
            setState(() {
              homeTabIndex = 1;
            });
          },
        ),
        _headerButton(
          index: 2,
          title: 'Lịch sử',
          onPressed: () {
            setState(() {
              homeTabIndex = 2;
            });
          },
        ),
      ],
    );
  }

  Widget _headerButton({
    required String title,
    required void Function()? onPressed,
    required int index,
  }) {
    final bool isSelected = index == homeTabIndex;
    return Expanded(
      child: AppButtonTheme.underLine(
        onPressed: onPressed,
        lineColor: isSelected ? AppColor.primary1 : AppColor.white,
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

  Widget _buildContent(TaskerModel tasker) {
    if (homeTabIndex == 1) {
      return TaskerTaskContent(tasker: tasker);
    } else if (homeTabIndex == 2) {
      return HistoryContent(tasker: tasker);
    } else {
      return const NewPostContent();
    }
  }

  _fetchDataOnPage() {}
}
