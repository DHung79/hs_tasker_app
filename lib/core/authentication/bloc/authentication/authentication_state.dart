import 'package:equatable/equatable.dart';
import '../../../rest/models/rest_api_response.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AppAutheticated extends AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationStart extends AuthenticationState {}

class UserLogoutState extends AuthenticationState {}

class ResetPasswordDoneState extends AuthenticationState {}

class ForgotPasswordDoneState extends AuthenticationState {}

class ResendDoneState extends AuthenticationState {}

class UserTokenExpired extends AuthenticationState {}

class SetUserData<T extends BaseModel> extends AuthenticationState {
  final T currentUser;

  const SetUserData({required this.currentUser});

  @override
  List<Object> get props => [currentUser];
}

class AuthenticationNotAuthenticated extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String message;
  final String errorCode;

  const AuthenticationFailure({
    required this.message,
    required this.errorCode,
  });

  @override
  List<Object> get props => [message, errorCode];
}

class LoginLastUser extends AuthenticationState {
  final String username;
  final bool isKeepSession;

  const LoginLastUser({
    required this.username,
    required this.isKeepSession,
  });

  @override
  List<Object> get props => [username, isKeepSession];
}

class CheckOTPDoneState extends AuthenticationState {}

class ChangePasswordDoneState extends AuthenticationState {}
