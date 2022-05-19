import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../main.dart';

String formatFromString({
  required String value,
  required BuildContext context,
  String? displayedFormat,
}) {
  ScreenUtil.init(context);
  final format =
      displayedFormat ?? ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm:ss';
  String _displayedValue = '';

  final _dateTime = DateTime.tryParse(value);
  final _dateTimeLocal = _dateTime!.toLocal();
  _displayedValue = DateFormat(format).format(_dateTimeLocal);

  return _displayedValue;
}

String formatFromInt({
  required int value,
  required BuildContext context,
  String? displayedFormat,
}) {
  ScreenUtil.init(context);
  final format =
      displayedFormat ?? ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm:ss';
  String _displayedValue = '';
  if (value != 0) {
    final _dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final _dateTimeLocal = _dateTime.toLocal();
    _displayedValue = DateFormat(format).format(_dateTimeLocal);
  }
  return _displayedValue;
}

String timeAgoFromNow(dynamic value, BuildContext context) {
  ScreenUtil.init(context);
  late DateTime _dateTime;
  late DateTime _dateTimeLocal;
  if (value is int) {
    if (value != 0) {
      final _dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());
      _dateTimeLocal = _dateTime.toLocal();
    }
  } else if (value is String) {
    _dateTime = DateTime.tryParse(value)!;
    _dateTimeLocal = _dateTime.toLocal();
  }
  final difference = DateTime.now().difference(_dateTimeLocal);
  if (difference.inDays > 365) {
    final year = (difference.inDays / 365).floor();
    final yearString =
        year == 1 ? ScreenUtil.t(I18nKey.year)! : ScreenUtil.t(I18nKey.years)!;
    final endString = ' ' + yearString + ' ' + ScreenUtil.t(I18nKey.ago)!;
    return year.toString() + endString.toLowerCase();
  } else if (difference.inDays > 30) {
    final month = (difference.inDays / 30).floor();
    final monthString = month == 1
        ? ScreenUtil.t(I18nKey.month)!
        : ScreenUtil.t(I18nKey.months)!;
    final endString = ' ' + monthString + ' ' + ScreenUtil.t(I18nKey.ago)!;
    return month.toString() + endString.toLowerCase();
  } else if (difference.inDays > 7) {
    final week = (difference.inDays / 7).floor();
    final weekString =
        week == 1 ? ScreenUtil.t(I18nKey.week)! : ScreenUtil.t(I18nKey.weeks)!;
    final endString = ' ' + weekString + ' ' + ScreenUtil.t(I18nKey.ago)!;
    return week.toString() + endString.toLowerCase();
  } else if (difference.inDays > 0) {
    final dayString = difference.inDays == 1
        ? ScreenUtil.t(I18nKey.day)!
        : ScreenUtil.t(I18nKey.days)!;
    final endString = ' ' + dayString + ' ' + ScreenUtil.t(I18nKey.ago)!;
    return difference.inDays.toString() + endString.toLowerCase();
  } else if (difference.inHours > 0) {
    final hourString = difference.inHours == 1
        ? ScreenUtil.t(I18nKey.hour)!
        : ScreenUtil.t(I18nKey.hours)!;
    final endString = ' ' + hourString + ' ' + ScreenUtil.t(I18nKey.ago)!;
    return difference.inHours.toString() + endString.toLowerCase();
  } else if (difference.inMinutes > 0) {
    final minuteString = difference.inMinutes == 1
        ? ScreenUtil.t(I18nKey.minute)!
        : ScreenUtil.t(I18nKey.minutes)!;
    final endString = ' ' + minuteString + ' ' + ScreenUtil.t(I18nKey.ago)!;
    return difference.inMinutes.toString() + endString.toLowerCase();
  } else if (difference.inSeconds > 0) {
    final secondString = difference.inSeconds == 1
        ? ScreenUtil.t(I18nKey.second)!
        : ScreenUtil.t(I18nKey.seconds)!;
    final endString = ' ' + secondString + ' ' + ScreenUtil.t(I18nKey.ago)!;
    return difference.inSeconds.toString() + endString.toLowerCase();
  } else {
    return ScreenUtil.t(I18nKey.justNow)!;
  }
}
