import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hs_tasker_app/core/logger/logger.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'locator.dart';
import 'routes/app_route_information_parser.dart';
import 'routes/app_router_delegate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locales/i18n.dart';
import 'scroll_behavior.dart';
import 'theme/app_theme.dart';
import 'utils/app_state_notifier.dart';

export 'core/authentication/bloc/authentication_bloc_controller.dart';
export 'core/rest/models/rest_api_response.dart';
export 'core/logger/logger.dart';
export 'theme/app_colors.dart';
export 'theme/app_text_theme.dart';
export 'theme/svg_constants.dart';
export 'locales/i18n.dart';
export 'utils/screen_util.dart';
export 'locales/i18n_key.dart';
export 'theme/button_theme.dart';
export 'core/tasker/tasker.dart';
export 'core/authentication/auth.dart';

int notiBadges = 0;
int homeTabIndex = 0;

Future<SharedPreferences> prefs = SharedPreferences.getInstance();
// Page index
GlobalKey globalKey = GlobalKey();

navigateTo(String route) async {
  locator<AppRouterDelegate>().navigateTo(route);
}

final List<Locale> supportedLocales = <Locale>[
  const Locale('vi'),
  const Locale('en'),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadVersion();
  setupLocator();
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (_) => AppStateNotifier(),
      child: const OKToast(
        child: App(),
      ),
    ),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
  static _AppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>();
}

class _AppState extends State<App> {
  final AppRouteInforParser _routeInfoParser = AppRouteInforParser();
  Locale currentLocale = supportedLocales[0];

  void setLocale(Locale value) {
    setState(() {
      currentLocale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return MaterialApp.router(
          title: 'Home Services',
          debugShowCheckedModeBanner: false,
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routeInformationParser: _routeInfoParser,
          routerDelegate: locator<AppRouterDelegate>(),
          builder: (context, child) => child!,
          scrollBehavior: MyCustomScrollBehavior(),
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            I18n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: supportedLocales,
          locale: currentLocale,
        );
      },
    );
  }
}

Future<PackageInfo> loadVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  logDebug(
      ' appName: ${packageInfo.appName}  \n version: ${packageInfo.version}');

  return packageInfo;
}

String? getCurrentRouteName() {
  return locator<AppRouterDelegate>().currentConfiguration.name;
}
