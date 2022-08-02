import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/map_screen/map_screen.dart';
import '../screens/change_password_screen/change_password_screen.dart';
import '../screens/tasker_experience_screen/tasker_experience_screen.dart';
import '../screens/to_do_task_screen/to_do_task_screen.dart';
import '../screens/working_task_screen/working_task_screen.dart';
import '../screens/edit_tasker_profile_screen/edit_tasker_profile_screen.dart';
import '../screens/tasker_profile_screen/tasker_profile_screen.dart';
import '../screens/job_detail_screen/job_detail_screen.dart';
import '../screens/notification_screen/notification_screen.dart';
import '../screens/forgot_password_screen/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/onboarding/authentication_screen.dart';
import '../screens/register_screen/register_screen.dart';
import '../screens/not_found/page_not_found_screen.dart';
import '../screens/otp_screen/otp_screen.dart';
import '../screens/reset_password_screen/reset_password_screen.dart';
import 'no_animation_transition_delegate.dart';
import 'route_names.dart';
import 'route_path.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  String _routePath = '';

  @override
  AppRoutePath get currentConfiguration => AppRoutePath.routeFrom(_routePath);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      transitionDelegate: NoAnimationTransitionDelegate(),
      pages: [
        _pageFor(_routePath),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedBook to null
        notifyListeners();

        return true;
      },
    );
  }

  _pageFor(String route) {
    return MaterialPage(
      key: const ValueKey('Home Service Partner'),
      child: _screenFor(route),
    );
  }

  _screenFor(String route) {
    if (route == initialRoute || route == homeRoute) {
      return const HomeScreen();
    }
    //authentication
    if (route == authenticationRoute) {
      return const AuthenticationScreen();
    }

    if (route == registerRoute) {
      return const RegisterScreen();
    }

    if (route == forgotPasswordRoute) {
      return const ForgotPasswordScreen();
    }

    if (route == resetPasswordRoute) {
      return const ResetPasswordScreen();
    }

    if (route == otpRoute) {
      return const OTPScreen();
    }

    if (route == taskerProfileRoute) {
      return const TaskerProfileScreen();
    }

    if (route == notificationRoute) {
      return const NotificationScreen();
    }
    if (route.startsWith(jobDetailRoute)) {
      if (route.length > jobDetailRoute.length) {
        final id = route.substring(jobDetailRoute.length + 1, route.length);
        if (id.isNotEmpty) return JobDetailScreen(id: id);
      }
      return const HomeScreen();
    }
    if (route.startsWith(taskHistoryRoute)) {
      if (route.length > taskHistoryRoute.length) {
        final id = route.substring(taskHistoryRoute.length + 1, route.length);
        if (id.isNotEmpty) return JobDetailScreen(id: id);
      }
      return const HomeScreen();
    }

    if (route == editTaskerProfileRoute) {
      return const EditTaskerProfileScreen();
    }

    if (route.startsWith(workingTaskRoute)) {
      if (route.length > workingTaskRoute.length) {
        final id = route.substring(workingTaskRoute.length + 1, route.length);
        if (id.isNotEmpty) return WorkingTaskScreen(id: id);
      }
      return const HomeScreen();
    }

    if (route.startsWith(toDoTaskRoute)) {
      if (route.length > toDoTaskRoute.length) {
        final id = route.substring(toDoTaskRoute.length + 1, route.length);
        if (id.isNotEmpty) return ToDoTaskScreen(id: id);
      }
      return const HomeScreen();
    }

    if (route == taskerExperienceRoute) {
      return const TaskerExperienceScreen();
    }

    if (route == changePasswordRoute) {
      return const ChangePasswordScreen();
    }

    if (route == mapRoute) {
      return const MapScreen();
    }

    return PageNotFoundScreen(route);
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _routePath = configuration.name!;
  }

  void navigateTo(String name) {
    preRoute = _routePath;
    _routePath = name;
    notifyListeners();
  }
}
