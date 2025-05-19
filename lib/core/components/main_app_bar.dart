import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/img/logo1.png",
              width: 60, height: 60),
          IconButton(
            onPressed: () {
              context.pushNamed("settingsView");
            },
            icon: Icon(
              Icons.settings_sharp,
              color: Theme.of(context)
                  .colorScheme
                  .inversePrimary,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
