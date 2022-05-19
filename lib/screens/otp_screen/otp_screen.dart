import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '/routes/route_names.dart';
import '../../main.dart';
import '../../theme/validator_text.dart';
import '../../widgets/jt_toast.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _otpController = TextEditingController();
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: AppColor.transparent,
                  highlightColor: AppColor.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.secondary1,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgIcon(
                              SvgIcons.arrowBack,
                              color: AppColor.black,
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 111,
                          height: 44,
                          child: Center(
                            child: Text(
                              'Nhập email',
                              style: AppTextTheme.normalText(AppColor.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    navigateTo(forgotPasswordRoute);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _key,
                autovalidateMode: _autovalidate,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'Nhập mã OTP',
                        style: AppTextTheme.bigText(AppColor.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: _buildErrorMessage(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        controller: _otpController,
                        textStyle: AppTextTheme.bigText(AppColor.white),
                        animationType: AnimationType.fade,
                        animationDuration: const Duration(milliseconds: 250),
                        autoFocus: true,
                        autoDismissKeyboard: false,
                        cursorColor: AppColor.white,
                        backgroundColor: AppColor.primary1,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        pinTheme: PinTheme(
                          fieldHeight: 40,
                          fieldWidth: 32,
                          activeFillColor: AppColor.primary1,
                          selectedFillColor: AppColor.primary1,
                          activeColor: AppColor.white,
                          selectedColor: AppColor.white,
                          inactiveColor: AppColor.white,
                          inactiveFillColor: AppColor.primary1,
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (_errorMessage!.isNotEmpty) {
                              _errorMessage = '';
                            }
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            _errorMessage =
                                ValidatorText.empty(fieldName: 'OTP');
                            return '';
                          } else {
                            _errorMessage = '';
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _otpController.text = value!;
                        },
                        onCompleted: (value) => _checkOTP(),
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
                        onPressed: () => _checkOTP(),
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
                              'Gửi lại',
                              style: AppTextTheme.normalHeaderTitle(
                                  AppColor.white),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _checkOTP() {
    setState(() {
      _errorMessage = '';
    });

    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      // AuthenticationBlocController().authenticationBloc.add(
      //       ForgotPassword(email: emailController.text),
      //     );
      navigateTo(resetPasswordRoute);
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.always;
      });
    }
  }

  Widget _buildErrorMessage() {
    return _errorMessage != null && _errorMessage!.isNotEmpty
        ? Center(
            child: Text(
              _errorMessage!,
              style: AppTextTheme.normalHeaderTitle(AppColor.others1),
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
