import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconData {
  String path;
  SvgIconData({required this.path});
}

class SvgIcons {
  static SvgIconData close = SvgIconData(path: 'assets/svg/17072.svg');
  static SvgIconData arrowBack = SvgIconData(path: 'assets/svg/17073.svg');
  static SvgIconData check = SvgIconData(path: 'assets/svg/17074.svg');
  static SvgIconData logout = SvgIconData(path: 'assets/svg/17075.svg');
  static SvgIconData home = SvgIconData(path: 'assets/svg/17076.svg');
  static SvgIconData bell = SvgIconData(path: 'assets/svg/17077.svg');
  static SvgIconData keyboardLeft = SvgIconData(path: 'assets/svg/17078.svg');
  // static SvgIconData arrowBack = SvgIconData(path: 'assets/svg/17079.svg');
  static SvgIconData time = SvgIconData(path: 'assets/svg/17080.svg');
  static SvgIconData calendar = SvgIconData(path: 'assets/svg/17081.svg');
  static SvgIconData location = SvgIconData(path: 'assets/svg/17082.svg');
  static SvgIconData edit = SvgIconData(path: 'assets/svg/17083.svg');
  static SvgIconData delete = SvgIconData(path: 'assets/svg/17084.svg');
  static SvgIconData editOutline = SvgIconData(path: 'assets/svg/17085.svg');
  static SvgIconData list = SvgIconData(path: 'assets/svg/17086.svg');
  static SvgIconData call = SvgIconData(path: 'assets/svg/17087.svg');
  static SvgIconData person = SvgIconData(path: 'assets/svg/17090.svg');
  // static SvgIconData list = SvgIconData(path: 'assets/svg/17091.svg');
  static SvgIconData discount = SvgIconData(path: 'assets/svg/17092.svg');
  static SvgIconData circleCheck = SvgIconData(path: 'assets/svg/17094.svg');
  static SvgIconData arrowTopLeft = SvgIconData(path: 'assets/svg/17095.svg');
  static SvgIconData map = SvgIconData(path: 'assets/svg/17096.svg');
  static SvgIconData search = SvgIconData(path: 'assets/svg/17097.svg');
  static SvgIconData dollar1 = SvgIconData(path: 'assets/svg/17098.svg');
  static SvgIconData keyboardDown = SvgIconData(path: 'assets/svg/17099.svg');
  static SvgIconData comment = SvgIconData(path: 'assets/svg/27650.svg');
  static SvgIconData more = SvgIconData(path: 'assets/svg/27653.svg');
  static SvgIconData addMoney = SvgIconData(path: 'assets/svg/27654.svg');
  static SvgIconData clock = SvgIconData(path: 'assets/svg/27655.svg');
  static SvgIconData note = SvgIconData(path: 'assets/svg/27656.svg');
  static SvgIconData filter = SvgIconData(path: 'assets/svg/27657.svg');
  static SvgIconData sideBar = SvgIconData(path: 'assets/svg/27658.svg');
  static SvgIconData group = SvgIconData(path: 'assets/svg/27659.svg');
  static SvgIconData clean = SvgIconData(path: 'assets/svg/27661.svg');
  static SvgIconData noti = SvgIconData(path: 'assets/svg/27663.svg');
  static SvgIconData setting = SvgIconData(path: 'assets/svg/27664.svg');
  static SvgIconData sort = SvgIconData(path: 'assets/svg/27665.svg');
  static SvgIconData dollar2 = SvgIconData(path: 'assets/svg/27703.svg');
  static SvgIconData wallet = SvgIconData(path: 'assets/svg/27705.svg');
  static SvgIconData car = SvgIconData(path: 'assets/svg/27711.svg');
  static SvgIconData navigation1 = SvgIconData(path: 'assets/svg/27713.svg');
  static SvgIconData checkList = SvgIconData(path: 'assets/svg/27715.svg');
  static SvgIconData google = SvgIconData(path: 'assets/svg/27717.svg');
  static SvgIconData barChart = SvgIconData(path: 'assets/svg/27718.svg');
  static SvgIconData star = SvgIconData(path: 'assets/svg/27720.svg');
  static SvgIconData password = SvgIconData(path: 'assets/svg/27721.svg');
  static SvgIconData alternateEmail = SvgIconData(path: 'assets/svg/27722.svg');
  static SvgIconData starOutline = SvgIconData(path: 'assets/svg/27723.svg');
  static SvgIconData refresh = SvgIconData(path: 'assets/svg/27724.svg');
}

class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.icon, {
    Key? key,
    this.size,
    this.color,
    this.semanticLabel,
  }) : super(key: key);

  final SvgIconData? icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon!.path,
      width: size,
      height: size,
      color: color,
      semanticsLabel: semanticLabel,
    );
  }
}
