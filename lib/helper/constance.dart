import 'package:flutter/material.dart';

final String tableUser = 'user';
final String columnId = 'id';
final String columnName = 'name';
final String columnPhone = 'phone';
final String columnEmail = 'email';

Color primaryColor = Colors.teal.shade500;


extension MyColorsExt on Color {

  bool get isLight => computeLuminance() > 0.5;
}

extension MyNum  on num {

  Widget get w => SizedBox(width: toDouble(),);
  Widget get h => SizedBox(height: toDouble(),);

}