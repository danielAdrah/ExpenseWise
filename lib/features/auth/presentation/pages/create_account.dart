// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:animate_do/animate_do.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:trackme/core/components/custom_button.dart';
import 'package:trackme/features/auth/domain/entity/account_entity.dart';
import '../../../../core/components/methods.dart';
import '../../../../core/theme/app_color.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';

class CreatAccount extends StatefulWidget {
  const CreatAccount({super.key});

  @override
  State<CreatAccount> createState() => _CreatAccountState();
}

class _CreatAccountState extends State<CreatAccount> {
  final accName = TextEditingController();
  final accCurrency = TextEditingController();
  final accBudget = TextEditingController();
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
                  controller: accName,
                  preIcon: Icons.person_4_outlined,
                  onIconPressed: () {},
                ),
                const SizedBox(height: 35),
                AuthTextField(
                  title: "Account Currency",
                  keyboardType: TextInputType.text,
                  controller: accCurrency,
                  preIcon: CupertinoIcons.money_dollar,
                  onIconPressed: () {},
                ),
                const SizedBox(height: 35),
                AuthTextField(
                  title: "Account Budget",
                  keyboardType: TextInputType.number,
                  controller: accBudget,
                  preIcon: CupertinoIcons.money_dollar_circle,
                  onIconPressed: () {},
                ),
                const SizedBox(height: 80),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AccountCreated) {
                      context.goNamed('mainBar');
                    }
                    if (state is AccountCreatingFailed) {
                      final sBar = Methods().errorSnackBar(state.message);
                      ScaffoldMessenger.of(context).showSnackBar(sBar);
                    }
                  },
                  builder: (context, state) {
                    return state is AccountCreating
                        ? Center(
                            child: SpinKitSpinningLines(
                            color: TColor.primary2,
                            size: 40,
                          ))
                        : CustomButton(
                            title: "Confirm",
                            onPressed: () {
                              print(accName.text);
                              print(accCurrency.text);
                              print(accBudget.text);

                              context.read<AuthBloc>().add(CreateAccountEvent(
                                  account: AccountEntity(
                                      accountName: accName.text,
                                      currency: accCurrency.text,
                                      budget: double.parse(accBudget.text))));
                            });
                  },
                ),
                TextButton(
                  onPressed: () {
                    context.pushNamed('mainBar');
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
