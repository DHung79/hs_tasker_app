import 'package:get/get.dart';
import '../../data/model/model.dart';
import '../../data/repository/posts_repository.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final MyRepository repository;
  HomeController({required this.repository});

  final _postsList = <MyModel>[].obs;
  List<MyModel> get postList => _postsList;
  set postList(value) => _postsList.value = value;

  final _post = MyModel.fromJson({}).obs;
  get post => _post.value;
  set post(value) => _post.value = value;

  getAll() {
    repository.getAll().then((data) {
      postList = data;
    });
  }

  adicionar(post) {}
  //dismissible
  excluir(id) {}
  //dismissible
  editar() {}
  details(post) {
    this.post = post;
    Get.toNamed(Routes.details);
  }
}
