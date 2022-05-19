import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';
import '../../constants/api_constants.dart';
import '../../helpers/api_helper.dart';
import '../../rest/rest_api_handler_data.dart';
import '../models/status.dart';

class AuthenticationProvider {
  loginWithEmailAndPassword(dynamic body) async {
    final url = ApiConstants.apiDomain + ApiConstants.apiVersion + '/login';
    final response = await RestApiHandlerData.login(
      path: url,
      body: body,
      headers: ApiHelper.headers(null),
    );
    return response;
  }

  signUpWithEmailAndPassword(dynamic body) async {
    return null;
  }

  getUserData(String id) async {
    final url = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.users +
        '/$id';
    final SharedPreferences sharedPreferences = await prefs;
    var token = sharedPreferences.getString('authtoken') ?? '';
    final response = await RestApiHandlerData.getData(
      path: url,
      headers: {
        'x-auth-token': token,
      },
    );
    return response;
  }

  signOut(dynamic body) async {
    final url = ApiConstants.apiDomain + ApiConstants.apiVersion + '/logout';
    final SharedPreferences sharedPreferences = await prefs;
    var token = sharedPreferences.getString('authtoken') ?? '';
    final response = await RestApiHandlerData.postData(
      path: url,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  resetPassword(dynamic body) async {
    final url = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.forgotPassword +
        '/reset-token';
    final response = await RestApiHandlerData.putData<Status>(
      path: url,
      body: body,
      headers: ApiHelper.headers(null),
    );
    return response;
  }

  forgotPassword(dynamic body) async {
    final url = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.forgotPassword;
    final response = await RestApiHandlerData.postData<Status>(
      path: url,
      body: body,
      headers: ApiHelper.headers(null),
    );
    return response;
  }

  removeFcmToken(dynamic body) async {
    final url = ApiConstants.apiDomain + ApiConstants.apiVersion + '/fcm_token';
    final response = await RestApiHandlerData.deleteData<Status>(
      path: url,
      body: body,
      headers: ApiHelper.headers(null),
    );
    return response;
  }

  signInWithFacebook(dynamic body) async {
    final url =
        ApiConstants.apiDomain + ApiConstants.apiVersion + '/login/facebook';
    final response = await RestApiHandlerData.login(
      path: url,
      body: body,
      headers: ApiHelper.headers(null),
    );
    return response;
  }

  signInWithGoogle(dynamic body) async {
    final url =
        ApiConstants.apiDomain + ApiConstants.apiVersion + '/login/google';
    final response = await RestApiHandlerData.login(
      path: url,
      body: body,
      headers: ApiHelper.headers(null),
    );
    return response;
  }

  taskerLogin(dynamic body) async {
    final url =
        ApiConstants.apiDomain + ApiConstants.apiVersion + '/login/tasker';
    final response = await RestApiHandlerData.login(
      path: url,
      body: body,
      headers: ApiHelper.headers(null),
    );
    return response;
  }
}
