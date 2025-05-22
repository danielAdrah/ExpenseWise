
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:animate_do/animate_do.dart";
import 'package:go_router/go_router.dart';
import 'package:trackme/core/components/custom_button.dart';
import '../widgets/auth_text_field.dart';

class CreatAccount extends StatefulWidget {
  const CreatAccount({super.key});

  @override
  State<CreatAccount> createState() => _CreatAccountState();
}

class _CreatAccountState extends State<CreatAccount> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: SingleChildScrollView(
          child: FadeInUp(
            delay: const Duration(milliseconds: 500),
            curve: Curves.decelerate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Text(
                  "What is in your mind for  this account?!",
                  style: TextStyle(
                      color: theme.inversePrimary,
                      fontSize: 22,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  "assets/img/analytics.png",
                  width: width * 0.5,
                  height: height * 0.22,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  title: "Account Name",
                  keyboardType: TextInputType.text,
                  controller: TextEditingController(),
                  preIcon: Icons.person_4_outlined,
                  onIconPressed: () {},
                ),
                const SizedBox(height: 35),
                AuthTextField(
                  title: "Account Currency",
                  keyboardType: TextInputType.text,
                  controller: TextEditingController(),
                  preIcon: CupertinoIcons.money_dollar,
                  onIconPressed: () {},
                ),
                const SizedBox(height: 35),
                AuthTextField(
                  title: "Account Budget",
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(),
                  preIcon: CupertinoIcons.money_dollar_circle,
                  onIconPressed: () {},
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 80),
                CustomButton(
                    title: "Confirm",
                    onPressed: () {
                      context.goNamed('mainBar');
                    }),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
