import 'package:get/get.dart';
import 'package:hs_tasker_app/screens/home/home_screen.dart';

import '../bindings/home_binding.dart';
part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
        name: Routes.initial,
        page: () => const HomeScreen(),
        binding: HomeBinding()),
    // GetPage(
    //     name: Routes.details,
    //     page: () => DetailsPage(),
    //     binding: DetailsBinding()),
  ];
}
