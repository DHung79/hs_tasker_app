import 'dart:async';
import '../../../main.dart';
import 'service_api_provider.dart';

class ServiceRepository {
  final _provider = ServiceApiProvider();

  Future<ApiResponse<T?>> deleteObject<T extends BaseModel>({
    String? id,
  }) =>
      _provider.deleteService<T>(
        id: id,
      );

  Future<ApiResponse<T?>> fetchAllData<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchAllServices<T>(params: params);

  Future<ApiResponse<T?>> fetchDataById<T extends BaseModel>({
    String? id,
  }) =>
      _provider.fetchServiceById<T>(
        id: id,
      );

  Future<ApiResponse<T?>>
      editObject<T extends BaseModel, K extends EditBaseModel>({
    K? editModel,
    String? id,
  }) =>
          _provider.editService<T, K>(
            editModel: editModel,
            id: id,
          );

  Future<ApiResponse<T?>>
      createObject<T extends BaseModel, K extends EditBaseModel>({
    K? editModel,
    String? id,
  }) =>
          _provider.createService<T, K>(
            editModel: editModel,
          );
}
