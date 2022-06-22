import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../main.dart';
import '../../widgets/jt_indicator.dart';
import '../layout_template/content_screen.dart';

class TaskerExperienceScreen extends StatefulWidget {
  const TaskerExperienceScreen({Key? key}) : super(key: key);

  @override
  State<TaskerExperienceScreen> createState() => _TaskerExperienceScreenState();
}

class _TaskerExperienceScreenState extends State<TaskerExperienceScreen> {
  final _pageState = PageState();
  final _taskerBloc = TaskerBloc();
  final List<String> _taskerMedals = [
    'Thân thiện',
    'Vui vẻ',
    'Nhanh nhẹn',
    'Đúng giờ',
    'Chăm chỉ',
    'Tốt bụng',
    'Ưa nhìn',
  ];
  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  void dispose() {
    _taskerBloc.dispose();
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
              child: snapshot.hasData
                  ? _taskerExperience(snapshot)
                  : const JTIndicator(),
            );
          }),
    );
  }

  Widget _taskerExperience(AsyncSnapshot<TaskerModel> snapshot) {
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
            color: AppColor.transparent,
            highlightColor: AppColor.white,
            child: SvgIcon(
              SvgIcons.arrowIosBack,
              size: 24,
              color: AppColor.black,
            ),
            onPressed: () => navigateTo(taskerProfileRoute),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'Thông tin của bạn',
                  style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                ),
              ),
            ),
          ),
          AppButtonTheme.fillRounded(
            constraints: const BoxConstraints(minHeight: 56),
            color: AppColor.transparent,
            highlightColor: AppColor.transparent,
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(TaskerModel tasker) {
    return LayoutBuilder(builder: (context, size) {
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: size.maxWidth,
              constraints: const BoxConstraints(minHeight: 128),
              child: _experienceHeader(tasker),
            ),
            _experienceContent(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 34),
              child: _userComment(),
            ),
          ],
        ),
      );
    });
  }

  Widget _experienceHeader(TaskerModel tasker) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
          ),
        ),
        Text(
          tasker.name,
          style: AppTextTheme.mediumBigText(AppColor.black),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RatingBar.builder(
                ignoreGestures: true,
                allowHalfRating: true,
                initialRating: 4.5,
                minRating: 1,
                itemCount: 5,
                itemSize: 24,
                direction: Axis.horizontal,
                itemPadding: const EdgeInsets.symmetric(horizontal: 6),
                itemBuilder: (context, _) {
                  return SvgIcon(
                    SvgIcons.star,
                    color: AppColor.primary2,
                  );
                },
                onRatingUpdate: (value) {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '4.5',
                  style: AppTextTheme.normalHeaderTitle(AppColor.black),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: Text(
            '(643 đánh giá)',
            style: AppTextTheme.normalText(AppColor.black),
          ),
        ),
      ],
    );
  }

  Widget _experienceContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _experienceDetail(
                  header: 'Tham gia từ',
                  title: '3/2019',
                ),
                VerticalDivider(
                  thickness: 1,
                  color: AppColor.shade1,
                ),
                _experienceDetail(
                  header: 'Công việc',
                  title: '320',
                ),
                VerticalDivider(
                  thickness: 1,
                  color: AppColor.shade1,
                ),
                _experienceDetail(
                  header: 'Đánh giá tích cực',
                  title: '90%',
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Huy hiệu',
                style: AppTextTheme.mediumHeaderTitle(AppColor.black),
              ),
              Text(
                '7 huy hiệu',
                style: AppTextTheme.normalText(AppColor.primary2),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SizedBox(
            height: 111,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                itemCount: _taskerMedals.length,
                itemBuilder: (BuildContext context, index) {
                  final medalTitle = _taskerMedals[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17.5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 60,
                              height: 60,
                            ),
                          ),
                        ),
                        Text(
                          medalTitle,
                          style: AppTextTheme.subText(AppColor.black),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget _experienceDetail({
    required String header,
    required String title,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            header,
            style: AppTextTheme.normalText(AppColor.text7),
          ),
        ),
        Text(
          title,
          style: AppTextTheme.mediumHeaderTitle(AppColor.primary1),
        ),
      ],
    );
  }

  Widget _userComment() {
    final List<UserComment> userComments = [
      UserComment(
        comment: 'Bạn làm rất tốt! Xứng đáng tăng lương',
        userName: 'Ngo Anh Duong',
        rated: '4.5',
      ),
      UserComment(
        comment: 'Hôm qua em tuyệt lắm!',
        userName: 'Chi Nhan',
        rated: '5.0',
      ),
    ];
    return LayoutBuilder(builder: (context, size) {
      return Column(
        children: [
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đánh giá tiêu biểu',
                    style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                  ),
                  Text(
                    'Xem thêm',
                    style: AppTextTheme.mediumHeaderTitle(AppColor.text7),
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: userComments.length,
              itemBuilder: (BuildContext context, index) {
                final userComment = userComments[index];
                return Container(
                  constraints: const BoxConstraints(minHeight: 87),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                userComment.comment,
                                style: AppTextTheme.normalText(AppColor.black),
                              ),
                            ),
                            Text(
                              userComment.userName,
                              style: AppTextTheme.subText(
                                AppColor.text7,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: AppButtonTheme.outlineRounded(
                            color: AppColor.white,
                            outlineColor: AppColor.shade1,
                            constraints: const BoxConstraints(minHeight: 44),
                            borderRadius: BorderRadius.circular(50),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: SvgIcon(
                                      SvgIcons.star,
                                      size: 24,
                                    ),
                                  ),
                                  Text(
                                    userComment.rated,
                                    style: AppTextTheme.normalText(
                                      AppColor.black,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                );
              }),
        ],
      );
    });
  }

  _fetchDataOnPage() {
    _taskerBloc.getProfile();
  }
}

class UserComment {
  final String comment;
  final String userName;
  final String rated;
  UserComment({
    required this.comment,
    required this.userName,
    required this.rated,
  });
}
