// ignore_for_file: unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/components/methods.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/limit_entity.dart';
import '../bloc/limit_bloc.dart';
import '../widgets/limit_card.dart';

class SpendingLimit extends StatefulWidget {
  const SpendingLimit({super.key});

  @override
  State<SpendingLimit> createState() => _SpendingLimitState();
}

class _SpendingLimitState extends State<SpendingLimit> {
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadLimits();
  }

  void _loadLimits() {
    final accountId = storage.read('selectedAcc');
    context.read<LimitBloc>().add(GetLimitsEvent(accountId: accountId));
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
            child: Text("Spending Limits",
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
          context.pushNamed('createLimit').then((_) => _loadLimits());
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
        child: BlocConsumer<LimitBloc, LimitState>(
          listener: (context, state) {
            if (state is DeleteLimitSuccess) {
              final snackbar =
                  Methods().successSnackBar("Limit deleted successfully");
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              _loadLimits();
            } else if (state is DeleteLimitError) {
              final snackbar = Methods().errorSnackBar(state.message);
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
          },
          builder: (context, state) {
            if (state is LimitLoading) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitWave(
                        color: TColor.primary2,
                        size: 40,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Loading your limits...",
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
            } else if (state is LimitsLoaded) {
              final limits = state.limits;

              if (limits.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/img/search.png",
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "No spending limits yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.inversePrimary,
                          fontFamily: 'Arvo',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Create a new limit to track your expenses",
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.inversePrimary.withOpacity(0.7),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: limits.length,
                  itemBuilder: ((context, index) {
                    final limit = limits[index];
                    return Slidable(
                      endActionPane:
                          ActionPane(motion: const StretchMotion(), children: [
                        SlidableAction(
                          onPressed: (context) {
                            _showDeleteConfirmation(context, limit);
                          },
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          label: 'Delete',
                          borderRadius: BorderRadius.circular(5),
                          spacing: 2,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            context
                                .pushNamed('editLimit', extra: limit)
                                .then((_) => _loadLimits());
                          },
                          icon: Icons.edit,
                          backgroundColor: Colors.green,
                          label: "Edit",
                          borderRadius: BorderRadius.circular(5),
                          spacing: 2,
                        ),
                      ]),
                      child: FadeInUp(
                        delay: Duration(milliseconds: 150 * (index % 5)),
                        curve: Curves.decelerate,
                        child: InkWell(
                          onTap: () {
                            context.pushNamed('limitDetail', extra: limit);
                          },
                          child: SpendingLimitCard(
                            limitCategory: limit.category,
                            totalAmount: limit.limitAmount,
                            remainedAmount:
                                limit.limitAmount - limit.spentAmount,
                            spendAmount: limit.spentAmount,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            } else if (state is LimitError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red.withOpacity(0.7),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Error loading limits",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.inversePrimary,
                        fontFamily: 'Arvo',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.inversePrimary.withOpacity(0.7),
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _loadLimits,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        "Try Again",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        backgroundColor: theme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Default state or initial state
            return Center(
              child: SpinKitWave(
                color: TColor.primary2,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, LimitEntity limit) {
    final theme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.primaryContainer,
          title: Text(
            "Delete Limit",
            style: TextStyle(
              color: theme.inversePrimary,
              fontFamily: 'Arvo',
            ),
          ),
          content: Text(
            "Are you sure you want to delete this spending limit?",
            style:
                TextStyle(color: theme.inversePrimary, fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: theme.inversePrimary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Delete the limit
                context.read<LimitBloc>().add(
                      DeleteLimitEvent(
                        id: limit.id,
                        accountId: limit.accountId,
                      ),
                    );
                Navigator.pop(context); // Close dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
