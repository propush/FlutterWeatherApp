import 'package:flutter/material.dart';

abstract class ColoredStatelessWidget extends StatelessWidget {
  static const appBarBgColor = Color(0xFFE7D2CC);
  static const appBarFgColor = Colors.white;
  static const buttonBgColor = Color(0xFF868B8E);
  static const buttonFgColor = Colors.white;
  static const widgetListBgColor = Color(0xFFEEEDE7);
  static const widgetBgColor = Colors.white70;
  static const cityFgColor = Color(0xFF868B8E);
  static const textFgColor = Colors.black;
  static const errorTextFgColor = Colors.red;

  const ColoredStatelessWidget({Key? key}) : super(key: key);
}
