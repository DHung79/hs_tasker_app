import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../widgets/jt_dialog.dart';
import '../../../widgets/jt_dropdown.dart';

class RemiderDialog extends StatefulWidget {
  const RemiderDialog({Key? key}) : super(key: key);

  @override
  State<RemiderDialog> createState() => _RemiderDialogState();
}

class _RemiderDialogState extends State<RemiderDialog> {
  @override
  Widget build(BuildContext context) {
    return JTDialog(
      header: Padding(
        padding: const EdgeInsets.only(top: 24),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            'Đặt lời nhắc',
            style: AppTextTheme.mediumBodyText(AppColor.black),
          ),
          InkWell(
            highlightColor: AppColor.transparent,
            splashColor: AppColor.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgIcon(
                SvgIcons.close,
                size: 24,
                color: AppColor.black,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ]),
      ),
      content: Column(
        children: [
          _dialogDropDownButton(
            title: 'Nhắc trước:',
            defaultValue: '30 phút',
            dataSource: const [
              {'name': '30 phút', 'value': '30 phút'},
              {'name': '1 tiếng', 'value': '1 tiếng'},
              {'name': '1 tiếng 30 phút', 'value': '1 tiếng 30 phút'},
            ],
            validator: (value) {
              return null;
            },
            onChanged: (value) {},
            onSaved: (value) {},
            onTap: () {},
          ),
          _dialogDropDownButton(
            title: 'Cách nhắc:',
            defaultValue: 'Thông báo đẩy',
            dataSource: const [
              {'name': 'Thông báo đẩy', 'value': 'Thông báo đẩy'},
            ],
            validator: (value) {
              return null;
            },
            onChanged: (value) {},
            onSaved: (value) {},
            onTap: () {},
          ),
        ],
      ),
      action: Padding(
        padding: const EdgeInsets.fromLTRB(0, 32, 0, 24),
        child: _dialogActions(),
      ),
    );
  }

  _dialogDropDownButton({
    required String title,
    required String defaultValue,
    required List<Map<String, dynamic>> dataSource,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Function(String?)? onSaved,
    Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              title,
              style: AppTextTheme.normalText(AppColor.black),
            ),
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 44),
              child: JTDropdownButtonFormField<String>(
                defaultValue: defaultValue,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: AppColor.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: AppColor.black),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(10, 13, 10, 13),
                ),
                dataSource: dataSource,
                validator: validator,
                onChanged: onChanged,
                onSaved: onSaved,
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _dialogActions() {
    return Column(children: [
      AppButtonTheme.fillRounded(
        constraints: const BoxConstraints(
          minHeight: 52,
        ),
        borderRadius: BorderRadius.circular(4),
        color: AppColor.primary2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgIcon(
              SvgIcons.checkCircleOutline,
              color: AppColor.white,
              size: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Đồng ý',
                style: AppTextTheme.headerTitle(AppColor.white),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      const SizedBox(height: 16),
      AppButtonTheme.fillRounded(
        constraints: const BoxConstraints(
          minHeight: 52,
        ),
        borderRadius: BorderRadius.circular(4),
        color: AppColor.shade1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgIcon(
              SvgIcons.close,
              color: AppColor.black,
              size: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Hủy bỏ',
                style: AppTextTheme.headerTitle(AppColor.black),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ]);
  }
}
