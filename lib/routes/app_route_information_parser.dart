import 'package:flutter/material.dart';
import 'route_names.dart';
import 'route_path.dart';

class AppRouteInforParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    final name = uri.path;

    if (name == initialRoute) {
      return AppRoutePath.initial();
    }
    if (name == homeRoute) {
      return AppRoutePath.home();
    }
    //authentication
    if (name == authenticationRoute) {
      return AppRoutePath.authentication();
    }
    if (name == registerRoute) {
      return AppRoutePath.register();
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
    if (name == workingTaskRoute) {
      return AppRoutePath.workingTask();
    }
    if (name == toDoTaskRoute) {
      return AppRoutePath.toDoTask();
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
    // if (name == roleRoute) {
    //   return AppRoutePath.roles();
    // }
    // if (name == createRoleRoute) {
    //   return AppRoutePath.createRoles();
    // }
    // if (name.startsWith(editRoleRoute)) {
    //   if (name.length > editRoleRoute.length) {
    //     final id = name.substring(editRoleRoute.length, name.length);
    //     if (id.isNotEmpty) return AppRoutePath.editRoles(id);
    //   }
    //   return AppRoutePath.roles();
    // }

    return AppRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    if (configuration.isUnknown) {
      return const RouteInformation(location: pageNotFoundRoute);
    }
    return RouteInformation(location: configuration.name);
  }
}
