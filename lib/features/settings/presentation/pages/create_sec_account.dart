import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:trackme/core/components/inline_nav_bar.dart';

import '../../../../core/components/custom_button.dart';
import '../../../../core/components/methods.dart';
import '../../../../core/theme/app_color.dart';
import '../../../auth/domain/entity/account_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';

class CreateSecAccount extends StatefulWidget {
  const CreateSecAccount({super.key});

  @override
  State<CreateSecAccount> createState() => _CreateSecAccountState();
}

class _CreateSecAccountState extends State<CreateSecAccount> {
  final accName = TextEditingController();
  final accCurrency = TextEditingController();
  final accBudget = TextEditingController();
  void clear() {
    accName.clear();
    accCurrency.clear();
    accBudget.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AccountCreated) {
                final sBar = Methods().successSnackBar(
                    "Your account has been created successfuly");
                ScaffoldMessenger.of(context).showSnackBar(sBar);
              }
              if (state is AccountCreatingFailed) {
                final sBar = Methods().errorSnackBar(state.message);
                ScaffoldMessenger.of(context).showSnackBar(sBar);
              }
            },
            builder: (context, state) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  children: [
                    const InlineNavBar(title: "Create Account"),
                    const SizedBox(height: 20),
                    FadeInUp(
                      delay: const Duration(milliseconds: 1000),
                      curve: Curves.decelerate,
                      child: Text(
                        "Got a new plan? Name your account",
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
                        controller: accName,
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
                        controller: accCurrency,
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
                        controller: accBudget,
                        preIcon: CupertinoIcons.money_dollar_circle,
                        onIconPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 80),
                    state is AccountCreating
                        ? Center(
                            child: SpinKitWave(
                            color: TColor.primary2,
                            size: 40,
                          ))
                        : FadeInUp(
                            delay: const Duration(milliseconds: 500),
                            curve: Curves.decelerate,
                            child: CustomButton(
                                title: "Create",
                                onPressed: () {
                                  if (accName.text.isEmpty ||
                                      accCurrency.text.isEmpty ||
                                      accBudget.text.isEmpty) {
                                    final Snackbar = Methods().infoSnackBar(
                                        'Please make sure not to leave any of the fields empty');
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(Snackbar);
                                  }else{
                                     context.read<AuthBloc>().add(
                                        CreateAccountEvent(
                                          account: AccountEntity(
                                            id: '',
                                            accountName: accName.text,
                                            currency: accCurrency.text,
                                            budget:
                                                double.parse(accBudget.text),
                                          ),
                                        ),
                                      );
                                  context.goNamed('mainBar');
                                  clear();
                                  }
                                 
                                })),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
