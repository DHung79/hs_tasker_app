import 'package:flutter/material.dart';
import '../../../../../main.dart';

class JTConfirmDialog extends StatefulWidget {
  final String? headerTitle;
  final String contentText;
  final Widget? actionField;
  final TextStyle? headerTitleStyle;
  final TextStyle? contentTextStyle;

  const JTConfirmDialog({
    Key? key,
    this.headerTitle,
    required this.contentText,
    this.actionField,
    this.headerTitleStyle,
    this.contentTextStyle,
  }) : super(key: key);
  @override
  _JTConfirmDialogState createState() => _JTConfirmDialogState();
}

class _JTConfirmDialogState extends State<JTConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      const double dialogWidth = 334;
      const double dialogHeight = 282;
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          constraints: const BoxConstraints(
            minWidth: dialogWidth,
            minHeight: dialogHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Text(
                  '${widget.headerTitle}',
                  style: widget.headerTitleStyle ??
                      AppTextTheme.mediumHeaderTitle(Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Divider(
                  thickness: 1.5,
                  color: AppColor.shade1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Text(
                  widget.contentText,
                  style: widget.contentTextStyle ??
                      AppTextTheme.normalText(Colors.black),
                ),
              ),
              if (widget.actionField != null) widget.actionField!,
            ],
          ),
        ),
      );
    });
  }
}
