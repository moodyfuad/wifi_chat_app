import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CTextField extends StatelessWidget {
  const CTextField({
    super.key,
    required this.controller,
    this.icon,
    this.isPassword = false,
    this.onChanged,
    this.onSubmitted,
    this.validator,
  });

  final TextEditingController controller;
  final bool isPassword;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;

  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: "Enter Your Name (English)",
        labelText: 'Name (English)',
      ),
    );
  }
}
