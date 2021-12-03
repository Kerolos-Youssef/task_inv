import 'package:flutter/material.dart';

class CustomTextInputField extends StatelessWidget {
  final TextEditingController? controller;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? hintText;
  final double? borderRadius;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final AutovalidateMode? autoValidateMode;

  CustomTextInputField({
    this.controller,
    this.maxLines,
    this.keyboardType,
    this.hintText,
    this.borderRadius = 0,
    this.onTap,
    this.validator,
    this.autoValidateMode,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return TextFormField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      controller: controller,
      onTap: onTap,
      validator: validator,
      autovalidateMode: autoValidateMode,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width * borderRadius!),
        ),
      ),
    );
  }
}
