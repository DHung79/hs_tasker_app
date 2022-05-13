import 'package:flutter/material.dart';
import 'package:hs_tasker_app/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:hs_tasker_app/screens/home/home_screen.dart';
import 'package:hs_tasker_app/screens/onboarding/authentication_screen.dart';
import 'package:hs_tasker_app/screens/register_screen/register_screen.dart';
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
      key: const ValueKey('HomeService'),
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

    // if (route == roleRoute) {
    //   return const UserManagementScreen(tab: 1);
    // }
    // if (route == createRoleRoute) {
    //   return const UserManagementScreen();
    // }
    // if (route.startsWith(editRoleRoute)) {
    //   if (route.length > editRoleRoute.length) {
    //     final id = route.substring(editRoleRoute.length + 1, route.length);
    //     if (id.isNotEmpty) return UserManagementScreen(id: id);
    //   }
    //   return const UserManagementScreen(tab: 1);
    // }

    return PageNotFoundScreen(route);
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _routePath = configuration.name!;
  }

  void navigateTo(String name) {
    _routePath = name;
    notifyListeners();
  }
}
