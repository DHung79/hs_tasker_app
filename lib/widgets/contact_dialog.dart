import 'package:flutter/material.dart';
import '../../../main.dart';

class ContactDialog extends StatefulWidget {
  const ContactDialog({Key? key}) : super(key: key);

  @override
  State<ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
              ),
              child: Text(
                'Liên lạc',
                style: AppTextTheme.mediumHeaderTitle(AppColor.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(
                thickness: 1.5,
                color: AppColor.shade1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: LayoutBuilder(builder: (context, size) {
                return SizedBox(
                  width: size.maxWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _contactButton(
                            title: 'Gọi điện',
                            svgIcon: SvgIcons.telephone,
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: _contactButton(
                          title: 'Nhắn tin',
                          svgIcon: SvgIcons.message,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget _contactButton({
    required String title,
    IconData? icon,
    SvgIconData? svgIcon,
    required Function()? onPressed,
  }) {
    return AppButtonTheme.fillRounded(
      constraints: const BoxConstraints(minHeight: 66),
      borderRadius: BorderRadius.circular(10),
      color: AppColor.primary2,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        icon != null
            ? Icon(
                icon,
                size: 24,
                color: AppColor.white,
              )
            : SvgIcon(
                svgIcon,
                size: 24,
                color: AppColor.white,
              ),
        Text(
          title,
          style: AppTextTheme.normalText(AppColor.white),
        ),
      ]),
      onPressed: onPressed,
    );
  }
}
