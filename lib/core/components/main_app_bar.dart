import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SlideInLeft(
            delay: const Duration(milliseconds: 200),
            curve: Curves.decelerate,
            child: Image.asset("assets/img/logo1.png", width: 60, height: 60),
          ),
          SlideInRight(
            delay: const Duration(milliseconds: 200),
            curve: Curves.decelerate,
            child: IconButton(
              onPressed: () {
                context.pushNamed("settingsView");
              },
              icon: Icon(
                Icons.settings_sharp,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
