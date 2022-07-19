import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/routes/route_names.dart';
import '../../main.dart';
import '../../widgets/jt_text_form_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _checkPasswordController = TextEditingController();
  bool _newPasswordSecure = true;
  bool _checkPasswordSecure = true;
  String? _errorMessage = '';
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: AppColor.primary1,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: AuthenticationBlocController().authenticationBloc,
        listener: (context, state) async {
          if (state is AuthenticationFailure) {
            _showError(state.errorCode);
          } else if (state is ResetPasswordDoneState) {
            navigateTo(authenticationRoute);
          }
        },
        child: LayoutBuilder(
          builder: (context, size) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  autovalidateMode: _autovalidate,
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          'Đặt mật khẩu mới',
                          style: AppTextTheme.bigText(AppColor.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            _errorMessage!,
                            style: AppTextTheme.normalHeaderTitle(
                                AppColor.others1),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: JTTextFormField(
                          hintText: 'NHẬP MẬT KHẨU MỚI',
                          isPassword: true,
                          obscureText: _newPasswordSecure,
                          controller: _newPasswordController,
                          passwordIconOnPressed: () {
                            setState(() {
                              _newPasswordSecure = !_newPasswordSecure;
                            });
                          },
                          onSaved: (value) {
                            _newPasswordController.text = value!.trim();
                          },
                          onChanged: (value) {
                            setState(() {
                              if (_errorMessage!.isNotEmpty) {
                                _errorMessage = '';
                              }
                            });
                          },
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return ValidatorText.empty(
                                  fieldName: ScreenUtil.t(I18nKey.password)!);
                            }
                            if (value.trim().length < 6) {
                              return ValidatorText.atLeast(
                                  fieldName: ScreenUtil.t(I18nKey.password)!,
                                  atLeast: 6);
                            }
                            if (value.trim().length > 50) {
                              return ValidatorText.moreThan(
                                  fieldName: ScreenUtil.t(I18nKey.password)!,
                                  moreThan: 50);
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: JTTextFormField(
                          hintText: 'NHẬP LẠI',
                          isPassword: true,
                          obscureText: _checkPasswordSecure,
                          controller: _checkPasswordController,
                          passwordIconOnPressed: () {
                            setState(() {
                              _checkPasswordSecure = !_checkPasswordSecure;
                            });
                          },
                          onSaved: (value) {
                            _checkPasswordController.text = value!.trim();
                          },
                          onChanged: (value) {
                            setState(() {
                              if (_errorMessage!.isNotEmpty) {
                                _errorMessage = '';
                              }
                            });
                          },
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return ValidatorText.empty(
                                  fieldName: ScreenUtil.t(I18nKey.password)!);
                            }
                            if (value != _newPasswordController.text) {
                              return 'Mật khẩu không khớp';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: AppButtonTheme.fillRounded(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(4),
                          constraints: const BoxConstraints(minHeight: 52),
                          child: Text(
                            'TIẾP TỤC',
                            style: AppTextTheme.headerTitle(
                              AppColor.primary1,
                            ),
                          ),
                          onPressed: () => _forgotPassword(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _forgotPassword() {
    setState(() {
      _errorMessage = '';
    });
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      AuthenticationBlocController().authenticationBloc.add(
            ResetPassword(password: _newPasswordController.text),
          );
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.always;
      });
    }
  }

  _showError(String errorCode) async {
    setState(() {
      _errorMessage = showError(errorCode, context);
    });
  }
}
