import 'package:flutter/material.dart';
import '../../core/authentication/auth.dart';
import '../../core/tasker/tasker.dart';
import '../../core/user/user.dart';
import '../../main.dart';
import '../layout_template/content_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageState = PageState();
  final _userBloc = UserBloc();

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  void dispose() {
    _userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return PageTemplate(
      pageState: _pageState,
      onUserFetched: (user) => setState(() {}),
      onFetch: () {
        _fetchDataOnPage();
      },
      showAppBar: false,
      child: FutureBuilder(
          future: _pageState.currentUser,
          builder: (context, AsyncSnapshot<TaskerModel> snapshot) {
            return PageContent(
              userSnapshot: snapshot,
              pageState: _pageState,
              onFetch: () {
                _fetchDataOnPage();
              },
              child: _buildContent(snapshot),
            );
          }),
    );
  }

  Widget _buildContent(AsyncSnapshot<TaskerModel> snapshot) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.red,
      child: TextButton(
        child: const Text('back to login'),
        onPressed: () {
          AuthenticationBlocController().authenticationBloc.add(UserLogOut());
        },
      ),
    );
  }

  _fetchDataOnPage() {}
}
