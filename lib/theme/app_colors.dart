import 'package:flutter/material.dart';

class AppColor {
  static Color primary1 = hexToColor('#8D0E57');
  static Color primary2 = hexToColor('#FF9E18');

  static Color secondary1 = hexToColor('#A43E79');
  static Color secondary2 = hexToColor('#FFB146');
  static Color secondary3 = hexToColor('#BB6E9A');
  static Color secondary4 = hexToColor('#FFDAA7');
  static Color secondary5 = hexToColor('#710B46');

  static Color text1 = hexToColor('#000000');
  static Color text2 = hexToColor('#FFFFFF');
  static Color text3 = hexToColor('#4E4351');
  static Color text4 = hexToColor('#710B46');
  static Color text5 = hexToColor('#FFB146');
  static Color text6 = hexToColor('#C687AB');
  static Color text7 = hexToColor('#9DB3C0');
  static Color text8 = hexToColor('#80949F');

  static Color shadow = hexToColor('#4F758C');

  static Color shade1 = hexToColor('#F3F4F4');
  static Color shade2 = hexToColor('#F9F9F9');
  static Color shade3 = hexToColor('#F4E7EE');
  static Color shade4 = hexToColor('#FFF5E8');
  static Color shade5 = hexToColor('#21A99F');
  static Color shade6 = hexToColor('#008BCB');
  static Color shade7 = hexToColor('#E4F7FF');
  static Color shade8 = hexToColor('#E3FFFD');
  static Color shade9 = hexToColor('#66C719');
  static Color shade10 = hexToColor('#EEFCFA');

  static Color inactive1 = hexToColor('#E1E5E7');
  static Color inactive2 = hexToColor('#F5F6F6');

  static Color others1 = hexToColor('#FF4E4E');
  static Color others2 = hexToColor('#4EFF80');
  static Color test1 = hexToColor('#BB3553');
  static Color test2 = hexToColor('#FDC552');

  //
  static Color newBackground = hexToColor('#E5E5E5');
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color transparent = Colors.transparent;
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
