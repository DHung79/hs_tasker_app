import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../../main.dart';
import 'login_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String? _errorMessage = '';
  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.primary1,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: AuthenticationBlocController().authenticationBloc,
        listener: (context, state) {
          if (state is AppAutheticated) {
            navigateTo(homeRoute);
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          bloc: AuthenticationBlocController().authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            return SafeArea(
              child: LayoutBuilder(builder: (context, size) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.maxHeight / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          _buildErrorMessage(),
                        ],
                      ),
                    ),
                    LoginForm(
                      state: state,
                      onError: (error) {
                        _errorMessage = error;
                      },
                    ),
                    const Spacer(),
                  ],
                );
              }),
            );
          },
        ),
      ),
    );
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
  // String _getLanguage() {
  //   switch (App.of(context)!.currentLocale.languageCode) {
  //     case 'vi':
  //       return 'Tiếng Việt';
  //     case 'en':
  //       return 'English';
  //     case 'th':
  //       return 'Thai';
  //     default:
  //       return 'Tiếng Việt';
  //   }
  // }
}
