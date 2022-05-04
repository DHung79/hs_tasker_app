import 'dart:async';
import '../../../main.dart';
import 'user_api_provider.dart';

class UserRepository {
  final _provider = UserApiProvider();

  Future<ApiResponse<T?>>
      deleteObject<T extends BaseModel, K extends EditBaseModel>({
    String? id,
  }) =>
          _provider.deleteUser<T>(
            id: id,
          );

  Future<ApiResponse<T?>>
      fetchAllData<T extends BaseModel, K extends EditBaseModel>({
    required Map<String, dynamic> params,
  }) =>
          _provider.fetchAllUsers<T>(params: params);

  Future<ApiResponse<T?>>
      fetchDataById<T extends BaseModel, K extends EditBaseModel>({
    String? id,
  }) =>
          _provider.fetchUserById<T>(
            id: id,
          );

  // Future<ApiResponse<T?>>
  //     getProfile<T extends BaseModel, K extends EditBaseModel>() =>
  //         _provider.getProfile<T>();

  // Future<ApiResponse<T?>>
  //     userChangePassword<T extends BaseModel, K extends EditBaseModel>(
  //             {Map<String, dynamic>? params}) =>
  //         _provider.userChangePassword<T>(
  //           params: params,
  //         );

  // Future<ApiResponse<T?>>
  //     editProfile<T extends BaseModel, K extends EditBaseModel>({
  //   K? editModel,
  // }) =>
  //         _provider.editProfile<T, K>(
  //           editModel: editModel,
  //         );

  // Future<ApiResponse<T?>>
  //     editObject<T extends BaseModel, K extends EditBaseModel>({
  //   K? editModel,
  //   String? id,
  // }) =>
  //         _provider.editUser<T, K>(
  //           editModel: editModel,
  //           id: id,
  //         );
}
