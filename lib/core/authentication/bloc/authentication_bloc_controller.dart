import '../../authentication/bloc/authentication/authentication_bloc.dart';

class AuthenticationBlocController {
  AuthenticationBlocController._();

  static AuthenticationBlocController _instance =
      AuthenticationBlocController._();

  factory AuthenticationBlocController() => _instance;

  // ignore: close_sinks
  AuthenticationBloc authenticationBloc = AuthenticationBloc();
}
