import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../config/fcm/fcm.dart';
import '../../main.dart';
import '../../theme/validator_text.dart';

class PageTemplate extends StatefulWidget {
  final Widget child;
  final PageState? pageState;
  final void Function(TaskerModel?) onUserFetched;
  final Widget? navItem;
  final Widget? tabTitle;
  final int? currentTab;
  final Widget? leading;
  final Widget? drawer;
  final List<Widget>? actions;
  final double elevation;
  final double appBarHeight;
  final Widget? flexibleSpace;
  final bool showAppBar;
  final Widget? appBar;

  const PageTemplate({
    Key? key,
    required this.child,
    this.pageState,
    required this.onUserFetched,
    this.navItem,
    this.tabTitle,
    this.currentTab,
    this.leading,
    this.drawer,
    this.actions,
    this.elevation = 0,
    this.appBarHeight = 56,
    this.flexibleSpace,
    this.showAppBar = true,
    this.appBar,
  }) : super(key: key);

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  late AuthenticationBloc _authenticationBloc;
  Future<TaskerModel>? _currentUser;
// int _totalNotifications;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool showNoti = false;
  final _taskerBloc = TaskerBloc();
  PushNotification? _notificationInfo;

  @override
  initState() {
    _authenticationBloc = AuthenticationBlocController().authenticationBloc;
    _authenticationBloc.add(AppLoadedup());
    requestPermissionsLocal();
    registerNotification(
      getFcmToken: (fcmToken) {
          currentFcmToken = fcmToken;
      },
      notificationInfo: _notificationInfo,
    );
    checkForInitialMessage(getNotification: (notification) {
      setState(() {
        _notificationInfo = notification;
        // _totalNotifications++;
      });
    });
    initLocalPushNotification();
    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'].toString(),
        dataBody: message.data['body'].toString(),
      );
      setState(() {
        _notificationInfo = notification;
      });
    });
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
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: _authenticationBloc,
      listener: (BuildContext context, AuthenticationState state) async {
        if (state is AuthenticationStart) {
          navigateTo(authenticationRoute);
        } else if (state is UserLogoutState) {
          navigateTo(authenticationRoute);
        } else if (state is AuthenticationFailure) {
          _showError(state.errorCode);
        } else if (state is UserTokenExpired) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ScreenUtil.t(I18nKey.signInSessionExpired)!,
              ),
            ),
          );
          navigateTo(authenticationRoute);
        } else if (state is AppAutheticated) {
          _authenticationBloc.add(GetUserData());
        } else if (state is SetUserData<TaskerModel>) {
          _currentUser = Future.value(state.currentUser);
        }
      },
      child: FutureBuilder(
        future: _currentUser,
        builder: (context, snapshot) {
          return Scaffold(
            key: _key,
            backgroundColor: AppColor.white,
            appBar: widget.showAppBar
                ? PreferredSize(
                    preferredSize: Size.fromHeight(widget.appBarHeight),
                    child: widget.appBar ??
                        AppBar(
                          backgroundColor: AppColor.white,
                          flexibleSpace: widget.flexibleSpace,
                          centerTitle: widget.currentTab != 0,
                          leading: widget.leading,
                          actions: widget.actions,
                          title: widget.tabTitle,
                          elevation: widget.elevation,
                        ),
                  )
                : null,
            drawer: widget.drawer,
            bottomNavigationBar: widget.navItem,
            body: LayoutBuilder(
              builder: (context, size) {
                return BlocListener<AuthenticationBloc, AuthenticationState>(
                  bloc: AuthenticationBlocController().authenticationBloc,
                  listener: (BuildContext context, AuthenticationState state) {
                    if (state is SetUserData<TaskerModel>) {
                      widget.pageState!.currentUser = Future.value(
                        state.currentUser,
                      );
                      // App.of(context)!.setLocale(
                      //   supportedLocales.firstWhere(
                      //       (e) => e.languageCode == state.currentLang),
                      // );
                      widget.onUserFetched(state.currentUser);
                    }
                  },
                  child: widget.child,
                );
              },
            ),
          );
        },
      ),
    );
  }

  _showError(String errorCode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(showError(errorCode, context))),
    );
  }
}

class PageContent extends StatelessWidget {
  final PageState pageState;
  final void Function()? onFetch;
  final Widget child;

  const PageContent({
    Key? key,
    required this.pageState,
    required this.child,
    this.onFetch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!pageState.isInitData) {
      if (onFetch != null) onFetch!();
      pageState.isInitData = true;
    }

    return child;
  }
}

class PageState {
  bool isInitData = false;
  Future<TaskerModel>? currentUser;
}
