import 'package:flutter/material.dart';

import '../../../../core/theme/app_text.dart';

// ignore: must_be_immutable
class AuthTextField extends StatelessWidget {
  final String title;
  final String? helpText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final IconData? icon;
  final IconData preIcon;
  final bool obscureText;
  void Function(String)? onChanged;
  final VoidCallback onIconPressed;
  String? Function(String?)? validator;
  AuthTextField({
    super.key,
    required this.title,
    this.helpText,
    this.controller,
    this.onChanged,
    this.icon,
    this.keyboardType,
    this.obscureText = false,
    required this.onIconPressed,
    required this.preIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          decoration: TextDecoration.none),
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        // fillColor: Theme.of(context).colorScheme.primaryContainer,
        fillColor: Theme.of(context).colorScheme.tertiary,
        filled: true,
        helperText: helpText,
        hintText: title,
        helperStyle:
            TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontFamily: 'Poppins'),
        hintStyle: AppText.bodySmall,

        // TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        suffixIcon: GestureDetector(
          onTap: onIconPressed,
          child: Icon(icon,
              color: Theme.of(context).colorScheme.inversePrimary, size: 22),
        ),
        prefixIcon: Icon(preIcon,
            color: Theme.of(context).colorScheme.inversePrimary, size: 25),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
