import 'dart:async';
import '../../../main.dart';
import '../../constants/api_constants.dart';
import '../../helpers/api_helper.dart';
import '../../rest/rest_api_handler_data.dart';
import 'dart:convert' as convert;

class NotificationApiProvider {
  Future<ApiResponse<T?>> fetchAllNoti<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.notifications +
        ApiConstants.tasker;
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

  Future<ApiResponse<T?>> getTotalUnread<T extends BaseModel>() async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.notifications +
        ApiConstants.tasker +
        ApiConstants.unread +
        ApiConstants.total;
    logDebug('path: $path');
    final token = await ApiHelper.getUserToken();
    logDebug('token: $token');
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> readAllNoti<T extends BaseModel>() async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.notifications +
        ApiConstants.read +
        ApiConstants.all;
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.putData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> readNotiById<T extends BaseModel>({
    required String id,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.notifications +
        ApiConstants.tasker +
        ApiConstants.read +
        '/$id';
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.putData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<bool> updateFcmToken({Map<String, dynamic>? body}) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.fcmToken +
        ApiConstants.tasker;
    final token = await ApiHelper.getUserToken();
    // logDebug('path: $path\nbody: $body');
    final response = await RestApiHandlerData.updateFcmToken(
      path: path,
      headers: ApiHelper.headers(token),
      body: convert.jsonEncode(body),
    );
    return response;
  }

  Future<bool> removeFcmToken<T extends BaseModel>({
    required String fcmToken,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.fcmToken +
        ApiConstants.tasker;
    final body = convert.jsonEncode({'fcm_token': fcmToken});
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.removeFcmToken(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
}
