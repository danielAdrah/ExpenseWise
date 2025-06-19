// ignore_for_file: avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:trackme/core/components/my_list_tile.dart';
import 'package:trackme/features/expenses/presentation/bloc/expense_event.dart';

import '../../../../core/components/main_app_bar.dart';
import '../../../../core/theme/app_color.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../expenses/data/models/expense_model.dart';
import '../../../expenses/presentation/bloc/expense_bloc.dart';
import '../../../expenses/presentation/bloc/expense_state.dart';
import '../../../expenses/presentation/bloc/upcoming_expense_bloc.dart';
import '../../../expenses/presentation/bloc/upcoming_expense_event.dart';
import '../../../settings/presentation/bloc/income_bloc.dart';
import '../widgets/total_pie_chart.dart';
// import '../widgets/total_pie_chart.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GetStorage storage = GetStorage();
  String? selectedAccount;
  @override
  void initState() {
    context.read<AuthBloc>().add(GetAccountsEvent());
    context
        .read<ExpenseBloc>()
        .add(LoadExpensesEvent(storage.read('selectedAcc') ?? ""));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
            if (state is ExpenseLoaded) {
              // Only load upcoming expenses after expenses are loaded
              final accountId = storage.read('selectedAcc') ?? "";
              // context
              //     .read<ExpenseBloc>()
              //     .add(LoadUpcomingExpensesEvent(accountId));
              context
                  .read<IncomeBloc>()
                  .add(LoadIncomeEvent(accountID: accountId));
            }
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                stretch: true,
                expandedHeight: media.width * 1.1,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      Container(
                        height: media.width * 1.1,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                        //here will be the piechart
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: media.width * 0.03),
                              child: const MainAppBar(),
                            ),
                            const SizedBox(height: 8),
                            const InteractivePieChart(),
                            const SizedBox(height: 30),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 80),
                                child: ZoomInDown(
                                  delay: const Duration(milliseconds: 500),
                                  child: BlocBuilder<AuthBloc, AuthState>(
                                      builder: (context, authState) {
                                    if (authState is GetAccountsLoaded &&
                                        authState.accounts.isNotEmpty) {
                                      final accounts = authState.accounts;
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary
                                                  .withOpacity(0.4),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        width: 100,
                                        child: DropdownButton<String>(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          hint: Text(
                                              storage.read('selectedAcc') ??
                                                  "Select an account",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary)),
                                          items: accounts.map((account) {
                                            return DropdownMenuItem<String>(
                                              value: account.accountName,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    account.accountName,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .inversePrimary),
                                                  ),
                                                ],
                                              ), // Display the category name
                                            );
                                          }).toList(),
                                          isExpanded: true,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          underline: Text(
                                            "",
                                            style:
                                                TextStyle(color: TColor.white),
                                          ),
                                          onChanged: (String? val) {
                                            if (val != null) {
                                              setState(() {
                                                selectedAccount = val;
                                              });
                                              storage.write('selectedAcc',
                                                  selectedAccount);

                                              // Load expenses with separate BLoCs
                                              context
                                                  .read<ExpenseBloc>()
                                                  .add(LoadExpensesEvent(val));
                                              context.read<UpcomingExpenseBloc>().add(LoadUpcomingExpensesEvent(val));
                                              context.read<IncomeBloc>().add(
                                                  LoadIncomeEvent(
                                                      accountID: val));
                                            }
                                          },
                                        ),
                                      );
                                    } else if (authState is GetAccountsLoaded &&
                                        authState.accounts.isEmpty) {
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary
                                                  .withOpacity(0.4),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        width: 130,
                                        child: Text(
                                            "You don't have any account",
                                            style: TextStyle(
                                                color: theme.inversePrimary,
                                                fontFamily: 'Poppins')),
                                      );
                                    } else if (authState
                                        is GetAccountsLoading) {
                                      return Center(
                                          child: SpinKitWave(
                                        color: TColor.primary2,
                                        size: 30,
                                      ));
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //=======================================
              SliverToBoxAdapter(
                child: BlocBuilder<ExpenseBloc, ExpenseState>(
                  builder: (context, state) {
                    // Debug state type
                    print("Dashboard expense state: ${state.runtimeType}");

                    if (state is ExpenseLoaded) {
                      // Display regular expenses
                      if (state.expenses.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                              child: Text(
                                  "There are no expenses to be displayed\nAdd an expense first",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: theme.inversePrimary,
                                      fontSize: 17,
                                      fontFamily: 'Poppins'))),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.expenses.length,
                          itemBuilder: ((context, index) {
                            var exp = state.expenses[index];
                            return ZoomInDown(
                              delay: const Duration(milliseconds: 500),
                              child: Slidable(
                                endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    theme.primaryContainer,
                                                content: Text(
                                                  "Are You Sure You Want To Delete This ?",
                                                  style: TextStyle(
                                                      color:
                                                          theme.inversePrimary,
                                                      fontFamily: 'Poppins'),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      context
                                                          .read<ExpenseBloc>()
                                                          .add(
                                                              DeleteExpenseEvent(
                                                                  exp.id));
                                                      context
                                                          .read<ExpenseBloc>()
                                                          .add(LoadExpensesEvent(
                                                              storage.read(
                                                                      'selectedAcc') ??
                                                                  ""));
                                                      context.pop();
                                                    },
                                                    child: Text(
                                                      "Yes",
                                                      style: TextStyle(
                                                          color: theme
                                                              .inversePrimary),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      context.pop();
                                                    },
                                                    child: Text("No",
                                                        style: TextStyle(
                                                            color: theme
                                                                .inversePrimary)),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icons.delete,
                                        backgroundColor: Colors.red,
                                        label: "Delete",
                                        borderRadius: BorderRadius.circular(5),
                                        spacing: 2,
                                      ),
                                      SlidableAction(
                                        onPressed: (context) {
                                          context.pushNamed('editExpense',
                                              extra: ExpenseModel(
                                                name: exp.name,
                                                quantity: exp.quantity,
                                                price: exp.price,
                                                accountId: exp.accountId,
                                                category: exp.category,
                                                id: exp.id,
                                                subCategory: exp.subCategory,
                                                userId: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                              ));
                                        },
                                        icon: Icons.edit,
                                        label: "Edit",
                                        backgroundColor: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                        spacing: 2,
                                      ),
                                    ]),
                                child: MyListTile(
                                  type: exp.category,
                                  title: exp.name,
                                  price: exp.price.toString(),
                                  date: DateTime.now(),
                                ),
                              ),
                            );
                          }),
                        );
                      }
                    } else if (state is ExpenseError) {
                      return Center(
                        child: Text("Error: ${state.message}",
                            style: TextStyle(
                                color: theme.inversePrimary,
                                fontSize: 17,
                                fontFamily: 'Poppins')),
                      );
                    } else if (state is ExpenseLoading) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/img/wait.png',
                              width: 90,
                              height: 90,
                            ),
                            const SizedBox(height: 15),
                            Text("Loading expenses...",
                                style: TextStyle(
                                    color: theme.inversePrimary,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink(); // No more "nooooooooo"
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
