import 'package:flutter/material.dart';

class TextFieldPrimary extends StatelessWidget {
  const TextFieldPrimary({
    super.key,
    this.hintText,
    this.onChanged,
    this.controller,
    this.icon,
    this.readOnly = false,
    this.required = false,
  });
  final String? hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Icon? icon;
  final bool readOnly;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: hintText,
          suffixIcon: icon != null
              ? IconButton(
                  icon: icon!,
                  onPressed: () {},
                )
              : null),
      readOnly: readOnly,
      controller: controller,
      onChanged: onChanged,
      validator: (value) {
        if (required && value!.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }
}
