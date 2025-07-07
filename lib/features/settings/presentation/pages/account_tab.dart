import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_color.dart';
import '../../../auth/domain/entity/account_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/account_tile.dart';

class AccountsView extends StatefulWidget {
  const AccountsView({super.key});

  @override
  State<AccountsView> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  void deleteAccount(AccountEntity account) async {
    context.read<AuthBloc>().add(DeleteAccountEvent(account.id));
    context.read<AuthBloc>().add(GetAccountsEvent());
  }

  @override
  void initState() {
    context.read<AuthBloc>().add(GetAccountsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: theme.inversePrimary),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: FadeInDown(
          delay: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: Text('My Accounts',
              style: TextStyle(
                  color: theme.inversePrimary,
                  fontSize: 21,
                  fontFamily: 'Arvo')),
        ),
        leading: FadeInLeft(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: theme.inversePrimary,
              )),
        ),
        actions: [
          FadeInRight(
              duration: const Duration(milliseconds: 200),
              curve: Curves.decelerate,
              child:
                  Image.asset("assets/img/logo1.png", width: 55, height: 55)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: () {
          context.pushNamed('createSecAccount');
        },
        child: Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Color(0XFF8B5CF6),
                Color(0XFF5A31F4),
              ],
            ),
          ),
          child: const Center(
            child: Icon(Icons.add, color: Colors.white, size: 35),
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is GetAccountsLoaded &&
                authState.accounts.isNotEmpty) {
              return ListView.builder(
                  itemCount: authState.accounts.length,
                  itemBuilder: (context, index) {
                    final account = authState.accounts[index];
                    return Slidable(
                      endActionPane:
                          ActionPane(motion: const StretchMotion(), children: [
                        SlidableAction(
                          onPressed: (context) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: theme.primaryContainer,
                                  content: Text(
                                    "Are You Sure You Want To Delete This ?",
                                    style: TextStyle(
                                        color: theme.inversePrimary,
                                        fontFamily: 'Poppins'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        deleteAccount(account);
                                        context.pop();
                                        // context.read<AuthBloc>().add(
                                        //     DeleteAccountEvent(account.id));
                                        // context.goNamed('settingsView');
                                      },
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                            color: theme.inversePrimary),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      child: Text("No",
                                          style: TextStyle(
                                              color: theme.inversePrimary)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                          spacing: 2,
                        ),
                      ]),
                      child: FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        curve: Curves.decelerate,
                        child: AccountTile(
                          icon: Icons.account_box,
                          currency: account.currency,
                          title: account.accountName,
                          budget: account.budget.toString(),
                        ),
                      ),
                    );
                  });
            } else if (authState is GetAccountsLoaded &&
                authState.accounts.isEmpty) {
              return Center(
                  child: Text("You don't have any accounts yet!!",
                      style: TextStyle(
                        color: theme.inversePrimary,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      )));
            } else if (authState is GetAccountsLoading) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitFoldingCube(
                        color: TColor.primary2,
                        size: 40,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Loading your accounts...",
                        style: TextStyle(
                          color: theme.inversePrimary,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      )),
    );
  }
}
