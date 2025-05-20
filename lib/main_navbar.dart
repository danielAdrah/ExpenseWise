import 'package:animate_do/animate_do.dart';
import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_color.dart';
import 'features/dashboard/presentation/pages/dashboard_view.dart';

import 'features/expenses/presentation/pages/upcoming_expense_view.dart';
import 'features/goals/presentation/pages/goals_view.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});

  @override
  State<MainNavBar> createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  int selectTab = 0;
  PageStorageBucket pageStorageBucket = PageStorageBucket();
  Widget currentTabView = const DashboardView();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: PageStorage(
        bucket: pageStorageBucket,
        child: currentTabView,
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: () {
          _showDialoge(context);
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0.5,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //D A S H B O A R D
              InkWell(
                onTap: () {
                  setState(() {
                    selectTab = 0;
                    currentTabView = const DashboardView();
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimateIcon(
                      onTap: () {
                        setState(() {
                          selectTab = 0;
                          currentTabView = const DashboardView();
                        });
                      },
                      iconType: IconType.animatedOnTap,
                      height: 25,
                      width: 25,
                      color: selectTab == 0
                          ? Theme.of(context).colorScheme.primary
                          : TColor.gray30,
                      animateIcon: AnimateIcons.home,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(
                          fontSize: 13,
                          color: selectTab == 0
                              ? Theme.of(context).colorScheme.primary
                              : TColor.gray30),
                    ),
                  ],
                ),
              ),
              //C H A R T S
              InkWell(
                onTap: () {
                  setState(() {
                    selectTab = 1;
                    currentTabView = Container(
                      child: const Center(
                        child: Text("2"),
                      ),
                    );
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimateIcon(
                      onTap: () {
                        setState(() {
                          selectTab = 1;
                          currentTabView = Container(
                            child: const Center(
                              child: Text("2"),
                            ),
                          );
                        });
                      },
                      iconType: IconType.animatedOnTap,
                      height: 25,
                      width: 25,
                      color: selectTab == 1
                          ? Theme.of(context).colorScheme.primary
                          : TColor.gray30,
                      animateIcon: AnimateIcons.activity,
                    ),
                    Text(
                      "Chart",
                      style: TextStyle(
                          fontSize: 13,
                          color: selectTab == 1
                              ? Theme.of(context).colorScheme.primary
                              : TColor.gray30),
                    ),
                  ],
                ),
              ),
              SizedBox(width: width * 0.02),
              //G O A L S
              InkWell(
                onTap: () {
                  setState(() {
                    selectTab = 2;
                    currentTabView = const GoalView();
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimateIcon(
                      onTap: () {
                        setState(() {
                          selectTab = 2;
                          currentTabView = const GoalView();
                        });
                      },
                      iconType: IconType.animatedOnTap,
                      height: 25,
                      width: 25,
                      color: selectTab == 2
                          ? Theme.of(context).colorScheme.primary
                          : TColor.gray30,
                      animateIcon: AnimateIcons.list,
                    ),
                    Text(
                      "Goals",
                      style: TextStyle(
                          fontSize: 13,
                          color: selectTab == 2
                              ? Theme.of(context).colorScheme.primary
                              : TColor.gray30),
                    ),
                  ],
                ),
              ),
              //U P C O M I N G
              InkWell(
                onTap: () {
                  setState(() {
                    selectTab = 3;
                    currentTabView = const UpcomingExpenseView();
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimateIcon(
                      onTap: () {
                        setState(() {
                          selectTab = 3;
                          currentTabView = const UpcomingExpenseView();
                        });
                      },
                      iconType: IconType.animatedOnTap,
                      height: 25,
                      width: 25,
                      color: selectTab == 3
                          ? Theme.of(context).colorScheme.primary
                          : TColor.gray30,
                      animateIcon: AnimateIcons.hourglass,
                    ),
                    Text(
                      "upcoming",
                      style: TextStyle(
                          fontSize: 13,
                          color: selectTab == 3
                              ? Theme.of(context).colorScheme.primary
                              : TColor.gray30),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_showDialoge(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;
        return AlertDialog(
          elevation: 5,
          // shadowColor: Colors.grey,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          content: Container(
            // padding: EdgeInsets.all(5),
            width: width * 0.67,
            height: height * 0.35,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: 4,
                  itemBuilder: ((context, index) {
                    List<String> images = [
                      "assets/img/budget.png",
                      "assets/img/piggy-bank.png",
                      "assets/img/asset-management.png",
                      "assets/img/financial-profit (1).png",
                    ];
                    List<String> titles = [
                      "Create Expense",
                      "Create\nGoal",
                      "Create Upcoming",
                      "Spending\nLimit"
                    ];
                    return InkWell(
                      onTap: () {
                        if (index == 0) {
                          //this line to close the alert da
                          Navigator.popUntil(context, (route) => route.isFirst);
                          context.pushNamed("createExpense");
                        }
                        if (index == 1) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          context.pushNamed('createGoal');
                        }
                        if (index == 2) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          context.pushNamed('createUpcoming');
                        }
                        if (index == 3) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          context.pushNamed('spendingsLimit');
                        }
                      },
                      child: ZoomIn(
                        delay: const Duration(milliseconds: 50),
                        curve: Curves.decelerate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                              borderRadius: BorderRadius.circular(25)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(images[index], width: 60, height: 60),
                              Text(
                                titles[index],
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontSize: 13,
                                  fontFamily: "Arvo",
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
            ),
          ),
        );
      });
}
