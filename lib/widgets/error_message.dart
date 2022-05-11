import 'package:flutter/material.dart';

import '../main.dart';

class ErrorMessage extends StatefulWidget {
  final String errorMessage;
  const ErrorMessage({Key? key, required this.errorMessage}) : super(key: key);

  @override
  State<ErrorMessage> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<ErrorMessage> {
  @override
  Widget build(BuildContext context) {
    return widget.errorMessage.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                minHeight: 24,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(
                    color: AppColor.test1,
                    width: 1,
                  ),
                ),
                child: Padding(
                  child: Text(
                    widget.errorMessage,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.text1,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
