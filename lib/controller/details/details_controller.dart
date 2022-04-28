import 'package:get/get.dart';
import '../../data/model/model.dart';
import '../../data/repository/posts_repository.dart';

class DetailsController extends GetxController {
  final MyRepository repository;
  DetailsController({required this.repository}) : assert(repository != null);

  final _post = MyModel.fromJson({}).obs;
  MyModel get post => _post.value;
  set post(value) => _post.value = value;

  editar(post) {
    print('editar');
  }

  delete(id) {
    print('deletar');
  }
}
