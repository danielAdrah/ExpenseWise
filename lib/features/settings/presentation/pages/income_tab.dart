// ignore_for_file: unused_local_variable, avoid_print

import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
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
              if (state is IncomeDeleteSuccess || state is IncomeAddSuccess) {
                context.read<IncomeBloc>().add(LoadIncomeEvent(
                    accountID: storage.read('selectedAcc') ?? ""));
              }
            },
            builder: (context, state) {
              print(state);
              if (state is IncomeLoaded) {
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
                                  content: Text(
                                    "Are You Sure You Want To Delete This ?",
                                    style: TextStyle(
                                        color: theme.inversePrimary,
                                        fontFamily: 'Poppins'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
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
                        delay: const Duration(milliseconds: 150),
                        curve: Curves.decelerate,
                        child: InkWell(
                          onTap: () {
                            // context.pushNamed('limitDetail');
                          },
                          child: IncomeCard(
                            title: income.category,
                            price: income.amount.toString(),
                            date: DateTime.parse(income.date),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              } else if (state is IncomeLoading) {
                return Padding(
                  padding: EdgeInsets.only(top: 0, bottom: height * 0.2),
                  child: Center(
                      child: SpinKitWave(
                    color: TColor.primary2,
                    size: 40,
                  )),
                );
              } else if (state is IncomeError) {
                return Center(
                  child: Text(state.message,
                      style: TextStyle(
                          color: theme.inversePrimary,
                          fontSize: 17,
                          fontFamily: 'Poppins')),
                );
              } else {
                return Center(child: Text("dfdfd"));
              }
            },
          ),
        ),
      ),
    );
  }
}
