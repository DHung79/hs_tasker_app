import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../controller/home/home_controller.dart';
import '../data/provider/api.dart';
import '../data/repository/posts_repository.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() {
      return HomeController(
          repository:
              MyRepository(apiClient: MyApiClient(httpClient: http.Client())));
    });
  }
}
