// ignore_for_file: unused_local_variable

import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_color.dart';
import '../widgets/income_card.dart';

class IncomeTabView extends StatefulWidget {
  const IncomeTabView({super.key});

  @override
  State<IncomeTabView> createState() => _IncomeTabViewState();
}

class _IncomeTabViewState extends State<IncomeTabView> {
  // @override
  // void initState() {
  //   super.initState();
  //   controller.displayLimits();
  // }

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
          child: ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: 15,
            itemBuilder: ((context, index) {
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
                                  style: TextStyle(color: theme.inversePrimary),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: Text("No",
                                    style:
                                        TextStyle(color: theme.inversePrimary)),
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
                      title: "Investment",
                      price: "1500",
                      date: DateTime.now(),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
