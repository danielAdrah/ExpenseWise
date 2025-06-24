// ignore_for_file: unused_local_variable, avoid_print

import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/components/gradient_icon.dart';
import '../../../../core/components/methods.dart';
import '../../../../core/theme/app_color.dart';
import '../bloc/income_bloc.dart';
import '../widgets/income_card.dart';

class IncomeTabView extends StatefulWidget {
  const IncomeTabView({super.key});

  @override
  State<IncomeTabView> createState() => _IncomeTabViewState();
}

class _IncomeTabViewState extends State<IncomeTabView> {
  final GetStorage storage = GetStorage();
  @override
  void initState() {
    context
        .read<IncomeBloc>()
        .add(LoadIncomeEvent(accountID: storage.read('selectedAcc') ?? ""));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: FadeInDown(
            delay: const Duration(milliseconds: 150),
            curve: Curves.decelerate,
            child: Text("My Incomes",
                style: TextStyle(
                    color: theme.inversePrimary, fontFamily: 'Arvo'))),
        leading: FadeInLeft(
          delay: const Duration(milliseconds: 150),
          curve: Curves.decelerate,
          child: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.inversePrimary,
              size: 25,
            ),
          ),
        ),
        actions: [
          FadeInRight(
              delay: const Duration(milliseconds: 150),
              curve: Curves.decelerate,
              child: Image.asset("assets/img/logo1.png", width: 60, height: 60))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: () {
          context.pushNamed('createIncome');
        },
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                TColor.secondaryG50,
                TColor.secondaryG,
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
          padding: const EdgeInsets.only(top: 10),
          child: BlocConsumer<IncomeBloc, IncomeState>(
            listener: (context, state) {
              // Handle state transitions that require UI feedback
              if (state is IncomeDeleteSuccess) {
                final snackBar =
                    Methods().successSnackBar('Income deleted successfully');
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // Reload incomes after deletion
                context.read<IncomeBloc>().add(LoadIncomeEvent(
                    accountID: storage.read('selectedAcc') ?? ""));
              } else if (state is IncomeDeleteError) {
                // Show error message when income deletion fails
                final snackBar =
                    Methods().errorSnackBar('Failed to delete income');
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            builder: (context, state) {
              // Debug the current state
              print("Current income state: $state");

              if (state is IncomeInitial) {
                // Initial state - trigger loading
                context.read<IncomeBloc>().add(LoadIncomeEvent(
                    accountID: storage.read('selectedAcc') ?? ""));
                return Center(
                  child: Text("Loading incomes...",
                      style: TextStyle(
                          fontFamily: 'Poppins', color: theme.inversePrimary)),
                );
              } else if (state is IncomeLoading ||
                  state is IncomeDeleteInProgress) {
                // Show loading indicator for all loading states
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitWave(
                        color: TColor.secondaryG50,
                        size: 40,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state is IncomeLoading
                            ? "Loading your incomes..."
                            : "Deleting income...",
                        style: TextStyle(
                          color: theme.inversePrimary,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is IncomeLoaded) {
                // Display the list of incomes when loaded
                if (state.income.isEmpty) {
                  // Handle empty state
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GradientIcon(
                          gradient: RadialGradient(
                            colors: [
                              TColor.secondaryG50,
                              TColor.secondaryG,
                            ],
                          ),
                          icon: Icons.account_balance_wallet_outlined,
                          size: 100,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No incomes found",
                          style: TextStyle(
                            color: theme.inversePrimary,
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Tap the + button to add your first income",
                          style: TextStyle(
                            color: theme.inversePrimary.withOpacity(0.7),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // Display the list of incomes
                print("Income data: ${state.income.length}");
                return ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.income.length,
                  itemBuilder: ((context, index) {
                    var income = state.income[index];
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
                                  title: Text(
                                    "Delete Income",
                                    style: TextStyle(
                                      color: theme.inversePrimary,
                                      fontFamily: 'Arvo',
                                    ),
                                  ),
                                  content: Text(
                                    "Are you sure you want to delete this income?",
                                    style: TextStyle(
                                        color: theme.inversePrimary,
                                        fontFamily: 'Poppins'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Delete the income when confirmed
                                        context.read<IncomeBloc>().add(
                                            DeleteIncomeEvent(
                                                accountID: income.id));
                                        context.pop();
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
                          label: 'Delete',
                          borderRadius: BorderRadius.circular(5),
                          spacing: 2,
                        ),
                      ]),
                      child: FadeInUp(
                        delay: Duration(milliseconds: 150 + (index * 50)),
                        curve: Curves.decelerate,
                        child: InkWell(
                          onTap: () {
                            // Show income details
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Income Details",
                                      style: TextStyle(
                                        color: theme.inversePrimary,
                                        fontFamily: 'Arvo',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDetailRow(
                                        "Category", income.category, theme),
                                    _buildDetailRow(
                                        "Amount",
                                        "\$${income.amount.toStringAsFixed(2)}",
                                        theme),
                                    _buildDetailRow("Date", income.date, theme),
                                    _buildDetailRow("Note", income.note, theme),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () => context.pop(),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: TColor.secondaryG50,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text("Close"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: IncomeCard(
                            title: income.category,
                            price: income.amount.toString(),
                            date: DateTime.tryParse(income.date) ??
                                DateTime.now(),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              } else if (state is IncomeError) {
                // Display error message
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 70,
                        color: Colors.red.withOpacity(0.7),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Error Loading Incomes",
                        style: TextStyle(
                          color: theme.inversePrimary,
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          state.message,
                          style: TextStyle(
                            color: theme.inversePrimary.withOpacity(0.7),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Retry loading incomes
                          context.read<IncomeBloc>().add(LoadIncomeEvent(
                              accountID: storage.read('selectedAcc') ?? ""));
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // Fallback for any unhandled states
                return Center(
                  child: Text(
                    "Unknown state: ${state.runtimeType}",
                    style: TextStyle(
                      color: theme.inversePrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// Helper method for income details
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
