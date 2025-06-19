import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/components/main_app_bar.dart';
import '../../../../core/components/my_list_tile.dart';
import '../../../../core/theme/app_color.dart';
import '../../data/models/upcoming_expense_model.dart';
import '../../domain/entities/upcoming_expense_entity.dart';
import '../bloc/upcoming_expense_bloc.dart';
import '../bloc/upcoming_expense_event.dart';
import '../bloc/upcoming_expense_state.dart';

class UpcomingExpenseView extends StatefulWidget {
  const UpcomingExpenseView({super.key});

  @override
  State<UpcomingExpenseView> createState() => _UpcomingExpenseViewState();
}

class _UpcomingExpenseViewState extends State<UpcomingExpenseView> {
  final GetStorage storage = GetStorage();

  void refreshList() {
    context
        .read<UpcomingExpenseBloc>()
        .add(LoadUpcomingExpensesEvent(storage.read('selectedAcc') ?? ""));
  }

  void deleteAccount(UpcomingExpenseEntity exp) async {
    context.read<UpcomingExpenseBloc>().add(DeleteUpcomingExpenseEvent(exp.id));
    refreshList();
  }

  @override
  void initState() {
    context
        .read<UpcomingExpenseBloc>()
        .add(LoadUpcomingExpensesEvent(storage.read('selectedAcc') ?? ""));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              stretch: true,
              expandedHeight: 80,
              flexibleSpace: FlexibleSpaceBar(
                background: MainAppBar(),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocConsumer<UpcomingExpenseBloc, UpcomingExpenseState>(
                listener: (context, state) {
                  if (state is DeleteUpcomingExpenseDone ||
                      state is AddUpcomingExpenseDone ||
                      state is UpdateUpcomingExpenseDone) {
                    refreshList();
                  }
                },
                builder: (context, state) {
                  if (state is UpcomingExpenseLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UpcomingExpenseLoaded) {
                    if (state.expenses.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Padding(
                          padding: EdgeInsets.only(top: height * 0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/img/search.png",
                                width: height * 0.2,
                                height: height * 0.2,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  "There are no upcoming expenses to be displayed. Add one first",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: theme.inversePrimary,
                                      fontSize: 15,
                                      fontFamily: 'Poppins')),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.expenses.length,
                      itemBuilder: ((context, index) {
                        var exp = state.expenses[index];
                        return Slidable(
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
                                                color: theme.inversePrimary,
                                                fontFamily: 'Poppins'),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                deleteAccount(exp);
                                                context.pop();
                                              },
                                              child: Text(
                                                "Yes",
                                                style: TextStyle(
                                                    color:
                                                        theme.inversePrimary),
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
                                    context.pushNamed('editUpcoming',
                                        extra: UpcomingExpenseModel(
                                          date: exp.date,
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
                          child: FadeInDown(
                            delay: const Duration(milliseconds: 500),
                            curve: Curves.decelerate,
                            child: SizedBox(
                              width: double.infinity,
                              child: MyListTile(
                                type: exp.category,
                                title: exp.name,
                                price: exp.price.toString(),
                                date: DateTime.parse(exp.date),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  } else if (state is UpcomingExpenseError) {
                    return Center(
                      child: Text(state.message,
                          style: TextStyle(
                              color: theme.inversePrimary,
                              fontSize: 17,
                              fontFamily: 'Poppins')),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
