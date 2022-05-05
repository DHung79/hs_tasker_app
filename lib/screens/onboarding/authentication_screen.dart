import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import '../../../main.dart';
import '../../core/authentication/auth.dart';
import 'login_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                bool isKeyboardPopUp = size.maxHeight < 560;
                return Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.fitWidth,
                    ),
                    Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          LoginForm(state: state),
                        ],
                      ),
                    ),
                    !isKeyboardPopUp
                        ? const SizedBox(height: 64)
                        : const Spacer(),
                    // AppButton(
                    //   title:
                    //       '${ScreenUtil.t(I18nKey.forgotPassword)!.toUpperCase()}',
                    //   onPressed: () {
                    //     navigateTo(ForgotPasswordRoute);
                    //   },
                    // ),
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
