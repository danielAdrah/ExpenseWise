import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';


import '../../../../core/components/inline_nav_bar.dart';
import '../../../../core/theme/app_color.dart';
import '../../../goals/presentation/widgets/goal_item.dart';

class LimitDetail extends StatefulWidget {
  const LimitDetail({super.key});

  @override
  State<LimitDetail> createState() => _LimitDetailState();
}

class _LimitDetailState extends State<LimitDetail> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var media = MediaQuery.of(context).size;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const InlineNavBar(title: "Limit Details"),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: media.width * 0.055,
                        left: media.width * 0.055,
                        top: media.width * 0.05),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      height: 600,
                      decoration: BoxDecoration(
                          color: theme.primaryContainer,
                          border:
                              Border.all(color: TColor.border.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(25)),
                      child: FadeInDown(
                        delay: const Duration(milliseconds: 150),
                        curve: Curves.decelerate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 70),
                            GoalItem(
                              width: width,
                              title: "The limit Category",
                              value: "food",
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Divider(
                                  color: TColor.gray50,
                                  indent: 20,
                                  endIndent: 20,
                                  thickness: 1),
                            ),
                            GoalItem(
                              width: width,
                              title: "The limit balance",
                              value: " \$50000",
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Divider(
                                  color: TColor.gray50,
                                  indent: 20,
                                  endIndent: 20,
                                  thickness: 1),
                            ),
                            GoalItem(
                              width: width,
                              title: " spending amount",
                              value: " \$300000",
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Divider(
                                  color: TColor.gray50,
                                  indent: 20,
                                  endIndent: 20,
                                  thickness: 1),
                            ),
                            GoalItem(
                              width: width,
                              title: "Remaining amount",
                              value: "\$20000",
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Divider(
                                  color: TColor.gray50,
                                  indent: 20,
                                  endIndent: 20,
                                  thickness: 1),
                            ),
                            GoalItem(
                              width: width,
                              title: "Start date",
                              value: "2/2/2025",
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Divider(
                                  color: TColor.gray50,
                                  indent: 20,
                                  endIndent: 20,
                                  thickness: 1),
                            ),
                            GoalItem(
                              width: width,
                              title: "End date",
                              value: "2/3/2025",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
