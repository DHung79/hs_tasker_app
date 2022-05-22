import 'package:flutter/material.dart';
import '../main.dart';

class JTDialog extends StatefulWidget {
  final Widget? header;
  final Widget? content;
  final Widget? action;
  final EdgeInsetsGeometry dividerPadding;

  const JTDialog({
    Key? key,
    required this.header,
    required this.content,
    required this.action,
    this.dividerPadding = const EdgeInsets.symmetric(vertical: 8),
  }) : super(key: key);
  @override
  _JTDialogState createState() => _JTDialogState();
}

class _JTDialogState extends State<JTDialog> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      const double dialogWidth = 334;
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
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.header != null) widget.header!,
                if (widget.header != null)
                  Padding(
                    padding: widget.dividerPadding,
                    child: Divider(
                      thickness: 1.5,
                      color: AppColor.shade1,
                    ),
                  ),
                if (widget.content != null) widget.content!,
                if (widget.action != null) widget.action!,
              ],
            ),
          ),
        ),
      );
    });
  }
}
