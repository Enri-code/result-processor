import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HeaderTitleTextField extends StatelessWidget {
  const HeaderTitleTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.inputFormatters,
    this.style,
    this.validator,
  });

  final TextEditingController? controller;
  final String labelText;
  final TextStyle? style;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: style,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black26, fontSize: 11),
        errorStyle: const TextStyle(fontSize: 0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
      validator: validator ??
          (value) {
            if (value?.isEmpty ?? true) return '';
            return null;
          },
    );
  }
}
