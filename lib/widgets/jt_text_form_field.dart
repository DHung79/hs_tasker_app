import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/main.dart';

class JTTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool obscureText;
  final Function()? passwordIconOnPressed;
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  const JTTextFormField({
    Key? key,
    this.controller,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.isPassword = false,
    this.passwordIconOnPressed,
    this.hintText,
    this.obscureText = false,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  State<JTTextFormField> createState() => _JTTextFormFieldState();
}

class _JTTextFormFieldState extends State<JTTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        style: TextStyle(color: AppColor.white),
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 3.0,
              color: AppColor.text7,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          errorStyle: AppTextTheme.subText(AppColor.others1),
          suffixIcon: widget.isPassword
              ? TextButton(
                  child: widget.obscureText
                      ? Icon(
                          Icons.remove_red_eye,
                          color: AppColor.white,
                        )
                      : SvgIcon(
                          SvgIcons.password,
                          color: AppColor.white,
                        ),
                  onPressed: widget.passwordIconOnPressed,
                )
              : null,
          filled: true,
          fillColor: AppColor.secondary3,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 3.0,
              color: AppColor.text7,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 3.0,
              color: AppColor.text7,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          hintText: widget.hintText,
          hintStyle: AppTextTheme.mediumBodyText(AppColor.white),
        ),
        controller: widget.controller,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
      ),
    );
  }
}
