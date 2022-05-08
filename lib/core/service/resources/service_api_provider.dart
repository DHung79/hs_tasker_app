import 'dart:async';
import 'dart:convert' as convert;
import '../../../main.dart';
import '../../constants/api_constants.dart';
import '../../helpers/api_helper.dart';
import '../../rest/rest_api_handler_data.dart';

class ServiceApiProvider {
  Future<ApiResponse<T?>> fetchAllServices<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path =
        ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.users;
    if (params.isNotEmpty) {
      var queries = <String>[];
      params.forEach((key, value) => queries.add('$key=$value'));
      path += '?' + queries.join('&');
    }
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> fetchServiceById<T extends BaseModel>({
    String? id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.users +
        '/$id';
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> deleteService<T extends BaseModel>({
    String? id,
  }) async {
    final path =
        ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.users;
    final body = convert.jsonEncode({'id': id});
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.deleteData<T>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

//   Future<ApiResponse<T?>>
//       editProfile<T extends BaseModel, K extends EditBaseModel>({
//     K? editModel,
//   }) async {
//     final path = ApiConstants.apiDomain +
//         ApiConstants.apiVersion +
//         ApiConstants.users +
//         ApiConstants.me;
//     final body = convert.jsonEncode(EditBaseModel.toEditInfoJson(editModel));
//     logDebug('path: $path\nbody: $body');
//     final token = await ApiHelper.getServiceToken();
//     final response = await RestApiHandlerData.putData<T>(
//       path: path,
//       body: body,
//       headers: ApiHelper.headers(token),
//     );
//     return response;
//   }

//   Future<ApiResponse<T?>>
//       editService<T extends BaseModel, K extends EditBaseModel>({
//     K? editModel,
//     String? id,
//   }) async {
//     final path = ApiConstants.apiDomain +
//         ApiConstants.apiVersion +
//         ApiConstants.users +
//         '/$id';
//     final body = convert.jsonEncode(EditBaseModel.toEditJson(editModel));
//     final token = await ApiHelper.getServiceToken();
//     logDebug('path: $path\nbody: $body');
//     final response = await RestApiHandlerData.putData<T>(
//       path: path,
//       body: body,
//       headers: ApiHelper.headers(token),
//     );
//     return response;
//   }

//   Future<ApiResponse<T?>> getProfile<T extends BaseModel>() async {
//     final path = ApiConstants.apiDomain +
//         ApiConstants.apiVersion +
//         ApiConstants.users +
//         ApiConstants.me;
//     final token = await ApiHelper.getServiceToken();
//     final response = await RestApiHandlerData.getData<T>(
//       path: path,
//       headers: ApiHelper.headers(token),
//     );
//     return response;
//   }

//   Future<ApiResponse<T?>> userChangePassword<T extends BaseModel>(
//       {Map<String, dynamic>? params}) async {
//     final path = ApiConstants.apiDomain +
//         ApiConstants.apiVersion +
//         ApiConstants.users +
//         ApiConstants.me +
//         ApiConstants.changePassword;
//     final token = await ApiHelper.getServiceToken();
//     final body = convert.jsonEncode(params);
//     logDebug('path: $path\nbody: $body');
//     final response = await RestApiHandlerData.putData<T>(
//       path: path,
//       body: body,
//       headers: ApiHelper.headers(token),
//     );
//     return response;
//   }
// }
}
