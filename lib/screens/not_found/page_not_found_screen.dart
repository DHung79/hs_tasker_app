import 'package:flutter/material.dart';

import '../../main.dart';
import '../../routes/route_names.dart';

class PageNotFoundScreen extends StatefulWidget {
  final String route;
  const PageNotFoundScreen(this.route, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PageNotFoundScreenState();
}

class _PageNotFoundScreenState extends State<PageNotFoundScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 20,
          ),
          onTap: () {
            navigateTo(initialRoute);
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          const Icon(
            Icons.report_gmailerrorred_outlined,
            size: 120,
          ),
          const SizedBox(height: 60),
          Text(
            'Không tìm thấy trang!',
            style: Theme.of(context).textTheme.headline1,
          ),
        ],
      ),
    );
  }
}
