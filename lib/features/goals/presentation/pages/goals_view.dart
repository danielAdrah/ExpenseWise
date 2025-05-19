import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/components/main_app_bar.dart';


import '../widgets/goal_card.dart';

class GoalView extends StatefulWidget {
  const GoalView({super.key});

  @override
  State<GoalView> createState() => _GoalViewState();
}

class _GoalViewState extends State<GoalView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
                  return GoalCard(
                    width: width,
                    height: height,
                    goalName: "New Car",
                    current: "25000",
                    finalBalance: "900000",
                    date: "2/2/2024",
                    onTap: () {
                      
                      context.pushNamed("goalDetail");
                    },
                  );
                },
                childCount: 10,
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}
