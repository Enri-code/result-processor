import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unn_grading/src/core/constants/theme.dart';

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

class SemesterFormField extends StatelessWidget {
  const SemesterFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    const items = [
      DropdownMenuItem(value: 'First', child: Text('First')),
      DropdownMenuItem(value: 'Second', child: Text('Second')),
    ];
    return DropdownButtonFormField2(
      value: items.map((e) => e.value).contains(controller.text)
          ? controller.text
          : null,
      items: items,
      hint: Text('Semester', style: themeData.inputDecorationTheme.hintStyle),
      style: const TextStyle(color: Colors.black, fontSize: 11),
      menuItemStyleData: const MenuItemStyleData(
        height: 32,
        padding: EdgeInsets.zero,
      ),
      decoration: const InputDecoration(
        labelText: 'Semester',
        errorStyle: TextStyle(fontSize: 0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        contentPadding: EdgeInsets.all(8),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return '';
        return null;
      },
      onChanged: (value) => controller.text = value ?? '',
    );
  }
}
