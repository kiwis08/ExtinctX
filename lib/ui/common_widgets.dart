import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedTextFormField extends StatelessWidget {
  const RoundedTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscure = false,
    this.autofillHints,
    this.inputType,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.validator,
    this.fillColor,
    this.inputFormatters,
    this.onChanged,
    this.borderRadius,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final bool obscure;
  final Widget? prefixIcon;
  final Icon? suffixIcon;
  final TextInputType? inputType;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String?)? onChanged;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      focusNode: focusNode,
      controller: controller,
      keyboardType: inputType,
      autofillHints: autofillHints,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          filled: fillColor != null,
          fillColor: fillColor,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: labelText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 30),
              borderSide: BorderSide.none),
          floatingLabelBehavior: FloatingLabelBehavior.never),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
