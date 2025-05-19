import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';



class CustomeAppBar extends StatelessWidget {
  const CustomeAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              // Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
            )),
        FadeInDown(
          delay: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: media.width * 0.05),
          ),
        ),
        FadeInRight(
          delay: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: IconButton(
            onPressed: () {
             
            },
            icon: Icon(
              Icons.settings_sharp,
              color: Colors.white.withOpacity(0.6),
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
