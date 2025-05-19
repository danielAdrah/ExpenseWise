import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatefulWidget {
  final String title;
  // final void Function()? onPressed;

  const NavBar({
    super.key,
    required this.title,
    // required this.onPressed,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FadeInLeft(
          delay: const Duration(milliseconds: 200),
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
          delay: const Duration(milliseconds: 120),
          curve: Curves.decelerate,
          child: Text(
            widget.title,
            style: TextStyle(
                color: theme.inversePrimary,
                fontFamily: 'Arvo',
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
        ),
        Image.asset("assets/img/logo1.png", width: 60, height: 60),
      ],
    );
  }
}
