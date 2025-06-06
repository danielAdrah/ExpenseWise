import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/components/main_app_bar.dart';
import '../../../../core/components/my_list_tile.dart';
import '../../../../core/theme/app_color.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';

class UpcomingExpenseView extends StatefulWidget {
  const UpcomingExpenseView({super.key});

  @override
  State<UpcomingExpenseView> createState() => _UpcomingExpenseViewState();
}

class _UpcomingExpenseViewState extends State<UpcomingExpenseView> {
  final GetStorage storage = GetStorage();
  @override
  void initState() {
    context
        .read<ExpenseBloc>()
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
              child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, expState) {
                  if (expState is UpcomingExpenseLoaded) {
                    if (expState.expenses.isEmpty) {
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
                                  "There are no upcoming expenses to be displayed Add one first",
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
                      itemCount: expState.expenses.length,
                      itemBuilder: ((context, index) {
                        var exp = expState.expenses[index];
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
                                              onPressed: () {},
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
                                  onPressed: (context) {},
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
                  } else if (expState is UpcomingExpenseError) {
                    return Center(
                      child: Text(expState.message,
                          style: TextStyle(
                              color: theme.inversePrimary,
                              fontSize: 17,
                              fontFamily: 'Poppins')),
                    );
                  } else if (expState is UpcomingExpenseLoading) {
                    return Padding(
                      padding: EdgeInsets.only(top: height * 0.3),
                      child: Center(
                          child: SpinKitWave(
                        color: TColor.primary2,
                        size: 40,
                      )),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
