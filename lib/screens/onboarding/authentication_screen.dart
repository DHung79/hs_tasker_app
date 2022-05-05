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
      backgroundColor: Theme.of(context).cardColor,
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
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(24),
                    //     child: SizedBox(
                    //       width: 150,
                    //       height: 30,
                    //       child: InkWell(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Padding(
                    //               padding: EdgeInsets.only(right: 10),
                    //               child: Icon(
                    //                 Icons.language,
                    //                 size: 24,
                    //                 color: AppColor.hintColor,
                    //               ),
                    //             ),
                    //             Text(
                    //               _getLanguage(),
                    //               style: AppStyle.hintText2,
                    //             ),
                    //           ],
                    //         ),
                    //         onTap: () {
                    //           // navigateTo(LanguageRoute);
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Spacer(),
                    Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 24,
                            ),
                            child: Text(
                              '${ScreenUtil.t(I18nKey.signInTitle1)!.toUpperCase()}',
                              style: AppStyle.h3.copyWith(
                                fontSize: 20,
                                // color: AppColor.subTitle,
                              ),
                            ),
                          ),
                          LoginForm(state: state),
                        ],
                      ),
                    ),
                    !isKeyboardPopUp ? SizedBox(height: 64) : Spacer(),
                    // AppButton(
                    //   title:
                    //       '${ScreenUtil.t(I18nKey.forgotPassword)!.toUpperCase()}',
                    //   onPressed: () {
                    //     navigateTo(ForgotPasswordRoute);
                    //   },
                    // ),
                    Spacer(),
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
