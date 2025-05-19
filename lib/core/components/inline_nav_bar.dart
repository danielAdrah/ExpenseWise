import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InlineNavBar extends StatelessWidget {
  const InlineNavBar({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // const SizedBox(height: 10),
        FadeInLeft(
          delay: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: theme.inversePrimary,
                size: 30,
              )),
        ),
        FadeInDown(
          delay: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Text(
            title,
            style: TextStyle(
                color: theme.inversePrimary,
                fontSize: 20,
                fontFamily: "Arvo",
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none),
          ),
        ),
        FadeInRight(
          delay: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Image.asset(
            "assets/img/logo1.png",
            width: 60,
            height: 60,
          ),
        ),
      ],
    );
  }
}
