import 'route_names.dart';

class AppRoutePath {
  final String? name;
  final String routeId;
  final bool isUnknown;

  AppRoutePath.initial()
      : name = initialRoute,
        routeId = '',
        isUnknown = false;
  //authentication
  AppRoutePath.authentication()
      : name = authenticationRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.register()
      : name = registerRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.home()
      : name = homeRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.forgotPassword()
      : name = forgotPasswordRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.resetPassword()
      : name = forgotPasswordRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.otp()
      : name = otpRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.taskerProfile()
      : name = taskerProfileRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.notifications()
      : name = notificationRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.jobDetail()
      : name = jobDetailRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.taskerHistory()
      : name = taskHistoryRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.editTaskerProfile()
      : name = editTaskerProfileRoute,
        routeId = '',
        isUnknown = false;
  // AppRoutePath.roles()
  //     : name = roleRoute,
  //       routeId = '',
  //       isUnknown = false;
  // AppRoutePath.createRoles()
  //     : name = createRoleRoute,
  //       routeId = '',
  //       isUnknown = false;
  // AppRoutePath.editRoles(String id)
  //     : name = editRoleRoute + id,
  //       routeId = '',
  //       isUnknown = false;

  AppRoutePath.unknown()
      : name = null,
        routeId = '',
        isUnknown = true;

  static AppRoutePath routeFrom(String? name) {
    if (name == initialRoute) {
      return AppRoutePath.initial();
    }
    //authentication
    if (name == authenticationRoute) {
      return AppRoutePath.authentication();
    }
    if (name == registerRoute) {
      return AppRoutePath.register();
    }
    if (name == homeRoute) {
      return AppRoutePath.home();
    }
    if (name == forgotPasswordRoute) {
      return AppRoutePath.forgotPassword();
    }
    if (name == resetPasswordRoute) {
      return AppRoutePath.resetPassword();
    }
    if (name == otpRoute) {
      return AppRoutePath.otp();
    }
    if (name == taskerProfileRoute) {
      return AppRoutePath.taskerProfile();
    }
    if (name == notificationRoute) {
      return AppRoutePath.notifications();
    }
    if (name == jobDetailRoute) {
      return AppRoutePath.jobDetail();
    }
    if (name == taskHistoryRoute) {
      return AppRoutePath.taskerHistory();
    }
    if (name == editTaskerProfileRoute) {
      return AppRoutePath.editTaskerProfile();
    }
    // if (name == roleRoute) {
    //   return AppRoutePath.roles();
    // }
    // if (name == createRoleRoute) {
    //   return AppRoutePath.createRoles();
    // }
    // if (name != null && name.startsWith(editRoleRoute)) {
    //   if (name.length > editRoleRoute.length) {
    //     final id = name.substring(editRoleRoute.length, name.length);
    //     if (id.isNotEmpty) return AppRoutePath.editRoles(id);
    //   }
    //   return AppRoutePath.roles();
    // }
    return AppRoutePath.unknown();
  }
}
