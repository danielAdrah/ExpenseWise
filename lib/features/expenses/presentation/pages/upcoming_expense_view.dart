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
            BlocConsumer<UpcomingExpenseBloc, UpcomingExpenseState>(
              listener: (context, state) {
                if (state is DeleteUpcomingExpenseDone ||
                    state is AddUpcomingExpenseDone ||
                    state is UpdateUpcomingExpenseDone) {
                  refreshList();
                }
              },
              builder: (context, state) {
                if (state is UpcomingExpenseLoading) {
                  return SliverToBoxAdapter(
                    child: UpcomingexpenseLoadingState(
                        height: height, theme: theme),
                  );
                } else if (state is UpcomingExpenseLoaded) {
                  if (state.expenses.isEmpty) {
                    return SliverToBoxAdapter(
                      child: UpcomingexpenseEmptyState(
                          height: height, theme: theme),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
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
                            child: InkWell(
                              onTap: () {
                                // Show expense details in a modal bottom sheet
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: theme.primaryContainer,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) => Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Upcoming Expense Details",
                                          style: TextStyle(
                                            color: theme.inversePrimary,
                                            fontFamily: 'Arvo',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        _buildDetailRow(
                                            "Category", exp.category, theme),
                                        _buildDetailRow("Subcategory",
                                            exp.subCategory, theme),
                                        _buildDetailRow(
                                            "Name", exp.name, theme),
                                        _buildDetailRow("Quantity",
                                            exp.quantity.toString(), theme),
                                        _buildDetailRow(
                                            "Price",
                                            "\$${exp.price.toStringAsFixed(2)}",
                                            theme),
                                        _buildDetailRow(
                                            "Date", exp.date, theme),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  context.pop();
                                                  context.pushNamed(
                                                      'editUpcoming',
                                                      extra:
                                                          UpcomingExpenseModel(
                                                        date: exp.date,
                                                        name: exp.name,
                                                        quantity: exp.quantity,
                                                        price: exp.price,
                                                        accountId:
                                                            exp.accountId,
                                                        category: exp.category,
                                                        id: exp.id,
                                                        subCategory:
                                                            exp.subCategory,
                                                        userId: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                      ));
                                                },
                                                icon: const Icon(Icons.edit),
                                                label: const Text("Edit"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  context.pop();
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        backgroundColor: theme
                                                            .primaryContainer,
                                                        content: Text(
                                                          "Are You Sure You Want To Delete This?",
                                                          style: TextStyle(
                                                              color: theme
                                                                  .inversePrimary,
                                                              fontFamily:
                                                                  'Poppins'),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              deleteAccount(
                                                                  exp);
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
                                                            child: Text(
                                                              "No",
                                                              style: TextStyle(
                                                                  color: theme
                                                                      .inversePrimary),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: const Icon(Icons.delete),
                                                label: const Text("Delete"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
                          ),
                        );
                      },
                      childCount: state.expenses.length,
                    ),
                  );
                } else if (state is UpcomingExpenseError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(state.message,
                          style: TextStyle(
                              color: theme.inversePrimary,
                              fontSize: 17,
                              fontFamily: 'Poppins')),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UpcomingexpenseEmptyState extends StatelessWidget {
  const UpcomingexpenseEmptyState({
    super.key,
    required this.height,
    required this.theme,
  });

  final double height;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.2),
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
          Text("There are no upcoming expenses to be displayed. Add one first",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: theme.inversePrimary,
                  fontSize: 15,
                  fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}

class UpcomingexpenseLoadingState extends StatelessWidget {
  const UpcomingexpenseLoadingState({
    super.key,
    required this.height,
    required this.theme,
  });

  final double height;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: height * 0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFoldingCube(
              color: TColor.primary2,
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              "Loading your upcoming expenses...",
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
  }
}

Widget _buildDetailRow(String label, String value, ColorScheme theme) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.inversePrimary.withOpacity(0.7),
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: theme.inversePrimary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
