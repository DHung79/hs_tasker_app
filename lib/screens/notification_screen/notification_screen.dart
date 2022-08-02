import 'package:flutter/material.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../core/base/blocs/block_state.dart';
import '../../core/notification/notification.dart';
import '../../main.dart';
import '../../widgets/display_date_time.dart';
import '../../widgets/jt_indicator.dart';
import '../layout_template/content_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final PageState _pageState = PageState();
  final _notiBloc = NotificationBloc();
  final _scrollController = ScrollController();
  int maxPage = 0;
  int currentPage = 1;
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _notiBloc.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (currentPage < maxPage) {
        currentPage += 1;
        _fetchDataOnPage(currentPage);
      }
    }
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
                _fetchDataOnPage(1);
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
              SvgIcons.arrowBackIos,
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
              size: 24,
              color: AppColor.black,
            ),
            onPressed: () {
              refreshData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(builder: (context, size) {
      return StreamBuilder(
          stream: _notiBloc.allData,
          builder: (context,
              AsyncSnapshot<ApiResponse<NotificationListModel?>> snapshot) {
            if (snapshot.hasData) {
              if (notifications.isNotEmpty) {
                final records = snapshot.data!.model!.records;
                for (var noti in records) {
                  if (notifications.where((e) => e.id == noti.id).isEmpty) {
                    notifications.add(noti);
                  }
                }
              } else {
                notifications = snapshot.data!.model!.records;
              }
              maxPage = snapshot.data!.model!.meta.totalPage;
              return Stack(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final noti = notifications[index];
                      return _buildNoti(
                        noti,
                        isLast: notifications.length - 1 == index,
                      );
                    },
                  ),
                  StreamBuilder(
                      stream: _notiBloc.allDataState,
                      builder: (context, state) {
                        if (!state.hasData ||
                            state.data == BlocState.fetching) {
                          return Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.shadow.withOpacity(0.32),
                                    blurStyle: BlurStyle.outer,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const JTIndicator(),
                            ),
                          );
                        }
                        return const SizedBox();
                      }),
                ],
              );
            }
            return const SizedBox();
          });
    });
  }

  Widget _buildNoti(NotificationModel noti, {bool isLast = false}) {
    final screenSize = MediaQuery.of(context).size;
    bool isRead = noti.read;

    Color tagColor = AppColor.primary2;
    switch (noti.notificationType.status) {
      case 3:
        tagColor = AppColor.shade9;
        break;
      case 4:
        tagColor = AppColor.others1;
        break;
      default:
        tagColor = AppColor.primary2;
    }

    return StatefulBuilder(builder: (context, setState) {
      return InkWell(
        child: Container(
          width: screenSize.width,
          decoration: BoxDecoration(
            border: Border(
              left: !isRead
                  ? BorderSide(
                      width: 4,
                      color: tagColor,
                    )
                  : BorderSide.none,
              bottom: !isLast
                  ? BorderSide(
                      color: AppColor.shade1,
                    )
                  : BorderSide.none,
            ),
          ),
          child: _notiTag(noti),
        ),
        onTap: () {
          if (noti.notificationType.name == 'Notification Task') {
            if (noti.notificationType.status == 3) {
              navigateTo(jobDetailRoute + '/${noti.taskId}');
            } else if (noti.notificationType.status! == 4) {
              navigateTo(taskHistoryRoute + '/${noti.taskId}');
            }
            _notiBloc.readNotiById(id: noti.id);
          } else {
            _notiBloc.readNotiById(id: noti.id).then((value) {
              setState(() {
                isRead = value.read;
              });
            });
          }
        },
      );
    });
  }

  Widget _notiTag(NotificationModel noti) {
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
                    noti.title,
                    style: AppTextTheme.normalText(AppColor.primary1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      noti.body,
                      style: AppTextTheme.normalText(AppColor.black),
                    ),
                  ),
                  Text(
                    timeAgoFromNow(noti.createdTime, context),
                    style: AppTextTheme.normalText(AppColor.text7),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  _fetchDataOnPage(
    int page,
  ) {
    _notiBloc.fetchAllData(params: {
      'limit': 10,
      'page': page,
    });
    _notiBloc.getTotalUnread().then((value) {
      setState(() {
        notiBadges = value.totalUnreadNoti;
      });
    });
  }

  refreshData() async {
    maxPage = 0;
    currentPage = 1;
    notifications.clear();
    await _notiBloc.fetchAllData(params: {
      'limit': 10,
      'page': currentPage,
    });
    _scrollController.jumpTo(0);
  }
}
