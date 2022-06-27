import 'dart:async';
import 'dart:io';
import '../../../main.dart';
import '../../base/models/upload_image.dart';
import 'tasker_api_provider.dart';

class TaskerRepository {
  final _provider = TaskerApiProvider();

  Future<ApiResponse<T?>>
      fetchAllData<T extends BaseModel, K extends EditBaseModel>({
    required Map<String, dynamic> params,
  }) =>
          _provider.fetchAllTaskers<T>(params: params);

  Future<ApiResponse<T?>>
      getProfile<T extends BaseModel, K extends EditBaseModel>() =>
          _provider.fetchTaskerByToken<T>();

  Future<ApiResponse<T?>>
      fetchDataById<T extends BaseModel, K extends EditBaseModel>({
    String? id,
  }) =>
          _provider.fetchTaskerById<T>(
            id: id,
          );

  Future<ApiResponse<T?>>
      editObject<T extends BaseModel, K extends EditBaseModel>({
    K? editModel,
    String? id,
  }) =>
          _provider.editTaskerById<T, K>(
            editModel: editModel,
            id: id,
          );

  Future<ApiResponse<T?>>
      deleteObject<T extends BaseModel, K extends EditBaseModel>({
    String? id,
  }) =>
          _provider.deleteTaskerById<T>(
            id: id,
          );

  Future<ApiResponse<T?>>
      editProfile<T extends BaseModel, K extends EditBaseModel>({
    K? editModel,
  }) =>
          _provider.editProfile<T, K>(
            editModel: editModel,
          );

  Future<ApiResponse<T?>>
      editPassword<T extends BaseModel, K extends EditBaseModel>({
    K? editModel,
  }) =>
          _provider.editPassword<T, K>(
            editModel: editModel,
          );

  uploadImage<T extends BaseModel>(
          {required UploadImage image}) =>
      _provider.uploadImage<T>(
        image: image,
      );
}
