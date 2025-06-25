import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final Alignment alignment;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 15,
    this.color = Colors.black,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        softWrap: true,
        maxLines: 2,
        style: TextStyle(fontSize: fontSize, color: color),
      ),
    );
  }
}
