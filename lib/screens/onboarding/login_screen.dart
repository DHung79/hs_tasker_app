import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import 'package:validators/validators.dart';
import '../../main.dart';
import '../../widgets/jt_text_form_field.dart';

class LoginForm extends StatefulWidget {
  final AuthenticationState? state;
  const LoginForm({Key? key, this.state}) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage = '';
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  bool? _isKeepSession = false;
  bool _passwordSecure = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(GetLastUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: AuthenticationBlocController().authenticationBloc,
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          _showError(state.errorCode);
        } else if (state is LoginLastUser) {
          _emailController.text = state.username;
          setState(() {
            _isKeepSession = state.isKeepSession;
          });
        }
      },
      child: LayoutBuilder(
        builder: (context, size) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            padding: size.maxWidth < 500
                ? EdgeInsets.zero
                : const EdgeInsets.all(30),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: size.maxWidth - 48),
                child: Form(
                  autovalidateMode: _autovalidate,
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildErrorMessage(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: JTTextFormField(
                          hintText: 'TÀI KHOẢN',
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          onSaved: (value) {
                            _emailController.text = value!.trim();
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
                                  fieldName: ScreenUtil.t(I18nKey.email)!);
                            }
                            if (!isEmail(value.trim())) {
                              return ValidatorText.invalidFormat(
                                  fieldName: ScreenUtil.t(I18nKey.email)!);
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: JTTextFormField(
                          hintText: 'MẬT KHẨU',
                          isPassword: true,
                          obscureText: _passwordSecure,
                          controller: _passwordController,
                          passwordIconOnPressed: () {
                            setState(() {
                              _passwordSecure = !_passwordSecure;
                            });
                          },
                          onSaved: (value) {
                            _passwordController.text = value!.trim();
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
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Center(
                          child: InkWell(
                            splashColor: AppColor.transparent,
                            highlightColor: AppColor.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ScreenUtil.t(I18nKey.forgotPassword)!,
                                style: AppTextTheme.link(AppColor.white),
                              ),
                            ),
                            onTap: () => navigateTo(forgotPasswordRoute),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: AppButtonTheme.fillRounded(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(4),
                          constraints: const BoxConstraints(minHeight: 52),
                          child: Text(
                            ScreenUtil.t(I18nKey.signIn)!.toUpperCase(),
                            style: AppTextTheme.headerTitle(
                              AppColor.primary1,
                            ),
                          ),
                          onPressed: () => _login(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: AppButtonTheme.fillRounded(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(4),
                          constraints: const BoxConstraints(minHeight: 52),
                          child: Text(
                            'ĐĂNG KÍ',
                            style: AppTextTheme.headerTitle(
                              AppColor.primary1,
                            ),
                          ),
                          onPressed: () => navigateTo(registerRoute),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _login() {
    setState(() {
      _errorMessage = '';
    });
    if (widget.state is AuthenticationLoading) return;

    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      AuthenticationBlocController().authenticationBloc.add(
            UserLogin(
              email: _emailController.text,
              password: _passwordController.text,
              keepSession: _isKeepSession!,
              isMobile: true,
            ),
          );
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  Widget _buildErrorMessage() {
    return _errorMessage != null && _errorMessage!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Center(
              child: Text(
                _errorMessage!,
                style: AppTextTheme.normalHeaderTitle(AppColor.others1),
              ),
            ),
          )
        : const SizedBox();
  }

  _showError(String errorCode) async {
    setState(() {
      _errorMessage = showError(errorCode, context);
    });
  }
}
