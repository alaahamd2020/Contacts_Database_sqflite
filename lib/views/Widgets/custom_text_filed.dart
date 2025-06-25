import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  final String text;
  final int fontSize;
  final Color? color;
  final void Function(String?)? onsave;
  final String? Function(String?)? validator;
  final TextInputType? type;
  final TextEditingController controller;
  const CustomTextFiled({
    super.key,
    required this.controller,
    required this.text,
    this.fontSize = 16,
    this.color = Colors.grey,
    this.onsave,
    this.validator,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // initialValue: initialValues.toString(),
      controller: controller,

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(hintText: text, fillColor: color),
      // onSaved: onsave,
      onFieldSubmitted: onsave,
      validator: validator,
      keyboardType: type,
    );
  }
}
