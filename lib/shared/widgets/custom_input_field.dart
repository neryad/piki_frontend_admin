import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class CustomInputField extends StatelessWidget {
  final int? maxLength;
  final String? placeHolder;
  final String? label;
  final String? helperTxt;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool isPassword;
  final String formProperty;
  final String? Function(String?)? customValidation;
  final String? Function(String?)? customOnChanged;
  final Map<String, dynamic> fromValues;
  const CustomInputField({
    super.key,
    this.placeHolder,
    this.label,
    this.helperTxt,
    this.icon,
    this.suffixIcon,
    this.keyboardType,
    this.isPassword = false,
    required this.formProperty,
    required this.fromValues,
    this.customValidation,
    this.customOnChanged,
    this.maxLength,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      maxLength: maxLength,
      keyboardType: keyboardType,
      obscureText: isPassword,
      onChanged: (value) {
        fromValues[formProperty] = value;
        if (customOnChanged != null) {
          customOnChanged!(value);
        }
      },
      validator: customValidation ?? customValidation,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: placeHolder,
        labelText: label,
        helperText: helperTxt,
        suffixIcon: suffixIcon == null ? null : Icon(suffixIcon),
        // prefixIcon: Icon(Icons.verified_user_outlined),
        icon: icon == null ? null : Icon(icon),
        // counterText: '3 caracteres'
      ),
    );
  }
}
