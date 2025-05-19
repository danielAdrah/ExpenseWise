import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double size;
  final FontWeight fontWeight;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.size = 16,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          // image: const DecorationImage(
          //   image: AssetImage("assets/img/primary_btn.png"),
          // ),
          gradient: const LinearGradient(
            colors: [
              // Color(0XFF5A31F4),
              // Color(0XFF8B5CF6),

              Color(0XFF3A0CA3),
              Color(0XFF8B5CF6),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontSize: size,
              fontWeight: fontWeight,
              fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}
