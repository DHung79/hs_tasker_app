import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/routes/route_names.dart';
import 'package:validators/validators.dart';
import '../../main.dart';
import '../../theme/validator_text.dart';
import '../../widgets/jt_text_form_field.dart';
import '../../widgets/jt_toast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _errorMessage = '';
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  bool _processing = false;
  Timer? _delayForgotPassword;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  void dispose() {
    _delayForgotPassword?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: AppColor.primary1,
      appBar: AppBar(
        backgroundColor: AppColor.primary1,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              splashColor: AppColor.transparent,
              highlightColor: AppColor.transparent,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: AppColor.black,
                ),
              ),
              onTap: () {
                navigateTo(authenticationRoute);
              },
            ),
          ),
        ],
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: AuthenticationBlocController().authenticationBloc,
        listener: (context, state) async {
          if (state is AuthenticationFailure) {
            _showError(state.errorCode);
          }
          if (state is ForgotPasswordDoneState) {
            JTToast.init(context);
            navigateTo(otpRoute);
            await Future.delayed(const Duration(milliseconds: 400));
            JTToast.successToast(
                width: 327,
                height: 53,
                message: ScreenUtil.t(I18nKey.checkYourEmail)!);
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
                          ScreenUtil.t(I18nKey.forgotPassword)!,
                          style: AppTextTheme.bigText(AppColor.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: _buildErrorMessage(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: JTTextFormField(
                          hintText: 'NHẬP EMAIL',
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          onSaved: (value) {
                            _emailController.text = value!.trim();
                          },
                          onChanged: (value) {
                            setState(() {
                              if (_errorMessage.isNotEmpty) {
                                _errorMessage = '';
                              }
                              if (_processing && _errorMessage.isEmpty) {
                                _processing = false;
                              }
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty || value.trim().isEmpty) {
                              return ValidatorText.empty(
                                  fieldName: ScreenUtil.t(I18nKey.email)!);
                            }
                            if (!isEmail(value.trim())) {
                              return ValidatorText.invalidFormat(
                                  fieldName: ScreenUtil.t(I18nKey.email)!);
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) => _forgotPassword(),
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
                          onPressed: !_processing ? _forgotPassword : null,
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
      _processing = true;
      _delayForgotPassword =
          Timer.periodic(const Duration(seconds: 2), (timer) {
        if (timer.tick == 1) {
          timer.cancel();
          setState(() {
            _processing = false;
          });
        }
      });
    });
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      AuthenticationBlocController().authenticationBloc.add(
            ForgotPassword(email: _emailController.text),
          );
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.always;
      });
    }
  }

  Widget _buildErrorMessage() {
    return _errorMessage.isNotEmpty
        ? Center(
            child: Text(
              _errorMessage,
              style: AppTextTheme.normalHeaderTitle(AppColor.others1),
            ),
          )
        : const SizedBox();
  }

  _showError(String errorCode) async {
    setState(() {
      _errorMessage = showError(errorCode, context, fieldName: 'Email');
    });
  }
}
