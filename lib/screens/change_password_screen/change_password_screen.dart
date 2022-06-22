import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../main.dart';
import '../../theme/validator_text.dart';
import '../../widgets/jt_indicator.dart';
import '../../widgets/jt_toast.dart';
import '../layout_template/content_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _pageState = PageState();
  final _taskerBloc = TaskerBloc();
  String _errorMessage = '';
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _checkNewPasswordController = TextEditingController();
  bool _oldPasswordSecure = true;
  bool _newPasswordSecure = true;
  bool _checkNewPasswordSecure = true;

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    JTToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    _taskerBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return PageTemplate(
      pageState: _pageState,
      onUserFetched: (user) => setState(() {}),
      appBarHeight: 0,
      child: FutureBuilder(
          future: _pageState.currentUser,
          builder: (context, AsyncSnapshot<TaskerModel> snapshot) {
            return PageContent(
              pageState: _pageState,
              onFetch: () {
                _fetchDataOnPage();
              },
              child: snapshot.hasData
                  ? _changePassword(snapshot)
                  : const JTIndicator(),
            );
          }),
    );
  }

  Widget _changePassword(AsyncSnapshot<TaskerModel> snapshot) {
    final tasker = snapshot.data;
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: _appBar(),
      ),
      body: _buildContent(tasker!),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow.withOpacity(0.16),
              blurRadius: 16,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Row(
          children: [
            AppButtonTheme.fillRounded(
              constraints: const BoxConstraints(minHeight: 56),
              color: AppColor.transparent,
              highlightColor: AppColor.white,
              child: SvgIcon(
                SvgIcons.arrowBack,
                size: 24,
                color: AppColor.black,
              ),
              onPressed: () => navigateTo(taskerProfileRoute),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Center(
                  child: Text(
                    'Đổi mật khẩu',
                    style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                  ),
                ),
              ),
            ),
            AppButtonTheme.fillRounded(
              constraints: const BoxConstraints(minHeight: 56),
              color: AppColor.transparent,
              highlightColor: AppColor.white,
              child: const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(TaskerModel tasker) {
    final editModel = EditTaskerModel.fromModel(tasker);
    logDebug('password: ${tasker.password}');
    return LayoutBuilder(builder: (context, size) {
      return BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: AuthenticationBlocController().authenticationBloc,
        listener: (context, state) async {
          if (state is AuthenticationFailure) {
            _showError(state.errorCode);
          }
          if (state is ChangePasswordDoneState) {
            await Future.delayed(const Duration(milliseconds: 400));
            navigateTo(taskerProfileRoute);
            JTToast.successToast(message: 'Bạn đã đổi mật khẩu thành công');
          }
        },
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              _inputField(editModel),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 34),
                child: _buildActions(editModel),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _inputField(EditTaskerModel editModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidate,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInput(
              header: 'Mật khẩu cũ',
              controller: _oldPasswordController,
              obscureText: _oldPasswordSecure,
              passwordIconOnPressed: () {
                setState(() {
                  _oldPasswordSecure = !_oldPasswordSecure;
                });
              },
              onSaved: (value) {
                editModel.password = value!.trim();
              },
              onChanged: (value) {
                setState(() {
                  if (_errorMessage.isNotEmpty) {
                    _errorMessage = '';
                  }
                });
              },
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ValidatorText.empty(fieldName: 'Mật khẩu cũ');
                }
                if (value.trim() != editModel.password) {
                  return 'Nhập sai mật khẩu';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: _buildInput(
                header: 'Mật khẩu mới',
                controller: _newPasswordController,
                obscureText: _newPasswordSecure,
                passwordIconOnPressed: () {
                  setState(() {
                    _newPasswordSecure = !_newPasswordSecure;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    if (_errorMessage.isNotEmpty) {
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
                        fieldName: ScreenUtil.t(I18nKey.password)!, atLeast: 6);
                  }
                  if (value.trim().length > 50) {
                    return ValidatorText.moreThan(
                        fieldName: ScreenUtil.t(I18nKey.password)!,
                        moreThan: 50);
                  }
                  if (value.trim() == editModel.password) {
                    return 'Mật khẩu mới phải khác với mật khẩu cũ';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: _buildInput(
                header: 'Nhập lại mật khẩu mới',
                controller: _checkNewPasswordController,
                obscureText: _checkNewPasswordSecure,
                passwordIconOnPressed: () {
                  setState(() {
                    _checkNewPasswordSecure = !_checkNewPasswordSecure;
                  });
                },
                onSaved: (value) {
                  editModel.newPassword = value!.trim();
                },
                onChanged: (value) {
                  setState(() {
                    if (_errorMessage.isNotEmpty) {
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
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required String header,
    required TextEditingController? controller,
    required bool obscureText,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Function(String?)? onSaved,
    Function()? passwordIconOnPressed,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Text(
            header,
            style: AppTextTheme.mediumHeaderTitle(AppColor.black),
          ),
        ),
        Container(
          constraints: const BoxConstraints(minHeight: 50),
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: AppColor.black),
            obscureText: obscureText,
            decoration: InputDecoration(
              errorStyle: AppTextTheme.subText(AppColor.others1),
              filled: true,
              fillColor: AppColor.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: AppColor.text7,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: AppColor.text7,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              suffixIcon: TextButton(
                child: obscureText
                    ? Icon(
                        Icons.remove_red_eye,
                        color: AppColor.black,
                      )
                    : SvgIcon(
                        SvgIcons.password,
                        color: AppColor.black,
                      ),
                onPressed: passwordIconOnPressed,
              ),
            ),
            onSaved: onSaved,
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(EditTaskerModel editModel) {
    return LayoutBuilder(builder: (context, size) {
      return Column(
        children: [
          AppButtonTheme.fillRounded(
            constraints: BoxConstraints(
              minWidth: size.maxWidth - 32,
              minHeight: 52,
            ),
            borderRadius: BorderRadius.circular(4),
            color: AppColor.primary2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgIcon(
                  SvgIcons.circleCheck,
                  color: AppColor.white,
                  size: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Xác nhận',
                    style: AppTextTheme.headerTitle(AppColor.white),
                  ),
                ),
              ],
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _editPassword(editModel: editModel);
              } else {
                setState(() {
                  _autovalidate = AutovalidateMode.onUserInteraction;
                });
              }
            },
          )
        ],
      );
    });
  }

  _editPassword({required EditTaskerModel editModel}) {
    setState(() {
      _errorMessage = '';
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AuthenticationBlocController().authenticationBloc.add(
            ChangePassword(
              password: _oldPasswordController.text,
              newPassword: _newPasswordController.text,
            ),
          );
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.onUserInteraction;
      });
    }
    // _taskerBloc.changePassword(editModel: editModel).then(
    //   (value) async {
    //     AuthenticationBlocController().authenticationBloc.add(GetUserData());
    //     navigateTo(taskerProfileRoute);
    //     JTToast.successToast(message: ScreenUtil.t(I18nKey.updateSuccess)!);
    //   },
    // ).onError((ApiError error, stackTrace) {
    //   setState(() {
    //     _errorMessage = showError(error.errorCode, context);
    //   });
    // }).catchError(
    //   (error, stackTrace) {
    //     setState(() {
    //       _errorMessage = error.toString();
    //     });
    //   },
    // );
  }

  _showError(String errorCode) {
    setState(() {
      _errorMessage = showError(errorCode, context, fieldName: 'Email');
    });
  }

  _fetchDataOnPage() {
    _taskerBloc.getProfile();
  }
}
