// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trackme/core/components/primary_button.dart';

import '../../../../core/theme/app_text.dart';
import '../widgets/auth_text_field.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final mailCont = TextEditingController();
  final passCont = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: width,
                height: height / 4.5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
                child: ZoomInDown(
                  duration: Duration(milliseconds: 700),
                  child: Image.asset("assets/img/logo.png",
                      width: 10, height: 10, fit: BoxFit.contain),
                ),
              ),
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 70),
                        Center(
                          child: ZoomInDown(
                            duration: Duration(milliseconds: 750),
                            child: Text(
                              "Welcome Back !!",
                              style: AppText.headlineLarge,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        FadeInDown(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.easeInOut,
                          child: AuthTextField(
                            title: "Email",
                            keyboardType: TextInputType.emailAddress,
                            controller: mailCont,
                            preIcon: Icons.mail_outline,
                            onIconPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 25),
                        FadeInDown(
                          duration: Duration(milliseconds: 900),
                          curve: Curves.easeInOut,
                          child: AuthTextField(
                            title: "Password",
                            controller: passCont,
                            preIcon: Icons.lock_outline,
                            icon: Icons.visibility,
                            onIconPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 30),
                        ZoomIn(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.asset("assets/img/logo1.png"),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: FadeInUp(
                            duration: Duration(milliseconds: 1100),
                            curve: Curves.easeInOut,
                            child: PrimaryButton(
                                title: "Sign In",
                                onPressed: () {
                                  context.goNamed('createAcc');
                                }),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            context.pushNamed("signUp");
                          },
                          child: FadeInUp(
                            duration: Duration(milliseconds: 1200),
                            curve: Curves.easeInOut,
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: Theme.of(context).textTheme.bodyMedium,
                              
                                children: [
                                  TextSpan(
                                    text: "SignUp",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                             
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
