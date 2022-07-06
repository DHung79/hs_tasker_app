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
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_sharp,
                color: AppColor.shade5,
                size: 26,
              ),
              SizedBox(
                width: width - 26 - 32,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13, 16, 0, 16),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.text1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void errorToast({
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
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColor.others1,
                size: 26,
              ),
              SizedBox(
                width: width - 26 - 32,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13, 16, 0, 16),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.text1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void warningToast({
    required Widget child,
  }) {
    FToast().showToast(
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
      child: LayoutBuilder(builder: (context, size) {
        return Container(
          width: size.maxWidth - 32,
          constraints: const BoxConstraints(minHeight: 92),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: AppColor.white,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 12,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(10),
                  ),
                  color: AppColor.others2,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(child: child),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: VerticalDivider(
                            thickness: 1.5,
                            color: AppColor.shade1,
                          ),
                        ),
                        AppButtonTheme.fillRounded(
                          color: AppColor.white,
                          highlightColor: AppColor.white,
                          constraints: const BoxConstraints(
                            minHeight: 40,
                            minWidth: 40,
                          ),
                          child: SvgIcon(
                            SvgIcons.close,
                            color: AppColor.black,
                            size: 24,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
