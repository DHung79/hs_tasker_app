import 'package:rxdart/rxdart.dart';
import '../../base/blocs/block_state.dart';
import '../../rest/api_helpers/api_exception.dart';
import '../../rest/models/rest_api_response.dart';
import '../task.dart';

class TaskBloc {
  final _repository = TaskRepository();
  final _allDataFetcher = BehaviorSubject<ApiResponse<ListTaskModel?>>();
  final _allDataState = BehaviorSubject<BlocState>();
  final _taskDataFetcher = BehaviorSubject<ApiResponse<TaskModel?>>();

  Stream<ApiResponse<ListTaskModel?>> get allData => _allDataFetcher.stream;
  Stream<ApiResponse<TaskModel?>> get taskData => _taskDataFetcher.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;

  fetchAllData(Map<String, dynamic>? params) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository.fetchAllData<ListTaskModel, EditTaskModel>(
          params: params!);
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

  fetchDataById(String id) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchDataById<TaskModel, EditTaskModel>(id: id);
      if (_taskDataFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _taskDataFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _taskDataFetcher.sink.add(data);
      }
    } on AppException catch (e) {
      _taskDataFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
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

  Future<TaskModel> takeTask(String id) async {
    try {
      // Await response from server.
      final data = await _repository.takeTask<TaskModel, EditTaskModel>(id);
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

  Future<TaskModel> cancelTask({
    required String id,
    required String reason,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.cancelTask<TaskModel, EditTaskModel>(
        id: id,
        reason: reason,
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

  Future<TaskModel> updateTaskStatus(String id) async {
    try {
      // Await response from server.
      final data =
          await _repository.updateTaskStatus<TaskModel, EditTaskModel>(id);
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

  Future<TaskModel> uploadListImage({
    required String id,
    bool isBefore = true,
    required List<String> filesPath,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.uploadListImage<TaskModel>(
        id: id,
        isBefore: isBefore,
        filesPath: filesPath,
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

  Future<TaskModel> completeTask({
    required String id,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.completeTask<TaskModel>(id);
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
    _taskDataFetcher.close();
  }
}
