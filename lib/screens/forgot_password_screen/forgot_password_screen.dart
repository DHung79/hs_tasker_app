import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import 'package:validators/validators.dart';
import '../../core/authentication/auth.dart';
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // bool _passwordSecure = true;
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
          } else if (state is ResetPasswordState) {
            JTToast.init(context);
            navigateTo(resetPasswordRoute);
            await Future.delayed(const Duration(milliseconds: 400));
            JTToast.successToast(
                width: 327,
                height: 53,
                message: ScreenUtil.t(I18nKey.checkYourEmail)!);
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
                      children: [
                        Text(ScreenUtil.t(I18nKey.forgotPassword)!),
                        _buildErrorMessage(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: JTTextFormField(
                            hintText: 'TÀI KHOẢN',
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            onSaved: (value) {
                              emailController.text = value!.trim();
                            },
                            onChanged: (value) {
                              setState(() {
                                if (_errorMessage!.isNotEmpty) {
                                  _errorMessage = '';
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              'ĐĂNG KÍ',
                              style:
                                  AppTextTheme.headerTitle(AppColor.primary1),
                            ),
                            onPressed: () => _forgotPassword,
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
            ForgotPassword(email: emailController.text),
          );
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  _buildErrorMessage() {
    return _errorMessage != null && _errorMessage!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                minHeight: 24,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(
                    color: Theme.of(context).errorColor,
                    width: 1,
                  ),
                ),
                child: Padding(
                  child: Text(
                    _errorMessage!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).errorColor),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                ),
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
