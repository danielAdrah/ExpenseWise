// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class DateTextField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextAlign titleAlign;
  final IconData icon;
  final bool obscureText;
  final VoidCallback onIconPressed;
  void Function()? onTap;
  DateTextField(
      {super.key,
      required this.title,
      required this.onTap,
      this.controller,
      this.titleAlign = TextAlign.left,
      required this.icon,
      this.keyboardType,
      this.obscureText = false,
      required this.onIconPressed});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: true,
      style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          decoration: TextDecoration.none),
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.tertiary,
        filled: true,
        hintText: title,
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontFamily: 'Arvo'),
        prefixIcon: GestureDetector(
          onTap: onIconPressed,
          child: Icon(icon,
              color: Theme.of(context).colorScheme.inversePrimary, size: 25),
        ),
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
