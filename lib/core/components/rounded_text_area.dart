import 'package:flutter/material.dart';

class RoundedTextArea extends StatelessWidget {
  final String title;
  final int length;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextAlign titleAlign;
  final IconData preIcon;
  final bool obscureText;
  final VoidCallback onIconPressed;
  RoundedTextArea(
      {super.key,
      required this.title,
      this.controller,
      this.titleAlign = TextAlign.left,
      required this.preIcon,
      this.keyboardType,
      this.obscureText = false,
      required this.onIconPressed,
      required this.length});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 4,
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
        // prefixIcon: Icon(preIcon,
        //     color: Theme.of(context).colorScheme.inversePrimary, size: 25),
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
