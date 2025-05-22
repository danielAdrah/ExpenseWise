import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trackme/core/components/inline_nav_bar.dart';

import '../../../../core/components/custom_button.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';

class CreateSecAccount extends StatefulWidget {
  const CreateSecAccount({super.key});

  @override
  State<CreateSecAccount> createState() => _CreateSecAccountState();
}

class _CreateSecAccountState extends State<CreateSecAccount> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                const InlineNavBar(title: "Create Account"),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 1000),
                  curve: Curves.decelerate,
                  child: Text(
                    "What is in your mind for  this account?!",
                    style: TextStyle(
                        color: theme.inversePrimary,
                        fontSize: 22,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 900),
                  child: Image.asset(
                    "assets/img/analytics.png",
                    width: width * 0.5,
                    height: height * 0.22,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  curve: Curves.decelerate,
                  child: AuthTextField(
                    title: "Account Name",
                    keyboardType: TextInputType.text,
                    controller: TextEditingController(),
                    preIcon: Icons.person_4_outlined,
                    onIconPressed: () {},
                  ),
                ),
                const SizedBox(height: 35),
                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  curve: Curves.decelerate,
                  child: AuthTextField(
                    title: "Account Currency",
                    keyboardType: TextInputType.text,
                    controller: TextEditingController(),
                    preIcon: CupertinoIcons.money_dollar,
                    onIconPressed: () {},
                  ),
                ),
                const SizedBox(height: 35),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  curve: Curves.decelerate,
                  child: AuthTextField(
                    title: "Account Budget",
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(),
                    preIcon: CupertinoIcons.money_dollar_circle,
                    onIconPressed: () {},
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 80),
                FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    curve: Curves.decelerate,
                    child: CustomButton(title: "Create", onPressed: () {})),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
