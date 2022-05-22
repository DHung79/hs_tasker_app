import 'package:flutter/material.dart';
import '../main.dart';

class JTDropdownButtonFormField<T> extends StatelessWidget {
  final List<Map<String, dynamic>> dataSource;
  final T defaultValue;
  final InputDecoration? decoration;
  final String? Function(T?)? validator;
  final void Function(T)? onChanged;
  final void Function(T?)? onSaved;
  final void Function()? onTap;

  const JTDropdownButtonFormField({
    Key? key,
    required this.dataSource,
    required this.defaultValue,
    this.decoration,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    T _displayedValue = defaultValue;
    if (_displayedValue == null) {
      // Get the first value of the `dataSource`
      if (dataSource.isEmpty) {
        return const Text('DataSource must not be empty');
      }
      _displayedValue = dataSource[0]['name'];
    }
    if (_displayedValue == null) {
      return const Text('Could not find the default value');
    }
    return DropdownButtonFormField<T>(
      isExpanded: true,
      decoration: decoration,
      value: _displayedValue,
      icon: SvgIcon(
        SvgIcons.keyboardDown,
        size: 24,
        color: AppColor.black,
      ),
      style: AppTextTheme.normalText(AppColor.black),
      onTap: onTap,
      onChanged: onChanged != null
          ? (newValue) {
              onChanged!(newValue!);
            }
          : null,
      validator: validator,
      onSaved: onSaved,
      items: dataSource.map<DropdownMenuItem<T>>((Map<String, dynamic> value) {
        return DropdownMenuItem<T>(
          value: value['value'] as T,
          child: Text(
            value['name'],
            style: AppTextTheme.normalText(AppColor.black),
          ),
        );
      }).toList(),
    );
  }
}
