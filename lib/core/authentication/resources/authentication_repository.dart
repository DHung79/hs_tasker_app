import 'dart:convert' as convert;
import '../../authentication/resources/authentication_provider.dart';

class AuthenticationRepository {
  final provider = AuthenticationProvider();

  Future<dynamic> signUpWithEmailAndPassword(
      String? email, String? password) async {
    await Future.delayed(
        const Duration(seconds: 1)); // simulate a network delay
    final response = await provider
        .signUpWithEmailAndPassword({'email': email, 'password': password});
    return response;
  }

  Future<dynamic> signOut(Map<String, dynamic> params) async {
    await Future.delayed(
        const Duration(seconds: 1)); // simulate a network delay
    final body = convert.jsonEncode(params);
    final response = await provider.signOut(body);
    return response;
  }

  Future<dynamic> resetPassword(
    String id,
    String password,
  ) async {
    await Future.delayed(
        const Duration(seconds: 1)); // simulate a network delay
    final body = convert.jsonEncode({
      'id': id,
      'password': password,
    });
    final response = await provider.resetPassword(body);
    return response;
  }

  Future<dynamic> forgotPassword(String email) async {
    await Future.delayed(
        const Duration(seconds: 1)); // simulate a network delay
    final body = convert.jsonEncode({'email': email});
    final response = await provider.forgotPassword(body);
    return response;
  }

  Future<dynamic> checkEmail(String email) async {
    await Future.delayed(
        const Duration(seconds: 1)); // simulate a network delay
    final body = convert.jsonEncode({'email': email});
    final response = await provider.checkEmail(body);
    return response;
  }

  Future<dynamic> removeFcmToken(String fcmToken) async {
    await Future.delayed(
        const Duration(seconds: 1)); // simulate a network delay
    final body = convert.jsonEncode({
      'fcm_token': fcmToken,
    });
    final response = await provider.removeFcmToken(body);
    return response;
  }

  Future<dynamic> loginWithFacebook(String? accessToken) async {
    await Future.delayed(
        const Duration(seconds: 1)); // simulate a network delay
    final body = convert.jsonEncode({'accessToken': accessToken});
    final response = await provider.signInWithFacebook(body);
    return response;
  }

  Future<dynamic> loginWithGoogle(String? accessToken) async {
    await Future.delayed(
        const Duration(seconds: 1)); // simulate a network delay
    final body = convert.jsonEncode({'accessToken': accessToken});
    final response = await provider.signInWithGoogle(body);
    return response;
  }

  Future<dynamic> taskerLogin(String? email, String? password) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    final body = convert.jsonEncode({'email': email, 'password': password});
    final response = await provider.taskerLogin(body);
    return response;
  }

  Future<dynamic> checkOTP(String otp) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    final body = convert.jsonEncode({'otp': otp});
    final response = await provider.checkOTP(body);
    return response;
  }

  Future<dynamic> changePassword(
    String password,
    String newPassword,
  ) async {
    await Future.delayed(
        const Duration(seconds: 1)); // simulate a network delay
    final body = convert.jsonEncode({
      'password': password,
      'new_password': newPassword,
    });
    final response = await provider.changePassword(body);
    return response;
  }
}
