import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:trackme/core/components/my_list_tile.dart';

import '../../../../core/components/main_app_bar.dart';
import '../../../../core/theme/app_color.dart';
import '../widgets/total_pie_chart.dart';
// import '../widgets/total_pie_chart.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List<String> accounts = [
    "My Daily spending Account",
    "Big spending Account",
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
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
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary
                                            .withOpacity(0.4),
                                      ),
                                      borderRadius: BorderRadius.circular(15)),
                                  width: 100,
                                  child: DropdownButton<String>(
                                    borderRadius: BorderRadius.circular(25),
                                    hint: Text("Select an account",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary)),
                                    items: accounts.map((String account) {
                                      return DropdownMenuItem<String>(
                                        value: account,
                                        child: Row(
                                          children: [
                                            Text(
                                              account,
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
                                      style: TextStyle(color: TColor.white),
                                    ),
                                    onChanged: (String? val) {
                                      if (val != null) {}
                                    },
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //=======
            SliverToBoxAdapter(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 20,
                itemBuilder: ((context, index) {
                  return FadeInDown(
                    delay: const Duration(milliseconds: 500),
                    curve: Curves.decelerate,
                    child: Slidable(
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
                            context.pushNamed('editExpense');
                          },
                          icon: Icons.edit,
                          label: "Edit",
                          backgroundColor: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                          spacing: 2,
                        ),
                      ]),
                      child: MyListTile(
                          type: "HealthCare",
                          title: "Meat",
                          price: "1500",
                          date: DateTime.now()),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
