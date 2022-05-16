import 'package:flutter/material.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../core/authentication/auth.dart';
import '../../core/tasker/tasker.dart';
import '../../main.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/jt_indicator.dart';
import '../layout_template/content_screen.dart';

class TaskerProfileScreen extends StatefulWidget {
  const TaskerProfileScreen({Key? key}) : super(key: key);

  @override
  State<TaskerProfileScreen> createState() => _TaskerProfileScreenState();
}

class _TaskerProfileScreenState extends State<TaskerProfileScreen> {
  final _pageState = PageState();
  bool _isObscure = true;
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
                  ? _taskerProfile(snapshot)
                  : const JTIndicator(),
            );
          }),
    );
  }

  Widget _taskerProfile(AsyncSnapshot<TaskerModel> snapshot) {
    final tasker = snapshot.data;
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: _appBar(),
      ),
      body: _buildContent(tasker!),
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
            color: Colors.transparent,
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
                  'Hồ sơ người dùng',
                  style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                ),
              ),
            ),
          ),
          AppButtonTheme.fillRounded(
            constraints: const BoxConstraints(minHeight: 56),
            color: Colors.transparent,
            highlightColor: AppColor.white,
            child: SvgIcon(
              SvgIcons.logout,
              size: 24,
              color: AppColor.primary2,
            ),
            onPressed: () {
              _buildLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  _buildLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return JTConfirmDialog(
          headerTitle: 'Cảnh báo',
          contentText: 'Bạn có chắc chắn muốn đăng xuất?',
          actionField: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgIcon(
                            SvgIcons.check,
                            color: AppColor.primary2,
                            size: 20,
                          ),
                        ),
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
                    AuthenticationBlocController()
                        .authenticationBloc
                        .add(UserLogOut());
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
      },
    );
  }

  Widget _buildContent(TaskerModel tasker) {
    return LayoutBuilder(builder: (context, size) {
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 128),
              child: _profileHeader(tasker),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 204),
              child: _taskerInfo(
                headerTitle: 'Liên lạc',
                onEdit: () {},
                infoContent: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: _buildDetail(
                        title: tasker.email,
                        svgIcon: SvgIcons.alternateEmail,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: _buildDetail(
                        title: tasker.phoneNumber,
                        svgIcon: SvgIcons.call,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 180),
              child: _taskerInfo(
                headerTitle: 'Ví điện tử',
                onEdit: () {},
                infoContent: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: LayoutBuilder(builder: (context, size) {
                        const value = '120.000.000';
                        final text = _isObscure
                            ? value.replaceAll(RegExp(r"."), "*")
                            : value;
                        final title = text + ' VND';

                        return _buildDetail(
                          title: title,
                          svgIcon: SvgIcons.dollar1,
                          child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Hiển thị',
                                style: AppTextTheme.mediumBodyText(
                                  AppColor.primary2,
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: AppButtonTheme.fillRounded(
                        constraints: BoxConstraints(
                          minWidth: size.maxWidth - 64,
                          minHeight: 52,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        color: AppColor.shade1,
                        child: Text(
                          'Nạp thêm tiền',
                          style: AppTextTheme.headerTitle(AppColor.shade9),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildActions()
          ],
        ),
      );
    });
  }

  Widget _profileHeader(TaskerModel tasker) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 16, 24),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.png',
              width: 80,
              height: 80,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tasker.name,
                  style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    tasker.email,
                    style: AppTextTheme.mediumBodyText(AppColor.black),
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                    child: Text(
                      'Đổi mật khẩu',
                      style: AppTextTheme.normalText(AppColor.primary2),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _taskerInfo({
    required String headerTitle,
    required Widget infoContent,
    Function()? onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow.withOpacity(0.16),
              blurRadius: 24,
              blurStyle: BlurStyle.outer,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      headerTitle,
                      style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgIcon(
                          SvgIcons.editOutline,
                          size: 24,
                          color: AppColor.text7,
                        ),
                      ),
                      onTap: onEdit,
                    )
                  ],
                ),
              ),
              infoContent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail({
    required String title,
    SvgIconData? svgIcon,
    IconData? icon,
    Widget? child,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.shade1,
          ),
          child: Center(
            child: icon != null
                ? Icon(
                    icon,
                    color: AppColor.shade5,
                    size: 20,
                  )
                : SvgIcon(
                    svgIcon,
                    color: AppColor.shade5,
                    size: 20,
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Text(
              title,
              style: AppTextTheme.normalText(AppColor.black),
            ),
          ),
        ),
        if (child != null) child,
      ],
    );
  }

  Widget _buildActions() {
    return LayoutBuilder(builder: (context, size) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButtonTheme.fillRounded(
                constraints: BoxConstraints(
                  minWidth: size.maxWidth - 32,
                  minHeight: 52,
                ),
                borderRadius: BorderRadius.circular(4),
                color: AppColor.primary2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgIcon(
                      SvgIcons.starOutline,
                      color: AppColor.white,
                      size: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Xem đánh giá',
                        style: AppTextTheme.headerTitle(AppColor.white),
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButtonTheme.outlineRounded(
                constraints: BoxConstraints(
                  minWidth: size.maxWidth - 32,
                  minHeight: 52,
                ),
                borderRadius: BorderRadius.circular(4),
                outlineColor: AppColor.primary2,
                color: AppColor.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgIcon(
                      SvgIcons.editOutline,
                      color: AppColor.primary2,
                      size: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Chỉnh sửa hồ sơ',
                        style: AppTextTheme.headerTitle(AppColor.primary2),
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      );
    });
  }

  _fetchDataOnPage() {}
}
