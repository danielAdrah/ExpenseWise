import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../../core/components/inline_nav_bar.dart';
import '../widgets/blur_card.dart';
import '../widgets/info_row.dart';

class LimitDetail extends StatefulWidget {
  const LimitDetail({super.key});

  @override
  State<LimitDetail> createState() => _LimitDetailState();
}

class _LimitDetailState extends State<LimitDetail> {
  bool showDetails = false;

  final List<Map<String, String>> recentExpenses = [
    {'name': 'McDonald\'s', 'amount': '\$12.00'},
    {'name': 'Supermarket', 'amount': '\$75.00'},
    {'name': 'Coffee Shop', 'amount': '\$6.00'},
    {'name': 'Coffee Shop', 'amount': '\$6.00'},
    {'name': 'Coffee Shop', 'amount': '\$6.00'},
    {'name': 'Coffee Shop', 'amount': '\$6.00'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // const SizedBox(height: 20),
                const InlineNavBar(title: "Limit Details"),
                const SizedBox(height: 15),
                BounceInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Image.asset("assets/img/wallet.png",
                      width: 100, height: 100),
                  // child: Icon(Icons.account_balance_wallet_rounded,
                  //     size: 80, color: theme.primary),
                ),
                const SizedBox(height: 10),
                FadeIn(
                  duration: const Duration(milliseconds: 1500),
                  child: Text(
                    "Track your budget smartly.",
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.inversePrimary,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SlideInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: BlurCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //here we will display the category name of the selected limit
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("Food",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 16),
                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: 0.6,
                            minHeight: 10,
                            backgroundColor: Colors.grey[800],
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.inverseSurface),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text("60% used",
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                                fontFamily: 'Poppins')),
                        const SizedBox(height: 20),
                        // Values
                        InfoRow(
                            label: "Limit Balance",
                            value: "\$50,000",
                            theme: theme),
                        InfoRow(
                            label: "Spending Amount",
                            value: "\$30,000",
                            theme: theme),
                        InfoRow(
                            label: "Remaining",
                            value: "\$20,000",
                            theme: theme),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 10),
                        InfoRow(
                            label: "Start", value: "2/2/2025", theme: theme),
                        InfoRow(label: "End", value: "2/3/2025", theme: theme),
                        const SizedBox(height: 10),

                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                showDetails = !showDetails;
                              });
                            },
                            icon: Icon(
                              showDetails
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: theme.primary,
                            ),
                            label: Text(
                              showDetails ? "Hide Details" : "More Details",
                              style: TextStyle(
                                  color: theme.primary, fontFamily: 'Poppins'),
                            ),
                          ),
                        ),

                        AnimatedCrossFade(
                          firstChild: const SizedBox(),
                          secondChild: Column(
                            children: recentExpenses.map((expense) {
                              return FadeInUp(
                                delay: const Duration(milliseconds: 100),
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.receipt_long,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
