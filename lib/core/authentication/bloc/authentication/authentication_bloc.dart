import 'package:bloc/bloc.dart';
import 'package:hs_tasker_app/core/notification/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import '../../../../../main.dart';
import '../../models/status.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    final AuthenticationRepository authenticationService =
        AuthenticationRepository();
    on<AppLoadedup>((event, emit) async {
      final SharedPreferences sharedPreferences = await prefs;
      emit(AuthenticationLoading());
      try {
        if (sharedPreferences.getString('authtoken') != null) {
          emit(AppAutheticated());
        } else {
          emit(AuthenticationStart());
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<UserSignUp>((event, emit) async {
      final SharedPreferences sharedPreferences = await prefs;
      emit(AuthenticationLoading());
      try {
        final data = await authenticationService.signUpWithEmailAndPassword(
            event.email, event.password);
        if (data["error"] == null) {
          final currentUser = UserData.fromJson(data);
          if (currentUser.id! > 0) {
            sharedPreferences.setString('authtoken', currentUser.token!);
            emit(AppAutheticated());
          } else {
            emit(AuthenticationNotAuthenticated());
          }
        } else {
          emit(AuthenticationFailure(
            message: data["error_message"],
            errorCode: data["error_code"].toString(),
          ));
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<UserLogin>(
      (event, emit) async {
        final SharedPreferences sharedPreferences = await prefs;
        emit(AuthenticationLoading());
        try {
          final data = await authenticationService.taskerLogin(
            event.email,
            event.password,
          );
          if (data["error_message"] == null) {
            final currentUser = Token.fromJson(data);
            if (currentUser.id.isNotEmpty) {
              final _now = DateTime.now().millisecondsSinceEpoch;
              sharedPreferences.setString('authtoken', currentUser.token);
              sharedPreferences.setString('last_username', event.email);
              sharedPreferences.setString('last_userpassword', event.password);
              sharedPreferences.setBool('keep_session', event.keepSession);
              sharedPreferences.setInt('login_time', _now);
              emit(AppAutheticated());
            } else {
              emit(AuthenticationNotAuthenticated());
            }
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        } on Error catch (e) {
          emit(AuthenticationFailure(
            message: e.toString(),
            errorCode: '',
          ));
        }
      },
    );

    on<TokenExpired>((event, emit) async {
      _cleanupCache();
      emit(UserTokenExpired());
    });

    on<GetLastUser>((event, emit) async {
      final SharedPreferences sharedPreferences = await prefs;
      final username = sharedPreferences.getString('last_username') ?? '';
      final keepSession = sharedPreferences.getBool('keep_session') ?? false;
      emit(
        LoginLastUser(
          username: username,
          isKeepSession: keepSession,
        ),
      );
    });

    on<GetUserData>((event, emit) async {
      final SharedPreferences sharedPreferences = await prefs;
      final token = sharedPreferences.getString('authtoken');
      if (token == null || token.isEmpty) {
        _cleanupCache();
        emit(AuthenticationStart());
      } else {
        await sharedPreferences.reload();
        // Expire local if the time is over 24h
        final _keepSesstion =
            sharedPreferences.getBool('keep_session') ?? false;
        var _isExpired = false;
        if (!_keepSesstion) {
          final _loginTime = sharedPreferences.getInt('login_time');
          const _aDay = 24 * 60 * 60 * 1000;
          if (_loginTime == null) {
            _isExpired = true;
          } else if (DateTime.now().millisecondsSinceEpoch - _loginTime >
              _aDay) {
            _isExpired = true;
          }
        }
        if (_isExpired) {
          _cleanupCache();
          emit(UserTokenExpired());
        } else {
          final userJson = sharedPreferences.getString('userJson');
          if (userJson != null && userJson.isNotEmpty) {
            try {
              final account = await TaskerBloc().getProfile();
              // ignore: unnecessary_null_comparison
              if (account == null) {
                Map<String, dynamic> json = convert.jsonDecode(userJson);
                final account = TaskerModel.fromJson(json);
                account.password =
                    sharedPreferences.getString('last_userpassword') ?? '';
                emit(SetUserData(currentUser: account));
              } else {
                final json = account.toJson();
                final jsonStr = convert.jsonEncode(json);
                sharedPreferences.setString('userJson', jsonStr);
                account.password =
                    sharedPreferences.getString('last_userpassword') ?? '';
                emit(SetUserData(currentUser: account));
              }
              return;
            } on Error catch (e) {
              emit(AuthenticationFailure(
                message: e.toString(),
                errorCode: '',
              ));
            }
          } else {
            final account = await TaskerBloc().getProfile();
            // ignore: unnecessary_null_comparison
            if (account == null) {
              _cleanupCache();
              emit(UserTokenExpired());
            } else {
              final json = account.toJson();
              final jsonStr = convert.jsonEncode(json);
              sharedPreferences.setString('userJson', jsonStr);
              account.password =
                  sharedPreferences.getString('last_userpassword') ?? '';
              emit(SetUserData(currentUser: account));
            }
          }
        }
      }
    });

    on<ForgotPassword>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        final SharedPreferences sharedPreferences = await prefs;
        final String email =
            sharedPreferences.getString('resend_otp_email') ?? '';
        if (event.email != email) {
          sharedPreferences.setString('resend_otp_email', event.email);
          final data = await authenticationService.forgotPassword(event.email);
          if (data is ApiResponse) {
            if (data.error == null) {
              emit(ForgotPasswordDoneState());
            } else {
              emit(AuthenticationFailure(
                message: data.error!.errorMessage,
                errorCode: data.error!.errorCode,
              ));
            }
          } else {
            if (data["error_message"] == null) {
              emit(ForgotPasswordDoneState());
            } else {
              emit(AuthenticationFailure(
                message: data["error_message"],
                errorCode: data["error_code"].toString(),
              ));
            }
          }
        } else {
          final data = await authenticationService.checkEmail(event.email);
          if (data is ApiResponse) {
            if (data.error == null) {
              emit(ForgotPasswordDoneState());
            } else {
              emit(AuthenticationFailure(
                message: data.error!.errorMessage,
                errorCode: data.error!.errorCode,
              ));
            }
          } else {
            if (data["error_message"] == null) {
              emit(ForgotPasswordDoneState());
            } else {
              emit(AuthenticationFailure(
                message: data["error_message"],
                errorCode: data["error_code"].toString(),
              ));
            }
          }
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<CheckOTP>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        final SharedPreferences sharedPreferences = await prefs;
        final data = await authenticationService.checkOTP(event.otp);
        if (data is ApiResponse<OtpModel>) {
          if (data.model != null) {
            sharedPreferences.remove('resend_otp_email');
            sharedPreferences.setString('reset_id', data.model!.userId);
            emit(CheckOTPDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data.error!.errorMessage,
              errorCode: data.error!.errorCode,
            ));
          }
        } else {
          if (data["error_message"] == null) {
            emit(CheckOTPDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<ResendOTP>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        final SharedPreferences sharedPreferences = await prefs;
        final email = sharedPreferences.getString('resend_otp_email') ?? '';
        final data = await authenticationService.forgotPassword(email);
        if (data is ApiResponse) {
          if (data.error == null) {
            emit(ResendDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data.error!.errorMessage,
              errorCode: data.error!.errorCode,
            ));
          }
        } else {
          if (data["error_message"] == null) {
            emit(ResendDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<ResetPassword>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        final SharedPreferences sharedPreferences = await prefs;
        final userId = sharedPreferences.getString('reset_id') ?? '';
        final data = await authenticationService.resetPassword(
          userId,
          event.password,
        );
        if (data is ApiResponse) {
          if (data.error == null) {
            sharedPreferences.remove('reset_id');
            emit(ResetPasswordDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data.error!.errorMessage,
              errorCode: data.error!.errorCode,
            ));
          }
        } else {
          if (data["error_message"] == null) {
            emit(ResetPasswordDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<ChangePassword>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        final SharedPreferences sharedPreferences = await prefs;
        final data = await authenticationService.changePassword(
          event.password,
          event.newPassword,
        );
        if (data is ApiResponse) {
          if (data.error == null) {
            final userJson = sharedPreferences.getString('userJson');
            if (userJson != null && userJson.isNotEmpty) {
              Map<String, dynamic> json = convert.jsonDecode(userJson);
              final account = TaskerModel.fromJson(json);
              sharedPreferences.setString(
                  'last_userpassword', event.newPassword);
              emit(SetUserData(currentUser: account));
            }
            emit(ChangePasswordDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data.error!.errorMessage,
              errorCode: data.error!.errorCode,
            ));
          }
        } else {
          if (data["error_message"] == null) {
            sharedPreferences.setString('last_userpassword', event.newPassword);
            emit(ChangePasswordDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<UserLogOut>((event, emit) async {
      // await authenticationService.signOut({'fcmToken': currentFcmToken});
      _cleanupCache();
      emit(UserLogoutState());
    });
  }

  _cleanupCache() async {
    final SharedPreferences sharedPreferences = await prefs;
    sharedPreferences.remove('authtoken');
    sharedPreferences.remove('userJson');
    sharedPreferences.remove('login_time');
    sharedPreferences.remove('last_lang');
    if (currentFcmToken != null) {
      await NotificationRepository().removeFcmToken(fcmToken: currentFcmToken!);
    }
  }
}
