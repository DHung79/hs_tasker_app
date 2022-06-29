import 'dart:async';
import '../../../main.dart';
import 'task_api_provider.dart';

class TaskRepository {
  final _provider = TaskApiProvider();

  Future<ApiResponse<T?>>
      fetchAllData<T extends BaseModel, K extends EditBaseModel>({
    required Map<String, dynamic> params,
  }) =>
          _provider.fetchAllTasks<T>(params: params);

  Future<ApiResponse<T?>>
      getProfile<T extends BaseModel, K extends EditBaseModel>() =>
          _provider.fetchTaskByToken<T>();

  Future<ApiResponse<T?>>
      fetchDataById<T extends BaseModel, K extends EditBaseModel>({
    String? id,
  }) =>
          _provider.fetchTaskById<T>(
            id: id,
          );

  Future<ApiResponse<T?>>
      editObject<T extends BaseModel, K extends EditBaseModel>({
    K? editModel,
    String? id,
  }) =>
          _provider.editTaskById<T, K>(
            editModel: editModel,
            id: id,
          );
  Future<ApiResponse<T?>>
      takeTask<T extends BaseModel, K extends EditBaseModel>(String id) =>
          _provider.taskerTakeTask<T, K>(id: id);

  Future<ApiResponse<T?>>
      deleteObject<T extends BaseModel, K extends EditBaseModel>({
    String? id,
  }) =>
          _provider.deleteTaskById<T>(
            id: id,
          );

  Future<ApiResponse<T?>>
      cancelTask<T extends BaseModel, K extends EditBaseModel>(String id) =>
          _provider.cancelTask<T, K>(id: id);

  Future<ApiResponse<T?>>
      updateTaskStatus<T extends BaseModel, K extends EditBaseModel>(String id) =>
          _provider.updateTaskStatus<T, K>(id: id);
}
