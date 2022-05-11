import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../main.dart';

class JTToast {
  static void init(BuildContext context) {
    FToast().init(context);
  }

  static void successToast({
    required String message,
    double width = 308,
    double height = 72,
  }) {
    FToast().showToast(
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
      // positionedToastBuilder: (context, child) {
      //   return Column(
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.only(top: 125),
      //         child: child,
      //       ),
      //     ],
      //   );
      // },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_sharp,
              color: AppColor.shade5,
              size: 26,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.text1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
