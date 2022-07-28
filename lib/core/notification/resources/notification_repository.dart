import 'dart:async';
import '../../rest/models/rest_api_response.dart';
import 'notification_api_provider.dart';

class NotificationRepository {
  final _provider = NotificationApiProvider();

  Future<ApiResponse<T?>> fetchAllData<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchAllNoti<T>(params: params);

  Future<ApiResponse<T?>> getTotalUnread<T extends BaseModel>() =>
      _provider.getTotalUnread<T>();

  Future<ApiResponse<T?>> readAllNoti<T extends BaseModel>() =>
      _provider.readAllNoti<T>();

  Future<ApiResponse<T?>> readNotiById<T extends BaseModel>({
    required String id,
  }) =>
      _provider.readNotiById<T>(id: id);

  Future<bool> updateFcmToken({
    Map<String, dynamic>? body,
  }) =>
      _provider.updateFcmToken(body: body);

  Future<bool> removeFcmToken<T extends BaseModel>({
    required String fcmToken,
  }) =>
      _provider.removeFcmToken(fcmToken: fcmToken);
}
