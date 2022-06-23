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

  AppRoutePath.jobDetail(String id)
      : name = jobDetailRoute + id,
        routeId = '',
        isUnknown = false;

  AppRoutePath.taskerHistory(String id)
      : name = taskHistoryRoute + id,
        routeId = '',
        isUnknown = false;

  AppRoutePath.editTaskerProfile()
      : name = editTaskerProfileRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.workingTask(String id)
      : name = workingTaskRoute + id,
        routeId = '',
        isUnknown = false;

  AppRoutePath.toDoTask(String id)
      : name = toDoTaskRoute + id,
        routeId = '',
        isUnknown = false;

  AppRoutePath.taskerExperience()
      : name = taskerExperienceRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.changePassword()
      : name = changePasswordRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.map()
      : name = mapRoute,
        routeId = '',
        isUnknown = false;

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

    if (name != null && name.startsWith(jobDetailRoute)) {
      if (name.length > jobDetailRoute.length) {
        final id = name.substring(jobDetailRoute.length, name.length);
        if (id.isNotEmpty) return AppRoutePath.jobDetail(id);
      }
      return AppRoutePath.home();
    }
    if (name != null && name.startsWith(taskHistoryRoute)) {
      if (name.length > taskHistoryRoute.length) {
        final id = name.substring(taskHistoryRoute.length, name.length);
        if (id.isNotEmpty) return AppRoutePath.taskerHistory(id);
      }
      return AppRoutePath.home();
    }
    if (name == editTaskerProfileRoute) {
      return AppRoutePath.editTaskerProfile();
    }
    if (name != null && name.startsWith(workingTaskRoute)) {
      if (name.length > workingTaskRoute.length) {
        final id = name.substring(workingTaskRoute.length, name.length);
        if (id.isNotEmpty) return AppRoutePath.workingTask(id);
      }
      return AppRoutePath.home();
    }
    if (name != null && name.startsWith(toDoTaskRoute)) {
      if (name.length > toDoTaskRoute.length) {
        final id = name.substring(toDoTaskRoute.length, name.length);
        if (id.isNotEmpty) return AppRoutePath.toDoTask(id);
      }
      return AppRoutePath.home();
    }
    if (name == taskerExperienceRoute) {
      return AppRoutePath.taskerExperience();
    }
    if (name == changePasswordRoute) {
      return AppRoutePath.changePassword();
    }
    if (name == mapRoute) {
      return AppRoutePath.map();
    }
    return AppRoutePath.unknown();
  }
}
