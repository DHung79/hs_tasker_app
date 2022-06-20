import 'package:flutter/material.dart';
import '../main.dart';

class ValidatorText {
  static String empty({required String fieldName}) {
    return fieldName +
        ' ' +
        ScreenUtil.t(I18nKey.mustNotBeEmpty)!.toLowerCase();
  }

  static String invalidFormat({required String fieldName}) {
    var invalidFormat = ScreenUtil.t(I18nKey.invalidFormat)!;
    var invalid = ScreenUtil.t(I18nKey.invalid)!;
    if (invalidFormat.startsWith(ScreenUtil.t(I18nKey.invalid)!)) {
      return invalidFormat.replaceRange(invalidFormat.indexOf(' '),
              invalidFormat.indexOf(' '), ' ' + fieldName.toLowerCase()) +
          ' ';
    } else {
      return invalidFormat.substring(0, invalidFormat.length - invalid.length) +
          fieldName.toLowerCase() +
          ' ' +
          invalid.toLowerCase();
    }
  }

  static String invalid({required String fieldName}) {
    var invalidFormat = ScreenUtil.t(I18nKey.invalidFormat)!;
    var invalid = ScreenUtil.t(I18nKey.invalid)!;
    if (invalidFormat.startsWith(ScreenUtil.t(I18nKey.invalid)!)) {
      return invalid + ' ' + fieldName.toLowerCase();
    } else {
      return fieldName.toUpperCase() + ' ' + invalid.toLowerCase();
    }
  }

  static String atLeast({required String fieldName, required double atLeast}) {
    return fieldName +
        ' ' +
        ScreenUtil.t(I18nKey.mustBeAtLeast)!.toLowerCase() +
        ' $atLeast ' +
        ScreenUtil.t(I18nKey.characters)!.toLowerCase();
  }

  static String moreThan(
      {required String fieldName, required double moreThan}) {
    return fieldName +
        ' ' +
        ScreenUtil.t(I18nKey.mustNotBeMoreThan)!.toLowerCase() +
        ' $moreThan ' +
        ScreenUtil.t(I18nKey.characters)!.toLowerCase();
  }
}

String showError(String errorCode, BuildContext context, {String? fieldName}) {
  ScreenUtil.init(context);
  String message = '';
  switch (errorCode) {
    case '100':
      message = ScreenUtil.t(I18nKey.notHavePermissionToControlDoor)!;
      break;
    case '400':
      if (fieldName != null) {
        if (fieldName == 'Email') {
          message = ScreenUtil.t(I18nKey.emailDoesNotExist)!;
        } else {
          message = fieldName + ' ' + ScreenUtil.t(I18nKey.isExpired)!;
        }
      } else {
        message = ScreenUtil.t(I18nKey.invalidEmailOrPassword)!;
      }
      break;
    case '404':
      if (fieldName != null) {
        if (fieldName == 'Email') {
          message = ScreenUtil.t(I18nKey.emailDoesNotExist)!;
        } else {
          message = ScreenUtil.t(I18nKey.incorrectOTP)!;
        }
      } else {
        message = ScreenUtil.t(I18nKey.invalidEmailOrPassword)!;
      }
      break;
    case '900':
      message = ScreenUtil.t(I18nKey.unauthorized)!;
      break;
    case '901':
      message = ScreenUtil.t(I18nKey.tokenExpired)!;
      break;
    case '902':
      message = ScreenUtil.t(I18nKey.invalidToken)!;
      break;
    case '1000':
      message = ScreenUtil.t(I18nKey.invalidEmailOrPassword)!;
      break;
    case '1001':
      message = ScreenUtil.t(I18nKey.userNotFound)!;
      break;
    case '1002':
      message = 'Email và số điện thoại đã tồn tại!';
      break;
    case '1003':
      message = ScreenUtil.t(I18nKey.emailAlreadyExists)!;
      break;
    case '1004':
      message = ScreenUtil.t(I18nKey.phoneNumberAlreadyExists)!;
      break;
    case '1005':
      message = ScreenUtil.t(I18nKey.invalidPassword)!;
      break;
    case '1006':
      message = 'Không tìm thấy người giúp việc!';
      break;
    case '1007':
      message = 'Không tìm thấy dịch vụ!';
      break;
    case '1008':
      message = 'Không tìm thấy đơn hàng!';
      break;
    case '1009':
      message = 'Không tìm thấy bình luận và đánh giá!';
      break;
    case '1010':
      message = 'Không thể cập nhật vì người giúp việc đã huỷ đơn';
      break;
    case '1011':
      message = ScreenUtil.t(I18nKey.invalidResetId)!;
      break;
    case '1012':
      message = 'Công việc đã được người khác nhận';
      break;
    case '1013':
      message = 'Công việc đã bị huỷ';
      break;
    case '1014':
      message = 'Không tìm thấy Admin!';
      break;
    case '1015':
      message = 'Mã OTP đã hết hạn';
      break;
    case '1016':
      message = 'Không tìm thấy thông tin liên lạc!';
      break;
    case '1017':
      message = ScreenUtil.t(I18nKey.emailDoesNotExist)!;
      break;
    case '1100':
      message = ScreenUtil.t(I18nKey.pageAndLimitShouldBeNumberic)!;
      break;
    case '1101':
      message = ScreenUtil.t(I18nKey.mustBeAnEmail)!;
      break;
    case '1102':
      message = ScreenUtil.t(I18nKey.shouldNotBeEmpty)!;
      break;
    case '1103':
      message = ScreenUtil.t(I18nKey.mustBeString)!;
      break;
    case '1104':
      message = ScreenUtil.t(I18nKey.mustBeNumber)!;
      break;
    case '1105':
      message = ScreenUtil.t(I18nKey.mustBeBetween)!;
      break;
    case '1106':
      message = ScreenUtil.t(I18nKey.mustBeArray)!;
      break;
    case '1107':
      message = ScreenUtil.t(I18nKey.eachValueMustBeString)!;
      break;
    case '1200':
      message = ScreenUtil.t(I18nKey.doorNotFound)!;
      break;
    case '1201':
      message = ScreenUtil.t(I18nKey.unlockDoorFail)!;
      break;
    case '1202':
      message = ScreenUtil.t(I18nKey.openDoorFail)!;
      break;
    case '1203':
      message = ScreenUtil.t(I18nKey.lockDoorFail)!;
      break;
    default:
      message = '';
      break;
  }
  return message;
}
