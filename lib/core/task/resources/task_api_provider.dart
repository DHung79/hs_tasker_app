import 'dart:async';
import 'dart:convert' as convert;
import '../../../main.dart';
import '../../constants/api_constants.dart';
import '../../helpers/api_helper.dart';
import '../../rest/rest_api_handler_data.dart';

class TaskApiProvider {
  Future<ApiResponse<T?>> fetchAllTasks<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path =
        ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.tasks;
    if (params.isNotEmpty) {
      var queries = <String>[];
      params.forEach((key, value) => queries.add('$key=$value'));
      path += '?' + queries.join('&');
    }
    logDebug('path: $path');
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> fetchTaskByToken<T extends BaseModel>() async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.tasks +
        ApiConstants.me;
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> fetchTaskById<T extends BaseModel>({
    String? id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.tasks +
        '/$id';
    logDebug('path: $path');
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>>
      editTaskById<T extends BaseModel, K extends EditBaseModel>({
    K? editModel,
    String? id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.tasks +
        '/$id';
    final body = convert.jsonEncode(EditBaseModel.toEditJson(editModel!));
    final token = await ApiHelper.getUserToken();
    logDebug('path: $path\nbody: $body');
    final response = await RestApiHandlerData.putData<T>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> deleteTaskById<T extends BaseModel>({
    String? id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.tasks +
        '/$id';
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.deleteData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>>
      taskerTakeTask<T extends BaseModel, K extends EditBaseModel>({
    required String id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.tasks +
        ApiConstants.tasker +
        '/$id';
    final body = convert.jsonEncode({});
    logDebug('path: $path\nbody: $body');
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.postData<T>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>>
      cancelTask<T extends BaseModel, K extends EditBaseModel>({
    required String id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.tasks +
        ApiConstants.tasker +
        '/$id';
    final body = convert.jsonEncode({});
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.putData<T>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>>
      updateTaskStatus<T extends BaseModel, K extends EditBaseModel>({
    required String id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.tasks +
        ApiConstants.tasker +
        '/$id';
    final body = convert.jsonEncode({});
    logDebug('path: $path\nbody: $body');
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.putData<T>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> uploadListImage<T extends BaseModel>({
    required String id,
    required bool isBefore,
    required List<String> filesPath,
  }) async {
    final apiKey = isBefore ? '/upload-before' : '/upload-after';
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.tasks +
        apiKey +
        '/$id';
    final body = convert.jsonEncode({});
    logDebug('path: $path\nbody: $body');
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.putUpload<T>(
      path: path,
      headers: ApiHelper.upload(token),
      field: isBefore ? 'list_pictures_before' : 'list_pictures_after',
      filesPath: filesPath,
    );
    return response;
  }

  Future<ApiResponse<T?>> completeTask<T extends BaseModel>({
    required String id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.tasks +
        ApiConstants.tasker +
        '/complete' +
        '/$id';
    final body = convert.jsonEncode({});
    logDebug('path: $path\nbody: $body');
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.postData<T>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
}
