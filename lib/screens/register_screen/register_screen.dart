import 'package:flutter/material.dart';
import '/routes/route_names.dart';
import '../../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
      appBar: AppBar(
        backgroundColor: AppColor.primary1,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                navigateTo(authenticationRoute);
              },
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, size) {
          final horizontalPadding = size.maxWidth * 0.1;
          return Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              17,
              horizontalPadding,
              0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'TRỞ THÀNH ĐỐI TÁC CỦA II HOME',
                    style: AppTextTheme.headerTitle(Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    ScreenUtil.t(I18nKey.registerContent)!,
                    style: AppTextTheme.mediumHeaderTitle(AppColor.shade3),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
