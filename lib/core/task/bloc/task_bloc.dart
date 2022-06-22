import 'package:rxdart/rxdart.dart';
import '../../base/blocs/block_state.dart';
import '../../rest/api_helpers/api_exception.dart';
import '../../rest/models/rest_api_response.dart';
import '../task.dart';

class TaskBloc {
  final _repository = TaskRepository();
  final BehaviorSubject<ApiResponse<ListTaskModel?>> _allDataFetcher =
      BehaviorSubject<ApiResponse<ListTaskModel>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<ListTaskModel?>> get allData => _allDataFetcher.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;

  fetchAllData(Map<String, dynamic>? params) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository
          .fetchAllData<ListTaskModel, EditTaskModel>(params: params!);
      if (_allDataFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _allDataFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _allDataFetcher.sink.add(data);
      }
    } on AppException catch (e) {
      _allDataFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  Future<TaskModel> getProfile() async {
    try {
      // Await response from server.
      final data = await _repository.getProfile<TaskModel, EditTaskModel>();
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  Future<TaskModel> fetchDataById(String id) async {
    try {
      // Await response from server.
      final data =
          await _repository.fetchDataById<TaskModel, EditTaskModel>(id: id);
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  Future<TaskModel> deleteObject({String? id}) async {
    try {
      // Await response from server.
      final data =
          await _repository.deleteObject<TaskModel, EditTaskModel>(id: id);
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  Future<TaskModel> editObject({
    EditTaskModel? editModel,
    String? id,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.editObject<TaskModel, EditTaskModel>(
        editModel: editModel,
        id: id,
      );
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  Future<TaskModel> editProfile({
    EditTaskModel? editModel,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.editProfile<TaskModel, EditTaskModel>(
        editModel: editModel,
      );
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  dispose() {
    _allDataFetcher.close();
    _allDataState.close();
  }
}
