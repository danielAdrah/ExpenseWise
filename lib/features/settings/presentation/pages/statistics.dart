import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/piechart.dart';
import '../widgets/section_title.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  bool showDetails = false;
  bool showDetails1 = false;
  bool showDetails2 = false;
  final List<Map<String, String>> recentExpenses = [
    {'name': 'McDonald\'s', 'amount': '\$12.00'},
    {'name': 'Supermarket', 'amount': '\$75.00'},
    {'name': 'Coffee Shop', 'amount': '\$6.00'},
    {'name': 'Coffee Shop', 'amount': '\$6.00'},
    {'name': 'Coffee Shop', 'amount': '\$6.00'},
    {'name': 'Coffee Shop', 'amount': '\$6.00'},
  ];
  // @override
  // void initState() {
  //   super.initState();
  //   cont.homeSubPiechart();
  //   cont.transportsubPiechart();
  //   cont.foodSubPiechart();
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        elevation: 0.0,
        title: ZoomIn(
          delay: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: Text(
            "Statistics",
            style: TextStyle(
                color: theme.inversePrimary, fontSize: 22, fontFamily: "Arvo"),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: FadeInLeft(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: theme.inversePrimary,
              )),
        ),
        actions: [
          FadeInRight(
              duration: const Duration(milliseconds: 200),
              curve: Curves.decelerate,
              child:
                  Image.asset("assets/img/logo1.png", width: 55, height: 55)),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FadeInUp(
            delay: const Duration(milliseconds: 300),
            curve: Curves.decelerate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ZoomInDown(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      "Zoom Into Your Spendings",
                      style: TextStyle(
                          color: theme.inversePrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins"),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 7),
                  child: SectionTitle(title: "Transport"),
                ),
                //T R A N S P R T A T I O N
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: theme.primaryContainer,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubPieChart(
                        category: "Transport",
                        gradientList: const [
                          [Color(0xFF6C3EFF), Color(0xFF3F2B96)],
                          [Color(0xFF00C9A7), Color(0xFF007F5F)],
                          [Color(0xFFFFC107), Color(0xFFFF8F00)],
                          [
                            Color.fromARGB(255, 241, 141, 26),
                            Color.fromARGB(255, 223, 10, 10)
                          ]
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              showDetails = !showDetails;
                            });
                          },
                          icon: Icon(
                            showDetails ? Icons.expand_less : Icons.expand_more,
                            color: theme.inversePrimary,
                          ),
                          label: Text(
                            showDetails ? "Hide Details" : "More Details",
                            style: TextStyle(
                                color: theme.inversePrimary,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox(),
                        secondChild: Column(
                          children: recentExpenses.map((expense) {
                            return FadeInUp(
                              delay: const Duration(milliseconds: 100),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(CupertinoIcons.car_detailed,
                                      color: theme.primary, size: 20),
                                  title: Text(expense['name']!,
                                      style: TextStyle(
                                          color: theme.inversePrimary,
                                          fontFamily: 'Arvo')),
                                  trailing: Text(expense['amount']!,
                                      style: TextStyle(
                                          color: theme.inversePrimary,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        crossFadeState: showDetails
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 400),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 7),
                  child: SectionTitle(title: "Food"),
                ),
                //F O O D
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  // height: media.width * 0.8,
                  decoration: BoxDecoration(
                    color: theme.primaryContainer,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubPieChart(
                        category: "Food",
                        gradientList: const [
                          [Color(0xFF6C3EFF), Color(0xFF3F2B96)],
                          [Color(0xFF00C9A7), Color(0xFF007F5F)],
                          [Color(0xFFFFC107), Color(0xFFFF8F00)],
                          [
                            Color.fromARGB(255, 241, 141, 26),
                            Color.fromARGB(255, 223, 10, 10)
                          ]
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              showDetails1 = !showDetails1;
                            });
                          },
                          icon: Icon(
                            showDetails1
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: theme.inversePrimary,
                          ),
                          label: Text(
                            showDetails1 ? "Hide Details" : "More Details",
                            style: TextStyle(
                                color: theme.inversePrimary,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox(),
                        secondChild: Column(
                          children: recentExpenses.map((expense) {
                            return FadeInUp(
                              delay: const Duration(milliseconds: 100),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.restaurant_menu,
                                      color: theme.primary, size: 20),
                                  title: Text(expense['name']!,
                                      style: TextStyle(
                                          color: theme.inversePrimary,
                                          fontFamily: 'Arvo')),
                                  trailing: Text(expense['amount']!,
                                      style: TextStyle(
                                          color: theme.inversePrimary,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        crossFadeState: showDetails1
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 7),
                  child: SectionTitle(title: "Utilites"),
                ),
                //U T I L I T E S
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  // height: media.width * 0.8,
                  decoration: BoxDecoration(
                    color: theme.primaryContainer,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      SubPieChart(
                        category: "Utilites",
                        gradientList: const [
                          [Color(0xFF00BCD4), Color(0xFF3F51B5)],
                          [Color(0xFF005C97), Color(0xFF363795)],
                          [Color(0xFF00B09B), Color(0xFF96C93D)],
                          [
                            Color.fromARGB(255, 241, 141, 26),
                            Color.fromARGB(255, 223, 10, 10)
                          ],
                        ],
                      ),
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              showDetails2 = !showDetails2;
                            });
                          },
                          icon: Icon(
                            showDetails2
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: theme.inversePrimary,
                          ),
                          label: Text(
                            showDetails2 ? "Hide Details" : "More Details",
                            style: TextStyle(
                                color: theme.inversePrimary,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox(),
                        secondChild: Column(
                          children: recentExpenses.map((expense) {
                            return FadeInUp(
                              delay: const Duration(milliseconds: 100),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.lightbulb_outline,
                                      color: theme.primary, size: 20),
                                  title: Text(expense['name']!,
                                      style: TextStyle(
                                          color: theme.inversePrimary,
                                          fontFamily: 'Arvo')),
                                  trailing: Text(expense['amount']!,
                                      style: TextStyle(
                                          color: theme.inversePrimary,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        crossFadeState: showDetails2
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
