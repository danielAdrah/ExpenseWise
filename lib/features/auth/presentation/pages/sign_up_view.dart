// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:trackme/core/components/primary_button.dart';

import '../../../../core/components/methods.dart';
import '../../../../core/theme/app_color.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/password_cubit.dart';
import '../widgets/auth_text_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final nameCont = TextEditingController();
  final mailCont = TextEditingController();
  final passCont = TextEditingController();
  final conforimPassCont = TextEditingController();
  final formKey = GlobalKey<FormState>();
  double passwordStrength = 0;

  Color getStrengthColor() {
    if (passwordStrength < 0.3) return Colors.red;
    if (passwordStrength < 0.7) return Colors.orange;
    return Colors.green;
  }

  void checkPasswordStrength(String password) {
    double strength = 0;
    if (password.length >= 8) strength += 0.3;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.3;
    setState(() {
      passwordStrength = strength.clamp(0, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                print("dooooooooooone");
                context.pushNamed("signIn");
              } else if (state is AuthError) {
                final sBar = Methods().errorSnackBar(state.message);
                ScaffoldMessenger.of(context).showSnackBar(sBar);
              }
            },
            builder: (context, state) {
              return Column(
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
                                duration: Duration(milliseconds: 800),
                                child: Text(
                                  "Get Started",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    fontFamily: "Arvo",
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            FadeInDown(
                              duration: Duration(milliseconds: 800),
                              child: AuthTextField(
                                title: "Name",
                                controller: nameCont,
                                preIcon: Icons.person_2_outlined,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Please enter your name'
                                        : null,
                                onIconPressed: () {},
                              ),
                            ),
                            const SizedBox(height: 25),
                            FadeInDown(
                              duration: Duration(milliseconds: 900),
                              // curve: Curves.easeInOut,
                              child: AuthTextField(
                                title: "Email",
                                keyboardType: TextInputType.emailAddress,
                                controller: mailCont,
                                preIcon: Icons.mail_outline,
                                onIconPressed: () {},
                                validator: (value) =>
                                    value != null && value.contains('@')
                                        ? null
                                        : 'Enter a valid email',
                              ),
                            ),
                            const SizedBox(height: 25),
                            FadeInDown(
                              duration: Duration(milliseconds: 1000),
                              // curve: Curves.easeInOut,
                              child: BlocBuilder<PasswordVisibilityCubit, bool>(
                                builder: (context, state) {
                                  return AuthTextField(
                                    obscureText: state,
                                    title: "Password",
                                    controller: passCont,
                                    preIcon: Icons.lock_outline,
                                    icon: state
                                        ? CupertinoIcons.eye_slash_fill
                                        : CupertinoIcons.eye_fill,
                                    onIconPressed: () => context
                                        .read<PasswordVisibilityCubit>()
                                        .toggleVisibility(),
                                    onChanged: checkPasswordStrength,
                                    helpText:
                                        'Use at least 8 characters with a number & symbol',
                                    validator: (value) => passwordStrength < 0.7
                                        ? 'Password is too weak'
                                        : null,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            FadeInDown(
                              duration: Duration(milliseconds: 1050),
                              // curve: Curves.easeInOut,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 4,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.grey[300],
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: passwordStrength,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: getStrengthColor(),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            FadeInDown(
                              duration: Duration(milliseconds: 1100),
                              // curve: Curves.easeInOut,
                              child: BlocBuilder<ConfirmPasswordVisibilityCubit,
                                  bool>(
                                builder: (context, state2) {
                                  return AuthTextField(
                                    title: "Confirm Password",
                                    controller: conforimPassCont,
                                    preIcon: Icons.lock_outline,
                                    obscureText: state2,
                                    icon: state2
                                        ? CupertinoIcons.eye_slash_fill
                                        : CupertinoIcons.eye_fill,
                                    validator: (value) => value == passCont.text
                                        ? null
                                        : 'Passwords do not match',
                                    onIconPressed: () => context
                                        .read<ConfirmPasswordVisibilityCubit>()
                                        .toggleVisibility(),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 40),
                            state is AuthLoading
                                ? Center(
                                    child: SpinKitSpinningLines(
                                    color: TColor.primary2,
                                    size: 40,
                                  ))
                                : Center(
                                    child: FadeInUp(
                                    duration: Duration(milliseconds: 1200),
                                    // curve: Curves.easeInOut,
                                    child: PrimaryButton(
                                        title: "Sign Up",
                                        onPressed: () {
                                          // context.goNamed('mainBar');
                                          if (formKey.currentState!
                                              .validate()) {
                                            context.read<AuthBloc>().add(
                                                SignUpRequested(
                                                    mailCont.text,
                                                    passCont.text,
                                                    nameCont.text));
                                          } else {
                                            print("noooo");
                                          }
                                        }),
                                  )),
                            const SizedBox(height: 20),
                            FadeInUp(
                              duration: Duration(milliseconds: 1100),
                              curve: Curves.easeInOut,
                              child: InkWell(
                                onTap: () {
                                  context.pushNamed("signIn");
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: "Already have an account? ",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        fontFamily: 'Poppins'),
                                    children: [
                                      TextSpan(
                                        text: "SignIn",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
