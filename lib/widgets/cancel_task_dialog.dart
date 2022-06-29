import 'package:flutter/material.dart';
import '../../../core/task/task.dart';
import '../../../main.dart';
import '../../../widgets/jt_dialog.dart';

class CancelTaskDialog extends StatefulWidget {
  final TaskModel task;
  final Widget contentHeader;
  final String accountBalances;
  final bool isWarning;
  final Function()? onConfirmed;
  const CancelTaskDialog({
    Key? key,
    required this.task,
    required this.contentHeader,
    required this.accountBalances,
    this.isWarning = false,
    this.onConfirmed,
  }) : super(key: key);

  @override
  State<CancelTaskDialog> createState() => _CancelTaskDialogState();
}

class _CancelTaskDialogState extends State<CancelTaskDialog> {
  @override
  Widget build(BuildContext context) {
    return JTDialog(
      header: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hủy công việc',
              style: AppTextTheme.mediumHeaderTitle(AppColor.black),
            ),
          ],
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: widget.contentHeader,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              constraints: const BoxConstraints(minHeight: 40),
              decoration: BoxDecoration(
                color: AppColor.shade1,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      'Phí hủy:',
                      style: AppTextTheme.normalText(AppColor.black),
                    ),
                  ),
                  Text(
                    '${widget.task.totalPrice} VND',
                    style: AppTextTheme.normalText(AppColor.others1),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    'Số dư:',
                    style: AppTextTheme.mediumBodyText(AppColor.black),
                  ),
                ),
                Text(
                  widget.accountBalances,
                  style: AppTextTheme.mediumBodyText(AppColor.primary2),
                ),
              ],
            ),
          ),
        ],
      ),
      action: Padding(
        padding: const EdgeInsets.fromLTRB(0, 32, 0, 24),
        child: widget.isWarning ? _warningAction() : _dialogActions(),
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
                'Xác nhận',
                style: AppTextTheme.headerTitle(AppColor.white),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.of(context).pop();
          if (widget.onConfirmed != null) {
            widget.onConfirmed!();
          } else {
            _warningDialog();
          }
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

  _warningAction() {
    return AppButtonTheme.fillRounded(
      constraints: const BoxConstraints(
        minHeight: 52,
      ),
      borderRadius: BorderRadius.circular(4),
      color: AppColor.primary2,
      child: Text(
        'Trở về',
        style: AppTextTheme.headerTitle(AppColor.white),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  _warningDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black12,
        builder: (BuildContext context) {
          return CancelTaskDialog(
            task: widget.task,
            contentHeader: Text(
              'Số dư của bạn không đủ để hủy công việc. Vui lòng nạp thêm để hủy.',
              style: AppTextTheme.normalText(AppColor.others1),
            ),
            accountBalances: '10.000 VND',
            isWarning: true,
          );
        });
  }
}
