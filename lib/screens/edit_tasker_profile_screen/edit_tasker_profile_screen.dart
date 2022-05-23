import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../main.dart';
import '../../theme/validator_text.dart';
import '../../widgets/jt_indicator.dart';
import '../../widgets/jt_toast.dart';
import '../layout_template/content_screen.dart';

class EditTaskerProfileScreen extends StatefulWidget {
  const EditTaskerProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditTaskerProfileScreen> createState() =>
      _EditTaskerProfileScreenState();
}

class _EditTaskerProfileScreenState extends State<EditTaskerProfileScreen> {
  final _pageState = PageState();
  final _taskerBloc = TaskerBloc();
  String _errorMessage = '';
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
              userSnapshot: snapshot,
              pageState: _pageState,
              onFetch: () {
                _fetchDataOnPage();
              },
              child: snapshot.hasData
                  ? _editTaskerProfile(snapshot)
                  : const JTIndicator(),
            );
          }),
    );
  }

  Widget _editTaskerProfile(AsyncSnapshot<TaskerModel> snapshot) {
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
                    'Chỉnh sửa hồ sơ',
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
    return LayoutBuilder(builder: (context, size) {
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 31, 0, 23),
              child: Container(
                constraints: const BoxConstraints(minHeight: 134),
                child: _avatar(tasker),
              ),
            ),
            _inputField(editModel),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _buildActions(editModel),
            ),
          ],
        ),
      );
    });
  }

  Widget _avatar(TaskerModel tasker) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Image.asset(
            'assets/images/logo.png',
            width: 100,
            height: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: AppButtonTheme.outlineRounded(
            constraints: const BoxConstraints(minHeight: 26),
            color: AppColor.white,
            outlineColor: AppColor.black,
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Tải lên ảnh',
                style: AppTextTheme.normalText(AppColor.black),
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _inputField(EditTaskerModel editModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _key,
        autovalidateMode: _autovalidate,
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Text(
                    'Tên hiển thị',
                    style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(minHeight: 50),
                  child: TextFormField(
                    initialValue: editModel.name,
                    style: TextStyle(color: AppColor.black),
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
                          const EdgeInsets.symmetric(horizontal: 16),
                      hintText: 'Nhập tên',
                      hintStyle: AppTextTheme.normalText(AppColor.text7),
                    ),
                    onSaved: (value) {
                      editModel.name = value!.trim();
                    },
                    onChanged: (value) {
                      setState(() {
                        if (_errorMessage.isNotEmpty) {
                          _errorMessage = '';
                        }
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.trim().isEmpty) {
                        return ValidatorText.empty(
                            fieldName: ScreenUtil.t(I18nKey.name)!);
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 7),
                  child: Text(
                    'Số điện thoại',
                    style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(minHeight: 50),
                  child: TextFormField(
                    initialValue: editModel.phoneNumber,
                    style: TextStyle(color: AppColor.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                          const EdgeInsets.symmetric(horizontal: 16),
                      hintText: 'Nhập số điện thoại',
                      hintStyle: AppTextTheme.normalText(AppColor.text7),
                    ),
                    onSaved: (value) {
                      editModel.phoneNumber = value!.trim();
                    },
                    onChanged: (value) {
                      setState(() {
                        if (_errorMessage.isNotEmpty) {
                          _errorMessage = '';
                        }
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.trim().isEmpty) {
                        return ValidatorText.empty(fieldName: 'số điện thoại');
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
              if (_key.currentState!.validate()) {
                _key.currentState!.save();
                _editUserInfo(editModel: editModel);
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

  _editUserInfo({required EditTaskerModel editModel}) {
    _taskerBloc.editProfile(editModel: editModel).then(
      (value) async {
        AuthenticationBlocController().authenticationBloc.add(GetUserData());
        navigateTo(taskerProfileRoute);
        JTToast.successToast(message: ScreenUtil.t(I18nKey.updateSuccess)!);
      },
    ).onError((ApiError error, stackTrace) {
      setState(() {
        _errorMessage = showError(error.errorCode, context);
      });
    }).catchError(
      (error, stackTrace) {
        setState(() {
          _errorMessage = error.toString();
        });
      },
    );
  }

  _fetchDataOnPage() {
    _taskerBloc.getProfile();
  }
}
