import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/components/main_app_bar.dart';
import '../../../../core/components/my_list_tile.dart';

class UpcomingExpenseView extends StatefulWidget {
  const UpcomingExpenseView({super.key});

  @override
  State<UpcomingExpenseView> createState() => _UpcomingExpenseViewState();
}

class _UpcomingExpenseViewState extends State<UpcomingExpenseView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
  
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
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
                        label: "Delete",
                        borderRadius: BorderRadius.circular(5),
                        spacing: 2,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          context.pushNamed('editUpcoming');
                        },
                        icon: Icons.edit,
                        label: "Edit",
                        backgroundColor: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                        spacing: 2,
                      ),
                    ]),
                    child: MyListTile(
                        type: "Food",
                        title: "Meat",
                        price: "1500",
                        date: DateTime.now()),
                  );
                },
                childCount: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
